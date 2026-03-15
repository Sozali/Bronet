-- =============================================================
-- BRONET CRM — Supabase Schema
-- Run this entire file in: Supabase Dashboard → SQL Editor → New Query
-- =============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── PROFILES (consumer users) ───────────────────────────────
create table public.profiles (
  id              uuid references auth.users on delete cascade primary key,
  full_name       text,
  phone           text,
  avatar_url      text,
  loyalty_points  integer default 0,
  subscription_tier text default 'free'
    check (subscription_tier in ('free', 'gold', 'platinum')),
  created_at      timestamptz default now()
);

-- ─── BUSINESSES ──────────────────────────────────────────────
create table public.businesses (
  id                uuid default uuid_generate_v4() primary key,
  owner_id          uuid references auth.users on delete cascade not null,
  name              text not null,
  description       text,
  category          text,
  address           text,
  phone             text,
  avatar_url        text,
  is_active         boolean default true,
  rating            numeric(3,2) default 0,
  review_count      integer default 0,
  subscription_tier text default 'free'
    check (subscription_tier in ('free', 'gold', 'platinum')),
  created_at        timestamptz default now()
);

-- ─── SERVICES ────────────────────────────────────────────────
create table public.services (
  id               uuid default uuid_generate_v4() primary key,
  business_id      uuid references public.businesses on delete cascade not null,
  name             text not null,
  description      text,
  price            numeric(10,2) not null,
  duration_minutes integer not null,
  category         text,
  is_active        boolean default true,
  created_at       timestamptz default now()
);

-- ─── BOOKINGS ────────────────────────────────────────────────
create table public.bookings (
  id            uuid default uuid_generate_v4() primary key,
  consumer_id   uuid references auth.users on delete set null,
  business_id   uuid references public.businesses on delete cascade not null,
  service_id    uuid references public.services on delete set null,
  status        text default 'pending'
    check (status in ('pending','confirmed','declined','completed','cancelled','rescheduled')),
  booking_date  date not null,
  booking_time  time not null,
  notes         text,
  price         numeric(10,2),
  points_earned integer default 0,
  created_at    timestamptz default now()
);

-- ─── DEALS ───────────────────────────────────────────────────
create table public.deals (
  id              uuid default uuid_generate_v4() primary key,
  business_id     uuid references public.businesses on delete cascade,
  service_id      uuid references public.services on delete set null,
  name            text not null,
  description     text,
  original_price  numeric(10,2),
  deal_price      numeric(10,2),
  tag             text check (tag in ('FLAŞ','HƏFTƏLIK','YENİ İSTİFADƏÇİ','XÜSUSI')),
  slots_total     integer,
  slots_remaining integer,
  expires_at      timestamptz,
  is_active       boolean default true,
  points_cost     integer,
  points_earn     integer default 0,
  created_at      timestamptz default now()
);

-- ─── REVIEWS ─────────────────────────────────────────────────
create table public.reviews (
  id          uuid default uuid_generate_v4() primary key,
  booking_id  uuid references public.bookings on delete set null,
  consumer_id uuid references auth.users on delete set null,
  business_id uuid references public.businesses on delete cascade not null,
  rating      integer check (rating between 1 and 5) not null,
  comment     text,
  created_at  timestamptz default now()
);

-- ─── BUSINESS HOURS ──────────────────────────────────────────
create table public.business_hours (
  id          uuid default uuid_generate_v4() primary key,
  business_id uuid references public.businesses on delete cascade not null,
  day_of_week integer check (day_of_week between 0 and 6) not null,
  open_time   time,
  close_time  time,
  is_closed   boolean default false,
  unique(business_id, day_of_week)
);

-- ─── NOTIFICATIONS ───────────────────────────────────────────
create table public.notifications (
  id         uuid default uuid_generate_v4() primary key,
  user_id    uuid references auth.users on delete cascade not null,
  title      text not null,
  body       text,
  is_read    boolean default false,
  type       text,
  related_id uuid,
  created_at timestamptz default now()
);

-- =============================================================
-- ROW LEVEL SECURITY
-- =============================================================
alter table public.profiles       enable row level security;
alter table public.businesses     enable row level security;
alter table public.services       enable row level security;
alter table public.bookings       enable row level security;
alter table public.deals          enable row level security;
alter table public.reviews        enable row level security;
alter table public.business_hours enable row level security;
alter table public.notifications  enable row level security;

-- Profiles
create policy "Own profile full access"
  on public.profiles for all using (auth.uid() = id);

-- Businesses
create policy "Public read active businesses"
  on public.businesses for select using (is_active = true);
create policy "Owners full access to own business"
  on public.businesses for all using (auth.uid() = owner_id);

-- Services
create policy "Public read active services"
  on public.services for select using (is_active = true);
create policy "Owners manage services"
  on public.services for all using (
    exists (select 1 from public.businesses where id = business_id and owner_id = auth.uid())
  );

-- Bookings
create policy "Consumers see own bookings"
  on public.bookings for select using (auth.uid() = consumer_id);
create policy "Business sees their bookings"
  on public.bookings for select using (
    exists (select 1 from public.businesses where id = business_id and owner_id = auth.uid())
  );
create policy "Consumers create bookings"
  on public.bookings for insert with check (auth.uid() = consumer_id);
create policy "Consumers update own bookings"
  on public.bookings for update using (auth.uid() = consumer_id);
create policy "Business updates booking status"
  on public.bookings for update using (
    exists (select 1 from public.businesses where id = business_id and owner_id = auth.uid())
  );

-- Deals
create policy "Public read active deals"
  on public.deals for select using (is_active = true);
create policy "Owners manage deals"
  on public.deals for all using (
    exists (select 1 from public.businesses where id = business_id and owner_id = auth.uid())
  );

-- Reviews
create policy "Public read reviews"
  on public.reviews for select using (true);
create policy "Consumers write reviews"
  on public.reviews for insert with check (auth.uid() = consumer_id);

-- Business hours
create policy "Public read hours"
  on public.business_hours for select using (true);
create policy "Owners manage hours"
  on public.business_hours for all using (
    exists (select 1 from public.businesses where id = business_id and owner_id = auth.uid())
  );

-- Notifications
create policy "Own notifications"
  on public.notifications for all using (auth.uid() = user_id);

-- =============================================================
-- FUNCTIONS & TRIGGERS
-- =============================================================

-- Auto-create profile row when user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce(new.raw_user_meta_data->>'phone', '')
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Auto-update business rating after a new review
create or replace function public.update_business_rating()
returns trigger as $$
begin
  update public.businesses set
    rating       = (select avg(rating)   from public.reviews where business_id = new.business_id),
    review_count = (select count(*)      from public.reviews where business_id = new.business_id)
  where id = new.business_id;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_review_created
  after insert on public.reviews
  for each row execute procedure public.update_business_rating();
