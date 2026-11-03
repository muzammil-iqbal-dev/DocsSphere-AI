# Module: Goal Dashboard

Use cases: UC15, UC16, UC17, UC18. See 00-overview.md for actors, status values and include/extend relationships.

## UC15 — Create Goal and Generate Document Checklist

- **Module:** Goal Dashboard
- **Brief Description:** Document Owner sets a personal goal (e.g., a visa or admission application) and the system creates a checklist of the documents needed, matching it against the documents already uploaded.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.

**Post-conditions:**

- Goal and checklist are saved.
- Existing documents are matched to checklist items and missing items are shown.

**Main success scenario:** Goal is created with a checklist showing available and missing documents.

**Main flow:**

1. **Actor:** Selects "New Goal".
2. **System:** Prompt for the goal description.
3. **Actor:** Enters the goal (e.g., "Apply for a student visa").
4. **System:** Send the goal to the AI to find out which documents are needed.
5. **System:** Display the suggested checklist for review.
6. **Actor:** Adds, removes or renames items and confirms.
7. **System:** Match the checklist items against the Document Owner's existing documents and mark the available ones.
8. **System:** Save the goal and display it on the Goal Dashboard with its progress.

**Alternative flows:**

- **3.a.** If the goal description is empty, display an error message.
- **4.a.** If the AI cannot make a checklist, let the Document Owner build the checklist by hand.
- **5.a.** If the Document Owner discards the checklist, the goal is not saved.

---

## UC16 — Track Goal Progress

- **Module:** Goal Dashboard
- **Brief Description:** Document Owner views each goal's progress and sees which required documents are available and which are still missing; progress updates automatically as documents are uploaded.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- At least one goal must exist.

**Post-conditions:**

- Current progress and missing documents of the goal are displayed.
- Checklist is updated when a matching document is added.

**Main success scenario:** Document Owner sees goal progress and completes missing items.

**Main flow:**

1. **Actor:** Opens the Goal Dashboard.
2. **System:** Fetch the goals and checklist statuses.
3. **System:** Display each goal with its completion percentage.
4. **Actor:** Selects a goal.
5. **System:** Display the checklist with linked documents and highlight missing items.
6. **Actor:** Selects "Upload" for a missing item.
7. **System:** Open the upload flow linked to that item.
8. **System:** After processing, update the checklist and progress automatically.

**Alternative flows:**

- **2.a.** If no goals exist, prompt the Document Owner to create one.
- **5.a.** If a linked document has expired, mark the checklist item as "Expired" and count it as missing.
- **5.b.** If a linked document has been deleted, mark the checklist item as missing.

---

## UC17 — Edit Goal

- **Module:** Goal Dashboard
- **Brief Description:** Document Owner edits the checklist of an existing goal by adding, removing or renaming items.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- Goal must exist.

**Post-conditions:**

- Goal checklist is updated; linked documents are not affected.

**Main success scenario:** Goal checklist is updated and the dashboard is refreshed.

**Main flow:**

1. **Actor:** Selects a goal and chooses "Edit".
2. **System:** Display the edit form with the current checklist.
3. **Actor:** Makes the changes and saves.
4. **System:** Check and save the changes.
5. **System:** Recalculate progress and display the updated Goal Dashboard.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, no changes are made.
- **4.a.** If a checklist item has an empty name, display an error message and let the Document Owner correct it.

---

## UC18 — Delete Goal

- **Module:** Goal Dashboard
- **Brief Description:** Document Owner deletes a goal that is no longer needed. Only the goal and its checklist are removed; the uploaded documents stay in the library.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- Goal must exist.

**Post-conditions:**

- Goal and its checklist are deleted; linked documents are not affected.

**Main success scenario:** Goal is removed and the dashboard is refreshed.

**Main flow:**

1. **Actor:** Selects a goal and chooses "Delete".
2. **System:** Ask for confirmation and explain that the documents will not be deleted.
3. **Actor:** Confirms the deletion.
4. **System:** Remove the goal and its checklist.
5. **System:** Display the updated Goal Dashboard.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, no changes are made.
