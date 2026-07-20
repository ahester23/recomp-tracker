-- Adds a selectable input method per habit (checkbox / stepper / slider).
-- Run in Supabase SQL Editor.

alter table habits add column if not exists method text not null default 'checkbox';
update habits set method = 'stepper' where unit is not null and method = 'checkbox';
