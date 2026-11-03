# DocSphereAI — Windows desktop prototype

This workspace contained the project use case document and diagrams, but no application source. The FYP presentation identifies **Flutter/Dart** as the Windows UI stack and FastAPI, OCR, RAG, Qdrant and MongoDB as planned services. This implementation follows the documented Flutter direction and keeps all unavailable services clearly in sample mode.

## Run locally

Requires Flutter with the Windows desktop toolchain enabled and Visual Studio's C++ desktop workload. From this folder:

```powershell
flutter pub get
flutter run -d windows
```

The file chooser and Windows drag-and-drop accept PDF and image files up to 20 MB each. This prototype records only fictional, in-memory file metadata and shows **Processing**. It does not upload or copy file bytes, and it does not claim OCR, classification, indexing, authentication or AI operations completed.

## Implemented screen/use-case map

| Screens and interactions | Use cases |
|---|---|
| Sign Up, Log In, role-specific demo entry, logout confirmation | UC01–UC03 |
| Multi-file selection/drop, validation, scan availability feedback, processing/retry states | UC04–UC08 |
| Library list/grid, category/search/favourite/sort/pin, details, edit, original preview, extracted text review | UC09–UC11 |
| Everyday-language search and document-grounded answer examples with source links | UC12–UC13 |
| Interactive Life Canvas map, node selection, pan/zoom, reset and details | UC14 |
| Goal creation/edit/checklist, matching, progress, missing/expired states and delete confirmation | UC15–UC18 |
| Expiry list, sample reminders, in-app notifications and calendar highlights | UC19–UC20, UC30 |
| Side-by-side duplicate decision and contradiction review panel | UC21–UC22 |
| Favourites, pinned, hidden/unhide, Deleted/restore and two-step permanent deletion | UC23–UC29 |
| Separate Admin overview, account details/suspend/reactivate, issues and service health | UC31–UC34 |

## Data and privacy

All records are fictional and held in memory. Refreshing the app restores the examples. The Admin experience has separate navigation and has no route to Owner document screens. Admin counts and issue examples contain only aggregate or service-level metadata; service health is marked unavailable/sample, never represented as live.

## Backend-dependent work

The UI is prepared for the planned backend but is not wired to it. Real authentication, password hashing/session storage, document storage, scanner/webcam integration, OCR and mixed Urdu/English extraction, AI classification/metadata, semantic indexing, RAG answers, duplicate/contradiction detection, calendar persistence, Windows expiry notifications, audit logs, live account operations and service telemetry require their respective APIs/services. File selection only verifies the chosen file type and size locally.

## Explicit scope

The presentation lists document translation and smart-folder recommendations as proposed/out of scope; neither is introduced here. Legal, medical, tax and financial advice is not provided.
