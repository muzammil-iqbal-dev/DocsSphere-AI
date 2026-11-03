# Module: Life Canvas

Use cases: UC14. See 00-overview.md for actors, status values and include/extend relationships.

## UC14 — View Life Canvas (Document Map)

- **Module:** Life Canvas
- **Brief Description:** Document Owner explores a map, created automatically, in which each document is a dot and shared names, dates or topics form the links between them.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.

**Post-conditions:**

- An interactive map of the Document Owner's documents and how they are connected is shown.

**Main success scenario:** Document Owner sees related documents connected in the Life Canvas.

**Main flow:**

1. **Actor:** Opens the Life Canvas.
2. **System:** Fetch the Document Owner's documents and how they are connected.
3. **System:** Show the interactive map with documents grouped and coloured by category.
4. **Actor:** Drags the map, zooms with the mouse wheel and clicks a document.
5. **System:** Highlight the connected documents and show a short summary of the selected document.
6. **Actor:** Selects "Open document".
7. **System:** Open the document details.

**Alternative flows:**

- **2.a.** If fewer than two documents exist, display a message that links will appear as more documents are added.
- **4.a.** If the Document Owner clicks a link between two documents, display the reason for the link (shared name, date or topic).
