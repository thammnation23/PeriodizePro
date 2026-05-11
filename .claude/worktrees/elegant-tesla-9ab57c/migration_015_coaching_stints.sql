-- Migration 015: Coaching career stints
-- Run in Supabase → SQL Editor → New Query → paste → Run

create table if not exists coaching_stints (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users(id) on delete cascade,
  club_name     text not null,
  start_date    date,
  end_date      date,
  period_label  text,
  wins          integer default 0,
  draws         integer default 0,
  losses        integer default 0,
  notes         text,
  sort_order    integer default 0,
  created_at    timestamptz default now()
);

create index if not exists coaching_stints_user_idx  on coaching_stints(user_id);
create index if not exists coaching_stints_start_idx on coaching_stints(start_date);

alter table coaching_stints enable row level security;

drop policy if exists "coaching_stints_select" on coaching_stints;
create policy "coaching_stints_select" on coaching_stints for select using (auth.uid() = user_id);
drop policy if exists "coaching_stints_insert" on coaching_stints;
create policy "coaching_stints_insert" on coaching_stints for insert with check (auth.uid() = user_id);
drop policy if exists "coaching_stints_update" on coaching_stints;
create policy "coaching_stints_update" on coaching_stints for update using (auth.uid() = user_id);
drop policy if exists "coaching_stints_delete" on coaching_stints;
create policy "coaching_stints_delete" on coaching_stints for delete using (auth.uid() = user_id);
