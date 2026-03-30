# claude-plugins

A curated collection of Claude skills built for enterprise pursuit and delivery teams.
Each skill is a purpose-built AI workflow that runs in Claude Cowork, automating
complex, multi-step tasks that would otherwise take hours of manual effort.

**Author:** Navjyot Nishant
**Organization:** Cybage Software Inc.
**Last Updated:** March 25, 2026

---

## What Are Claude Skills?

Claude Skills are reusable instruction sets that tell Claude how to handle specific
complex tasks - reading documents, generating structured outputs, applying scoring
rubrics, and producing professional deliverables. They are installed once in Claude
Cowork and triggered by natural language.

Think of them as expert workflows you can invoke on demand.

---

## Requirements

All skills in this repository require **Claude Cowork** - the Claude desktop app with
filesystem access. They will not function in the standard Claude.ai chat interface.

**Why Cowork?**
- Skills need to read uploaded documents from disk
- Skills create output directories and save generated files
- Skills produce Excel, HTML, DOCX, and PDF outputs

**To get started:**
1. Download Claude Cowork from claude.ai
2. Sign in with your Anthropic account (Pro, Team, or Enterprise plan required)
3. Create a project for your use case
4. Install the skill from the relevant directory below

---

## Skills Index

### rfp-pursuit-toolkit

Tools for enterprise RFP pursuit teams covering the full clarification and proposal
evaluation lifecycle.

| Skill | What it does | Status |
|---|---|---|
| [rfp-clarification-q-optimizer](./Sales/rfp-pursuit-toolkit/rfp-clarification-q-optimizer/README.md) | Evaluates or generates RFP clarification questions. Produces a client-facing Query Log (Excel) and internal Question Assessment Report (HTML) | Active |
| [rfp-proposal-scorer](./Sales/rfp-pursuit-toolkit/rfp-proposal-scorer/README.md) | Scores a proposal across 15 quality dimensions covering strategic positioning, persona alignment, and RFP compliance. Produces a scoring report (DOCX + PDF) | In Development |

---

## Repository Structure

```
claude-plugins/
├── README.md                              (this file)
├── .gitignore
├── package-plugin.sh                      (packaging script - see below)
└── Sales/
    └── rfp-pursuit-toolkit/
        ├── README.md                      (toolkit overview and config setup)
        ├── .claude-plugin/
        │   └── plugin.json                (plugin manifest)
        ├── config/
        │   ├── config.template.yaml       (blank template for any company)
        │   └── config.yaml                (gitignored - your filled config)
        └── skills/
            ├── rfp-clarification-q-optimizer/
            │   └── SKILL.md
            └── rfp-proposal-scorer/
                └── SKILL.md               (in development)
```

---

## Installing Plugins via Marketplace (Recommended)

The easiest way to install plugins from this repo is via the Claude Cowork marketplace sync — no ZIP download needed.

1. Open **Claude Cowork > Customize > Browse plugins > Add marketplace**
2. Enter: `github.com/navjyotnishant/nj-claude-plugins`
3. Click **Sync**
4. Browse and install any plugin from the marketplace

Plugins installed this way stay up to date automatically whenever the repo is updated.

---

## Packaging a Plugin

Use `package-plugin.sh` at the repo root to produce a ready-to-upload ZIP.

**Prerequisites:** A filled `config/config.yaml` must exist inside the plugin directory.
Copy `config/config.template.yaml` → `config/config.yaml` and fill in all fields before running.

```bash
./package-plugin.sh <Org/plugin-name>

# Example
./package-plugin.sh Sales/rfp-pursuit-toolkit
```

The script will:
1. Validate `config/config.yaml` exists and has no unfilled placeholder values
2. Stage a clean copy — strips `config.template.yaml`, `*-config.yaml` files, `.DS_Store`, and nested ZIPs
3. Output `<plugin-name>.zip` at the repo root (gitignored)

Upload the ZIP to **Claude Cowork > Customize > Browse plugins > Upload custom plugin**.

---

## Contributing

Skills are authored and maintained by Navjyot Nishant. To suggest improvements,
report issues, or propose new skills, raise an issue in this repository.

When adding a new skill:
- Create a new directory at the appropriate level
- Include `SKILL.md` and `README.md` as a minimum
- Follow the credit block format (author, date, version, description, trigger)
- Add the skill to the Skills Index in this README

---

## License

Internal use. Contact Navjyot Nishant for usage outside Cybage Software Inc.
