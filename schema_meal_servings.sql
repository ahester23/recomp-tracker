-- Adds servings-per-batch to saved meals. Paste into your Supabase
-- project's SQL Editor (SQL Editor -> New query -> paste -> Run).

alter table saved_foods add column if not exists servings numeric not null default 1;
