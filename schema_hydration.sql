-- Adds water/caffeine logging. Paste into your Supabase project's SQL
-- Editor (SQL Editor -> New query -> paste -> Run).

create table if not exists hydration_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  type text not null check (type in ('water','caffeine')),
  amount numeric not null,
  created_at timestamptz not null default now()
);
create index if not exists hydration_entries_user_day_idx on hydration_entries(user_id, day);

alter table hydration_entries enable row level security;

create policy "hydration_select_own" on hydration_entries for select using (auth.uid() = user_id);
create policy "hydration_insert_own" on hydration_entries for insert with check (auth.uid() = user_id);
create policy "hydration_delete_own" on hydration_entries for delete using (auth.uid() = user_id);
