# nj-claude-plugins

A curated collection of Claude plugins built for enterprise pursuit and delivery teams.
Each plugin packages one or more Claude skills, shared guidance files, and configuration
needed to run repeatable AI workflows in Claude Cowork.

**Author:** Navjyot Nishant
**Last Updated:** March 25, 2026

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
1. Download Claude Cowork from claude.ai
2. Sign in with your Anthropic account (Pro, Team, or Enterprise plan required)
3. Create a project for your use case
4. Install the plugin from the relevant directory below

---

## Plugin Index

### rfp-pursuit-toolkit

Plugin for enterprise RFP pursuit teams covering the full clarification and proposal
evaluation lifecycle.

| Plugin | What it includes | Status |
|---|---|---|
| [rfp-pursuit-toolkit](./Sales/rfp-pursuit-toolkit/README.md) | Includes `rfp-clarification-q-optimizer` and `rfp-proposal-scorer` skills, shared guidance files, and config templates for enterprise RFP pursuits | Active |

---

## Repository Structure

```
nj-claude-plugins/
├── README.md                              (this file)
├── .claude-plugin/
│   └── marketplace.json                   (marketplace manifest)
├── .gitignore
├── package-plugin.sh                      (packaging script - see below)
└── Sales/
    └── rfp-pursuit-toolkit/
        ├── README.md                      (toolkit overview and config setup)
        ├── .claude-plugin/
        │   └── plugin.json                (plugin manifest)
        ├── shared/
        │   ├── output-directory.md        (shared config and directory flow)
        │   ├── file-resolution.md         (shared file resolution flow)
        │   └── relationship-modes.md      (shared relationship logic)
        ├── config/
        │   ├── config.template.yaml       (blank template for any company)
        │   ├── config.yaml                (gitignored - your filled config)
        │   ├── personas.template.yaml     (blank persona template)
        │   └── personas.yaml              (workspace or plugin-level personas)
        └── skills/
            ├── rfp-clarification-q-optimizer/
            │   └── SKILL.md
            └── rfp-proposal-scorer/
                └── SKILL.md
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
For `rfp-proposal-scorer`, a filled `config/personas.yaml` is also required.
Copy `config/config.template.yaml` → `config/config.yaml` and `config/personas.template.yaml` → `config/personas.yaml` before running.

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

Plugins and skills are authored and maintained by Navjyot Nishant. To suggest improvements,
report issues, or propose new plugins or skills, raise an issue in this repository.

When adding a new plugin:
- Create a new plugin directory with `.claude-plugin/plugin.json`
- Add `skills/`, shared files, config templates, and README content as needed
- Follow the Claude Cowork / plugin marketplace structure used in this repo
- Add the plugin to the Plugin Index in this README

---

## License

Apache-2.0. See [LICENSE](./LICENSE).
