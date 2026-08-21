# nj-claude-plugins

A curated collection of Claude plugins for enterprise pursuit, delivery, and content teams.
Each plugin packages one or more Claude skills, shared guidance files, and configuration
needed to run repeatable AI workflows in Claude Cowork.

**Author:** Navjyot Nishant
**Last Updated:** August 21, 2026

---

## What Are Claude Plugins?

Claude plugins are installable bundles for Claude Cowork. A plugin can include skills,
shared guidance files, configuration templates, hooks, agents, and other assets needed
for a reusable workflow.

In this repository, each plugin contains purpose-built skills that tell Claude how to
handle complex tasks like reading documents, generating structured outputs, applying
scoring rubrics, and producing professional deliverables.

---

## Requirements

All plugins in this repository require **Claude Cowork** - the Claude desktop app with
filesystem access. They will not function in the standard Claude.ai chat interface.

**Why Cowork?**
- Plugin skills need to read uploaded documents from disk
- Plugin skills create output directories and save generated files
- Plugin skills produce Excel, HTML, DOCX, and PDF outputs

**To get started:**
1. Download Claude Desktop from claude.ai
2. Sign in with your Anthropic account (Pro, Team, or Enterprise plan required)
3. In Claude Desktop, choose the Cowork tab
4. Create a project for your use case
5. Install the plugin by selecting Capabilities in the side panel

---

## Plugin Index

### rfp-pursuit-toolkit

Plugin for enterprise RFP pursuit teams covering the full clarification and proposal
evaluation lifecycle.

| Plugin | What it includes | Status |
|---|---|---|
| [rfp-pursuit-toolkit](./Sales/rfp-pursuit-toolkit/README.md) | Includes `rfp-clarification-q-optimizer` and `rfp-proposal-scorer` skills, shared guidance files, and config templates for enterprise RFP pursuits | Active |

### writing-desk

Plugin for researched writing, covering the full path from a topic to a fact-checked
draft. Built around the premise that the failure mode for thought-leadership content is
not bad prose but confidently stated claims that turn out to be wrong.

| Plugin | What it includes | Status |
|---|---|---|
| [writing-desk](./Content/writing-desk/README.md) | Includes the `research-blog-writer` skill, `/write-article`, `/fact-check`, `/social-post` and `/style-check` commands, and researcher, red-team and editor agents | Active |

---

## Repository Structure

```
nj-claude-plugins/
├── README.md                              (this file)
├── .claude-plugin/
│   └── marketplace.json                   (marketplace manifest)
├── .gitignore
├── package-plugin.sh                      (packaging script - see below)
├── Sales/
│   └── rfp-pursuit-toolkit/
│       ├── README.md                      (toolkit overview and config setup)
│       ├── .claude-plugin/
│       │   └── plugin.json                (plugin manifest)
│       ├── shared/
│       │   ├── output-directory.md        (shared config and directory flow)
│       │   ├── file-resolution.md         (shared file resolution flow)
│       │   └── relationship-modes.md      (shared relationship logic)
│       ├── config/
│       │   ├── config.template.yaml       (blank template for any company)
│       │   ├── personas.template.yaml     (blank persona template)
│       └── skills/
│           ├── rfp-clarification-q-optimizer/
│           │   └── SKILL.md
│           └── rfp-proposal-scorer/
│               └── SKILL.md
└── Content/
    └── writing-desk/
        ├── README.md                      (plugin overview and design notes)
        ├── .claude-plugin/
        │   └── plugin.json                (plugin manifest)
        ├── commands/
        │   ├── write-article.md           (/write-article)
        │   ├── fact-check.md              (/fact-check)
        │   ├── social-post.md             (/social-post)
        │   └── style-check.md             (/style-check)
        ├── agents/
        │   ├── researcher.md              (primary-source evidence gathering)
        │   ├── red-team.md                (adversarial fact-checking)
        │   └── editor.md                  (voice and continuity)
        └── skills/
            └── research-blog-writer/
                ├── SKILL.md
                └── references/
                    ├── claim-hygiene.md   (ten ways drafts get corrected)
                    └── data-visuals.md    (charts that do not lie)
```

---

## Installing Plugins

### Via Marketplace (Recommended)

The easiest way to install plugins from this repo is via the Claude Cowork marketplace sync — no ZIP download needed.

1. Open **Claude Cowork > Customize > Browse plugins > Add marketplace**
2. Enter: `github.com/navjyotnishant/nj-claude-plugins`
3. Click **Sync**
4. Browse and install any plugin from the marketplace

Plugins installed this way stay up to date automatically whenever the repo is updated.

---

### Packaging a Plugin

Use `package-plugin.sh` at the repo root to produce a ready-to-upload ZIP.

1. Fill in the required config files for the plugin.
   For `Sales/rfp-pursuit-toolkit`, this means `config/config.yaml` and `config/personas.yaml`.
2. Run:

```bash
./package-plugin.sh Sales/rfp-pursuit-toolkit
```

3. The script will generate `rfp-pursuit-toolkit.zip` at the repo root.
4. In Claude Cowork, open `Capabilities` and upload the generated ZIP.

---

## Contributing

Contributions are welcome. If you want to suggest improvements, add a plugin or skill,
or propose a workflow enhancement, please fork the repository and open a pull request.

For the full contribution workflow, repository expectations, and pull request guidance,
see [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## License

Apache-2.0. See [LICENSE](./LICENSE).
