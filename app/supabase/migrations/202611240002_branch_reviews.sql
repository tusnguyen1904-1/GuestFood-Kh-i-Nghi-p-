create table public.branch_reviews (
  branch_id text not null references public.branches(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  stars smallint not null check (stars between 1 and 5),
  body text not null check (char_length(body) <= 1000),
  updated_at timestamptz not null default now(),
  primary key (branch_id, user_id)
);
alter table public.branch_reviews enable row level security;
revoke all on public.branch_reviews from public, anon, authenticated;
create index branch_reviews_recent on public.branch_reviews(branch_id, updated_at desc, user_id);

-- Only this narrow public projection is readable. Account identifiers stay private.
create function public.read_branch_reviews(p_branch text, p_page integer default 0)
returns jsonb language sql stable security definer set search_path = '' as $$
  with visible as (
    select r.* from public.branch_reviews r
    join public.branches b on b.id = r.branch_id
    where r.branch_id = p_branch and b.published
  ), page as (
    select stars, body, updated_at from visible order by updated_at desc, user_id
    limit 10 offset (greatest(0,p_page)::bigint * 10)
  )
  select jsonb_build_object(
    'total', count(*), 'average', round(avg(stars),1),
    'items', (select coalesce(jsonb_agg(to_jsonb(page) order by updated_at desc),'[]'::jsonb) from page),
    'mine', (select jsonb_build_object('stars',stars,'body',body) from visible where user_id = auth.uid())
  ) from visible;
$$;

create function public.save_branch_review(p_branch text, p_stars integer, p_body text)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null or not exists(select 1 from public.branches where id=p_branch and published) then
    raise exception 'Review unavailable' using errcode='42501';
  end if;
  insert into public.branch_reviews(branch_id,user_id,stars,body)
  values(p_branch,auth.uid(),p_stars,trim(coalesce(p_body,'')))
  on conflict(branch_id,user_id) do update
    set stars=excluded.stars, body=excluded.body, updated_at=now();
end;
$$;
revoke all on function public.read_branch_reviews(text,integer), public.save_branch_review(text,integer,text) from public, anon, authenticated;
grant execute on function public.read_branch_reviews(text,integer) to anon,authenticated;
grant execute on function public.save_branch_review(text,integer,text) to authenticated;
notify pgrst,'reload schema';
