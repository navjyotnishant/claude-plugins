# Shared: File Resolution

This file is referenced by both rfp-clarification-q-optimizer and rfp-proposal-scorer.
Load it when you need to scan a working folder and infer file roles.

---

## Step 1 - Scan the Working Folder

```bash
ls -1 <folder_path>
```

List all files in the working folder. Do NOT ask the user for file paths.
Only ask for a path if the folder is completely empty.

---

## Step 2 - Infer File Roles from Filenames

Match filename signal words to likely roles:

| Signal words in filename | Likely role |
|---|---|
| rfp, requirements, request, tender, bid-doc, brief | RFP document |
| proposal, response, submission, answer, bid, our-response | Proposal / RFP response |
| questions, clarification, queries, q&a, draft-q | Draft clarification questions |
| qa-answers, client-answers, addendum, clarification-responses | Q&A answers from client |
| themes, win-themes, positioning, strategy | Win themes |
| account-plan, account_plan | Account Plan |
| qbr, quarterly-review | QBR |
| mbr, monthly-review | MBR |
| cff, feedback, customer-feedback, satisfaction, csat | Client feedback / satisfaction document |
| personas, buyer-personas | Personas file |
| competitor, competition, competitive | Competitor context |
| industry, client-context, background | Client industry / context |

---

## Step 3 - Confirm File Roles Before Proceeding

Show the inferred mapping and ask yes/no. Do NOT proceed without confirmation.

Example confirmation block (adapt to whichever files are relevant for the skill):

```
I found these files:
  RFP Document              : {filename}
  Proposal / Response       : {filename or "not provided"}
  Q&A Answers from Client   : {filename or "not provided"}
  Draft Questions           : {filename or "not provided"}
  Win Themes                : {filename or "not provided"}
  Account Plan              : {filename or "not provided"}
  QBR                       : {filename or "not provided"}
  MBR                       : {filename or "not provided"}
  Client Feedback Document  : {filename or "not provided"}
  Competitor Context        : {filename or "not provided"}
  Client Industry / Context : {filename or "not provided"}

Does this look right?
```

Only show rows relevant to the skill being run. Do not show rows for inputs
the skill does not use.

---

## Step 4 - Handle Edge Cases

**Two files could be the same role:**
Show both filenames and ask which is the final version. Never guess.

**File present but role unclear:**
State what you think it is and ask the user to confirm before proceeding.

**Account documents in Prospect mode:**
Do not prompt for Account Plan, QBR, MBR, or client feedback documents.
These are only relevant for Existing Client and Existing Client New Scope modes.

**No files found:**
Tell the user the folder is empty and ask them to add the required documents
before re-running the skill.
