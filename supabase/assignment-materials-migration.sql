-- Run once AFTER the initial assignment setup SQL.
-- Private bucket for institute-provided question papers and assignment resources.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'assignment-materials', 'assignment-materials', false, 20971520,
  array['application/pdf','image/jpeg','image/png','application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
)
on conflict (id) do update set public = false, file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Any authenticated student can read published assignment materials.
drop policy if exists "Authenticated users read assignment materials" on storage.objects;
create policy "Authenticated users read assignment materials"
on storage.objects for select to authenticated
using (bucket_id = 'assignment-materials');

-- Material uploads are performed by a trusted administrator through Supabase Dashboard
-- or a future server-side admin function. No browser client upload policy is granted.
