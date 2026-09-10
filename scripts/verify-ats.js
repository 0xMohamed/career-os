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
 *   node scripts/verify-ats.js                      # verifies all generated resume PDFs (compact)
 *   node scripts/verify-ats.js --verbose            # verifies all (detailed per-check output)
 *   node scripts/verify-ats.js resume.pdf           # verifies specific PDF
 *   node scripts/verify-ats.js siemens              # verifies specific application
 */

import { execSync } from "child_process";
import { existsSync, readFileSync } from "fs";
import { resolve } from "path";
import * as pdfjsLib from "pdfjs-dist/legacy/build/pdf.mjs";
import { root, paths, getBuildJobs, getPhoneInput } from "./config.js";

const allArgs = process.argv.slice(2);
const verbose = allArgs.includes("--verbose");
const args = allArgs.filter((arg) => arg !== "--" && arg !== "--verbose");
const rawTarget = args[0];

const configuredPhone = getPhoneInput();

let targetPdfNames = [];
if (rawTarget) {
  if (rawTarget.endsWith(".pdf")) {
    targetPdfNames = [rawTarget];
  } else {
    try {
      const jobs = getBuildJobs(rawTarget);
      targetPdfNames = jobs.map((j) => j.outName);
    } catch {
      targetPdfNames = [`resume-${rawTarget}.pdf`];
    }
  }
} else {
  const allJobs = getBuildJobs("all");
  targetPdfNames = allJobs.map((j) => j.outName);
}

let totalAllPassed = 0;
let totalAllFailed = 0;
const perFileResults = [];

function padRight(str, width) {
  if (str.length >= width) return str;
  return str + " ".repeat(width - str.length);
}

for (const pdfName of targetPdfNames) {
  const pdfPath = resolve(paths.output, pdfName);

  if (verbose) {
    console.log("=================================================");
    console.log(` ATS Verification: output/${pdfName}`);
    console.log("=================================================\n");
  }

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
  const failedCheckNames = [];

  function assertCheck(category, name, condition, details = "") {
    if (condition) {
      if (verbose) {
        console.log(`  ✓ [${category}] ${name}`);
      }
      passed++;
      totalAllPassed++;
    } else {
      if (verbose) {
        console.error(
          `  ✗ [${category}] ${name} ${details ? `— ${details}` : ""}`,
        );
      }
      failed++;
      totalAllFailed++;
      failedCheckNames.push(name);
    }
  }

  if (verbose) {
    console.log("1. Identity & Contact Field Verification");
  }
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

  if (configuredPhone) {
    const cleanPhone = configuredPhone.replace(/\s+/g, "");
    const phonePattern = new RegExp(
      configuredPhone
        .split("")
        .map((c) => (/\s/.test(c) ? "\\s*" : c.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")))
        .join(""),
    );
    assertCheck(
      "Identity",
      "Phone",
      phonePattern.test(fullText) || fullText.includes(cleanPhone),
      `expected "${configuredPhone}"`,
    );
  }

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
  if (verbose) console.log();

  if (verbose) {
    console.log("2. Standard Structural Headings Verification");
  }
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

  if (fullText.includes("KEY STRENGTHS")) {
    assertCheck("Heading", "KEY STRENGTHS (optional layout section)", true);
  }
  if (verbose) console.log();

  if (verbose) {
    console.log("3. Technical Keyword Extractability Verification");
  }
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

  if (fullText.includes("Oqel")) {
    assertCheck("Keyword", "Gemini (Oqel)", /Gemini/i.test(fullText));
  }
  if (verbose) console.log();

  if (verbose) {
    console.log("4. Interactive Hyperlinks Verification");
  }
  const norm = (u) => (u ? u.replace(/\/$/, "") : "");

  if (configuredPhone) {
    const cleanPhone = configuredPhone.replace(/\s+/g, "");
    assertCheck(
      "Link",
      "tel link",
      extractedLinks.some((l) => l === `tel:${cleanPhone}` || l.startsWith(`tel:${cleanPhone.replace(/^\+/, "")}`)),
      `expected tel:${cleanPhone}`,
    );
  }
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
  if (verbose) console.log();

  if (verbose) {
    console.log("5. Stream Reading Order & Semantic Analysis");
  }
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
  if (verbose) console.log();

  perFileResults.push({
    pdfName,
    passed,
    failed,
    failedCheckNames,
    total: passed + failed,
  });

  if (verbose) {
    console.log(` ${pdfName} Results: ${passed} Passed, ${failed} Failed`);
    console.log(` Total Pages Extracted : ${extractedPages.length}`);
    console.log(` Total Links Verified  : ${extractedLinks.length}`);
    console.log("-------------------------------------------------\n");
  }
}

const maxNameWidth = Math.max(...perFileResults.map((r) => r.pdfName.length));
const maxCountWidth = Math.max(
  ...perFileResults.map((r) => String(r.total).length),
);

if (!verbose) {
  console.log("ATS Verification\n");
}

for (const result of perFileResults) {
  const mark = result.failed === 0 ? "✓" : "✗";
  const namePadded = padRight(result.pdfName, maxNameWidth);
  const countStr = `${String(result.passed).padStart(maxCountWidth)}/${result.total}`;

  if (result.failed === 0) {
    console.log(`${mark} ${namePadded}  ${countStr}`);
  } else {
    const failures = result.failedCheckNames.join(", ");
    console.log(`${mark} ${namePadded}  ${countStr} — ${failures}`);
  }
}

console.log();

if (totalAllFailed > 0) {
  console.error(
    `✗ ATS checks failed with ${totalAllFailed} failure(s).`,
  );
  process.exit(1);
} else {
  console.log(`✓ All ATS checks passed.`);
}
