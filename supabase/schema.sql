-- The Boys Golf App - Supabase schema starter
create extension if not exists "uuid-ossp";

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null unique,
  phone text,
  role text not null default 'player' check (role in ('player','admin','commissioner')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.seasons (
  id uuid primary key default uuid_generate_v4(),
  year int not null unique,
  start_date date not null,
  end_date date not null,
  archived boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.golf_rounds (
  id uuid primary key default uuid_generate_v4(),
  season_id uuid not null references public.seasons(id) on delete cascade,
  play_date date not null,
  label text,
  status text not null default 'signup_open' check (status in ('signup_open','locked','rack_open','pairings_ready','published','completed','archived')),
  signup_deadline timestamptz not null,
  created_at timestamptz not null default now(),
  unique(season_id, play_date)
);

create table public.signups (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  player_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'no_response' check (status in ('playing','out','no_response')),
  updated_at timestamptz not null default now(),
  unique(round_id, player_id)
);

create table public.rack_times (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  player_id uuid not null references public.profiles(id) on delete cascade,
  tee_time time,
  side text check (side in ('front','back')),
  shutout boolean not null default false,
  used boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.tee_times (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  tee_time time not null,
  side text not null check (side in ('front','back')),
  source_rack_time_id uuid references public.rack_times(id) on delete set null,
  sort_order int not null default 0
);

create table public.guests (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  host_player_id uuid references public.profiles(id) on delete set null,
  guest_name text not null,
  created_at timestamptz not null default now()
);

create table public.pairing_rules (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  rule_type text not null check (rule_type in ('keep_together','keep_apart')),
  player_a uuid not null references public.profiles(id) on delete cascade,
  player_b uuid not null references public.profiles(id) on delete cascade
);

create table public.pairing_groups (
  id uuid primary key default uuid_generate_v4(),
  round_id uuid not null references public.golf_rounds(id) on delete cascade,
  tee_time_id uuid not null references public.tee_times(id) on delete cascade,
  group_number int not null
);

create table public.pairing_group_members (
  id uuid primary key default uuid_generate_v4(),
  group_id uuid not null references public.pairing_groups(id) on delete cascade,
  player_id uuid references public.profiles(id) on delete cascade,
  guest_id uuid references public.guests(id) on delete cascade,
  check ((player_id is not null and guest_id is null) or (player_id is null and guest_id is not null))
);

create table public.activity_log (
  id uuid primary key default uuid_generate_v4(),
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  details jsonb not null default '{}',
  created_at timestamptz not null default now()
);

create table public.app_settings (
  id int primary key default 1,
  league_name text not null default 'The Boys',
  app_subtitle text not null default 'Golf App',
  course_name text not null default 'Tashua Knolls Golf Course',
  footer_slogan text not null default 'From the first tee to the final tab at The Nest!',
  signup_deadline_day int not null default 4,
  signup_deadline_time time not null default '20:00',
  max_players_per_group int not null default 4,
  tee_time_interval_minutes int not null default 8,
  updated_at timestamptz not null default now(),
  constraint single_settings_row check (id = 1)
);

insert into public.app_settings (id) values (1) on conflict (id) do nothing;

alter table public.profiles enable row level security;
alter table public.seasons enable row level security;
alter table public.golf_rounds enable row level security;
alter table public.signups enable row level security;
alter table public.rack_times enable row level security;
alter table public.tee_times enable row level security;
alter table public.guests enable row level security;
alter table public.pairing_rules enable row level security;
alter table public.pairing_groups enable row level security;
alter table public.pairing_group_members enable row level security;
alter table public.activity_log enable row level security;
alter table public.app_settings enable row level security;

-- RLS policies will be tightened during implementation. Starter policies allow authenticated users to read key league data.
create policy "authenticated read profiles" on public.profiles for select to authenticated using (true);
create policy "authenticated read seasons" on public.seasons for select to authenticated using (true);
create policy "authenticated read rounds" on public.golf_rounds for select to authenticated using (true);
create policy "authenticated read settings" on public.app_settings for select to authenticated using (true);
