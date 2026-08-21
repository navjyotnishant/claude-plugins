# Data visuals for articles

When an article rests on a comparison, a visual carries the argument better than
a paragraph. But the way you build it matters more than people expect.

## Build charts as HTML, not as image prompts

**Image generation models corrupt digits and labels reliably.** They will
render "51%" as "5T%", drop the word "professional" from a scoped statistic,
invent an expansion for an acronym, and duplicate a caption. A chart with a
wrong number in it is worse than no chart, because it looks authoritative and
it is the first thing a reader checks.

For anything data-dense, write a self-contained HTML file the author opens and
screenshots at 2x. The numbers are then guaranteed correct because you typed
them.

Reserve image generation for illustration and mood, never for data.

## When the honest chart is not the obvious chart

Before building the comparison the author asked for, check whether the
underlying data supports a comparison at all.

A real example: incident counts across four AI providers looked like a natural
bar chart. But the provider publishing detailed postmortems had the highest
count, the one publishing boilerplate had a lower count, and the one splitting
disclosure across three dashboards could not be counted. The bar chart would
have ranked transparency and presented it as reliability.

The honest visual there was a **disclosure matrix**: providers as columns, what
each publishes as rows, filled and empty cells. Same data, opposite and correct
conclusion, and a more original visual than the bar chart would have been.

When sources measure or disclose differently, the non-comparability is usually
the more interesting finding. Build that.

## Design constraints that matter for social platforms

**Legibility at thumbnail size.** Most readers see the image at 400px wide on a
phone. If the argument depends on reading small captions, it will not land.
Test by scaling down and asking whether the point still arrives.

**Carry the argument in layout, not text.** The strongest visual in a piece
about an asymmetry was two columns, one crowded with logos and one deliberately
empty. That works at any size because the shape is the message. A dense
six-panel sketchnote with the same content does not.

**An intentionally empty region needs one line of text** or a dashed outline,
or readers will assume the image failed to render rather than that the
emptiness is the point.

**Cover images** on LinkedIn render around 1.91:1. Square 1200x1200 performs
better in the feed. Generate both if the piece will be shared as well as
published.

## Verify after generation

Whatever tool produced the visual, check every number against the article
before publishing. If an image model made it, assume at least one figure is
wrong until you have confirmed otherwise. Check scoped statistics especially:
"51% of professional developers" becoming "51% of developers" is a small visual
change and a material factual one.
