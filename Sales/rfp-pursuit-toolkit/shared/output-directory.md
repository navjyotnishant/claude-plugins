# Shared: Output Directory

This file is referenced by both rfp-clarification-q-optimizer and rfp-proposal-scorer.
Load it when you need to establish the config, confirm details, and create the output directory.

---

## Step 1 - Read Config

Before doing anything else, locate and read the config file.
Check these locations in order:

```bash
# Check workspace first
cat {workspace}/config.yaml

# If not found, check plugin config
cat ../../config/config.yaml
```

If neither exists, tell the user:

```
No config.yaml found. You have two options:

Option A (recommended) - Place config in your workspace:
1. Copy `../../config/config.template.yaml` from the plugin config/ folder
2. Fill in your company details
3. Save as config.yaml in your active workspace folder
4. Re-run the skill

Option B - Place config in the plugin folder:
1. Open the plugin config/ directory at `../../config/`
2. Copy `config.template.yaml` to `config.yaml`
3. Fill in your company details
4. Re-run the skill
```

Do not proceed without a valid config.yaml.

---

## Step 2 - Infer Client and RFP Name

Scan the working folder or uploaded files. Extract:

- `{client-name}` - from the RFP filename (e.g. `Marco_RFP_v2.pdf` → `Marco`)
- `{rfp-name}` - short descriptor from the RFP filename (e.g. `IT_Managed_Services`)
- `{date}` - today's date in YYYYMMDD format

---

## Step 3 - Confirm All Details Before Creating Anything

Present the following confirmation block and wait for explicit user approval.
Do NOT create any directories or files before confirmation.

```
Before I proceed, please confirm the following details:

  Client name        : {inferred client name}
  RFP name           : {inferred rfp name}
  Date               : {today's date}
  Relationship mode  : {Prospect / Existing Client / Existing Client New Scope}
  Output folder      : workspace/rfp-pursuits/{client}_{rfp}_{date}/{skill-name}/

Does this look right? (yes / correct me)
```

If the user has not specified relationship mode, ask before showing the confirmation:

```
Is this a Prospect, an Existing Client, or an Existing Client responding to a New Scope RFP?
```

---

## Step 4 - Create Output Directory

Only after the user confirms, create the output directory:

```bash
mkdir -p "workspace/rfp-pursuits/{client}_{rfp}_{date}/{skill-name}/"
```

Both skills write into the same `{client}_{rfp}_{date}` parent folder,
each in their own subfolder:

```
workspace/rfp-pursuits/
└── {client}_{rfp}_{date}/
    ├── rfp-clarification-q-optimizer/
    │   ├── {company}_Query_Log_{client}_{date}.xlsx
    │   └── Question_Assessment_Report_{client}_{date}.html
    └── rfp-proposal-scorer/
        ├── Proposal_Scoring_Report_{client}_{date}.docx
        └── Proposal_Scoring_Report_{client}_{date}.pdf
```
