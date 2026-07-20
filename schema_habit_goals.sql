-- Upgrades habits to support daily goals and a single running total per
-- day (instead of a list of individual log entries). Run in Supabase SQL
-- Editor. This clears the small amount of test data logged so far today
-- so the new one-row-per-day model can apply cleanly.

delete from habit_entries;

alter table habits add column if not exists goal numeric;
alter table habits add column if not exists step numeric not null default 1;

create unique index if not exists habit_entries_habit_day_idx on habit_entries(habit_id, day);
