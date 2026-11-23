create table public.admin_roles (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.admin_roles enable row level security;
grant select on public.admin_roles to authenticated;
create policy own_role on public.admin_roles for select to authenticated using (user_id=auth.uid());

create function public.is_catalog_admin() returns boolean language sql stable security invoker
set search_path='' as $$ select exists(select 1 from public.admin_roles where user_id=auth.uid()) $$;
revoke all on function public.is_catalog_admin() from public;
grant execute on function public.is_catalog_admin() to authenticated;

create table public.branches (
  id text primary key, name text not null check(length(trim(name))>0),
  address text not null check(length(trim(address))>0),
  lat double precision not null check(lat between -90 and 90),
  lon double precision not null check(lon between -180 and 180),
  map text not null check(map ~ '^https://(maps\.app\.goo\.gl/|goo\.gl/maps/|www\.google\.com/maps[/?])'),
  place_id text unique, verified_at date not null, published boolean not null default false
);
create table public.dishes (
  id bigint generated always as identity primary key,
  branch_id text not null references public.branches(id) on delete cascade,
  name text not null check(length(trim(name))>0),
  price integer not null check(price>0), unit text not null,
  photo text not null default '', unique(branch_id,name)
);
alter table public.branches enable row level security;
alter table public.dishes enable row level security;
grant select on public.branches,public.dishes to anon,authenticated;
create policy visible_branch on public.branches for select using (published);
create policy visible_dish on public.dishes for select using
 (exists(select 1 from public.branches b where b.id=branch_id and b.published));
create policy admin_branch on public.branches for select to authenticated using(public.is_catalog_admin());
create policy admin_dish on public.dishes for select to authenticated using(public.is_catalog_admin());

create table public.verification_records (
 id bigint generated always as identity primary key, branch_id text not null references public.branches(id),
 editor uuid references auth.users(id) on delete set null, changed_at timestamptz not null default now(),
 evidence text not null, previous jsonb, current_record jsonb not null
);
alter table public.verification_records enable row level security;
grant select on public.verification_records to authenticated;
create policy admin_records on public.verification_records for select to authenticated using(public.is_catalog_admin());

-- All catalog edits, including the audit snapshot, succeed or roll back together.
create function public.save_branch(p_id text,p_record jsonb,p_dishes jsonb,p_evidence text)
returns void language plpgsql security definer set search_path='' as $$
declare before_edit jsonb;
begin
 if not exists(select 1 from public.admin_roles where user_id=auth.uid()) then
   raise exception 'Admin required' using errcode='42501';
 end if;
 if length(trim(coalesce(p_evidence,'')))=0 or jsonb_array_length(p_dishes)<1 then raise exception 'Missing evidence or dishes'; end if;
 perform pg_advisory_xact_lock(hashtext(p_id));
 select to_jsonb(b) || jsonb_build_object('dishes',(select jsonb_agg(to_jsonb(d)) from public.dishes d where d.branch_id=b.id))
 into before_edit from public.branches b where b.id=p_id;
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values(p_id,p_record->>'name',p_record->>'address',(p_record->>'lat')::float8,
 (p_record->>'lon')::float8,p_record->>'map',nullif(p_record->>'place_id',''),(p_record->>'verified_at')::date,(p_record->>'published')::boolean)
 on conflict(id) do update set name=excluded.name,address=excluded.address,lat=excluded.lat,lon=excluded.lon,
 map=excluded.map,place_id=excluded.place_id,verified_at=excluded.verified_at,published=excluded.published;
 delete from public.dishes where branch_id=p_id;
 insert into public.dishes(branch_id,name,price,unit,photo)
 select p_id,d.name,d.price,d.unit,coalesce(d.photo,'') from jsonb_to_recordset(p_dishes) as d(name text,price integer,unit text,photo text);
 insert into public.verification_records(branch_id,editor,evidence,previous,current_record)
 values(p_id,auth.uid(),p_evidence,before_edit,p_record || jsonb_build_object('dishes',p_dishes));
end $$;
revoke all on function public.save_branch(text,jsonb,jsonb,text) from public;
grant execute on function public.save_branch(text,jsonb,jsonb,text) to authenticated;

create table public.expenses (
 id uuid primary key, user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 shop text not null default '', dish text not null default '', amount integer not null check(amount>0),
 day date not null, category text not null check(category in ('Bữa sáng','Bữa trưa','Bữa tối','Ăn vặt','Đồ uống','Khác')),
 note text not null default '', created_at timestamptz not null default now()
);
create index expenses_period on public.expenses(user_id,day desc);
create table public.weekly_budgets (
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 week date not null check(extract(isodow from week)=1), amount integer not null check(amount>0),
 primary key(user_id,week)
);
alter table public.expenses enable row level security;
alter table public.weekly_budgets enable row level security;
grant select,insert,update,delete on public.expenses,public.weekly_budgets to authenticated;
create policy own_expenses on public.expenses for all to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy own_budgets on public.weekly_budgets for all to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());

create table public.location_reports (
 id uuid primary key default gen_random_uuid(), branch_id text not null references public.branches(id),
 user_id uuid default auth.uid() references auth.users(id) on delete set null,
 note text not null check(length(trim(note)) between 1 and 500), resolved boolean not null default false
);
alter table public.location_reports enable row level security;
grant insert(branch_id,note),select,update(resolved) on public.location_reports to authenticated;
create policy submit_report on public.location_reports for insert to authenticated with check(user_id=auth.uid() and not resolved and exists(select 1 from public.branches b where b.id=branch_id and b.published));
create policy view_reports on public.location_reports for select to authenticated using(public.is_catalog_admin());
create policy resolve_report on public.location_reports for update to authenticated using(public.is_catalog_admin()) with check(public.is_catalog_admin());

-- Scope grants explicitly even on projects with permissive default table privileges.
revoke insert,update,delete,truncate,references,trigger on public.admin_roles,public.branches,public.dishes,public.verification_records from public,anon,authenticated;
revoke truncate,references,trigger on public.expenses,public.weekly_budgets from public,anon,authenticated;
revoke insert,update,delete,truncate,references,trigger on public.location_reports from public,anon,authenticated;
grant insert(branch_id,note),update(resolved) on public.location_reports to authenticated;
