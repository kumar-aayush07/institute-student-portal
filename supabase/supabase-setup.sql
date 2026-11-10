-- Institute Student Portal: Assignment module foundation
-- Run this entire file in Supabase Dashboard > SQL Editor > New query.
-- This creates assignment records, student submissions, and a private upload bucket.

create extension if not exists pgcrypto;

create table if not exists public.assignments (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text not null,
  description text,
  instructions text,
  assigned_at timestamptz not null default now(),
  due_at timestamptz,
  max_marks numeric(8,2),
  question_file_path text,
  allowed_extensions text[] not null default array['pdf','doc','docx','jpg','jpeg','png'],
  max_file_size_mb integer not null default 20 check (max_file_size_mb between 1 and 100),
  allow_resubmission boolean not null default true,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists assignments_published_due_idx
  on public.assignments (is_published, due_at desc);

create table if not exists public.assignment_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.assignments(id) on delete cascade,
  student_id uuid not null references auth.users(id) on delete cascade,
  file_path text not null,
  original_file_name text not null,
  file_size_bytes bigint not null check (file_size_bytes > 0),
  mime_type text,
  submitted_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  status text not null default 'submitted' check (status in ('submitted','reviewed','late')),
  marks_obtained numeric(8,2),
  faculty_feedback text,
  unique (assignment_id, student_id)
);

create index if not exists assignment_submissions_student_idx
  on public.assignment_submissions (student_id, submitted_at desc);

alter table public.assignments enable row level security;
alter table public.assignment_submissions enable row level security;

-- Students can read published assignments only. Assignment creation/editing is
-- intentionally reserved for trusted server-side/admin tooling at this stage.
drop policy if exists "Authenticated students read published assignments" on public.assignments;
create policy "Authenticated students read published assignments"
  on public.assignments for select to authenticated
  using (is_published = true);

-- Students can see only their own submissions.
drop policy if exists "Students read own submissions" on public.assignment_submissions;
create policy "Students read own submissions"
  on public.assignment_submissions for select to authenticated
  using (student_id = auth.uid());

-- Students can create a submission only for themselves and only while the
-- assignment is published and not past its deadline.
drop policy if exists "Students submit their own work" on public.assignment_submissions;
create policy "Students submit their own work"
  on public.assignment_submissions for insert to authenticated
  with check (
    student_id = auth.uid()
    and exists (
      select 1 from public.assignments a
      where a.id = assignment_id
        and a.is_published = true
        and (a.due_at is null or now() <= a.due_at)
    )
  );

-- Resubmission updates are restricted to the student's own row and assignments
-- that explicitly permit resubmission and are still before the deadline.
drop policy if exists "Students update own permitted submissions" on public.assignment_submissions;
create policy "Students update own permitted submissions"
  on public.assignment_submissions for update to authenticated
  using (student_id = auth.uid())
  with check (
    student_id = auth.uid()
    and exists (
      select 1 from public.assignments a
      where a.id = assignment_id
        and a.is_published = true
        and a.allow_resubmission = true
        and (a.due_at is null or now() <= a.due_at)
    )
  );

-- Private bucket: each student's objects live under <auth.uid()>/<assignment-id>/...
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'assignment-submissions',
  'assignment-submissions',
  false,
  20971520,
  array[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'image/jpeg',
    'image/png'
  ]
)
on conflict (id) do update set
  public = false,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Students may upload only into their own top-level folder.
drop policy if exists "Students upload files to own folder" on storage.objects;
create policy "Students upload files to own folder"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'assignment-submissions'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Students can read only their own private submission files.
drop policy if exists "Students read files from own folder" on storage.objects;
create policy "Students read files from own folder"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'assignment-submissions'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Students can replace/remove only files in their own folder.
drop policy if exists "Students update files in own folder" on storage.objects;
create policy "Students update files in own folder"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'assignment-submissions'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'assignment-submissions'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Students delete files in own folder" on storage.objects;
create policy "Students delete files in own folder"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'assignment-submissions'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
