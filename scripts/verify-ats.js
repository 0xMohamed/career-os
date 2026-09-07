#!/usr/bin/env node
/**
 * verify-ats.js — Career OS ATS Compatibility Verification Script
 *
 * This script verifies ATS compatibility of the compiled resume PDF:
 *   1. Full text extraction via native PDFKit (no OCR, no rasterized text).
 *   2. Presence and extractability of required identity and contact fields.
 *   3. Presence and extractability of standard structural resume headings.
 *   4. Extractability of representative technical keywords.
 *   5. Presence of interactive hyperlink annotations.
 *   6. Analysis of logical reading order in the two-column PDF stream.
 *
 * Usage:
 *   node scripts/verify-ats.js
 *   pnpm run test:ats
 */

import { execSync } from "child_process";
import { existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, "..");
const args = process.argv.slice(2).filter(arg => arg !== "--");
const rawTarget = args[0];

let targetPdfNames = [];
if (rawTarget) {
  const norm = rawTarget.endsWith(".pdf") ? rawTarget : `${rawTarget}.pdf`;
  targetPdfNames = [norm === "master.pdf" ? "resume.pdf" : norm];
} else {
  targetPdfNames = ["resume.pdf", "single.pdf", "classic.pdf"];
}

let totalAllPassed = 0;
let totalAllFailed = 0;

for (const pdfName of targetPdfNames) {
  const pdfPath = resolve(root, "output", pdfName);

  console.log("=================================================");
  console.log(` ATS Verification: output/${pdfName}`);
  console.log("=================================================\n");

  if (!existsSync(pdfPath)) {
    console.log(`Target PDF output/${pdfName} not found. Compiling output/${pdfName} first...`);
    try {
      if (pdfName === "single.pdf") {
        execSync(`node scripts/build.js master standard`, { cwd: root, stdio: "inherit" });
      } else if (pdfName === "classic.pdf") {
        execSync(`node scripts/build.js master classic`, { cwd: root, stdio: "inherit" });
      } else {
        const appName = pdfName === "resume.pdf" ? "master" : pdfName.replace(".pdf", "");
        execSync(`node scripts/build.js ${appName}`, { cwd: root, stdio: "inherit" });
      }
    } catch (err) {
      console.error(`✗ Failed to compile ${pdfName}.`);
      process.exit(1);
    }
  }

  // ── 1. Native PDF Text & Annotation Extraction via Swift PDFKit ───────
  let extractedPages = [];
  let extractedLinks = [];

  try {
    const swiftCode = `
import PDFKit
import Foundation

let url = URL(fileURLWithPath: "${pdfPath}")
guard let doc = PDFDocument(url: url) else {
    fputs("ERR_LOAD", stderr)
    exit(1)
}

print("PAGE_COUNT:\\(doc.pageCount)")
for i in 0..<doc.pageCount {
    guard let page = doc.page(at: i) else { continue }
    print("---PAGE_START:\\(i+1)---")
    print(page.string ?? "")
    print("---PAGE_END---")
    for ann in page.annotations {
        if let linkUrl = ann.url?.absoluteString {
            print("LINK_URL:\\(linkUrl)")
        }
    }
}
`;

    const output = execSync(`swift -e '${swiftCode.replace(/'/g, "'\\''")}'`, {
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
    });

    const lines = output.split("\n");
    let currentPageText = [];
    let capturing = false;

    for (const line of lines) {
      if (line.startsWith("---PAGE_START:")) {
        capturing = true;
        currentPageText = [];
      } else if (line.startsWith("---PAGE_END---")) {
        capturing = false;
        extractedPages.push(currentPageText.join("\n"));
      } else if (capturing) {
        currentPageText.push(line);
      } else if (line.startsWith("LINK_URL:")) {
        extractedLinks.push(line.replace("LINK_URL:", "").trim());
      }
    }
  } catch (err) {
    console.error("✗ Error extracting PDF stream via PDFKit:", err.message);
    process.exit(1);
  }

  const fullText = extractedPages.join("\n\n");
  let passed = 0;
  let failed = 0;

  function assertCheck(category, name, condition, details = "") {
    if (condition) {
      console.log(`  ✓ [${category}] ${name}`);
      passed++;
      totalAllPassed++;
    } else {
      console.error(`  ✗ [${category}] ${name} ${details ? `— ${details}` : ""}`);
      failed++;
      totalAllFailed++;
    }
  }

  // ── 2. Identity & Contact Verification ────────────────────────────────
  console.log("1. Identity & Contact Field Verification");
  assertCheck("Identity", "Full Name (Mohamed Seoudy)", /Mohamed\s+Seoudy/i.test(fullText));
  assertCheck("Identity", "Title (Frontend Engineer)", /Frontend\s+Engineer/i.test(fullText));
  assertCheck("Identity", "Phone", fullText.includes("+1 XXX XXX XXX") || fullText.includes("+20 1X XXX XXXX"));
  assertCheck("Identity", "Email (hello@seoudy.dev)", fullText.includes("hello@seoudy.dev"));
  assertCheck("Identity", "Website (seoudy.dev)", fullText.includes("seoudy.dev"));
  assertCheck("Identity", "GitHub (0xMohamed)", fullText.includes("GitHub · 0xMohamed") || fullText.includes("0xMohamed"));
  assertCheck("Identity", "LinkedIn (0xmohamed)", fullText.includes("LinkedIn · 0xMohamed") || fullText.includes("0xMohamed") || fullText.includes("0xmohamed"));
  assertCheck("Identity", "Location (Cairo, Egypt)", /Cairo,\s*Egypt/i.test(fullText));
  console.log();

  // ── 3. Structural Headings Verification ────────────────────────────────
  console.log("2. Standard Structural Headings Verification");
  const REQUIRED_HEADINGS = [
    "EXPERIENCE",
    "PROJECTS",
    "SUMMARY",
    ...(pdfName !== "classic.pdf" ? ["KEY STRENGTHS"] : []),
    "EDUCATION",
    "SKILLS",
    "LANGUAGES",
  ];

  for (const heading of REQUIRED_HEADINGS) {
    assertCheck("Heading", heading, fullText.includes(heading));
  }
  console.log();

  // ── 4. Technical Keyword Extraction Verification ───────────────────────
  console.log("3. Technical Keyword Extractability Verification");
  const KEYWORDS = [
    "TypeScript",
    "JavaScript",
    "React",
    "Next.js",
    "TanStack",
    "Redux Toolkit",
    "Zustand",
    "Jotai",
    "Zod",
    "D3",
    "Canvas",
    "SVG",
    "Fastify",
    "PostgreSQL",
    "REST APIs",
    "Python",
    "Tailwind CSS",
    "Design Systems",
    "Gemini",
    "HTML5",
    "CSS3",
  ];

  for (const kw of KEYWORDS) {
    assertCheck("Keyword", kw, new RegExp(`\\b${kw.replace(".", "\\.")}`, "i").test(fullText));
  }
  console.log();

  // ── 5. Interactive Hyperlinks Verification ─────────────────────────────
  console.log("4. Interactive Hyperlinks Verification");
  const EXPECTED_LINKS = [
    "mailto:hello@seoudy.dev",
    "https://seoudy.dev",
    "https://github.com/0xMohamed",
    "https://linkedin.com/in/0xmohamed",
    "https://summa.vercel.app/",
    "https://stories.lintu.io",
    "https://usemodra.xyz",
    "https://oqel.vercel.app/",
    "https://basira-graph.vercel.app",
    "https://dskby.vercel.app/",
    "https://cargo-lab.vercel.app",
  ];

  // Verify phone link (supports real number or placeholder format)
  assertCheck("Link", "tel link", extractedLinks.some(l => l.startsWith("tel:+20")));

  for (const link of EXPECTED_LINKS) {
    assertCheck("Link", link, extractedLinks.includes(link));
  }
  console.log();

  // ── 6. Reading Order & Layout Analysis ────────────────────────────────
  console.log("5. Stream Reading Order & Semantic Analysis");
  const nameIndex = fullText.search(/Mohamed\s+Seoudy/i);
  const expIndex = fullText.indexOf("EXPERIENCE");
  const summaryIndex = fullText.indexOf("SUMMARY");
  const projectsIndex = fullText.indexOf("PROJECTS");
  const educationIndex = fullText.indexOf("EDUCATION");
  const skillsIndex = fullText.indexOf("SKILLS");
  const languagesIndex = fullText.indexOf("LANGUAGES");

  assertCheck("Order", "Header precedes all content sections", nameIndex >= 0 && nameIndex < expIndex && nameIndex < summaryIndex);
  assertCheck("Order", "Experience and Summary are parsed in stream", expIndex >= 0 && summaryIndex >= 0);
  assertCheck("Order", "Skills and Languages are fully indexed", skillsIndex >= 0 && languagesIndex >= 0);
  console.log();

  // ── Summary Report for this file ──────────────────────────────────────
  console.log(` ${pdfName} Results: ${passed} Passed, ${failed} Failed`);
  console.log(` Total Pages Extracted : ${extractedPages.length}`);
  console.log(` Total Links Verified  : ${extractedLinks.length}`);
  console.log("-------------------------------------------------\n");
}

if (totalAllFailed > 0) {
  console.error(`✗ ATS Compatibility verification failed with ${totalAllFailed} failure(s).`);
  process.exit(1);
} else {
  console.log(`✓ All ATS Compatibility verifications passed successfully (${totalAllPassed} total checks passed).`);
}
