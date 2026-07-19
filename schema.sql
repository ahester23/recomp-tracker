-- Load Log schema — paste this into your new Supabase project's
-- SQL Editor (left sidebar → SQL Editor → New query) and click Run.
-- Safe to run once on a fresh project.

create table if not exists settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  targets jsonb not null default '{"calories":1800,"protein":125,"carbs":210,"fat":50}',
  last_day_index int not null default -1,
  updated_at timestamptz not null default now()
);

create table if not exists food_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  name text not null,
  cal numeric not null default 0,
  protein numeric not null default 0,
  carbs numeric not null default 0,
  fat numeric not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists food_entries_user_day_idx on food_entries(user_id, day);

create table if not exists workout_days (
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  day_index int not null,
  primary key (user_id, day)
);

create table if not exists exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  name text not null,
  sets jsonb not null default '[]',
  created_at timestamptz not null default now()
);
create index if not exists exercises_user_day_idx on exercises(user_id, day);
create index if not exists exercises_user_name_idx on exercises(user_id, name);

alter table settings enable row level security;
alter table food_entries enable row level security;
alter table workout_days enable row level security;
alter table exercises enable row level security;

create policy "settings_select_own" on settings for select using (auth.uid() = user_id);
create policy "settings_insert_own" on settings for insert with check (auth.uid() = user_id);
create policy "settings_update_own" on settings for update using (auth.uid() = user_id);

create policy "food_entries_select_own" on food_entries for select using (auth.uid() = user_id);
create policy "food_entries_insert_own" on food_entries for insert with check (auth.uid() = user_id);
create policy "food_entries_delete_own" on food_entries for delete using (auth.uid() = user_id);

create policy "workout_days_select_own" on workout_days for select using (auth.uid() = user_id);
create policy "workout_days_insert_own" on workout_days for insert with check (auth.uid() = user_id);
create policy "workout_days_update_own" on workout_days for update using (auth.uid() = user_id);

create policy "exercises_select_own" on exercises for select using (auth.uid() = user_id);
create policy "exercises_insert_own" on exercises for insert with check (auth.uid() = user_id);
create policy "exercises_delete_own" on exercises for delete using (auth.uid() = user_id);
