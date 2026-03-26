---
name: rfp-clarification-q-optimizer
author: Navjyot Nishant
date: March 25, 2026
version: 1.0
description: Evaluates or generates RFP clarification questions. Produces a client-facing Query Log (Excel) and internal Question Assessment Report (HTML) with scoring across 5 dimensions.
---

# rfp-clarification-q-optimizer

## When to Use This Skill

Use this skill whenever you need to:
- Evaluate existing clarification questions for an RFP
- Generate clarification questions from scratch based on an RFP
- Review, deduplicate, and optimize draft Q&A questions
- Create a client-facing Query Log ready to send to the client
- Identify gaps in RFP coverage that have no clarification question

Always trigger when both an RFP and a list of clarification questions are present together.

---

## Overview

Produces two outputs from an RFP and optional draft clarification questions:
1. **{config.branding.excel_header_title}** - client-facing Excel in Cybage branded format
2. **Question Assessment Report** - internal interactive HTML report with PDF export,
   covering per-question scoring, deduplication log, gap coverage matrix, and priority
   classification

---

## Step 0 - Read Config and Establish Output Directory

### Read config.yaml

Before doing anything else, read the config file:

```bash
cat config/config.yaml
```

If `config/config.yaml` does not exist, check for `config/config.template.yaml` and
tell the user:

```
No config.yaml found. Please:
1. Copy config/config.template.yaml
2. Rename it to config.yaml
3. Fill in your company details
4. Re-run the skill
```

Do not proceed without a valid config.yaml. All company-specific values
(branding, delivery model, frameworks, differentiators) are loaded from this file.

### Infer client and RFP name from input filenames

Scan the working folder or uploaded files. Extract:
- `{client-name}` - from the RFP filename (e.g. `Marco_RFP_v2.pdf` → `Marco`)
- `{rfp-name}` - short descriptor from the RFP filename (e.g. `IT_Managed_Services`)
- `{date}` - today's date in YYYYMMDD format

Proposed directory:
```
workspace/rfp-pursuits/{client-name}_{rfp-name}_{date}/rfp-clarification-q-optimizer/
```

### Confirm with user before creating anything

Present the following and wait for explicit confirmation:
```
Before I proceed, please confirm the following details:

  Client name        : {inferred client name}
  RFP name           : {inferred rfp name}
  Date               : {today's date}
  Relationship mode  : {Prospect / Existing Client / Existing Client New Scope}
  Output folder      : workspace/rfp-pursuits/{client}_{rfp}_{date}/rfp-clarification-q-optimizer/

Does this look right? (yes / correct me)
```

If the user has not specified relationship mode, ask explicitly:
```
One more thing - is this a Prospect, an Existing Client, or an Existing Client
responding to a New Scope RFP?
```

Only create the directory and proceed after the user confirms all details.

```bash
mkdir -p "workspace/rfp-pursuits/{client}_{rfp}_{date}/rfp-clarification-q-optimizer/"
```

---

## Step 1 - File Resolution

### Scan the working folder

```bash
ls -1 <folder_path>
```

### Infer file roles from filenames

| Signal words in filename | Likely role |
|---|---|
| rfp, requirements, request, tender, bid-doc, brief | RFP document |
| questions, clarification, queries, q&a, draft-q | Draft clarification questions |
| themes, win-themes, positioning, strategy | Win themes |
| account-plan, account_plan | Account Plan |
| qbr, quarterly-review | QBR |
| mbr, monthly-review | MBR |
| cff, feedback, customer-feedback | CFF Form |

### Confirm file roles before proceeding

```
I found these files:
  RFP Document              : {filename}
  Draft Questions (optional): {filename or "not provided"}
  Win Themes (optional)     : {filename or "not provided"}
  Account Plan (optional)   : {filename or "not provided"}
  QBR (optional)            : {filename or "not provided"}
  MBR (optional)            : {filename or "not provided"}
  CFF Form (optional)       : {filename or "not provided"}

Does this look right?
```

Do NOT ask for file paths. Only ask if a folder is completely empty.
If two files could share the same role, show both and ask which is the final version.
Account documents are only relevant for Existing Client and Existing Client New Scope
modes. Do not prompt for them in Prospect mode.

### Determine operating mode

- **Mode A** - Draft questions file is present: evaluate, deduplicate, consolidate, rewrite
- **Mode B** - No draft questions file: generate questions from scratch

Announce the mode to the user before proceeding.

---

## Step 2 - Read and Analyze Inputs

### Read the RFP

Extract all text, tables, and structured content. Identify:
- All stated requirements, scope items, and evaluation criteria
- Ambiguities, missing definitions, and under-specified areas
- Mandatory vs. evaluated sections
- Any published evaluation weights or scoring criteria
- Commercial, technical, operational, and SLA-related gaps

### Read win themes (if provided)

Note the key themes. These inform:
- Strategic reframing of questions (dimension 18)
- Priority classification of gaps (dimension 20)

### Read account documents (Existing Client modes only)

Extract the following signals from each document:

| Document | What to extract |
|---|---|
| Account Plan | Current delivery scope, team structure, strategic objectives, known client priorities |
| QBR | Recent SLA performance, delivery metrics, strategic initiatives, open items |
| MBR | Recent operational performance, open issues, escalations, trends |
| CFF Form | Satisfaction scores, specific praise, flagged concerns, improvement requests |

**CFF-specific rule:** Log every concern or improvement area flagged in the CFF.
These become a blocklist - questions that reopen these topics are flagged in
dimension 18 and reframed to demonstrate progress rather than resurface issues.

**Known scope list:** Compile from Account Plan and QBR/MBR {config.company.short_name} already
knows about the client environment. This feeds dimension 16 scoring - questions
about things on this list are penalized in Existing Client mode.

### Read draft questions (Mode A only)

Extract all questions. Note:
- Original numbering and grouping
- Category and sub-category labels if present
- Any context or rationale provided alongside questions

---

## Step 3 - Analysis

### Relationship Mode Scoring Adjustments

Apply these adjustments throughout all dimension scoring:

**Prospect:** Standard scoring thresholds. Generic questions acceptable at score 3.

**Existing Client:**
- Questions about items on the known scope list score 1 in dimension 16
- Generic questions score 2 max in dimension 16
- Dimension 18 score 5 requires the question to reference or build on existing
  partnership, delivery history, or outcomes
- Questions that read like a cold pitch score 2 max in dimension 18
- CFF blocklist applied - flagged concern topics are reframed, not reopened

**Existing Client New Scope:**
- Apply Existing Client thresholds for questions touching current scope areas
- Apply Prospect thresholds for questions about genuinely new scope areas
- Label each question as "current scope" or "new scope" before scoring

---

### Mode A - Evaluate and Improve Draft Questions

#### Dimension 16 - Question Quality (per question)

| Score | What it looks like |
|---|---|
| 5 | Specific, unambiguous, uncovers a hidden requirement or shapes the deal |
| 4 | Relevant and specific, adds value but does not shape the deal |
| 3 | Relevant but generic - could apply to any RFP |
| 2 | Vague or obvious - client will find it low-value |
| 1 | Off-topic, already answered in RFP, harmful, or asks what {config.company.short_name} should already know |

Flag score 1 for removal. Flag score 2 for rewrite.

#### Dimension 17 - Deduplication and Consolidation (document level)

- Identify duplicate or substantially overlapping questions
- Consolidate into single sharper questions
- Record: original Q numbers merged, rationale, consolidated wording

#### Dimension 18 - Strategic Intent / Deal Shaping (per question)

| Score | What it looks like |
|---|---|
| 5 | Subtly reinforces a win theme or references existing partnership to deepen vs. discover |
| 4 | Proactive - opens a door but does not explicitly position |
| 3 | Neutral - purely clarification-seeking |
| 2 | Reactive, defensive, or reads like a cold pitch (Existing Client mode) |
| 1 | Could weaken {config.company.short_name}'s position or reopens a CFF-flagged concern |

For score 3 questions where a win theme is relevant, recommend a reframed version.

#### Dimension 19 - Coverage of Critical Gaps (document level)

- List all major ambiguities, risks, and missing information from the RFP
- For each gap: Covered / Partially Covered / Not Covered
- For Not Covered gaps, generate a recommended question

#### Dimension 20 - Prioritization (per question)

| Priority | What it means |
|---|---|
| Critical | Must be answered before solutioning or pricing is possible |
| High | Significantly affects scope or delivery model |
| Medium | Useful context, affects quality of response |
| Low | Nice to have - minimal impact if unanswered |

Derive from RFP signals where available. Apply generic logic as fallback.

---

### Mode B - Generate Questions from Scratch

1. Identify all RFP gaps, ambiguities, and missing specifications
2. Generate a question per gap
3. Apply relationship mode framing (deepen vs. discover, CFF blocklist, win themes)
4. Classify by priority (dimension 20)
5. Group by category and sub-category
6. Skip dimensions 16 and 17
7. Run dimension 19 as completeness check

---

## Step 4 - Build the Final Question Set

- Remove score 1 questions
- Rewrite score 2 questions
- Apply all dimension 17 consolidations
- Apply dimension 18 strategic reframing where recommended
- Assign final category, sub-category, priority
- Renumber sequentially from 1

### Default category taxonomy

| Category | Example Sub-Categories |
|---|---|
| General - RFP | NDA, Coverage, Eligibility |
| Scope | In-scope / out-of-scope, Locations, Asset inventory |
| Technical | Architecture, Toolchain, Integration, Security |
| Delivery Model | Onshore/offshore mix, SLA tiers, Escalation |
| Commercial | Pricing structure, Rate cards, Contract terms |
| Governance | Reporting cadence, RACI, Escalation paths |
| Transition | Timelines, Knowledge transfer, Incumbent handover |
| SLA | Response targets, Resolution targets, Penalty clauses |

Derive from RFP structure. Use defaults only where RFP provides no signals.

---

## Step 5 - Generate Outputs

### Output A - {config.branding.excel_header_title} (Excel)

Generate using openpyxl. Single sheet, no internal scoring tab.

#### Layout

- Rows 1-3: merged header banner, dark navy (#1F2D3D), "{config.branding.excel_header_title}" centered
  white bold 16pt Calibri, tagline right-aligned white 9pt italic
- Row 4: column headers, fill #2E4057, white bold 10pt Calibri
- Row 5+: alternating #DCE6F1 / #FFFFFF, 10pt Calibri #2C2C2C, thin borders #BFBFBF

#### Columns

| Col | Label | Width |
|---|---|---|
| A | Query No. | 10 |
| B | Category | 20 |
| C | Sub-Category | 22 |
| D | {config.company.short_name} Query | 60 |
| E | Response to Query | 35 |

Col D: wrap text. Col E: blank, fill #F2F2F2.
Sort: Priority descending within each Category. Priority column NOT shown in client file.

```python
import openpyxl
from openpyxl.styles import PatternFill, Font, Alignment, Border, Side
from openpyxl.utils import get_column_letter

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "{config.branding.excel_header_title}"

ws.merge_cells("A1:E3")
ws["A1"].value = "{config.branding.excel_header_title}"
ws["A1"].font = Font(name="Calibri", bold=True, size=16, color="FFFFFF")
ws["A1"].alignment = Alignment(horizontal="center", vertical="center")
ws["A1"].fill = PatternFill("solid", fgColor="1F2D3D")

col_headers = ["Query No.", "Category", "Sub-Category", "{config.company.short_name} Query", "Response to Query"]
col_widths = [10, 20, 22, 60, 35]
for i, (h, w) in enumerate(zip(col_headers, col_widths), 1):
    cell = ws.cell(row=4, column=i, value=h)
    cell.font = Font(name="Calibri", bold=True, size=10, color="FFFFFF")
    cell.fill = PatternFill("solid", fgColor="2E4057")
    cell.alignment = Alignment(horizontal="center" if i==1 else "left",
                               vertical="center", wrap_text=True)
    ws.column_dimensions[get_column_letter(i)].width = w

thin = Side(style="thin", color="BFBFBF")
border = Border(left=thin, right=thin, top=thin, bottom=thin)
for row_idx, q in enumerate(final_questions, start=5):
    fill = PatternFill("solid", fgColor="DCE6F1" if row_idx%2==1 else "FFFFFF")
    for col_idx, val in enumerate([q["number"],q["category"],q["sub_category"],q["question"],""], 1):
        cell = ws.cell(row=row_idx, column=col_idx, value=val)
        cell.font = Font(name="Calibri", size=10, color="2C2C2C")
        cell.fill = PatternFill("solid", fgColor="F2F2F2") if col_idx==5 else fill
        cell.border = border
        cell.alignment = Alignment(horizontal="center" if col_idx==1 else "left",
                                   vertical="top", wrap_text=True)
wb.save(output_path)
```

---

### Output B - Question Assessment Report (HTML)

Self-contained single HTML file. All CSS and JS inline. No external dependencies.

#### Color palette

| Token | Hex | Usage |
|---|---|---|
| Navy | #1F2D3D | Nav bar, headers |
| Teal | #1B7A8A | Accents, links, highlights |
| Red | #C0392B | Critical, score 1 |
| Amber | #E67E22 | High, score 2 |
| Blue | #2980B9 | Medium, score 3 |
| Green | #27AE60 | Low, score 4-5 |
| Light gray | #F4F6F8 | Page background |
| White | #FFFFFF | Card backgrounds |

#### Global layout

Fixed top nav bar (navy) containing:
- Left: "{config.company.short_name} | {Client} RFP - Question Assessment" in white
- Center: tab links - Overview | Questions | Gap Matrix | Dedup Log | Input Documents
- Right: "Export to PDF" button (teal background, white text)

Page background #F4F6F8. Content in white cards with subtle box-shadow.
Font: Inter or system-ui, 14px base.

---

#### Tab 1 - Overview

**3 stat cards (side by side):**

- **Overall Quality Score** - large number color coded (green ≥80, amber 60-79, red <60),
  sub-label "Question Quality Score", small "Based on {N} questions evaluated"
- **Critical Priority Questions** - large count in red, sub-label "Critical Priority
  Questions", clickable - filters Questions tab to Critical
- **Uncovered Gaps** - large count in amber, sub-label "RFP Gaps Without a Question",
  clickable - filters Gap Matrix to Not Covered

**2-panel row below cards:**

Left (50%) - Critical Questions list: Q# | Category | first 80 chars of question.
Each row clickable - jumps to that question expanded in Questions tab.
If none: green checkmark "No critical gaps identified."

Right (50%) - Uncovered Gaps list: gap description truncated.
Each row clickable - jumps to that row in Gap Matrix.
If none: green checkmark "All identified gaps have coverage."

**Relationship context banner** (full width, below 2-panel row):

Banner is a structured status block - not a single strip. Behavior varies by mode
and missing inputs.

Warning rules:
- Win themes missing + Prospect: amber warning
- Win themes missing + Existing Client or Existing Client New Scope: red warning
- Account docs missing + Existing Client or Existing Client New Scope: red warning
- Account docs: not shown for Prospect mode

Banner states:

Prospect - fully loaded:
```
✅ Relationship Mode: Prospect  |  ✅ Win themes: Loaded ({N} themes)
```

Prospect - win themes missing:
```
✅ Relationship Mode: Prospect  |  ⚠️ Win themes: Not provided - D18 using {config.company.short_name} delivery positioning
```

Existing Client - fully loaded:
```
✅ Relationship Mode: Existing Client
✅ Account documents: Account Plan, QBR, CFF loaded
✅ Win themes: Loaded ({N} themes)
```

Existing Client - both missing:
```
✅ Relationship Mode: Existing Client
🔴 Account documents: None loaded - relationship-based scoring limited
🔴 Win themes: Not provided - D18 strategic scoring degraded
```

Existing Client - account docs missing, win themes loaded:
```
✅ Relationship Mode: Existing Client
🔴 Account documents: None loaded - relationship-based scoring limited
✅ Win themes: Loaded ({N} themes)
```

Existing Client New Scope - both missing:
```
✅ Relationship Mode: Existing Client New Scope  |  Scored as: Hybrid
🔴 Account documents: None loaded - relationship-based scoring limited
🔴 Win themes: Not provided - D18 strategic scoring degraded
```

Existing Client New Scope - fully loaded:
```
✅ Relationship Mode: Existing Client New Scope  |  Scored as: Hybrid
✅ Account documents: Account Plan, QBR, MBR, CFF loaded
✅ Win themes: Loaded ({N} themes)
```

---

#### Tab 2 - Questions

**Sticky filter bar:**
Dropdowns for Priority | Action | Category | D16 Score | D18 Score.
Active filter badge count. "Clear all" link.

**Collapsed rows (default):**
```
[Q#] [Category] [Sub-Category] [Priority badge] [D16 ●●●○○] [D18 ●●●●○] [Action badge] [▼]
```

Priority badges: color coded pills.
Action badges: Kept (green) | Rewritten (teal) | Removed (red) | Consolidated (gray).

**Expanded row:**
```
Original Question:
"{full text}"

Dimension 16 - Question Quality    ●●●○○  3/5  Adequate
{rationale}

Dimension 18 - Strategic Intent    ●●●●○  4/5  Strong
{rationale}

Action: Rewritten
Rewritten version:
"{rewritten text}"
```

Consolidated: "Merged into Q{X}" with link.
Removed: reason in red text.
Mode B: show D18 and Priority only, skip D16/D17.

---

#### Tab 3 - Gap Matrix

**Summary bar:** "{N} gaps - {X} Covered | {Y} Partially Covered | {Z} Not Covered"

**Filter:** All | Covered | Partially Covered | Not Covered

**Table columns:** # | RFP Gap / Ambiguity | Coverage | Question(s) | Recommended Question

Row left-border color: green (Covered) | amber (Partially Covered) | red (Not Covered).
Coverage cell: colored pill badge.
Questions cell: clickable Q# badges linking to Tab 2.
Recommended Question: shown only for Not Covered rows, italic text.

---

#### Tab 4 - Dedup Log

Mode B: "Not applicable - questions were generated, not deduplicated."

**Summary:** "Original: {N} → After consolidation: {M} ({X} merged, {Y} removed)"

**Consolidation cards:**
```
Merged: Q3 + Q7 + Q11
Reason: {rationale}
Consolidated Question: "{text}"
```

**Removed questions section:**
List of Q# with removal reason (score 1 - off-topic / already in RFP / harmful / known scope).

---

#### Tab 5 - Input Documents

Header: "Input Documents & Impact on Scoring"
Sub-header: "Upload missing documents and rerun to improve question quality and scoring accuracy."

**Section 1 - Documents Provided** (green checkmark per row)

Table columns: Document | Type | Mandatory | What it contributed

Example rows:
- Marco_RFP_v2.pdf | RFP | Required | Source of all gaps, requirements, and priority signals
- Win_Themes.pdf | Win Themes | Recommended | Enabled D18 strategic framing across 12 questions

**Section 2 - Documents Missing** (color coded by mandatory status)

Table columns: Document | Type | Mandatory | Impact of Missing | Action

Mandatory status is dynamic based on relationship mode:

| Document | Prospect | Existing Client | Existing Client New Scope |
|---|---|---|---|
| RFP | Required | Required | Required |
| Draft Questions | Recommended | Recommended | Recommended |
| Win Themes | Recommended | Required | Required |
| Account Plan | Not applicable | Required | Required |
| QBR / MBR | Not applicable | Required | Required |
| CFF Form | Not applicable | Recommended | Recommended |

Row color coding in missing table:
- Required (red): light red background #FFDCE1
- Recommended (amber): light amber background #FFF2CC
- Not applicable: not shown

Impact of missing - per document:
- Draft Questions: "Running in Mode B - questions generated from scratch, not evaluated against existing draft"
- Win Themes (Prospect): "D18 strategic framing using {config.company.short_name} delivery positioning as fallback - less targeted"
- Win Themes (Existing Client): "D18 strategic scoring degraded - win theme reinforcement not possible"
- Account Plan: "Known scope list could not be compiled - D16 relationship scoring limited"
- QBR / MBR: "Recent delivery metrics unavailable - D18 partnership framing weakened"
- CFF Form: "CFF blocklist unavailable - risk of inadvertently reopening client concerns"

Action column: "Upload and rerun" (static text, not a button)

**Call to action bar** (teal background, bottom of tab):

```
To improve your score:
1. Upload the missing documents listed above to your working folder
2. Return to Claude and say: "Rerun rfp-clarification-q-optimizer with updated documents"
3. The skill will detect the new files and regenerate both outputs
```

---

#### PDF Export

"Export to PDF" triggers `window.print()` with print CSS:

```css
@media print {
  nav, .filter-bar, .export-btn { display: none; }
  .tab-content { display: block !important; page-break-before: always; }
  .question-detail { display: block !important; }
  body { background: white; }
  .card { box-shadow: none; border: 1px solid #ddd; }
  tr { page-break-inside: avoid; }
  .tab-content::before {
    content: attr(data-title);
    display: block;
    font-size: 18px;
    font-weight: bold;
    color: #1F2D3D;
    margin-bottom: 16px;
    padding-bottom: 8px;
    border-bottom: 2px solid #1B7A8A;
  }
}
```

All 5 tabs print in sequence. All question rows fully expanded. Page breaks between tabs.

---

## Step 6 - Save Outputs and Confirm

```
workspace/rfp-pursuits/{client}_{rfp}_{date}/rfp-clarification-q-optimizer/
  {config.company.short_name}_Query_Log_{client}_{date}.xlsx
  Question_Assessment_Report_{client}_{date}.html
```

Confirm to user:
```
Done. Two files saved:

  Client deliverable : {config.company.short_name}_Query_Log_{client}_{date}.xlsx
  Internal report    : Question_Assessment_Report_{client}_{date}.html
                       (open in browser - use Export to PDF button to save as PDF)

Final question count  : {N} across {X} categories
Questions removed     : {N}
Questions rewritten   : {N}
Questions consolidated: {N} pairs merged
Uncovered RFP gaps    : {N} (see Gap Matrix tab)
```

---

## Recommendations Quality Standard

Each recommendation must be specific, actionable, and framed as suggested language.

Good: "Q4 and Q7 both ask about offshore delivery from different angles. Consolidate
into: 'Are there restrictions or preferences regarding delivery from {config.company.short_name} offshore
locations (India) or nearshore (Toronto, Poland, Brazil)?'"

Bad: "Some questions could be more specific."

---

## Edge Cases

- **Image-heavy RFP PDF**: Note unreadable sections in Gap Matrix, flag for manual review
- **No category labels on draft questions**: Infer from content using default taxonomy
- **Win themes not provided**: D18 runs using {config.company.short_name} delivery positioning as fallback (rightshore model, AI-native SDLC, delivery maturity). Show amber warning (Prospect) or red warning (Existing Client modes) in Overview banner and Input Documents tab.
- **No account docs in Existing Client mode**: Apply Existing Client thresholds but note
  that known scope list could not be compiled - flag in Overview tab
- **All questions score 4-5**: Note as strong quality signal in Overview. Still run D17 and D19
- **Short or high-level RFP**: Flag lack of specificity as a gap in Gap Matrix
