# Module: Smart Search & AI Assistant

Use cases: UC08, UC12, UC13. See 00-overview.md for actors, status values and include/extend relationships.

## UC08 — Prepare Document for Smart Search

- **Module:** Smart Search & AI Assistant
- **Brief Description:** Once the text is final, the system prepares the document for smart search and links it to related documents in the Life Canvas.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Final text and details must be saved.

**Post-conditions:**

- The document is ready to be found through search.
- Links between documents are created or updated.
- Document status is "Ready".

**Main success scenario:** Document becomes searchable and linked in the Life Canvas.

**Main flow:**

1. **System:** Receive the final text and details saved by Sort Document and Pick Out Key Details (UC06).
2. **System:** Split the text into chunks.
3. **System:** Generate an embedding (a numerical representation of the meaning) for each chunk.
4. **System:** Store the embeddings with the document ID in the search index so that the document can be found in search later.
5. **System:** Compare names, dates and topics with the Document Owner's other documents and create or update links in the Life Canvas.
6. **System:** Update expiry tracking and goal checklists. If a possible duplicate or conflicting detail is found, start Detect Duplicate Documents (UC21) or Detect Contradictions Between Documents (UC22).
7. **System:** Set the document status to "Ready".

**Alternative flows:**

- **3.a.** If generating embeddings fails, mark the document "Pending Index" and retry automatically at the next scheduled retry.
- **4.a.** If the search index is not available, keep the work waiting and retry; the document stays "Pending Index".

---

## UC12 — Search Documents in Everyday Language

- **Module:** Smart Search & AI Assistant
- **Brief Description:** Document Owner searches documents by typing a question or phrase in everyday language and gets results ranked by meaning, not only by exact words.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- At least one document must be prepared for search.

**Post-conditions:**

- A ranked list of matching documents from the Document Owner's library is displayed.

**Main success scenario:** Document Owner finds and opens the relevant document.

**Main flow:**

1. **Actor:** Types a question or phrase in the search bar.
2. **System:** Generate an embedding of the search text.
3. **System:** Look through the Document Owner's documents.
4. **System:** Fetch the details of the best matches.
5. **System:** Display the ranked results with name, type and a matching snippet.
6. **Actor:** Selects a result.
7. **System:** Open the document details.

**Alternative flows:**

- **1.a.** If the query is empty, prompt the Document Owner to enter a search term.
- **3.a.** If no relevant documents are found, display a "No matching documents" message.
- **3.b.** If the search fails, display an error message with a retry option.

---

## UC13 — Ask AI Assistant a Question

- **Module:** Smart Search & AI Assistant
- **Brief Description:** Document Owner asks a question in plain language and the assistant answers using only the Document Owner's documents, showing which documents the answer came from.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.
- At least one document must be prepared for search.
- AI service must be available.

**Post-conditions:**

- An answer based on the Document Owner's documents is shown together with its sources.

**Main success scenario:** Document Owner gets an answer with cited source documents.

**Main flow:**

1. **Actor:** Opens the AI Assistant and types a question (e.g., "What is my CNIC number?").
2. **System:** Generate an embedding of the question.
3. **System:** Find the most relevant parts of the Document Owner's documents, along with related information from the Life Canvas.
4. **System:** Send the question and the relevant text to the AI, with the instruction to answer only from the Document Owner's documents.
5. **System:** Write the answer and attach references to the source documents.
6. **System:** Display the answer with clickable source citations.
7. **Actor:** Clicks a source citation.
8. **System:** Open the cited document.

**Alternative flows:**

- **1.a.** If the question asks for legal, medical, tax or financial advice, explain that this is outside the scope and only offer information found in the Document Owner's documents.
- **3.a.** If no relevant information is found, inform the Document Owner that the answer is not in their documents instead of guessing.
- **4.a.** If the AI service is not available, display an error message with a retry option.
