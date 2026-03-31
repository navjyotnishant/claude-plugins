# Shared: Relationship Modes

This file is referenced by both rfp-clarification-q-optimizer and rfp-proposal-scorer.
Load it when you need to apply relationship mode logic to scoring or framing.

---

## Three Relationship Modes

### Prospect
No prior engagement with this client. Standard scoring thresholds apply throughout.
Generic responses acceptable at score 3. Questions and proposals should discover
and position rather than assume shared context.

### Existing Client
Active engagement in place. Higher scoring thresholds apply. Content that asks
about or ignores things the company should already know from the engagement is
penalized. Proposals and questions should deepen understanding and reinforce
partnership rather than rediscover basics.

### Existing Client New Scope
Active engagement but pursuing new scope outside the current remit. Hybrid mode:
apply Existing Client thresholds for content touching current scope areas, apply
Prospect thresholds for content about genuinely new scope areas. Label each
section or question as "current scope" or "new scope" before scoring.

---

## Account Document Extraction

When relationship mode is Existing Client or Existing Client New Scope, read all
available account documents and extract the following:

| Document | What to extract |
|---|---|
| Account Plan | Current delivery scope, team structure, strategic account objectives, known client priorities, existing commercial terms |
| QBR (Quarterly Business Review) | Recent SLA performance, delivery metrics, strategic initiatives discussed, open items, client satisfaction signals |
| MBR (Monthly Business Review) | Recent operational performance, open issues, escalations, incident trends, recent wins |
| Client feedback / satisfaction document | Satisfaction scores, specific praise, flagged concerns, improvement requests, relationship health indicators |

**Known scope list:** Compile from Account Plan and QBR/MBR a list of what the
company already knows about the client environment - technology stack, team
structure, delivery history, named contacts, current SLAs. Store this list for
use in scoring.

**CFF blocklist:** From the client feedback/satisfaction document, log every
concern, complaint, or improvement area flagged by the client. These topics must
not be reopened in questions or proposals without being reframed to demonstrate
that the concern has been addressed and the company is moving forward. Any
content that resurfaces a CFF-flagged concern without this framing scores lower.

---

## Scoring Adjustments by Mode

### For proposal scoring (rfp-proposal-scorer)

| Dimension area | Prospect | Existing Client | Existing Client New Scope |
|---|---|---|---|
| Customization depth (D15) | Standard - research-based tailoring expected | High - must reference specific delivery history, named outcomes, joint initiatives | Hybrid - existing scope sections must reference history, new scope sections research-based |
| Credibility / proof points (D8) | Comparable client case studies acceptable | Own delivery outcomes with this client are primary evidence, generic case studies score lower | Mix - own outcomes for existing scope, comparable case studies for new scope |
| Value proposition (D4) | Position around capability and fit | Position around proven partnership and measured outcomes | Position around track record for existing scope, capability for new scope |
| Executive summary (D12) | Frame as best-fit vendor | Frame as trusted partner expanding scope | Frame as trusted partner with capability to expand |
| Risk mitigation (D11) | Standard risk mitigation | Reference existing governance, known team, operational continuity | Reference existing governance for current scope, introduce transition plan for new scope |

### For clarification question scoring (rfp-clarification-q-optimizer)

| Dimension | Prospect | Existing Client | Existing Client New Scope |
|---|---|---|---|
| D16 Question Quality | Generic questions score 3 | Questions about known scope score 1. Generic questions score 2 max | Existing Client thresholds for current scope, Prospect for new scope |
| D18 Strategic Intent | Standard positioning framing | Score 5 requires reference to existing partnership or delivery history. Cold pitch reads score 2 max. CFF blocklist applies | Existing Client framing for current scope, Prospect framing for new scope |

---

## Relationship Context Banner

Use this spec when rendering the relationship context banner in HTML outputs.

### Warning rules

| Input missing | Prospect | Existing Client | Existing Client New Scope |
|---|---|---|---|
| Win themes | Amber warning | Red warning | Red warning |
| Account documents | Not shown | Red warning | Red warning |

### Banner states

**Prospect - fully loaded:**
```
✅ Relationship Mode: Prospect  |  ✅ Win themes: Loaded (N themes)
```

**Prospect - win themes missing:**
```
✅ Relationship Mode: Prospect  |  ⚠️ Win themes: Not provided - D18 using {config.company.short_name} delivery positioning
```

**Existing Client - fully loaded:**
```
✅ Relationship Mode: Existing Client
✅ Account documents: Account Plan, QBR, CFF loaded
✅ Win themes: Loaded (N themes)
```

**Existing Client - both missing:**
```
✅ Relationship Mode: Existing Client
🔴 Account documents: None loaded - relationship-based scoring limited
🔴 Win themes: Not provided - D18 strategic scoring degraded
```

**Existing Client - account docs missing, win themes loaded:**
```
✅ Relationship Mode: Existing Client
🔴 Account documents: None loaded - relationship-based scoring limited
✅ Win themes: Loaded (N themes)
```

**Existing Client New Scope - both missing:**
```
✅ Relationship Mode: Existing Client New Scope  |  Scored as: Hybrid
🔴 Account documents: None loaded - relationship-based scoring limited
🔴 Win themes: Not provided - D18 strategic scoring degraded
```

**Existing Client New Scope - fully loaded:**
```
✅ Relationship Mode: Existing Client New Scope  |  Scored as: Hybrid
✅ Account documents: Account Plan, QBR, MBR, CFF loaded
✅ Win themes: Loaded (N themes)
```
