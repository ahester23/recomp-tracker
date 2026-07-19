-- Adds body measurement tracking (smart scale data). Paste into your
-- Supabase project's SQL Editor (SQL Editor -> New query -> paste -> Run).

create table if not exists body_stats (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  weight numeric,
  body_fat_pct numeric,
  bmi numeric,
  muscle_mass numeric,
  created_at timestamptz not null default now(),
  unique(user_id, day)
);
create index if not exists body_stats_user_day_idx on body_stats(user_id, day);

alter table body_stats enable row level security;

create policy "body_stats_select_own" on body_stats for select using (auth.uid() = user_id);
create policy "body_stats_insert_own" on body_stats for insert with check (auth.uid() = user_id);
create policy "body_stats_update_own" on body_stats for update using (auth.uid() = user_id);
create policy "body_stats_delete_own" on body_stats for delete using (auth.uid() = user_id);
