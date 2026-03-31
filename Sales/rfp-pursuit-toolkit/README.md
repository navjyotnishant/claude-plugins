# rfp-pursuit-toolkit

**Author:** Navjyot Nishant
**Version:** 1.0.0
**Date:** March 25, 2026

A Claude plugin for enterprise RFP pursuit teams. Bundles two skills plus
shared guidance files covering the full clarification and proposal evaluation lifecycle.

---

## Skills Included

| Skill | Namespace | When to use |
|---|---|---|
| rfp-clarification-q-optimizer | `rfp-pursuit-toolkit:rfp-clarification-q-optimizer` | Early pursuit - RFP received, questions being drafted or generated |
| rfp-proposal-scorer | `rfp-pursuit-toolkit:rfp-proposal-scorer` | Pre-submission - proposal written, ready for internal review |

**Pursuit sequence:**
```
RFP received
    |
    v
rfp-clarification-q-optimizer   <- generate or evaluate clarification questions
    |
    v
Client Q&A round
    |
    v
Proposal drafted
    |
    v
rfp-proposal-scorer             <- score and improve proposal before submission
```

---

## Setup - Configuration (Required Before First Use)

The plugin uses shared config files with workspace-first fallback:
- `config.yaml` for company details, delivery model, frameworks, and branding
- `personas.yaml` for buyer persona definitions used by `rfp-proposal-scorer`

**Steps:**
1. Open the `config/` folder in this plugin directory
2. Copy `config.template.yaml` and rename it to `config.yaml`
3. Copy `personas.template.yaml` and rename it to `personas.yaml`
4. Fill in all fields with your company details and personas
5. Save - the plugin reads these files automatically on first run

The skills check the active workspace first for `config.yaml` and `personas.yaml`,
then fall back to the plugin `config/` folder.

These files are mandatory where used:
- `config.yaml` is required for both skills
- `personas.yaml` is required for `rfp-proposal-scorer`
- win themes are required for `rfp-proposal-scorer` in Existing Client and Existing Client New Scope pursuits

If a required file is missing from both the active workspace and the plugin
`config/` folder, the skill should stop and ask the user to provide it before proceeding.

---

## How to Install

### Option 1 - Upload ZIP (easiest for individuals)

1. Fill in `config/config.yaml` as described above
2. Fill in `config/personas.yaml` for `rfp-proposal-scorer`
3. From the repo root, run:

   `./package-plugin.sh Sales/rfp-pursuit-toolkit`

4. The script will generate `rfp-pursuit-toolkit.zip` at the repo root
5. Open Claude Cowork > Customize > Browse plugins > Upload custom plugin
6. Upload the generated ZIP

### Option 2 - Install via Cowork Marketplace

The easiest way to install this plugin is via the Claude Cowork marketplace sync — no ZIP upload needed.

1. Open Claude Cowork > Customize > Browse plugins > Add marketplace
2. Enter: `github.com/navjyotnishant/nj-claude-plugins`
3. Click **Sync**
4. Browse or search for `rfp-pursuit-toolkit`
5. Install the plugin

---

## How to Use

Use this plugin from Claude Desktop in the Cowork tab. After the plugin is installed:
- add your RFP and any supporting files to the working folder or project
- make sure the required config files are available in the workspace or plugin `config/` folder
- ask Claude to run the relevant workflow in natural language

Typical inputs by workflow:
- `rfp-clarification-q-optimizer`: RFP document, optional draft clarification questions, optional win themes, and optional account documents for existing-client pursuits
- `rfp-proposal-scorer`: RFP document, proposal/response document, required `personas.yaml`, optional Q&A responses, optional competitor context, required win themes for Existing Client modes, and optional account documents

Example prompts:

**Clarification questions:**
- "Evaluate my clarification questions for this RFP"
- "Generate clarification questions for the Acme RFP"
- "Create a query log for this RFP"
- "Run the clarification Q optimizer on this RFP"
- "Generate a Cybage Query Log for this RFP"
- "Generate RFP clarification questions and produce the Excel and HTML report"
- "Use the rfp-clarification-q-optimizer for this RFP"
- "Create the Q&A log for this RFP - Excel format with scoring"

**Proposal scoring:**
- "Score my proposal against this RFP"
- "Review our proposal before submission"
- "Run a proposal quality check"

---

## Output Directory Structure

Both skills write outputs to a shared directory per pursuit:

```
workspace/
└── rfp-pursuits/
    └── {client-name}_{rfp-name}_{date}/
        ├── rfp-clarification-q-optimizer/
        │   ├── {company}_Query_Log_{client}_{date}.xlsx
        │   └── Question_Assessment_Report_{client}_{date}.html
        └── rfp-proposal-scorer/
            ├── Proposal_Scoring_Report_{client}_{date}.docx
            └── Proposal_Scoring_Report_{client}_{date}.pdf
```

Notes:
- `{company}` comes from `config.yaml` as `{config.company.short_name}`
- both skills write into the same pursuit folder, each in its own subfolder
- the skills confirm the output path before creating any files

---

## Plugin Structure

```
rfp-pursuit-toolkit/
├── README.md
├── .claude-plugin/
│   └── plugin.json
├── shared/
│   ├── output-directory.md
│   ├── file-resolution.md
│   └── relationship-modes.md
├── config/
│   ├── config.template.yaml
│   ├── personas.template.yaml
└── skills/
    ├── rfp-clarification-q-optimizer/
    │   └── SKILL.md
    └── rfp-proposal-scorer/
        └── SKILL.md
```

Notes:
- `shared/` contains reusable guidance used by multiple skills
- `config/` contains template files only; local filled files such as `config.yaml` and `personas.yaml` should not be committed
- `skills/` contains one directory per skill, each with its own `SKILL.md`

---

## Questions or Issues

Raise an issue at github.com/navjyotnishant/nj-claude-plugins or contact Navjyot Nishant.
