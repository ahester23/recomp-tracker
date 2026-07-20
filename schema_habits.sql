-- Replaces hydration tracking with general-purpose habit tracking.
-- Paste into your Supabase project's SQL Editor (SQL Editor -> New query
-- -> paste -> Run). The old hydration_entries table is no longer used by
-- the app and can be left alone or dropped manually later if you want.

create table if not exists habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  unit text,
  created_at timestamptz not null default now()
);

create table if not exists habit_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  habit_id uuid not null references habits(id) on delete cascade,
  day date not null,
  amount numeric not null default 1,
  created_at timestamptz not null default now()
);
create index if not exists habit_entries_user_day_idx on habit_entries(user_id, day);
create index if not exists habit_entries_habit_idx on habit_entries(habit_id);

alter table habits enable row level security;
alter table habit_entries enable row level security;

create policy "habits_select_own" on habits for select using (auth.uid() = user_id);
create policy "habits_insert_own" on habits for insert with check (auth.uid() = user_id);
create policy "habits_delete_own" on habits for delete using (auth.uid() = user_id);

create policy "habit_entries_select_own" on habit_entries for select using (auth.uid() = user_id);
create policy "habit_entries_insert_own" on habit_entries for insert with check (auth.uid() = user_id);
create policy "habit_entries_delete_own" on habit_entries for delete using (auth.uid() = user_id);
