-- Adds scheduled reminders/tasks, viewable and completable from the
-- Calendar section and shown as a banner on the Daily Tracker for the
-- day they're scheduled on.
-- Paste into your Supabase project's SQL Editor (SQL Editor -> New query
-- -> paste -> Run).

create table if not exists reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null,
  text text not null,
  completed boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists reminders_user_day_idx on reminders(user_id, day);

alter table reminders enable row level security;

create policy "reminders_select_own" on reminders for select using (auth.uid() = user_id);
create policy "reminders_insert_own" on reminders for insert with check (auth.uid() = user_id);
create policy "reminders_update_own" on reminders for update using (auth.uid() = user_id);
create policy "reminders_delete_own" on reminders for delete using (auth.uid() = user_id);
