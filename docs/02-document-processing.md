# Module: Document Processing

Use cases: UC04, UC05, UC06, UC07. See 00-overview.md for actors, status values and include/extend relationships.

## UC04 — Upload or Scan Document

- **Module:** Document Processing
- **Brief Description:** Document Owner adds one or more documents by scanning them with a scanner or webcam, choosing image or PDF files from the computer, or dragging and dropping files into the app. The original files are saved and the app starts working on it automatically. The Document Owner can also link Google Drive and Google Photos, so that selected documents, PDFs, slides and useful pictures containing text can be imported into the app. The Document Owner can also choose a folder on the computer, such as the Google Drive for desktop folder, to be watched so that new files in it are imported automatically.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: Read Text from Document (UC05); Sort Document and Pick Out Key Details (UC06). Extends: None.

**Preconditions:**

- Must be logged in.

**Post-conditions:**

- Original document is saved.
- The document is added with the status "Processing" and the text reading step begins.

**Main success scenario:** Document is uploaded and processing starts.

**Main flow:**

1. **Actor:** Selects "Add Document".
2. **System:** Display the options: Scan with Scanner/Webcam, Choose Image, Choose PDF, or Drag and Drop files.
3. **Actor:** Selects a source and scans, picks or drops one or more files.
4. **System:** Check the file type and size of each file.
5. **System:** Upload the file securely and save the original copy.
6. **System:** Add each document to the library and start working on it.
7. **System:** Display a progress indicator and notify the Document Owner when processing is complete.

**Alternative flows:**

- **3.a.** If permission is denied (e.g., webcam or file access is blocked in the Windows privacy settings), explain why it is needed and how to allow it, then request permission again.
- **3.b.** If the Document Owner chooses to link Google Drive, ask the Document Owner to sign in to Google and allow the app to access only the files the Document Owner picks. Display the Google file picker so the Document Owner can choose documents, PDFs, slides and other supported files from Drive. Import only the chosen files into the library; the rest of the Drive stays inaccessible to the app. Files that were already imported are not added again. Each imported file then continues through reading and sorting (UC05, UC06) like any other document.
- **3.c.** If the Document Owner chooses to link Google Photos, ask the Document Owner to sign in to Google and allow the app to access only the photos the Document Owner selects. Display the Google Photos picker so the Document Owner can select pictures or albums. Check each selected picture for text. Only pictures that contain useful, readable text related to a topic or to slides (for example lecture slides, whiteboards, notes or notices) are imported into the library and continue through reading and sorting (UC05, UC06). Selected pictures without useful text (for example people, places or food) are skipped and are not saved in the app, and the Document Owner is told how many were skipped.
- **3.d.** If the Document Owner chooses to watch a folder (for example the Google Drive for desktop folder on the computer), ask the Document Owner to select the folder and import the supported files in it and its subfolders. Keep a record of the files already imported. Check the folder again at regular intervals and whenever the app starts, and import only new or changed files. Files that cannot be read (for example Google Docs shortcut files) are skipped and the Document Owner is informed. The Document Owner can stop watching the folder at any time.
- **3.e.** If the selected folder is not available (for example Google Drive for desktop is not running), display a message that no new files could be checked and try again later.
- **3.f.** If the Google sign-in or permission is denied, or the link to Google Drive or Google Photos expires, display a message that nothing was imported and offer to link the account again. The Document Owner can unlink Google Drive or Google Photos at any time, and no new files are imported after unlinking.
- **4.a.** If the file type is unsupported or the file is too large, display an error message.
- **5.a.** If the upload fails because of connectivity, display an error message and offer a retry option.

---

## UC05 — Read Text from Document

- **Module:** Document Processing
- **Brief Description:** The system reads the text (OCR) from the uploaded image or PDF. It can handle printed text, mixed Urdu/English text and, as far as possible, handwriting.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Document must have been uploaded successfully.

**Post-conditions:**

- Extracted text is stored with the document.
- Document is passed on for sorting (UC06) or marked "Needs Review".

**Main success scenario:** Raw text is extracted and stored for the document.

**Main flow:**

1. **System:** Receive the uploaded file from Upload or Scan Document (UC04).
2. **System:** Prepare the file (turn PDF pages into images, improve the contrast and straighten the page).
3. **System:** Run OCR to read the text on each page.
4. **System:** Calculate the confidence (clearness and reliability) of the extracted text.
5. **System:** Store the extracted text with the document.
6. **System:** Pass the text on to sorting (UC06).

**Alternative flows:**

- **2.a.** If the file is damaged or cannot be opened, mark the document "Failed", show an error message to the Document Owner and offer "Retry" or "Upload Again".
- **4.a.** If no text is found or it is hard to read, try the alternative OCR engine and check again.
- **4.b.** If the text is still not reliable (e.g., handwriting), keep the original, mark the document "Needs Review" and ask the Document Owner to correct the text (UC07).

---

## UC06 — Sort Document and Pick Out Key Details

- **Module:** Document Processing
- **Brief Description:** The AI reads the text, works out the document type and category, picks out key details (dates, issuing authority, ID numbers, expiry date) and suggests a file name. The Document Owner can accept or change the result.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: Prepare Document for Smart Search (UC08). Extends: None.

**Preconditions:**

- Text has been extracted (UC05) or corrected (UC07).

**Post-conditions:**

- Document type, category, key details and suggested file name are saved.
- The document is passed on for search preparation (UC08).

**Main success scenario:** Document is sorted, key details are saved and a file name is suggested.

**Main flow:**

1. **System:** Receive the extracted text from Read Text from Document (UC05) or the corrected text from Correct Extracted Text Manually (UC07).
2. **System:** Send the text to the AI model.
3. **System:** Identify document type and category (e.g., passport, degree, contract).
4. **System:** Extract key details such as issue date, expiry date, issuing authority and holder name.
5. **System:** Suggest a file name.
6. **System:** Save the results and show them for review.
7. **Actor:** Reviews the result and accepts it.
8. **System:** Save the final details and start search preparation (UC08).

**Alternative flows:**

- **2.a.** If the AI service is not available, mark the document "Pending Sorting", tell the Document Owner and retry automatically at the next scheduled retry.
- **3.a.** If the type cannot be determined, set the category to "Uncategorized" and ask the Document Owner to choose a category.
- **7.a.** If the Document Owner changes the type, details or file name, check and save the changed values instead.
- **7.b.** If this use case was started from Correct Extracted Text Manually (UC07), skip the review and save the results.

---

## UC07 — Correct Extracted Text Manually

- **Module:** Document Processing
- **Brief Description:** When the app cannot read a document accurately (e.g., handwriting or blurry images), the Document Owner corrects the text while the original image stays safe.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: Sort Document and Pick Out Key Details (UC06). Extends: Read Text from Document (UC05).

**Preconditions:**

- Must be logged in.
- Document must exist and be marked "Needs Review" or be opened by the Document Owner for editing.

**Post-conditions:**

- Corrected text replaces the extracted text; the original file is unchanged.
- The document is sorted again and prepared for search using the corrected text.

**Main success scenario:** Extracted text is corrected and the document is re-processed.

**Main flow:**

1. **Actor:** Opens the document and selects "Edit Extracted Text".
2. **System:** Display the original image next to the editable extracted text.
3. **Actor:** Corrects the text and saves.
4. **System:** Check the text.
5. **System:** Update the stored text.
6. **System:** Sort the document again, extract the details again and prepare it for search (UC06, UC08) without asking for a second review.
7. **System:** Display the updated document details.

**Alternative flows:**

- **3.a.** If the Document Owner cancels, discard the changes and keep the previous text.
- **4.a.** If the text is empty, display an error message and ask the Document Owner to enter text.
