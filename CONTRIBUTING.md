# Contributing

Thanks for your interest in contributing to `nj-claude-plugins`.

This repository is organized around Claude plugins. Each plugin may include skills,
shared guidance files, configuration templates, and documentation needed to run
repeatable workflows in Claude Cowork.

## Ways to Contribute

You can contribute by:
- fixing bugs or improving existing plugins
- proposing or adding new plugins
- adding new skills to an existing plugin
- improving documentation, templates, and packaging workflows

If you are not ready to open a pull request yet, you can also open an issue with
your request or proposal.

## Fork and Pull Request Workflow

1. Fork this repository to your own GitHub account.
2. Clone your fork locally.
3. Create a branch for your change.
4. Make and test your changes.
5. Commit your work with a clear message.
6. Push your branch to your fork.
7. Open a pull request against `main` in this repository.

## Branch Naming

Use a short, descriptive branch name. Examples:
- `fix/readme-marketplace-steps`
- `feat/rfp-plugin-new-skill`
- `docs/contributing-guide`

## What to Include in a Pull Request

Please include:
- what problem you are solving
- what changed
- which plugin or skill is affected
- any setup or testing notes reviewers should know

If your pull request adds a new plugin or skill, also include:
- target users
- expected inputs
- expected outputs
- an example usage flow

## Plugin Structure Expectations

Each plugin should follow the repository’s plugin structure:
- plugin root with `.claude-plugin/plugin.json`
- `skills/` for skill directories
- `shared/` for reusable guidance files when needed
- `config/` for template configuration files
- `README.md` explaining setup and usage

## Configuration Files

Do not commit local filled config files such as:
- `config.yaml`
- `personas.yaml`
- other environment- or company-specific filled config files

Commit template files instead, for example:
- `config.template.yaml`
- `personas.template.yaml`

## Packaging Notes

If your change affects plugin packaging:
- keep `package-plugin.sh` aligned with the documented packaging workflow
- make sure required config files are validated before packaging
- make sure templates and local-only config files are handled correctly

## Documentation

When changing plugin behavior, update the relevant documentation too:
- root `README.md` for repo-level guidance
- plugin `README.md` for plugin-specific setup and usage
- `CONTRIBUTING.md` if contribution workflow changes

## Need Help or Want to Propose Something?

If you want to request a new plugin, skill, or workflow enhancement, open an issue
or pull request with a short description of:
- the use case
- who it is for
- the desired input and output
- why the current repo does not cover it yet
