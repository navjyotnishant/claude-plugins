---
name: rfp-proposal-scorer
description: Scores a proposal across 15 quality dimensions. Produces a DOCX + PDF scoring report with weighted assessment, win theme heatmap, and priority action plan.
---

# rfp-proposal-scorer

## When to Use This Skill

Use this skill whenever you need to:
- Score a proposal or RFP response before final submission
- Evaluate how well a proposal addresses strategic positioning, persona alignment, and RFP compliance
- Get an internal quality review with actionable recommendations
- Replace or supplement the rfp-scorer skill with a 15-dimension weighted assessment

Always trigger when a proposal document and an RFP are both present and the user
asks for evaluation, scoring, review, or quality check.

---

## Overview

Scores a proposal across 15 dimensions grouped into two weighted groups:
- Group 1: Strategic Positioning and Persona Alignment (dimensions 1-6, 12-15) - 60% weight
- Group 2: Compliance and Structure (dimensions 7-11) - 40% weight

Produces two outputs:
1. **Proposal Scoring Report** - DOCX with cover banner, executive summary, win theme heatmap, scorecard, dimension-by-dimension assessment, and priority action plan
2. **PDF** - converted from DOCX for sharing

---

## Shared References

This skill uses shared logic from the plugin. Read these files before proceeding:

- `../../shared/output-directory.md` - config lookup, directory naming, user confirmation flow
- `../../shared/file-resolution.md` - folder scanning, file role inference, confirmation protocol
- `../../shared/relationship-modes.md` - relationship mode definitions, scoring adjustments, account document extraction, banner spec

Follow those files exactly for Steps 0, 1, and relationship mode logic in Step 3.

---

## Step 0 - Read Config, Personas, and Establish Output Directory

Follow `../../shared/output-directory.md` for the full protocol.

Additionally, after reading config.yaml, locate and read the personas file:

```bash
# Check workspace first
cat {workspace}/personas.yaml

# If not found, check plugin config
cat ../../config/personas.yaml
```

If personas file not found:
```
No personas.yaml found. Persona alignment scoring (dimensions 1 and 2) will use
generic persona definitions. For more accurate scoring, place personas.yaml in
your workspace or plugin config/ folder.
```

Proceed without personas file - fall back to generic persona definitions built
into Step 4 dimension 1 and 2 scoring guidance.

Skill name for output directory: `rfp-proposal-scorer`

---

## Step 1 - File Resolution

Follow `../../shared/file-resolution.md` for the full protocol.

File roles relevant to this skill:

| Input | Required | Notes |
|---|---|---|
| RFP document | Required | Base requirements for dimensions 7 and 15 |
| Proposal / RFP response | Required | Primary document being scored |
| Q&A answers from client | Optional | Updates or overrides requirements where Q&A conflicts with RFP |
| Win themes | Required | Dimensions 3, 5, 12, 13 - flag as missing if not provided |
| Target buyer personas | Required | Multi-select from personas file - ask user which personas are in the buying group |
| Competitor context | Optional | Dimension 5 - see Step 3 for Mode A and Mode B |
| Client industry / context | Optional | Dimension 15 |
| Account Plan | Optional | Existing Client modes only |
| QBR / MBR | Optional | Existing Client modes only |
| Client feedback / satisfaction document | Optional | Existing Client modes only |

After file resolution, ask the user which personas are present in the buying group:

```
Which personas are part of the buying group for this pursuit?
(Select all that apply from your personas.yaml, or list them if you know)
```

---

## Step 2 - Read and Analyze All Inputs

### Read the RFP

Extract all text, tables, and structured content. Identify:
- All stated requirements, scope items, and evaluation criteria
- Mandatory vs. evaluated sections
- Any published evaluation weights or scoring criteria
- Section structure and question numbering

### Read Q&A answers from client (if provided)

- Note clarifications that change or add to original requirements
- Flag which requirements were clarified
- Q&A overrides RFP where they conflict - score against the Q&A version

### Read the proposal

Read the full proposal carefully, processing both text and visuals.
- Map each RFP requirement to the corresponding proposal section
- Note where requirements are addressed through visuals (diagrams, tables, org charts)
- Identify sections that are generic or templated vs. tailored

**Image reading protocol:**
Many proposals answer requirements through visuals - architecture diagrams, org charts,
reference cards, rate card tables, timeline visuals. Never score a section as missing
before checking whether a visual addresses it. For image-heavy PDFs, rasterize pages
where text extraction yields little content:

```python
from pdf2image import convert_from_path
pages = convert_from_path(proposal_file, dpi=150, first_page=N, last_page=N+3)
for i, page in enumerate(pages):
    page.save(f'/tmp/page_{N+i}.png')
```

Inspect rendered images and score based on what the visual actually delivers.

### Read win themes

Note all win themes. These are used in dimensions 3, 5, 12, 13 and to build
the win theme coverage heatmap.

### Read account documents (Existing Client modes)

Follow `../../shared/relationship-modes.md` account document extraction protocol.
Build the known scope list and CFF blocklist before scoring.

### Read competitor context (if provided - Mode A)

Note named competitors and any scope descriptor provided by the user.
This feeds dimension 5 competitive positioning scoring.

---

## Step 3 - Competitive Analysis

### Mode A - Named Competitors

User has provided specific competitor names. For each named competitor:
- Assess how well the proposal positions against them explicitly or implicitly
- Evaluate strength of differentiation, relevance of comparisons, clarity of "why us"
- Check whether the proposal addresses the competitor's known strengths

### Mode B - Inferred Competitors

No competitor context provided. Infer likely competitors via web search:

Search signals to use:
- RFP scope (e.g. managed IT services, cloud operations, application development)
- Client industry from RFP or client context file
- Delivery model signals from config (e.g. rightshore, offshore-heavy)
- Commercial/pricing signals from RFP (e.g. rate card structure, contract type)

Before running analysis, present inferred list to user for confirmation:

```
Based on the RFP scope, client industry, and delivery model, I believe the
likely competitors for this pursuit are:

1. {Competitor A} - {reason: e.g. known managed services provider in this vertical}
2. {Competitor B} - {reason}
3. {Competitor C} - {reason}

Should I run competitive analysis against these, or would you like to adjust the list?
```

Only proceed with competitive analysis after explicit user confirmation.

---

## Step 4 - Score All 15 Dimensions

Apply relationship mode scoring adjustments from `../../shared/relationship-modes.md`
throughout all dimension scoring.

### Scoring Rubric - 1 to 5 Scale

| Score | Label | Dot Visual | Description |
|---|---|---|---|
| 5 | Excellent | ●●●●● | Exceeds expectation - specific, evidenced, differentiated |
| 4 | Strong | ●●●●○ | Dimension clearly addressed with good supporting detail |
| 3 | Adequate | ●●●○○ | Covered but lacks specificity or depth |
| 2 | Weak | ●●○○○ | Referenced superficially with no supporting evidence |
| 1 | Critical Gap | ●○○○○ | Absent or nearly absent from the proposal |

---

### Group 1 - Strategic Positioning and Persona Alignment (60% weight)

#### Dimension 1 - Persona Alignment

Identify the target buyer personas selected by the user. For each persona, evaluate
whether the proposal messaging aligns with their priorities, language register, and
decision criteria using the persona definitions loaded from personas.yaml.

Score 5: Messaging is precisely calibrated to each persona - language depth, priority
framing, and decision criteria all addressed explicitly.
Score 4: Good persona alignment with minor gaps in language or priority framing.
Score 3: Proposal addresses some personas well but ignores others, or is generic
across all personas.
Score 2: Messaging is calibrated to one persona only, ignoring the buying group.
Score 1: Proposal reads as a generic capability document with no persona awareness.

Flag mismatches: too technical for financial personas, too generic for technical
personas, missing framing for any selected persona.

#### Dimension 2 - Stakeholder Coverage Completeness

Evaluate whether all key stakeholder perspectives in the buying group are represented:
business, technical, financial, and operational. A winning proposal supports consensus
decision-making, not just one champion.

Score 5: All four stakeholder perspectives explicitly addressed with tailored messaging.
Score 4: Three perspectives addressed well.
Score 3: Two perspectives addressed, others implied but not explicit.
Score 2: Only one stakeholder perspective dominates the entire proposal.
Score 1: Proposal reads as written for a single audience with no stakeholder awareness.

#### Dimension 3 - Alignment with Sales Win Themes

Validate that the proposal consistently reflects the win themes provided. Build a
win theme coverage map across all major proposal sections. Flag dilution, inconsistency,
or absence.

Score 5: All win themes present and reinforced in every major section. Messaging is
consistent and not diluted by contradictory content.
Score 4: All win themes present but not reinforced equally across sections.
Score 3: Most win themes present but one or more absent from key sections.
Score 2: Win themes appear in isolated sections only, not woven throughout.
Score 1: Win themes absent or contradicted by the proposal content.

#### Dimension 4 - Value Proposition Strength and Clarity

Assess whether the value proposition is clear, differentiated, and outcome-driven.
Check for measurable business impact (ROI, speed, efficiency, risk reduction)
vs. generic capability statements.

Score 5: Value proposition is specific, outcome-driven, quantified where possible,
and clearly differentiated from generic alternatives.
Score 4: Clear value proposition with good outcome framing but limited quantification.
Score 3: Value proposition present but generic - could apply to any vendor.
Score 2: Value statements present but vague or input-focused rather than outcome-focused.
Score 1: No discernible value proposition - proposal reads as a feature list.

Flag weak patterns: "we have extensive experience", "we deliver quality solutions",
"our team is dedicated" without supporting specifics.

#### Dimension 5 - Competitive Positioning and Differentiation

Using the competitive analysis from Step 3, assess how well the proposal positions
against the identified competitors.

Score 5: Clear differentiation narrative with specific "why us" arguments that
directly address competitor weaknesses. Unique capabilities and frameworks named.
Score 4: Good differentiation with some specific positioning but gaps in "why us" clarity.
Score 3: Generic differentiation present but not tied to specific competitive dynamics.
Score 2: Differentiation implied but not articulated. Proposal could apply to any vendor.
Score 1: No competitive awareness. Proposal reads as if it exists in a vacuum.

Reference config frameworks (e.g. {config.frameworks}) as differentiators where
relevant and where they genuinely address the RFP scope.

#### Dimension 6 - AI-Native Engineering Narrative

Evaluate the depth and authenticity of AI integration across the solution lifecycle
(development, testing, operations, support). Distinguish superficial AI mentions
from embedded AI-led transformation.

Score 5: AI is embedded across all delivery layers with named frameworks, specific
toolchains, and credible evidence. Automation claims use ranges not absolutes.
Score 4: AI embedded in most delivery layers with good specificity. Minor gaps.
Score 3: AI mentioned in context of one or two delivery layers only.
Score 2: AI present as buzzword or single mention without specificity.
Score 1: No AI narrative or AI mentioned only in passing.

Failure modes to flag:
- Absolute efficiency percentages ("40% improvement") without ranges or evidence
- AI scoped only to L1 support or helpdesk - signals limited maturity
- No named framework or platform - generic automation claims
- Replacement narrative (AI eliminates roles) vs. agent-assist narrative (AI augments)

Reference config frameworks applicable to AI/automation where relevant.

#### Dimension 12 - Executive Summary Effectiveness

Assess whether the executive summary clearly communicates the client problem, proposed
solution, value, and differentiation in a concise and compelling manner.

Score 5: Executive summary stands alone as a complete, compelling narrative. All win
themes present. Senior decision-maker audience clearly the target. Problem-solution-value-proof
structure followed.
Score 4: Strong executive summary with minor structural or framing gaps.
Score 3: Executive summary covers the basics but lacks differentiation or win theme alignment.
Score 2: Executive summary reads as a company introduction rather than a client-specific narrative.
Score 1: Executive summary absent, too long, or entirely generic.

#### Dimension 13 - Innovation and Transformation Quotient

Evaluate whether the proposal demonstrates forward-looking thinking rather than just
meeting current requirements. Does it help the client see where they could go, not
just what they need today?

Score 5: Proposal explicitly articulates a transformation vision, innovation roadmap,
or maturity progression tied to the client's business objectives.
Score 4: Forward-looking thinking present in key sections but not consistently applied.
Score 3: Innovation mentioned but framed as a capability, not as a client outcome.
Score 2: Proposal is entirely reactive to stated requirements with no proactive vision.
Score 1: Proposal focuses entirely on current state with no future orientation.

#### Dimension 14 - Consistency and Messaging Coherence

Check for consistency of messaging across all sections. No contradictions, repeated
themes articulated uniformly, terminology consistent throughout.

Score 5: Fully consistent messaging throughout. Terminology, positioning, and value
statements are aligned and reinforcing.
Score 4: Mostly consistent with minor variations in terminology or framing.
Score 3: Some inconsistency in how key themes are described across sections.
Score 2: Notable contradictions or significant terminology variation.
Score 1: Proposal reads as multiple documents assembled without a coherent narrative.

#### Dimension 15 - Client Context and Customization Depth

Assess how well the proposal reflects the client's specific industry, business context,
challenges, and objectives. Flag generic or reusable content.

Score 5: Every major section is tailored to the client. Named client challenges,
referenced client context, and client-specific examples throughout.
Score 4: Strong customization in most sections with isolated generic content.
Score 3: Some client-specific content but large portions feel templated.
Score 2: Minimal customization - client name appears in headers but content is generic.
Score 1: Proposal is a template with the client name replaced. No meaningful customization.

For Existing Client mode: apply higher threshold - the proposal must reference
specific delivery history, outcomes, and joint initiatives, not just industry context.

---

### Group 2 - Compliance and Structure (40% weight)

#### Dimension 7 - Solution Alignment to RFP Requirements

Ensure complete and traceable coverage of all RFP requirements. Map each requirement
to the corresponding proposal section. Apply Q&A overrides where applicable.

Score 5: All requirements addressed with clear traceability. Q&A updates reflected.
No gaps, no over-engineering.
Score 4: All requirements addressed with minor gaps in specificity or traceability.
Score 3: Most requirements addressed but 1-2 gaps or partial responses.
Score 2: Several requirements partially addressed or missing.
Score 1: Multiple requirements absent or significantly under-addressed.

Compliance view per requirement: Fully Met / Partially Met / Missing

#### Dimension 8 - Evidence, Proof Points, and Credibility

Assess the presence and relevance of case studies, client references, metrics,
and success stories. Do proof points align with the client's industry and problem context?

Score 5: Specific, relevant proof points with named clients (where permitted), quantified
outcomes, and direct alignment to the client's context.
Score 4: Good proof points with minor gaps in industry alignment or quantification.
Score 3: Proof points present but generic or from unrelated industries.
Score 2: Claims made but unsupported by evidence.
Score 1: No proof points. All claims are assertions.

For Existing Client mode: own delivery outcomes with this client are primary evidence.
Generic case studies from other clients score maximum 3 when client-specific evidence
is available and not used.

#### Dimension 9 - Commercial Narrative and ROI Justification

Evaluate whether pricing is linked to value delivered. Is there an ROI, TCO, or
cost optimization narrative? Is the commercial story connected to business outcomes?

Score 5: Pricing explicitly linked to value delivered. ROI model or TCO narrative
present. Commercial terms framed as investment, not cost.
Score 4: Good commercial narrative with minor gaps in ROI quantification.
Score 3: Commercial section present but disconnected from business outcomes.
Score 2: Pricing listed without context or value linkage.
Score 1: Commercial section absent or a rate card only with no narrative.

#### Dimension 10 - Storyline, Structure, and Readability

Analyze the overall narrative flow: problem, solution, value, proof, differentiation.
Is the proposal clear, logically structured, and easy to read?

Score 5: Compelling narrative arc throughout. Clear structure, no jargon without
explanation, no repetition. Evaluator (human or AI) can follow the logic easily.
Score 4: Good structure and readability with minor flow issues.
Score 3: Structure present but some sections are disjointed or jargon-heavy.
Score 2: Significant structural issues. Hard to follow without prior knowledge.
Score 1: No clear narrative. Content is a collection of sections with no flow.

Evaluator-readiness check (AI-assisted evaluation awareness):
- Consistent section headers matching RFP structure
- Named individuals in governance sections
- Explicit coverage of all work types in every relevant section
- Ranges not absolutes on efficiency claims

#### Dimension 11 - Risk Mitigation and Trust Signals

Evaluate whether risks are proactively addressed: delivery, transition, scalability,
security. Does the proposal build confidence and reduce perceived risk?

Score 5: All major risk categories addressed with specific mitigation strategies,
governance models, SLAs with teeth, and named accountable individuals.
Score 4: Good risk coverage with minor gaps in specificity.
Score 3: Risk section present but generic - no specific mitigations.
Score 2: Risks acknowledged but no mitigation strategies.
Score 1: Risk section absent.

---

## Step 5 - Calculate Weighted Score

### Weighted Scoring Model

**Group 1 - Strategic (60%):**
Dimensions 1, 2, 3, 4, 5, 6, 12, 13, 14, 15 (10 dimensions)
- Max raw score: 50 (10 x 5)
- Formula: (sum of Group 1 scores / 50) x 60
- Result: Group 1 contribution (0-60)

**Group 2 - Compliance (40%):**
Dimensions 7, 8, 9, 10, 11 (5 dimensions)
- Max raw score: 25 (5 x 5)
- Formula: (sum of Group 2 scores / 25) x 40
- Result: Group 2 contribution (0-40)

**Overall score:** Group 1 contribution + Group 2 contribution
- Express as: "XX / 100"
- Rating labels:
  - 85-100: Excellent
  - 70-84: Strong
  - 55-69: Adequate
  - 40-54: Weak
  - Below 40: Critical Gap

---

## Step 6 - Build Win Theme Coverage Heatmap

Create a text table showing coverage of each win theme across major proposal sections.
Color coding: green (Strong), amber (Weak), red (Missing).

| Proposal Section | Win Theme 1 | Win Theme 2 | Win Theme 3 |
|---|---|---|---|
| Executive Summary | Strong | Weak | Missing |
| Delivery Model | Strong | Strong | Weak |
| Commercial | Missing | Weak | Strong |

One row per major proposal section. One column per win theme.
This table goes into Section 3 of the DOCX report.

---

## Step 7 - Generate DOCX Report

Generate using python-docx. Match the rfp-scorer design language precisely:
teal palette (#1B7A8A), Calibri throughout, cover banner, section heading bars,
two-column assessment blocks, priority action plan.

### Global Formatting

- Font: Calibri throughout
- Body text: 10pt
- Section headings: 11pt bold
- Page size: US Letter, 1 inch margins
- Header (every page): Document title left, "Confidential - Internal Review" right,
  both in teal (#008B8B), 8pt, separated by horizontal rule
- Footer (every page): "{config.company.short_name} | {Client} Proposal Evaluation | {Month Year}"
  left, "Page N" right, 8pt italic, separated by horizontal rule

### Section 1 - Cover Banner

Full-width teal rectangle (#1B7A8A) spanning the top of page 1. White bold text:
- Line 1 (~20pt): "{CLIENT NAME} RFP - PROPOSAL EVALUATION"
- Line 2 (~18pt): "Strategic Quality Assessment and Recommendations"

Narrow light teal strip below banner:
"{config.company.short_name} | Evaluated: {Month Year} | Internal - Confidential"

### Section 2 - Executive Summary

Section heading bar: teal background, white bold caps "EXECUTIVE SUMMARY"

Two-column layout:

LEFT (~65%):
- "Evaluation Context" in teal bold
- 2-3 sentences: what is being evaluated, number of dimensions, scoring scale
- "Scoring Model" in teal bold
- "Group 1 - Strategic Positioning (60%) | Group 2 - Compliance and Structure (40%)"
- "Relationship Mode" in teal bold
- Mode and any missing input warnings (from shared/relationship-modes.md banner spec)

RIGHT (~35%): Score Box
- Light teal background
- "OVERALL SCORE" bold centered
- Large bold "XX / 100" (~28pt)
- Dot visual (●●●●○)
- Rating label (e.g. "Strong")
- Below score box: "Group 1: XX/60 | Group 2: XX/40"

### Section 3 - Key Findings Bar

Three-column table, no outer border:
- Column 1: "STANDOUT STRENGTHS" dark teal bold, light teal background
  2-4 bullets referencing specific dimension numbers
- Column 2: "SIGNIFICANT GAPS" amber bold, light amber background
  2-4 bullets referencing specific dimension numbers
- Column 3: "CRITICAL GAPS" red bold, light red background
  2-4 bullets referencing specific dimension numbers

### Section 4 - Win Theme Coverage Heatmap

Section heading bar: teal background, white bold caps "WIN THEME COVERAGE"

Table from Step 6. Cell fill by coverage:
- Strong: #E2EFDA (light green)
- Weak: #FFF2CC (light yellow)
- Missing: #FFDCE1 (light red)

Sub-note below table (italic): "Coverage assessed across all major proposal sections.
Weak or missing themes should be reinforced before final submission."

### Section 5 - Scorecard at a Glance

Section heading bar: teal background, white bold caps "SCORECARD AT A GLANCE"

Table with columns: Dim# | Dimension | Group | Weight | Score | Rating

| Dim# | Dimension | Group | Weight | Score | Rating |
|---|---|---|---|---|---|
| 1 | Persona Alignment | Strategic | 60% | 4/5 | ●●●●○ Strong |

Row shading by score:
- Score 5: #E2EFDA (light green)
- Score 4: #EBF3FB (light blue)
- Score 3: #FFF2CC (light yellow)
- Score 2: #FCE4D6 (light orange)
- Score 1: #FFDCE1 (light red)

Score key below (italic): "5 = Excellent | 4 = Strong | 3 = Adequate | 2 = Weak | 1 = Critical Gap"
Weighted score summary below: "Group 1 Strategic: XX/60 | Group 2 Compliance: XX/40 | Overall: XX/100"

### Section 6 - Detailed Dimension Assessment

Section heading bar: teal background, white bold caps "DETAILED DIMENSION ASSESSMENT"

One block per dimension, ordered Group 1 then Group 2. Each block:

**Dimension header line** (above the table):
"D{N} - {Dimension Name}" - D{N} in teal bold, name in dark gray 11pt bold

**Two-column table** (no outer border, light inner borders):

LEFT (~65%):
- "WHAT WAS EVALUATED" in small caps teal, followed by brief description of what
  this dimension examines
- "STRENGTHS IDENTIFIED" in small caps teal, bullet list of specific strengths
  found in the proposal with section references
- "GAPS IDENTIFIED" in small caps teal, bullet list of specific gaps

RIGHT (~35%, top-aligned):
- Score box: light background matching score color, large bold "X/5",
  dot visual (●●●●○), rating label
- "RECOMMENDATIONS" in small caps teal below score box
- Bullet list of specific, actionable recommendations

Separate each dimension block with a thin horizontal rule.

### Section 7 - Priority Action Plan

Section heading bar: teal background, white bold caps
"PRIORITY ACTION PLAN - BEFORE FINAL SUBMISSION"

Three tiers:

**P1 - CRITICAL (Submit Blocker)**
- Sub-heading: teal bold
- Box fill: #FFDCE1 (light red)
- Items scoring 1 on any dimension, or critical RFP compliance gaps

**P2 - HIGH (Scoring Impact)**
- Sub-heading: amber bold
- Box fill: #FFF2CC (light yellow)
- Items scoring 2 on any dimension, or significant win theme gaps

**P3 - RECOMMENDED (Differentiation)**
- Sub-heading: teal bold
- Box fill: #E2EFDA (light green)
- Items that would strengthen the proposal beyond the baseline

**Confidentiality footer** (italic, below action plan):
"This evaluation document is confidential and intended for internal review only.
Scores reflect an independent assessment of the submitted proposal against the
RFP requirements and strategic quality criteria. Recommendations are actionable
and should be incorporated before final submission to {Client Name}."

---

## Step 8 - Convert to PDF

```bash
python scripts/office/soffice.py --headless --convert-to pdf \
  "Proposal_Scoring_Report_{client}_{date}.docx"
```

---

## Step 9 - Save Outputs and Confirm

Save both files to the output directory confirmed in Step 0:

```
workspace/rfp-pursuits/{client}_{rfp}_{date}/rfp-proposal-scorer/
  Proposal_Scoring_Report_{client}_{date}.docx
  Proposal_Scoring_Report_{client}_{date}.pdf
```

Confirm to user:
```
Done. Two files saved:

  workspace/rfp-pursuits/{client}_{rfp}_{date}/rfp-proposal-scorer/
  Proposal_Scoring_Report_{client}_{date}.docx
  Proposal_Scoring_Report_{client}_{date}.pdf

Overall score        : {XX} / 100  ({Rating})
Group 1 Strategic    : {XX} / 60
Group 2 Compliance   : {XX} / 40
Critical gaps (P1)   : {N} items requiring immediate attention
High priority (P2)   : {N} items with significant scoring impact
```

---

## Recommendations Quality Standard

Each recommendation must be:
- **Specific**: reference the exact dimension number, section, role title, or metric
- **Actionable**: describe what to add, change, reframe, or replace
- **Framed as suggested language** where possible

Good: "D15 Client Context - The delivery model section reads as a template. Add
a paragraph referencing {client}'s current environment, naming the specific
platforms and work types relevant to this RFP."

Bad: "Improve customization throughout the proposal."

---

## Edge Cases

- **Proposal in image-heavy PDF**: Follow image reading protocol in Step 2. Never
  score a dimension as missing before checking rendered page images.
- **Q&A contradicts RFP**: Flag both versions. Score against Q&A (latest instruction
  wins) and note the conflict in the dimension block.
- **No Q&A file provided**: Note in executive summary. Score against original RFP only.
- **No win themes provided**: Score dimensions 3, 5, 12, 13 against general
  positioning quality only. Note in scorecard that win theme alignment could not
  be assessed. Flag in P2 action plan.
- **No personas file**: Use generic persona definitions embedded in dimension 1 and 2
  guidance. Note that persona scoring is based on generic profiles.
- **Competitor context not provided and user declines Mode B**: Score dimension 5
  based on internal competitive awareness visible in the proposal only.
- **Existing Client mode, no account documents**: Apply higher thresholds per
  shared/relationship-modes.md but note that known scope list and CFF blocklist
  could not be compiled. Flag in executive summary.
- **Short or high-level proposal**: Low scores on multiple dimensions are expected
  and valid. Do not adjust rubric. Provide specific recommendations for each gap.
