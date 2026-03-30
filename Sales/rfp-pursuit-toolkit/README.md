# rfp-pursuit-toolkit

**Author:** Navjyot Nishant
**Version:** 1.0.0
**Date:** March 25, 2026

A Claude plugin for enterprise RFP pursuit teams. Bundles two skills covering
the full clarification and proposal evaluation lifecycle.

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

Both skills read from a shared `config/config.yaml` file that contains your
company details, delivery model, frameworks, and branding.

**Steps:**
1. Open the `config/` folder in this plugin directory
2. Copy `config.template.yaml` and rename it to `config.yaml`
3. Fill in all fields with your company details
4. Save - the plugin reads this file automatically on first run

**Cybage users:** Use the pre-filled `cybage-config.yaml` shared by your admin.
Rename it to `config.yaml` - no other changes needed.

---

## How to Install

### Option 1 - Upload ZIP (easiest for individuals)

1. Fill in `config/config.yaml` as described above
2. Delete `config/config.template.yaml` and `config/cybage-config.yaml`
3. ZIP the entire `rfp-pursuit-toolkit/` folder:
   - Mac: `zip -r rfp-pursuit-toolkit.zip rfp-pursuit-toolkit/`
   - Windows: right-click folder > Send to > Compressed folder
4. Open Claude Cowork > Customize > Browse plugins > Upload custom plugin
5. Upload the ZIP

### Option 2 - Install via Cowork Marketplace (Team/Enterprise)

If your organization admin has set up a private marketplace from the claude-plugins
GitHub repo, install directly from Cowork:
1. Open Claude Cowork > Customize > Browse plugins
2. Search for `rfp-pursuit-toolkit`
3. Click Install

### Option 3 - GitHub sync (Team/Enterprise admins)

Connect the claude-plugins GitHub repo as a private marketplace:
1. Go to Organization Settings > Plugins
2. Add plugin source: `NavjyotNishant/claude-plugins`
3. Plugin syncs automatically on every repo update

---

## How to Use

Type `/` in Cowork to see available commands, or use natural language:

**Clarification questions:**
- "Evaluate my clarification questions for this RFP"
- "Generate clarification questions for the Acme RFP"
- "Create a query log for this RFP"

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
        │   ├── Query_Log_{client}_{date}.xlsx
        │   └── Question_Assessment_Report_{client}_{date}.html
        └── rfp-proposal-scorer/
            ├── Proposal_Scoring_Report_{client}_{date}.docx
            └── Proposal_Scoring_Report_{client}_{date}.pdf
```

---

## Questions or Issues

Raise an issue at github.com/NavjyotNishant/claude-plugins or contact Navjyot Nishant.
