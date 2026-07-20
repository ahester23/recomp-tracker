-- Fixes a bug: habit_entries was missing an UPDATE policy, so only the
-- first log each day worked (an insert); any change after that (a second
-- +/- tap, slider drag, or typed value) was silently blocked. Run in
-- Supabase SQL Editor.

create policy "habit_entries_update_own" on habit_entries for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
