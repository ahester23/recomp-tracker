-- Adds saved/reusable meals. Paste into your Supabase project's SQL Editor
-- (SQL Editor -> New query -> paste -> Run). Safe to run once.

create table if not exists saved_foods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  cal numeric not null default 0,
  protein numeric not null default 0,
  carbs numeric not null default 0,
  fat numeric not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists saved_foods_user_idx on saved_foods(user_id);

alter table saved_foods enable row level security;

create policy "saved_foods_select_own" on saved_foods for select using (auth.uid() = user_id);
create policy "saved_foods_insert_own" on saved_foods for insert with check (auth.uid() = user_id);
create policy "saved_foods_delete_own" on saved_foods for delete using (auth.uid() = user_id);
