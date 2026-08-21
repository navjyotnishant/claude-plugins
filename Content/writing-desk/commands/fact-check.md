---
description: Adversarially fact-check any draft against primary sources before publishing
argument-hint: [path to draft, or paste the text]
---

Fact-check this draft before it is published: $ARGUMENTS

If no draft was supplied, ask for the file path or the text.

Read `${CLAUDE_PLUGIN_ROOT}/skills/research-blog-writer/references/claim-hygiene.md` first. It lists the ten specific ways researched drafts go wrong, each drawn from a real error.

Then spawn the `red-team` agent against the draft.

This works on any draft, not only ones produced by this plugin. Drafts written by hand, drafts from colleagues, and older published pieces all benefit, and the errors it finds are usually the same ones.

When the results come back, present them grouped by severity:

**Wrong** — with the correct value and the primary source. Fix these.

**Unverifiable** — the author decides whether to keep, soften, or cut. Recommend the first-person hedge ("I have not found", "in the environments I have worked in"), which is almost always available and costs less than it appears to.

**Overstated** — with the narrower version written out. Prefer narrowing to deleting; the narrower claim is usually more interesting and always more defensible.

**Not verbatim** — the draft's version and the source's, side by side.

Be direct about severity. If a claim would get the author publicly corrected, say so plainly rather than burying it in a list. And if a correction points toward a better argument than the original claim, say that too.
