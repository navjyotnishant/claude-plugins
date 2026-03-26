# rfp-clarification-q-optimizer

**Author:** Navjyot Nishant
**Version:** 1.0
**Date:** March 25, 2026

Evaluates or generates RFP clarification questions for pursuit teams. Produces a
client-facing Query Log (Excel) and an internal Question Assessment Report (HTML).

---

## What It Does

| Mode | When | What Claude does |
|---|---|---|
| Mode A | Draft questions provided | Evaluates, deduplicates, consolidates, rewrites, scores |
| Mode B | No draft questions | Generates questions from scratch based on RFP gaps |

---

## Inputs

| Input | Required | Format |
|---|---|---|
| RFP document | Required | PDF or DOCX |
| Draft clarification questions | Optional | PDF / DOCX / Excel / free text |
| Relationship context | Required | Prospect / Existing Client / Existing Client New Scope |
| Win themes | Optional | Free text, bullet list, or PDF |
| Account Plan | Optional | PDF or DOCX |
| QBR / MBR | Optional | PDF or DOCX |
| Client feedback / satisfaction document | Optional | PDF or DOCX |

---

## Outputs

| Output | Format | Audience |
|---|---|---|
| Query Log | Excel (single tab) | Client - ready to send |
| Question Assessment Report | Interactive HTML with PDF export | Internal only |

The HTML report has 5 tabs: Overview, Questions, Gap Matrix, Dedup Log, Input Documents.

---

## How to Install

### Step 1 - Configure

1. Open the `config/` folder in this directory
2. Copy `config.template.yaml` and rename it to `config.yaml`
3. Fill in your company details
   - **Your company users:** Use the pre-filled config shared by your admin. Rename it to `config.yaml`.

### Step 2 - Package

Zip this entire skill folder with `config.yaml` inside:

```
rfp-clarification-q-optimizer.zip
└── rfp-clarification-q-optimizer/
    ├── SKILL.md
    ├── config/
    │   └── config.yaml
    └── README.md
```

**Important:** The ZIP must contain the skill folder as its root, not the files directly.

On Mac:
```bash
cd Sales/rfp-pursuit-toolkit
zip -r rfp-clarification-q-optimizer.zip rfp-clarification-q-optimizer/
```

On Windows: right-click the folder > Send to > Compressed (zipped) folder.

### Step 3 - Install

1. Go to **claude.ai > Settings > Skills**
2. Click **Add Skill**
3. Upload the ZIP file
4. Enable the skill in **Customize > Skills**

### Step 4 - Verify

In any Claude conversation type:
> "What skills do you have available?"

You should see `rfp-clarification-q-optimizer` in the list.

---

## How to Use

### Trigger phrases
- "Evaluate my clarification questions for this RFP"
- "Generate clarification questions for this RFP"
- "Review our Q&A questions and produce a query log"
- "Optimize these clarification questions"
- "Create a query log for this RFP"

### Recommended workflow

**Mode A - You have draft questions:**
1. Upload your RFP and draft questions
2. Tell Claude: *"Evaluate my clarification questions for the [Client] RFP"*
3. Confirm inferred client name, RFP name, and relationship mode
4. Claude scores, rewrites, and generates both outputs

**Mode B - No draft questions:**
1. Upload your RFP
2. Optionally paste win themes
3. Tell Claude: *"Generate clarification questions for the [Client] RFP"*
4. Claude generates and produces both outputs

**To improve scoring (Existing Client):**
1. Upload Account Plan, QBR, MBR, and/or client feedback document
2. Tell Claude: *"Rerun rfp-clarification-q-optimizer with updated documents"*

---

## Requirements

- Claude.ai account (Free, Pro, Max, Team, or Enterprise)
- Code execution enabled in Claude settings
- Skills feature enabled

---

## Tips

- Name files clearly: `Acme_RFP_v2.pdf`, `Draft_Questions.xlsx`, `Account_Plan.pdf`
- Always provide win themes - improves strategic scoring significantly
- Check the **Input Documents** tab in the HTML report to see what is missing
- Use **Export to PDF** in the report nav bar to save a PDF version

---

## Questions or Issues

Raise an issue in the ClaudeSkills repository or contact **Navjyot Nishant**.
