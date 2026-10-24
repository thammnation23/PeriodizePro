-- Migration 017: Pre/Post training entries on sessions
-- Run in Supabase → SQL Editor → New Query → paste → Run

alter table sessions
  add column if not exists pre_post jsonb default '[]'::jsonb;

update sessions set pre_post = '[]'::jsonb where pre_post is null;
