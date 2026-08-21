# Claim hygiene

Ten ways a researched draft gets publicly corrected. Each of these was a real
error caught during real fact-checking, not a hypothetical. Read this before
drafting and again before the red team stage.

---

## 1. The universal negative

The single most common failure. Any sentence of the form "no tool exists",
"nobody has built", "there is no framework for", "that does not exist from
anyone" can be destroyed by one commenter with one link.

A universal negative is the easiest claim in the world to disprove and the
hardest to defend. You are asserting something about the entire world based on
a search that returned nothing.

**Fix:** convert to first person and invite correction.

- Wrong: "That instrumentation does not exist, from anyone."
- Right: "I have not found a tool that does this. If it exists, I would like
  to be corrected."

The second version is honest, unattackable, and turns a potential ambush into
an invitation. It also usually generates better comments.

---

## 2. The claim your own audience knows is false

The most damaging category, because it costs you the credential you just
established. If you write "I have spent my career on database availability"
and then state something about availability that any practitioner knows is
wrong, the credential works against you.

Real example: "We have industry-standard definitions for cloud availability,
and they are comparable across vendors." False. AWS, Azure and GCP define
"unavailable" differently, measure over different windows, and carve out
different exclusions. Anyone who has argued a service credit knows this.

**Fix:** for any claim inside the author's stated expertise, apply extra
scrutiny rather than less. Familiarity breeds unchecked assertion. Often the
accurate version is more interesting: "definitions vary, but there is a shared
vocabulary and a contractual structure to argue inside" is both true and a
better setup for the argument.

---

## 3. The superseded source

A study you cite may have been updated, corrected, or withdrawn since
publication. Citing the old finding as current is worse than not citing it,
because it signals you did not check.

Real example: a widely-cited 2025 productivity RCT now carries a banner saying
the results are out of date, with a 2026 follow-up reaching a different
conclusion.

**Fix:** always load the source page itself and look for correction notices,
update banners, or a newer companion post. Then cite both, and say what
changed. The revision is often more interesting than the original finding.

---

## 4. The category error: paper vs product

"Tool X does Y" when X is a research prototype described in a workshop paper,
with no public release, whose own authors describe it as a proof of concept.

Real example: a fault-injection framework cited alongside two shipping
products, when its own future-work section said the goal was to "transform it
from a proof-of-concept into a comprehensive tool."

**Fix:** before calling something a tool, check for a repository, a release,
or install instructions. If it is a paper, say "a proof-of-concept from a 2025
workshop paper." Describing it accurately usually costs nothing and buys
precision. And read the paper: its actual findings are often more useful than
the citation you wanted it for.

---

## 5. The unfalsifiable universal about people

"Most organizations cannot answer these questions." "Most teams have never
measured this." No survey supports these. They feel true and cannot be
defended.

**Fix:** first person again. "I cannot answer all of these for every
environment I have worked in, and I have not yet met the engineering leader
who can." Same rhetorical force, nothing to attack, and it reads as more
honest rather than less confident.

---

## 6. The overstated irreversibility

"You cannot reconstruct X once Y happens." Usually you can, at least partly,
and someone will point out how.

Real example: "Once AI is embedded you cannot reconstruct what 'without'
looked like." False for anything derivable from git or ticket history, both of
which are immutable and timestamped.

**Fix:** separate what genuinely cannot be recovered from what can. In that
example, the system metrics were fully reconstructable; what could not be
recovered was **perception** (you cannot retroactively survey how a team felt)
and **pre-registration credibility** (a window chosen after seeing the result
invites bias questions). Naming precisely what is lost makes the advice more
useful, not less.

---

## 7. Counts that are not comparable

Comparing numbers across sources that measure or disclose differently
produces a ranking of transparency disguised as a ranking of quality.

Real example: incident counts across four AI providers. The provider that
published detailed postmortems had the highest count. The one that published
boilerplate had a lower count. The one that split disclosure across three
dashboards could not be counted at all. Publishing that as a league table
would have rewarded opacity.

**Fix:** when the underlying disclosure regimes differ, say so and make the
non-comparability the finding. It is usually a better story than the
comparison you were attempting.

---

## 8. Inference presented as quotation

Joining two statements from a source into one claim the source never made.

Real example: a vendor called "developer hours saved per week" the
industry-standard metric in one place, and described collecting time savings
via surveys in another. Writing "they describe the industry-standard metric as
self-reported time savings" is a reasonable inference, but the source never
said it in those words.

**Fix:** this is usually acceptable, but flag it to the author so they know
which sentences are direct quotation and which are their own synthesis. If a
claim is load-bearing, either find a direct statement or attribute the
inference to yourself.

---

## 9. The adjective standing in for evidence

"The field is unresolved." "This is a serious problem." "The gap is enormous."
Adjectives are claims the reader can reject. Data is something the reader
concludes from.

**Fix:** if you have the numbers, show them and let the adjective go unsaid.
"Two randomized controlled trials, one found 55.8% faster, one found 19%
slower" does not need "unresolved" attached; the reader gets there first and
believes it more.

If you do not have numbers, that is a signal the claim needs softening rather
than a stronger adjective.

---

## 10. Continuity breaks from editing

These appear only after revision, which is why they survive to publication.
Check for all of them in a final pass:

- **Dangling antecedents.** "That August 18 incident named five models" after
  the passage introducing that incident was cut in an earlier revision.
- **Orphan citations.** A source in the reference list that nothing in the
  body points to, usually because the sentence citing it was rewritten.
- **Missing citations.** A claim that lost its marker during a rewrite.
- **Duplicate headings.** Two headings saying the same thing, from merging
  sections.
- **Asymmetric softening.** A claim hedged in one place and still absolute in
  another, because only one instance was found on the fix pass.
- **Editor chrome.** Interface text ("Edit image", "Minimize") pasted in from
  a WYSIWYG editor.
- **Repeated phrases.** The same distinctive phrase twice in one sentence or
  paragraph, from a partial rewrite.

---

## The general principle

Every one of these has the same shape: a sentence that sounds authoritative
and is not quite true. The cost is asymmetric. A verified claim buys a little
credibility; a falsified one spends a lot.

When in doubt, the first-person hedge is almost always available and almost
always costs less than it appears to. "I have not found" instead of "there is
no." "In the environments I have worked in" instead of "in most
organizations." Readers trust a writer who marks the edge of their knowledge
more than one who does not appear to have an edge.
