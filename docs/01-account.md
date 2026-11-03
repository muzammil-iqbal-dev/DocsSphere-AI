# Module: Account

Use cases: UC01, UC02, UC03. See 00-overview.md for actors, status values and include/extend relationships.

## UC01 — Register Account

- **Module:** Account
- **Brief Description:** A new Document Owner creates a DocSphereAI account with a name, email and password, so that they can save and manage their documents.
- **Primary actors:** Document Owner
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- The Windows desktop application must be installed and the computer connected to the internet.
- Email address must not already be registered.

**Post-conditions:**

- The account is created and the Document Owner is logged in.
- The account is ready for the Document Owner to save documents.

**Main success scenario:** Document Owner gets a registered account and lands on an empty Document Library.

**Main flow:**

1. **Actor:** Opens the app and selects "Sign Up".
2. **System:** Display the registration form.
3. **Actor:** Enters name, email, password and confirm password, then submits.
4. **System:** Check the information entered.
5. **System:** Check that the email is not already registered.
6. **System:** Create the account and store the password securely (as a hash).
7. **System:** Log the Document Owner in and display the empty Home / Document Library screen.

**Alternative flows:**

- If the email format is invalid, the password is weak or passwords do not match, display an error message and let the Document Owner correct the data.
- If the email is already registered, display an error message and offer the "Log In" option.

---

## UC02 — Log In

- **Module:** Account
- **Brief Description:** A registered Document Owner or Admin logs in with email and password to access the document library (Document Owner) or the admin dashboard (Admin).
- **Primary actors:** Document Owner, Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Device must be connected to the internet.

**Post-conditions:**

- Document Owner or Admin is signed in securely.
- Document Owner sees the Document Library, or Admin sees the Admin Dashboard.

**Main success scenario:** Document Owner or Admin is logged in and sees their home screen.

**Main flow:**

1. **Actor:** Opens the app and selects "Log In".
2. **System:** Display the login form.
3. **Actor:** Enters email and password and submits.
4. **System:** Check the email and password.
5. **System:** Sign the user in securely and load their data.
6. **System:** Display the Home / Document Library screen for a Document Owner or the Admin Dashboard for an Admin.

**Alternative flows:**

- If the email or password is wrong, display an error message and let the user try again.
- If no account exists for the email, display an error message and offer the "Sign Up" option.
- If the account has been suspended by the Admin, display a message that the account is suspended and do not sign in.

---

## UC03 — Log Out

- **Module:** Account
- **Brief Description:** A logged-in Document Owner or Admin signs out so that nobody else can access their account on the device.
- **Primary actors:** Document Owner, Admin
- **Includes / Extends:** Includes: None. Extends: None.

**Preconditions:**

- Must be logged in.

**Post-conditions:**

- The Document Owner or Admin is signed out and any saved data is cleared from the device.

**Main success scenario:** Document Owner or Admin is logged out and sees the login screen.

**Main flow:**

1. **Actor:** Selects "Log Out" from the settings/profile menu.
2. **System:** Ask for confirmation.
3. **Actor:** Confirms.
4. **System:** Sign the user out and clear saved data from the device.
5. **System:** Display the login screen.

**Alternative flows:**

- **3.a.** If the user cancels, they stay signed in and remain on the current screen.
