-- Adds ingredient-level tracking to saved meals. Paste into your Supabase
-- project's SQL Editor (SQL Editor -> New query -> paste -> Run).

create table if not exists saved_meal_ingredients (
  id uuid primary key default gen_random_uuid(),
  meal_id uuid not null references saved_foods(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  cal numeric not null default 0,
  protein numeric not null default 0,
  carbs numeric not null default 0,
  fat numeric not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists saved_meal_ingredients_meal_idx on saved_meal_ingredients(meal_id);
create index if not exists saved_meal_ingredients_user_idx on saved_meal_ingredients(user_id);

alter table saved_meal_ingredients enable row level security;

create policy "smi_select_own" on saved_meal_ingredients for select using (auth.uid() = user_id);
create policy "smi_insert_own" on saved_meal_ingredients for insert with check (auth.uid() = user_id);
create policy "smi_delete_own" on saved_meal_ingredients for delete using (auth.uid() = user_id);
