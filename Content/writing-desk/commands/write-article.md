---
description: Research, draft, fact-check and edit a full article from a topic or rough idea
argument-hint: [topic or rough idea]
---

Write a researched, fact-checked article on: $ARGUMENTS

Invoke the `research-blog-writer` skill and run its full pipeline. Do not skip the red team stage; it is the stage that determines whether the piece survives an expert reader.

If no topic was supplied, ask what the user wants to write about before doing anything else.

Deliver a `.md` file and report, in your response:

- what the red team caught and how you resolved it
- anything you could not verify, so the user can decide whether to keep it
- any claim resting on inference rather than direct quotation
