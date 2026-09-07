#!/usr/bin/env node
/**
 * verify-ats.js — Career OS ATS Compatibility Verification Script
 *
 * Truly cross-platform ATS verification (macOS, Linux, Windows) powered by Mozilla pdfjs-dist:
 *   1. Full text extraction via pure JavaScript (no OCR, no Swift/macOS dependency).
 *   2. Universal identity and contact fields.
 *   3. Universal standard structural resume headings.
 *   4. Technical keywords extractability.
 *   5. Interactive hyperlink annotations.
 *   6. Stream reading order & semantic sequence analysis.
 *
 * Usage:
 *   node scripts/verify-ats.js                 # verifies all generated resume PDFs
 *   node scripts/verify-ats.js resume.pdf      # verifies specific PDF
 *   node scripts/verify-ats.js siemens         # verifies specific application
 */

import { execSync } from "child_process";
import { existsSync, readFileSync } from "fs";
import { resolve } from "path";
import * as pdfjsLib from "pdfjs-dist/legacy/build/pdf.mjs";
import { root, paths, getBuildJobs } from "./config.js";

const args = process.argv.slice(2).filter((arg) => arg !== "--");
const rawTarget = args[0];

let targetPdfNames = [];
if (rawTarget) {
  if (rawTarget.endsWith(".pdf")) {
    targetPdfNames = [rawTarget];
  } else {
    // Resolve application jobs
    try {
      const jobs = getBuildJobs(rawTarget);
      targetPdfNames = jobs.map((j) => j.outName);
    } catch {
      targetPdfNames = [`resume-${rawTarget}.pdf`];
    }
  }
} else {
  // Default: verify all configured build artifacts
  const allJobs = getBuildJobs("all");
  targetPdfNames = allJobs.map((j) => j.outName);
}

let totalAllPassed = 0;
let totalAllFailed = 0;

for (const pdfName of targetPdfNames) {
  const pdfPath = resolve(paths.output, pdfName);

  console.log("=================================================");
  console.log(` ATS Verification: output/${pdfName}`);
  console.log("=================================================\n");

  if (!existsSync(pdfPath)) {
    console.log(
      `Target PDF output/${pdfName} not found. Compiling output/${pdfName} first...`,
    );
    try {
      const allJobs = getBuildJobs("all");
      const matchedJob = allJobs.find((j) => j.outName === pdfName);
      if (matchedJob) {
        execSync(
          `node scripts/build.js ${matchedJob.app} ${matchedJob.layout}`,
          { cwd: root, stdio: "inherit" },
        );
      } else {
        const fallbackApp = pdfName
          .replace(/^resume-/, "")
          .replace(/\.pdf$/, "");
        execSync(`node scripts/build.js ${fallbackApp}`, {
          cwd: root,
          stdio: "inherit",
        });
      }
    } catch (err) {
      console.error(`✗ Failed to compile ${pdfName}:`, err.message);
      process.exit(1);
    }
  }

  // ── 1. Pure JS PDF Text & Annotation Extraction via pdfjs-dist ────────
  let extractedPages = [];
  let extractedLinks = [];

  try {
    const data = new Uint8Array(readFileSync(pdfPath));
    const doc = await pdfjsLib.getDocument({
      data,
      useSystemFonts: true,
      disableFontFace: true,
    }).promise;

    for (let i = 1; i <= doc.numPages; i++) {
      const page = await doc.getPage(i);
      const textContent = await page.getTextContent();

      // Reconstruct text lines preserving physical reading stream
      let lastY = null;
      let pageLines = [];
      let currentLine = "";

      for (const item of textContent.items) {
        if (!item.str) continue;
        const y = item.transform[5];
        if (lastY !== null && Math.abs(y - lastY) > 2) {
          if (currentLine) pageLines.push(currentLine.trim());
          currentLine = item.str;
        } else {
          currentLine += (currentLine ? " " : "") + item.str;
        }
        lastY = y;
      }
      if (currentLine) pageLines.push(currentLine.trim());

      extractedPages.push(pageLines.join("\n"));

      // Extract interactive link annotations
      const annots = await page.getAnnotations();
      for (const annot of annots) {
        const link =
          annot.url ||
          annot.unsafeUrl ||
          (annot.dest ? String(annot.dest) : null);
        if (link) {
          extractedLinks.push(link.trim());
        }
      }
    }
  } catch (err) {
    console.error("✗ Error extracting PDF stream via pdfjs-dist:", err.message);
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
      console.error(
        `  ✗ [${category}] ${name} ${details ? `— ${details}` : ""}`,
      );
      failed++;
      totalAllFailed++;
    }
  }

  // ── 2. Universal Identity & Contact Verification ──────────────────────
  console.log("1. Identity & Contact Field Verification");
  assertCheck(
    "Identity",
    "Full Name (Mohamed Seoudy)",
    /Mohamed\s+Seoudy/i.test(fullText),
  );
  assertCheck(
    "Identity",
    "Title (Frontend Engineer)",
    /Frontend\s+Engineer/i.test(fullText),
  );
  assertCheck(
    "Identity",
    "Phone",
    fullText.includes("+1 XXX XXX XXX") || /\+1\s*\d/.test(fullText),
  );
  assertCheck(
    "Identity",
    "Email (hello@seoudy.dev)",
    fullText.includes("hello@seoudy.dev"),
  );
  assertCheck(
    "Identity",
    "Website (seoudy.dev)",
    fullText.includes("seoudy.dev"),
  );
  assertCheck(
    "Identity",
    "GitHub (0xMohamed)",
    fullText.includes("GitHub · 0xMohamed") || fullText.includes("0xMohamed"),
  );
  assertCheck(
    "Identity",
    "LinkedIn (0xmohamed)",
    fullText.includes("LinkedIn · 0xMohamed") ||
      fullText.includes("0xMohamed") ||
      fullText.includes("0xmohamed"),
  );
  assertCheck(
    "Identity",
    "Location (Cairo, Egypt)",
    /Cairo,\s*Egypt/i.test(fullText),
  );
  console.log();

  // ── 3. Universal Structural Headings Verification ─────────────────────
  console.log("2. Standard Structural Headings Verification");
  const UNIVERSAL_HEADINGS = [
    "EXPERIENCE",
    "PROJECTS",
    "SUMMARY",
    "EDUCATION",
    "SKILLS",
    "LANGUAGES",
  ];

  for (const heading of UNIVERSAL_HEADINGS) {
    assertCheck("Heading", heading, fullText.includes(heading));
  }

  // Conditionally verify optional sections if present
  if (fullText.includes("KEY STRENGTHS")) {
    assertCheck("Heading", "KEY STRENGTHS (optional layout section)", true);
  }
  console.log();

  // ── 4. Technical Keyword Extraction Verification ───────────────────────
  console.log("3. Technical Keyword Extractability Verification");
  const UNIVERSAL_KEYWORDS = [
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
    "HTML5",
    "CSS3",
  ];

  for (const kw of UNIVERSAL_KEYWORDS) {
    assertCheck(
      "Keyword",
      kw,
      new RegExp(`\\b${kw.replace(".", "\\.")}`, "i").test(fullText),
    );
  }

  // Project-specific keywords (verified conditionally when project is included)
  if (fullText.includes("Oqel")) {
    assertCheck("Keyword", "Gemini (Oqel)", /Gemini/i.test(fullText));
  }
  console.log();

  // ── 5. Interactive Hyperlinks Verification ─────────────────────────────
  console.log("4. Interactive Hyperlinks Verification");
  const norm = (u) => (u ? u.replace(/\/$/, "") : "");

  assertCheck(
    "Link",
    "tel link",
    extractedLinks.some((l) => l.startsWith("tel:+20")),
  );
  assertCheck(
    "Link",
    "Email link",
    extractedLinks.some((l) => norm(l) === "mailto:hello@seoudy.dev"),
  );
  assertCheck(
    "Link",
    "Website link",
    extractedLinks.some((l) => norm(l) === "https://seoudy.dev"),
  );
  assertCheck(
    "Link",
    "GitHub link",
    extractedLinks.some((l) => norm(l) === "https://github.com/0xMohamed"),
  );
  assertCheck(
    "Link",
    "LinkedIn link",
    extractedLinks.some((l) => norm(l) === "https://linkedin.com/in/0xmohamed"),
  );

  // Check project links dynamically based on what projects are present in the PDF
  const KNOWN_PROJECT_LINKS = [
    { title: "Summa", url: "https://summa.vercel.app" },
    { title: "Lintu", url: "https://lintu.io" },
    { title: "Modra", url: "https://usemodra.xyz" },
    { title: "Oqel", url: "https://oqel.vercel.app" },
    { title: "Basira", url: "https://basira-graph.vercel.app" },
    { title: "Deskby", url: "https://dskby.vercel.app" },
    { title: "Cargo Lab", url: "https://cargo-lab.vercel.app" },
  ];

  for (const proj of KNOWN_PROJECT_LINKS) {
    if (fullText.includes(proj.title)) {
      assertCheck(
        "Link",
        `${proj.title} link`,
        extractedLinks.some((l) => norm(l) === norm(proj.url)),
      );
    }
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

  assertCheck(
    "Order",
    "Header precedes all content sections",
    nameIndex >= 0 && nameIndex < expIndex && nameIndex < summaryIndex,
  );
  assertCheck(
    "Order",
    "Experience and Summary are parsed in stream",
    expIndex >= 0 && summaryIndex >= 0,
  );
  assertCheck(
    "Order",
    "Skills and Languages are fully indexed",
    skillsIndex >= 0 && languagesIndex >= 0,
  );
  console.log();

  // ── Summary Report for this file ──────────────────────────────────────
  console.log(` ${pdfName} Results: ${passed} Passed, ${failed} Failed`);
  console.log(` Total Pages Extracted : ${extractedPages.length}`);
  console.log(` Total Links Verified  : ${extractedLinks.length}`);
  console.log("-------------------------------------------------\n");
}

if (totalAllFailed > 0) {
  console.error(
    `✗ ATS Compatibility verification failed with ${totalAllFailed} failure(s).`,
  );
  process.exit(1);
} else {
  console.log(
    `✓ All ATS Compatibility verifications passed successfully (${totalAllPassed} total checks passed).`,
  );
}
