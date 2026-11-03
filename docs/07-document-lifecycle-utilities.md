# Module: Document Lifecycle Utilities

Use cases: UC19, UC20, UC21, UC22, UC23, UC24, UC25, UC26, UC27, UC28, UC29, UC30. See 00-overview.md for actors, status values and include/extend relationships.

## UC19 — Track Document Expiry

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner views documents with expiry dates (passport, licence, certificates) and sees which are valid, expiring soon or already expired.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- Documents must have an extracted or entered expiry date.

**Post-conditions:**

- List of documents with their expiry status is displayed.

**Main success scenario:** Document Owner sees expiry status of all dated documents.

**Main flow:**

1. **Actor:** Opens the Expiry view.
2. **System:** Fetch the documents that have expiry dates.
3. **System:** Calculate each status (valid, expiring soon, expired).
4. **System:** Display the list sorted by nearest expiry with colour indicators.
5. **Actor:** Selects a document.
6. **System:** Open the document details.

**Alternative flows:**

- **2.a.** If no document has an expiry date, display a message explaining that none were found.
- **3.a.** If the date has already passed, show an "Expired" badge for that document.

---

## UC20 — Receive Expiry Reminder

- **Module:** Document Lifecycle Utilities
- **Brief Description:** The system automatically notifies the Document Owner before a document expires, so that it can be renewed in time.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must have at least one document with an expiry date.

**Post-conditions:**

- Document Owner is notified about documents that are expiring or expired.

**Main success scenario:** Document Owner is warned before a document expires.

**Main flow:**

1. **System:** When the app starts, and then once a day while the app is running, run the expiry check.
2. **System:** Identify documents expiring within the reminder period or already expired.
3. **System:** Send a Windows desktop notification listing these documents.
4. **Actor:** Clicks the notification.
5. **System:** Open the document details with the expiry information.

**Alternative flows:**

- **2.a.** If no document is expiring, no notification is sent.
- **3.a.** If notifications are disabled in Windows, or the app was not running at the time, show an alert banner inside the app the next time the Document Owner opens it.

---

## UC21 — Detect Duplicate Documents

- **Module:** Document Lifecycle Utilities
- **Brief Description:** When a new document is added, the system checks whether it already exists in the library and lets the Document Owner decide what to do with the duplicate.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: Prepare Document for Smart Search (UC08).

**Preconditions:**

- Must be logged in.
- The new document has been processed (UC08).

**Post-conditions:**

- Duplicate is flagged and the Document Owner's decision is applied.

**Main success scenario:** Document Owner is warned about a duplicate and resolves it.

**Main flow:**

1. **System:** Start the duplicate check for the newly processed document (extension of UC08).
2. **System:** Compare the file, its text and its meaning with the existing documents.
3. **System:** Decide whether the document is similar enough to count as a duplicate.
4. **System:** Notify the Document Owner and show both documents side by side.
5. **Actor:** Chooses "Keep Both", "Replace Existing" or "Discard New".
6. **System:** Apply the choice and update the library.

**Alternative flows:**

- **3.a.** If no duplicate is found, the document is added normally.
- **5.a.** If the Document Owner keeps both, mark them as related and do not flag them again.

---

## UC22 — Detect Contradictions Between Documents

- **Module:** Document Lifecycle Utilities
- **Brief Description:** The system compares key details (name, date of birth, address, dates, ID numbers) of related documents and warns the Document Owner about conflicting information.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: Prepare Document for Smart Search (UC08); Edit Document Name and Details (UC11).

**Preconditions:**

- Must be logged in.
- At least two related documents must be prepared for search.

**Post-conditions:**

- Conflicts are flagged on the affected documents.
- Document Owner resolution is saved.

**Main success scenario:** Document Owner is warned about conflicting data and resolves it.

**Main flow:**

1. **System:** Start the conflict check after a document is processed (UC08) or edited (UC11).
2. **System:** Compare its details with the same details in related documents.
3. **System:** Identify mismatches (e.g., different addresses or dates of birth).
4. **System:** Display a warning listing the conflicting details and the documents involved.
5. **Actor:** Reviews and either corrects a detail or marks the difference as intended.
6. **System:** Update the data and clear the warning.

**Alternative flows:**

- **3.a.** If no mismatch is found, no warning is displayed.
- **5.a.** If the Document Owner postpones the decision, keep the warning as "Pending" and show it again the next time either document is opened.

---

## UC23 — Favourite Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner marks an important document as a favourite so that it appears in the Favourites view, or removes the favourite mark.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: View Document Details (UC10).

**Preconditions:**

- Must be logged in.
- Document must exist.

**Post-conditions:**

- Favourite mark is saved; the document appears in the Favourites view (a filter of UC09).

**Main success scenario:** Document is marked as a favourite or the mark is removed.

**Main flow:**

1. **Actor:** Selects "Favourite" on a document.
2. **System:** Save the change.
3. **System:** Add the document to the Favourites view.
4. **Actor:** Selects "Favourite" again to remove the mark.
5. **System:** Remove the mark and update the Favourites view.

**Alternative flows:**

- **2.a.** If the update fails, display an error message and keep the previous state.

---

## UC24 — Pin Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner pins an important document to the top of the library for quick access, or removes the pin.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: View Document Details (UC10).

**Preconditions:**

- Must be logged in.
- Document must exist.

**Post-conditions:**

- Pin is saved; the document appears at the top of the library.

**Main success scenario:** Document is pinned or the pin is removed.

**Main flow:**

1. **Actor:** Selects "Pin" on a document.
2. **System:** Save the change.
3. **System:** Refresh the library so that pinned documents appear first.
4. **Actor:** Selects "Pin" again to unpin the document.
5. **System:** Remove the pin and refresh the library.

**Alternative flows:**

- **2.a.** If the update fails, display an error message and keep the previous state.

---

## UC25 — Hide Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner hides a sensitive document from the main library, search and AI answers. The document stays stored.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: View Document Details (UC10).

**Preconditions:**

- Must be logged in.
- Document must exist.

**Post-conditions:**

- Hidden documents are not shown in the library, search results, AI Assistant answers, Life Canvas or calendar, but remain stored and still count toward goal checklists and expiry reminders.

**Main success scenario:** Document is hidden from the main library.

**Main flow:**

1. **Actor:** Selects "Hide" on a document.
2. **System:** Ask for confirmation.
3. **Actor:** Confirms.
4. **System:** Mark the document as hidden and remove it from the library, search results, AI Assistant answers, Life Canvas and calendar.
5. **System:** Display a confirmation message.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, the document stays visible.

---

## UC26 — Unhide Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner views the hidden documents and brings a hidden document back to the main library.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- At least one hidden document must exist.

**Post-conditions:**

- The document appears again in the library, search results, AI Assistant answers, Life Canvas and calendar.

**Main success scenario:** Hidden document is restored to the library.

**Main flow:**

1. **Actor:** Opens "Hidden Documents".
2. **System:** Display the list of hidden documents.
3. **Actor:** Selects a document and chooses "Unhide".
4. **System:** Restore the document to the library, search results, AI Assistant answers, Life Canvas and calendar.
5. **System:** Display a confirmation message.

**Alternative flows:**

- **2.a.** If there are no hidden documents, display a "No hidden documents" message.

---

## UC27 — Delete Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner deletes a document to a "Deleted" area from where it can later be restored (UC28) or permanently removed (UC29).
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: View Document Details (UC10).

**Preconditions:**

- Must be logged in.
- Document must exist.

**Post-conditions:**

- The document is moved to the Deleted area and removed from the library, search results, AI Assistant answers and expiry tracking.
- Goal checklist items linked to the document show as missing.

**Main success scenario:** Document is moved to the Deleted area.

**Main flow:**

1. **Actor:** Selects "Delete" on a document.
2. **System:** Ask for confirmation.
3. **Actor:** Confirms.
4. **System:** Mark the document as deleted and remove it from the library, search results, AI Assistant answers, Life Canvas and expiry tracking.
5. **System:** Mark goal checklist items linked to this document as missing.
6. **System:** Display a confirmation message.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, the document is not deleted.

---

## UC28 — Restore Deleted Document

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner restores a deleted document from the "Deleted" area back to the library.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- At least one deleted document must exist.

**Post-conditions:**

- The document is back in the library, search results, AI Assistant answers and expiry tracking.
- Goal checklist items that match the document are marked available again.

**Main success scenario:** Deleted document is restored to the library.

**Main flow:**

1. **Actor:** Opens "Deleted Documents".
2. **System:** Display the list of deleted documents.
3. **Actor:** Selects a document and chooses "Restore".
4. **System:** Move the document back to the library, search results, AI Assistant answers, Life Canvas and expiry tracking.
5. **System:** Match the goal checklist items with the restored document again.
6. **System:** Display a confirmation message.

**Alternative flows:**

- **2.a.** If there are no deleted documents, display a "No deleted documents" message.

---

## UC29 — Delete Document Permanently

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner permanently removes a deleted document together with its extracted text and search data. This cannot be undone.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- The document must be in the Deleted area.

**Post-conditions:**

- The file, extracted text, search data and Life Canvas links of the document are permanently removed.

**Main success scenario:** Deleted document is permanently removed.

**Main flow:**

1. **Actor:** Opens "Deleted Documents" and selects "Delete Permanently" on a document.
2. **System:** Warn that this cannot be undone and ask for confirmation.
3. **Actor:** Confirms.
4. **System:** Ask for a second confirmation.
5. **Actor:** Confirms again.
6. **System:** Permanently remove the file, extracted text, search data and Life Canvas links of the document.
7. **System:** Display a confirmation message.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, the document stays in the Deleted area.
- **5.a.** If the Document Owner cancels, the document stays in the Deleted area.

---

## UC30 — View Calendar Highlights

- **Module:** Document Lifecycle Utilities
- **Brief Description:** Document Owner sees a calendar in which important document dates, such as expiry dates, are highlighted.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- Documents must have extracted or entered dates.

**Post-conditions:**

- Calendar with highlighted dates is displayed.

**Main success scenario:** Document Owner sees important dates and the documents behind them.

**Main flow:**

1. **Actor:** Opens the Calendar view.
2. **System:** Fetch the important dates from the Document Owner's documents.
3. **System:** Display the calendar with these dates highlighted.
4. **Actor:** Clicks a highlighted date.
5. **System:** Display the documents linked to that date.
6. **Actor:** Selects a document.
7. **System:** Open the document details.

**Alternative flows:**

- **2.a.** If no dates are available, display an empty calendar with an explanatory message.
