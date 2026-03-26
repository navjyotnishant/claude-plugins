# ClaudeSkills

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
ClaudeSkills/
├── README.md                              (this file)
├── .gitignore
└── Sales/
    └── rfp-pursuit-toolkit/
        ├── README.md                      (toolkit overview and config setup)
        ├── config/
        │   ├── config.template.yaml       (blank template for any company)
        │   └── cybage-config.yaml         (gitignored - Cybage specific)
        ├── rfp-clarification-q-optimizer/
        │   ├── SKILL.md
        │   └── README.md
        └── rfp-proposal-scorer/
            ├── SKILL.md
            └── README.md
```

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
