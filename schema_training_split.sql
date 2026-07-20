-- Adds an editable training split to settings, so a new user can define
-- their own day labels or an existing user can revise theirs from the
-- Training tab ("Edit split"). Defaults match the app's built-in split.
-- Paste into your Supabase project's SQL Editor (SQL Editor -> New query
-- -> paste -> Run).

alter table settings add column if not exists split jsonb not null default '{
  "full": ["Back & Biceps","Legs & Glutes","Shoulders","Legs & Glutes","Abs","Legs & Glutes","Rest Day"],
  "short": ["Back/Bi","Legs","Shoulders","Legs","Abs","Legs","Rest"]
}'::jsonb;
