-- Adds a reminder/task type and an optional time-of-day to reminders,
-- so items can be shown chronologically on the Daily Tracker banner
-- (items with no time sort last).
-- Paste into your Supabase project's SQL Editor (SQL Editor -> New query
-- -> paste -> Run).

alter table reminders add column if not exists kind text not null default 'reminder' check (kind in ('reminder','task'));
alter table reminders add column if not exists time_of_day time;
