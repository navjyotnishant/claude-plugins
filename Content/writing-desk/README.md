# writing-desk

Research, fact-check, and publish articles that survive expert scrutiny.

The premise: **the failure mode for thought-leadership writing is not bad prose, it is confidently stated claims that turn out to be wrong.** One falsifiable sentence loses more credibility than good writing gains, especially with technical audiences who fact-check in the comments. This plugin spends most of its effort attacking the draft rather than polishing it.

---

## What's included

| Component | Name | Purpose |
|-----------|------|---------|
| Skill | `research-blog-writer` | The full pipeline: scope, research, draft, red team, edit, deliver |
| Command | `/write-article` | Run the pipeline from a topic or rough idea |
| Command | `/fact-check` | Adversarially verify any draft, including ones written by hand |
| Command | `/social-post` | Turn a finished article into a LinkedIn feed post |
| Command | `/style-check` | Check any text against your writing style profile |
| Agent | `researcher` | Gathers evidence from primary sources, several run in parallel |
| Agent | `red-team` | Attacks every claim before publication |
| Agent | `editor` | Voice matching and continuity repair |

---

## The pipeline

```
Topic → Scope → Research (parallel agents) → Draft → Red team → Fix → Edit → .md
```

The red team stage is the one that matters and the one most tempting to skip.

---

## Usage

Write something from scratch:

```
/write-article the hidden cost of AI provider outages for engineering teams
```

Verify a draft you already wrote:

```
/fact-check ~/Documents/my-draft.md
```

Promote a finished piece:

```
/social-post ~/Documents/my-article.md
```

The skill also triggers on plain requests: "I want to write about X", "draft me a post on Y", "research and write up Z".

---

## Reference material

`skills/research-blog-writer/references/claim-hygiene.md` lists ten ways researched drafts get publicly corrected. Each is drawn from a real error caught in real fact-checking, not a hypothetical. The most common by a wide margin is the **universal negative**: any sentence of the form "no tool exists" or "nobody has built" can be destroyed by one commenter with one link.

`skills/research-blog-writer/references/data-visuals.md` covers building charts for articles, including why data-dense visuals should be HTML you screenshot rather than generated images, and how to recognise when the honest chart is not the chart you set out to make.

---

## Voice matching

The editor agent looks for a writing style profile, commonly a skill named `my-writing-style`, and treats its rules as non-negotiable. If you do not have one, the `setup-writing-style` skill can build it, or the editor will match the register of whatever you have written in the conversation.

Style profiles usually encode punctuation preferences and banned phrases. Violating one is worse than any prose improvement is worth.

---

## Requirements

Claude Cowork, for filesystem access and subagents. The research and red team stages spawn parallel agents and write files to disk.

---

## Design notes

Three decisions worth knowing about, because they are deliberate and unusual:

**Primary sources only.** Research agents are instructed to treat web search results as a map rather than the territory. Search summaries routinely garble numbers, drop qualifiers, and misattribute findings. Anything that reaches the draft must be quotable verbatim from the source itself.

**Corrections are followed, not patched around.** When the red team kills a load-bearing claim, the instruction is to look at what the correction reveals rather than to find a workaround. In practice the correction is often a better article than the original claim.

**Self-promotion goes in the author line.** If you have a product relevant to the topic, it belongs at the end, disclosed, not woven into the argument. A mention inside the body invites readers to re-read the whole piece as content marketing, which costs more than the mention gains.
