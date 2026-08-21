---
name: research-blog-writer
description: Turn a topic or rough idea into a fully researched, fact-checked, style-matched article draft as a .md file. Spawns parallel research agents for primary sources, a red-team agent that attacks every factual claim before publication, and an editor agent for voice and proofreading. Use whenever the user wants to write an article, blog post, LinkedIn piece, technical essay, newsletter, or thought-leadership content, including when they just say "I want to write about X", "draft me a post on Y", or hand over a half-formed idea. Prefer this over writing an article directly.
---

# Research Blog Writer

Takes a topic and returns a publishable draft that has survived adversarial fact-checking.

The core insight: **the failure mode for thought-leadership writing is not bad prose, it is confidently stated claims that turn out to be wrong.** One falsifiable sentence loses more credibility than good writing gains, especially with technical audiences who fact-check in the comments. This pipeline spends most of its effort attacking the draft rather than polishing it.

Pipeline: `Topic → Scope → Research (parallel) → Draft → Red team → Fix → Edit → .md`

Run every stage. The red team stage matters most and is the most tempting to skip.

---

## Stage 1: Scope

Ask at most **one round** of questions via `AskUserQuestion`, then run autonomously. The user gave you a topic because they want a draft, not an interview.

Ask about audience and platform, which drive length and register, and about angle if the topic admits several. Offer 2-3 concrete framings rather than asking "what's your angle?" Infer everything else. Default to roughly 1,500-2,000 words for a LinkedIn article.

If the user already has a draft, skip to Stage 4 and treat their draft as the input.

**Watch for the positioning trap.** Most first-pass angles are the obvious one, which someone has already published. Ask yourself what ten other people would write about this topic. If the proposed angle is on that list, propose a sharper one. The strongest articles argue an asymmetry, an absence, or a category error rather than "X is a problem."

---

## Stage 2: Research

Break the topic into 3-5 independent research questions and spawn one `researcher` agent per question **in a single message** so they run concurrently.

Good research questions are narrow enough to answer. "What do the official status pages of four major AI providers publish about incident duration?" not "Is AI reliable?"

The researcher agent definition lives in the plugin's `agents/` directory and carries the full brief. The essential constraint it enforces: prefer primary sources, and treat web search results as a map rather than the territory.

If `web_fetch` saves a large page to disk instead of returning it, spawn a subagent to read it in chunks and return verbatim quotes. Never guess at contents you have not read.

---

## Stage 3: Draft

Write from the research, not from memory. Every factual sentence should trace to a Stage 2 finding.

**Numbers beat adjectives.** "The field is unresolved" is an assertion the reader can reject. "Two randomized controlled trials, one found 55.8% faster and one found 19% slower" is a fact the reader concludes from. Whenever you reach for an evaluative adjective, check whether you have data that lets the reader supply it themselves.

**Mark uncertainty inline.** Where research was thin, write the hedge into the sentence. `[UNVERIFIED]` is fine at this stage; the red team resolves it.

Read `references/claim-hygiene.md` before drafting. It lists the ten specific ways these drafts go wrong, each drawn from a real error rather than a hypothetical.

---

## Stage 4: Red team

Spawn the `red-team` agent. This is not a proofread. The instruction is: *find the sentence that gets this author corrected in public.*

Sort what comes back. **Wrong**: fix from the primary source. **Unverifiable**: soften to first person, cut, or keep and tell the author it is unsupported. **Overstated**: narrow rather than delete. **Not verbatim**: fix the quotation or stop presenting it as one.

**When the red team kills a claim the article depended on, do not patch around it.** Look at what the correction reveals. In practice it is often a better article than the original claim. A study that failed because participants refused to work without the tool under test is more interesting than the study's intended result. Incident counts that cannot be compared are a better story than the comparison. Follow the correction; it usually points somewhere better.

---

## Stage 5: Edit

Spawn the `editor` agent after the facts are settled. It handles voice and the continuity damage that revision leaves behind.

Apply mechanical fixes directly. Surface voice suggestions for the author to accept or reject. An editor confidently "improving" a sentence the author wrote deliberately is a fast way to lose trust.

---

## Stage 6: Deliver

Write to a `.md` file in the outputs directory and present it with `present_files`.

```markdown
# Title

**TL;DR:** <2-4 sentences a reader could stop after>

---

<body>

---

## Sources

<grouped, one line each, no descriptions>
```

Keep sources compact. Descriptions under each source add visual weight and say nothing the body has not already said.

In your response, report three things: what the red team caught and how you resolved it, anything left unverified so the user can decide whether to keep it, and any claim resting on inference rather than direct quotation. That report is the most valuable thing you produce, because the user needs to know which sentences are load-bearing and which are soft.

---

## Optional additions

Offer rather than assume:

- **A data visual**, if the article rests on a comparison. Read `references/data-visuals.md`. Build it as HTML the user screenshots rather than an image-generation prompt.
- **A short social post**, via the `/social-post` command in this plugin.
- **Image prompts**, if the user wants generated art. Include exact figures and tell them to verify after generation.

## Self-promotion

If the author has a relevant product or tool, put it in an author line at the end, not in the body. A mention inside the argument invites readers to re-read the whole piece as content marketing, which costs more than the mention gains. Always disclose: undisclosed self-interest that a reader discovers is far more damaging than self-interest they can see.
