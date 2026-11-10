# Institute Student Portal — merged v4

## Run
Open `index.html` in a browser. Submitting the login form navigates to `dashboard.html` as a front-end prototype.

## Logo
Place the institute logo at `assets/logo.png`. It is used by the login header, login watermark, login card, and dashboard sidebar.

## Project structure
- `index.html` — user's customized IIT Madras login page
- `dashboard.html` — Candidate Dashboard overview
- `css/master.css` — user's uploaded master stylesheet plus the dashboard styles required by v4
- `assets/logo.png` — add the official logo here

## Preserved user changes
The uploaded login page content and uploaded master stylesheet were used as the base. Institute name in English, Hindi and Tamil, login placeholder, footer identity, card logo markup, and existing styling were retained. Dashboard styles were appended to the user's stylesheet.

## Dashboard
Sidebar: Overview, Attendance, Notices, Assignment, Exam, Results, Account, Documents, Personal Info and Logout. Non-overview sections are placeholders.

## Prototype limitation
The sign-in form currently navigates to the dashboard without authenticating credentials. Connect real authentication and authorization before deployment. Student ID, department and subject codes are placeholders.


## Attendance section
The dashboard now has a working Attendance view with summary placeholders, subject-wise attendance, recent activity table, academic-period selector UI, and sidebar/quick-access navigation. Attendance values remain blank until official records are connected; no sample attendance figures have been invented.


## Shared institutional branding update
- Added the institute-logo watermark to the Candidate Dashboard background; the login page retains its existing logo watermark.
- Added a multilingual IIT Madras identity footer to both pages (English, Hindi and Tamil).
- Added portal, academics and information navigation links in the shared footer.
- Footer and dashboard use the same `assets/logo.png` file.
- Footer layout and watermark styles are appended to `css/master.css`; existing styles were retained.

The footer's Privacy, Accessibility, Help and Contact items are presentation links/placeholders. Replace them with institute-approved destinations and contact details before production deployment.


## Version 7 — Global candidate header
- Added a full-width institutional header to dashboard pages (login page unchanged).
- Header shows the institute logo and name in English, Hindi and Tamil on the left.
- Student profile image, name, roll number and Logout action appear on the right.
- Sidebar navigation remains on the left and sticks while scrolling.
- Footer remains full-width below the dashboard workspace.
- Optional student image path: `assets/student.png`. If not supplied, initials are shown instead.
- Header and navigation adapt for smaller screens.


## Supabase-backed login and assignments
See `SUPABASE-SETUP.md` for authentication setup, admin-created student accounts, assignment publishing, and private submissions.
