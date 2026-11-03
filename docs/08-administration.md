# Module: Administration

Use cases: UC31, UC32, UC33, UC34. See 00-overview.md for actors, status values and include/extend relationships.

## UC31 — Suspend Account

- **Module:** Administration
- **Brief Description:** Admin suspends a Document Owner account (for example after misuse) so that it can no longer log in, without seeing any private documents.
- **Primary actors:** Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in as Admin.
- At least one active Document Owner account must exist.

**Post-conditions:**

- The account status is "Suspended".
- The suspended Document Owner cannot log in until the account is reactivated (UC32).

**Main success scenario:** Admin suspends a Document Owner account.

**Main flow:**

1. **Actor:** Opens the "Manage Accounts" screen.
2. **System:** Display the list of Document Owner accounts with name, email and status (Active or Suspended). Document contents are not shown.
3. **Actor:** Selects an active account.
4. **System:** Display the account details and the "Suspend" action.
5. **Actor:** Selects "Suspend" and confirms.
6. **System:** Set the account status to "Suspended" and sign the Document Owner out.
7. **System:** Display a confirmation message and the updated list.

**Alternative flows:**

- **2.a.** If no Document Owner accounts exist, display an empty state.
- **5.a.** If the Admin cancels, no change is made.

---

## UC32 — Reactivate Account

- **Module:** Administration
- **Brief Description:** Admin reactivates a suspended Document Owner account so that the Document Owner can log in again, without seeing any private documents.
- **Primary actors:** Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in as Admin.
- At least one suspended Document Owner account must exist.

**Post-conditions:**

- The account status is "Active".
- The Document Owner can log in again.

**Main success scenario:** Admin reactivates a suspended account.

**Main flow:**

1. **Actor:** Opens the "Manage Accounts" screen.
2. **System:** Display the list of Document Owner accounts with name, email and status (Active or Suspended). Document contents are not shown.
3. **Actor:** Selects a suspended account.
4. **System:** Display the account details and the "Reactivate" action.
5. **Actor:** Selects "Reactivate" and confirms.
6. **System:** Set the account status to "Active".
7. **System:** Display a confirmation message and the updated list.

**Alternative flows:**

- **2.a.** If no Document Owner accounts exist, display an empty state.
- **5.a.** If the Admin cancels, no change is made.

---

## UC33 — View Usage and Service Health

- **Module:** Administration
- **Brief Description:** Admin sees overall usage numbers (e.g., registered accounts, uploads) and the health of the app services (text reading, AI and search), without seeing any private document content.
- **Primary actors:** Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in as Admin.

**Post-conditions:**

- The usage summary and service status are displayed.

**Main success scenario:** Admin sees overall usage and the status of each service.

**Main flow:**

1. **Actor:** Opens the Admin Dashboard.
2. **System:** Collect combined usage counts and service status. No document text, file names or personal details are included.
3. **System:** Display the usage summary (accounts, uploads, failed processing) and the status of each service.
4. **Actor:** Selects a service.
5. **System:** Display the recent processing errors and response times of that service.

**Alternative flows:**

- **2.a.** If a service cannot be reached, show it as "Unavailable" with the last known time.

---

## UC34 — Review Reported Technical Issues

- **Module:** Administration
- **Brief Description:** Admin reads technical issues recorded by the app (such as failed uploads or processing errors) and marks them as in progress or resolved so that problems can be fixed.
- **Primary actors:** Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in as Admin.

**Post-conditions:**

- The issue status and note are saved.

**Main success scenario:** Admin reviews an issue and updates its status.

**Main flow:**

1. **Actor:** Opens the "Reported Issues" screen.
2. **System:** Display the list of issues with type, time and status (New, In Progress or Resolved). Document contents are not shown.
3. **Actor:** Selects an issue.
4. **System:** Display the issue details such as error type, time and the service affected.
5. **Actor:** Changes the status and adds a short note.
6. **System:** Save the status and note and display the updated list.

**Alternative flows:**

- **2.a.** If no issues have been reported, display a "No issues reported" message.
- **5.a.** If the Admin cancels, no changes are saved.
