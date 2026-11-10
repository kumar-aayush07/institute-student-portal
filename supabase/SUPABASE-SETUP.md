# Supabase setup — Assignment module

## Project connection

Use the project root URL (not the `/rest/v1/` endpoint):

```text
https://huzqfyrvgkjmnvsnajjs.supabase.co
```

Use the Supabase **publishable** key in browser code. Never put a secret or `service_role` key in this project.

## 1. Create the database objects

1. Open the Supabase project dashboard.
2. Go to **SQL Editor** → **New query**.
3. Open `supabase-setup.sql` from this project, copy its complete contents into the editor.
4. Click **Run**.
5. Confirm the query completes successfully.

This creates:
- `assignments` — assignment instructions, deadlines and question-file metadata.
- `assignment_submissions` — one current submission per student per assignment.
- A private Storage bucket named `assignment-submissions`.
- Row Level Security policies so students can read their own submissions and upload into their own user-ID folder.

## 2. Important current limitations

- The existing login page is still a visual prototype until Supabase Auth is wired into it. A dashboard URL is not proof of authentication.
- Assignment records must be created by trusted staff/admin tooling. Do not expose database write permissions to every student.
- The SQL sets a 20 MB upload limit and permits PDF, Word and common image files. Adjust the bucket and assignment settings together if the institute needs different limits.
- The initial policies intentionally allow students to read only published assignments and their own submission records/files. Faculty/admin access needs a separate, verified role model before it is added.

## 3. Student accounts

For the first secure test, create a test student in **Authentication → Users → Add user** and set an email/password. Do not use a real student's credentials for testing. The login UI must be connected to Supabase Auth before the portal is used with students.
