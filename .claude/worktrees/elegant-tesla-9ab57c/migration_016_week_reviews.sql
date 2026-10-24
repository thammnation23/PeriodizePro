-- Migration 016: Weekly Reflection + Competition Table awards
-- Run in Supabase → SQL Editor → New Query → paste → Run

create table if not exists week_reviews (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references auth.users(id) on delete cascade,
  week_num        integer not null,
  season          text default '2025-26',
  training_recap  text,
  game_recap      text,
  scoring         text,
  players_context text,
  focuses         text,
  notes           text,
  awards          jsonb default '{}'::jsonb,
  created_at      timestamptz default now(),
  updated_at      timestamptz default now(),
  unique(user_id, week_num, season)
);

create index if not exists week_reviews_user_idx on week_reviews(user_id);
create index if not exists week_reviews_week_idx on week_reviews(week_num);

alter table week_reviews enable row level security;

drop policy if exists "week_reviews_select" on week_reviews;
create policy "week_reviews_select" on week_reviews for select using (auth.uid() = user_id);
drop policy if exists "week_reviews_insert" on week_reviews;
create policy "week_reviews_insert" on week_reviews for insert with check (auth.uid() = user_id);
drop policy if exists "week_reviews_update" on week_reviews;
create policy "week_reviews_update" on week_reviews for update using (auth.uid() = user_id);
drop policy if exists "week_reviews_delete" on week_reviews;
create policy "week_reviews_delete" on week_reviews for delete using (auth.uid() = user_id);
