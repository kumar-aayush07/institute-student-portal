# Institute Student Portal — Supabase connection

## What is connected
- Login uses Supabase Auth password sign-in (no public registration).
- Dashboard requires an authenticated session and signs out through Supabase.
- Student name and optional roll number, student ID, department and avatar are read from Auth user metadata.
- Assignment page reads published rows from `public.assignments`, reads only the signed-in student's rows from `public.assignment_submissions`, and uploads files to the private `assignment-submissions` bucket.
- Institute-provided question files are read from the private `assignment-materials` bucket.

## 1. Supabase project settings
The project URL and publishable key are configured in `index.html` and `dashboard.html`.
The publishable key is intended for browser use. Never put a `service_role` or secret key in these files.

In Supabase Authentication > URL Configuration, add your deployed portal URL to the allowed Redirect URLs. For local testing with VS Code Live Server, add the exact local origin/path you use (for example `http://127.0.0.1:5500/**`).

For password recovery, also configure the site's redirect URL. SMTP/email delivery must be configured for reliable production email.

## 2. Add the materials bucket
The initial setup SQL creates `assignment-submissions`. Run `supabase/assignment-materials-migration.sql` once in SQL Editor to create `assignment-materials`.

## 3. Create student accounts (admin-created only)
Do NOT add a registration page. In Supabase Dashboard:
1. Open Authentication > Users.
2. Choose Add user / Invite user.
3. Enter the student's institutional email and set or invite a temporary password.
4. Set user metadata (if the dashboard form supports it) with values such as:
   `{"full_name":"Student Name","roll_number":"ROLL123","student_id":"STU123","department":"Computer Science"}`
5. If you set a temporary password, require the student to change it at first sign-in using your institute's onboarding process. Do not send passwords in public channels.

The browser app never creates accounts and never has a service-role key. Account provisioning through a dedicated admin panel should be implemented later as a server-side Supabase Edge Function with an admin-only authorization check.

## 4. Publish an assignment
In Table Editor > public > assignments, insert a row:
- title (required)
- subject (required)
- description / instructions
- assigned_at (defaults to now)
- due_at (ISO timestamp with timezone, or null)
- max_marks (optional)
- is_published = true
- allow_resubmission = true/false

To attach a question paper:
1. Upload the file in Storage > assignment-materials.
2. Use a path such as `papers/assignment-uuid/question-paper.pdf`.
3. Copy that exact object path into `question_file_path` on the assignment row.

Students can read published assignment records and download materials after sign-in. Only trusted administrators should upload materials and create/edit assignment rows.

## 5. Student submissions
Students upload PDF, DOC, DOCX, JPG or PNG files up to 20 MB. Objects are stored under:
`<authenticated-user-id>/<assignment-id>/<timestamp>-<filename>`

The database row is tied to `auth.uid()`. RLS prevents a student from reading another student's submission record or object. Submissions after the deadline are blocked by the database policy. Resubmission depends on `allow_resubmission`.

## 6. Run the portal
Serve the folder over HTTP (do not open HTML using file://). For example:
`python3 -m http.server 8000`
Then open `http://localhost:8000`.

## Important current scope
This is the student-facing authentication and assignment submission integration. The institute admin workflow for creating accounts and publishing assignments currently uses the Supabase Dashboard, not an in-portal admin panel. A production admin panel should be backed by server-side Edge Functions and admin role claims; do not grant account creation or assignment write permissions to every authenticated browser user.
