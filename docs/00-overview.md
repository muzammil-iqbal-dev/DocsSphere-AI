# DocSphereAI (Your Second Brain)

## Use Case Descriptions

Primary actors: Document Owner and Admin. The "System" is the app itself (the system boundary), not an actor. Work that the app does on its own in the background is shown under "System Response" only. Each role is explained below.

## Primary Actors and Their Roles

**Primary actors** – there are two types of people who use the app. The Document Owner is the end user of the Windows desktop application (mainly researchers and students), and the Admin looks after the app itself.

- **1. Document owner:** signs up, logs in and logs out, adds documents by scanning them or by choosing or dragging files from the computer into the app or by linking Google Drive and Google Photos, checks the text and details the app picks out, and corrects them when needed. Also browses the library, searches in everyday language, asks the AI Assistant questions and explores the Life Canvas. Sets goals, follows the checklist of documents needed and sees which ones are missing. Keeps an eye on expiry dates and the calendar, marks documents as favourite or pinned, hides, deletes or restores them, and decides what to do about duplicates or conflicting details.
- **2. Admin:** logs in and logs out, suspends or reactivates user accounts, reviews reported technical issues, and checks overall usage and service health. The Admin cannot see the private text or files of any Document Owner. The Admin account is created in advance by the system owner and is not created through "Sign Up".

**System** – the app itself (the system boundary, not an actor), working in the background. Its roles are reading the text of uploaded documents, sorting them, getting them ready for search, checking for expiry dates, duplicates and conflicting details, and sending expiry reminders.

## Document Status Values

- **Processing:** the file is saved and the text is being read, sorted and prepared for search.
- **Needs Review:** the text could not be read reliably, so the Document Owner has to correct it.
- **Pending Sorting:** the AI service was not available; the system retries automatically.
- **Pending Index:** search preparation failed; the system retries automatically.
- **Failed:** the file could not be opened; the Document Owner can retry or upload it again.
- **Ready:** the document is sorted, saved and can be found through search.
- **Hidden / Deleted:** the document is kept out of the main library because the Document Owner hid it, or it is in the Deleted area because the Document Owner deleted it.

## Relationships Between Use Cases

- **«include»:** Upload or Scan Document (UC04) includes Read Text from Document (UC05) and Sort Document and Pick Out Key Details (UC06). Sort Document and Pick Out Key Details (UC06) includes Prepare Document for Smart Search (UC08). Correct Extracted Text Manually (UC07) includes Sort Document and Pick Out Key Details (UC06).
- **«extend»:** Correct Extracted Text Manually (UC07) extends Read Text from Document (UC05). Detect Duplicate Documents (UC21) extends Prepare Document for Smart Search (UC08). Detect Contradictions Between Documents (UC22) extends Prepare Document for Smart Search (UC08) and Edit Document Name and Details (UC11). View Document Details (UC10) extends Browse Document Library and Categories (UC09). Edit Document Name and Details (UC11), Favourite Document (UC23), Pin Document (UC24), Hide Document (UC25) and Delete Document (UC27) extend View Document Details (UC10).
- **Navigation (not drawn):** Search Documents in Everyday Language (UC12), Ask AI Assistant a Question (UC13), View Life Canvas (Document Map) (UC14), Track Document Expiry (UC19), Receive Expiry Reminder (UC20) and View Calendar Highlights (UC30) open View Document Details (UC10) when the Document Owner selects a document, and Track Goal Progress (UC16) can start Upload or Scan Document (UC04) for a missing checklist item. These are normal navigation steps and are not shown as include/extend relationships.

## List of Use Cases

| ID | Use Case | Module |
|---|---|---|
| UC01 | Register Account | Account |
| UC02 | Log In | Account |
| UC03 | Log Out | Account |
| UC04 | Upload or Scan Document | Document Processing |
| UC05 | Read Text from Document | Document Processing |
| UC06 | Sort Document and Pick Out Key Details | Document Processing |
| UC07 | Correct Extracted Text Manually | Document Processing |
| UC08 | Prepare Document for Smart Search | Smart Search & AI Assistant |
| UC09 | Browse Document Library and Categories | Document Library |
| UC10 | View Document Details | Document Library |
| UC11 | Edit Document Name and Details | Document Library |
| UC12 | Search Documents in Everyday Language | Smart Search & AI Assistant |
| UC13 | Ask AI Assistant a Question | Smart Search & AI Assistant |
| UC14 | View Life Canvas (Document Map) | Life Canvas |
| UC15 | Create Goal and Generate Document Checklist | Goal Dashboard |
| UC16 | Track Goal Progress | Goal Dashboard |
| UC17 | Edit Goal | Goal Dashboard |
| UC18 | Delete Goal | Goal Dashboard |
| UC19 | Track Document Expiry | Document Lifecycle Utilities |
| UC20 | Receive Expiry Reminder | Document Lifecycle Utilities |
| UC21 | Detect Duplicate Documents | Document Lifecycle Utilities |
| UC22 | Detect Contradictions Between Documents | Document Lifecycle Utilities |
| UC23 | Favourite Document | Document Lifecycle Utilities |
| UC24 | Pin Document | Document Lifecycle Utilities |
| UC25 | Hide Document | Document Lifecycle Utilities |
| UC26 | Unhide Document | Document Lifecycle Utilities |
| UC27 | Delete Document | Document Lifecycle Utilities |
| UC28 | Restore Deleted Document | Document Lifecycle Utilities |
| UC29 | Delete Document Permanently | Document Lifecycle Utilities |
| UC30 | View Calendar Highlights | Document Lifecycle Utilities |
| UC31 | Suspend Account | Administration |
| UC32 | Reactivate Account | Administration |
| UC33 | View Usage and Service Health | Administration |
| UC34 | Review Reported Technical Issues | Administration |
