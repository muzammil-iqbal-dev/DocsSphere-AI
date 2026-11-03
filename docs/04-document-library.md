# Module: Document Library

Use cases: UC09, UC10, UC11. See 00-overview.md for actors, status values and include/extend relationships.

## UC09 — Browse Document Library and Categories

- **Module:** Document Library
- **Brief Description:** Document Owner views all their documents in one library, filtered by category or favourites and sorted by date or name.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.

**Post-conditions:**

- Document Owner sees the list of documents.

**Main success scenario:** Document Owner sees and selects documents from the library.

**Main flow:**

1. **Actor:** Opens the Home / Document Library screen.
2. **System:** Display the documents with pinned items first, plus category filters and a Favourites filter.
3. **Actor:** Selects a category, the Favourites filter or a sort option.
4. **System:** Display the filtered and sorted list.
5. **Actor:** Clicks a document.
6. **System:** Open the document details.

**Alternative flows:**

- **2.a.** If there are no documents, display an empty state that prompts the Document Owner to add a document.
- **4.a.** If no document matches the chosen category or filter, display a "No documents found" message.

---

## UC10 — View Document Details

- **Module:** Document Library
- **Brief Description:** Document Owner opens a document to see the original file, text, type, category, key details, expiry status and related documents.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: Browse Document Library and Categories (UC09).

**Preconditions:**

- Must be logged in.
- Document must exist and not be permanently deleted.

**Post-conditions:**

- Document details are displayed.

**Main success scenario:** Document Owner sees all details of the selected document.

**Main flow:**

1. **Actor:** Selects a document.
2. **System:** Fetch the document details and the original file.
3. **System:** Display the file preview, text, type, category, key details, expiry status, related documents and warnings (duplicate or conflicting details).
4. **Actor:** Selects an action (edit, favourite, pin, hide, delete) or opens a related document.
5. **System:** Perform the action or navigate to the selected item.

**Alternative flows:**

- **2.a.** If retrieval fails, display an error message with a retry option.
- **3.a.** If the original file is missing, display the extracted text only with a warning.

---

## UC11 — Edit Document Name and Details

- **Module:** Document Library
- **Brief Description:** Document Owner renames a document or changes its category and key details (e.g., issue and expiry dates) when the automatic result is wrong or incomplete.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: View Document Details (UC10).

**Preconditions:**

- Must be logged in.
- Document must exist.

**Post-conditions:**

- Updated details are saved.
- Expiry tracking, goal checklists and Life Canvas links are refreshed.

**Main success scenario:** Document details are updated.

**Main flow:**

1. **Actor:** Opens a document and selects "Edit".
2. **System:** Display the details that can be edited (name, category, dates, other key details).
3. **Actor:** Changes the values and saves.
4. **System:** Check the values.
5. **System:** Save the details and refresh expiry tracking, goals and Life Canvas links.
6. **System:** Display a confirmation and the updated details.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, no changes are saved.
- **4.a.** If a value is invalid (e.g., expiry date earlier than issue date or empty name), display an error message.
