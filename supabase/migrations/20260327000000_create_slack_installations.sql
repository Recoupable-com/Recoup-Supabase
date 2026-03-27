-- Create slack_installations table for Slack Marketplace distribution
create table if not exists public.slack_installations (
  id uuid primary key default gen_random_uuid(),
  slack_team_id text unique not null,
  slack_team_name text not null,
  organization_id uuid not null references public.accounts(id) on delete cascade,
  bot_token text not null,
  installed_by uuid not null references public.accounts(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Index for organization lookups
create index if not exists idx_slack_installations_organization_id
  on public.slack_installations(organization_id);

-- Enable RLS
alter table public.slack_installations enable row level security;

-- RLS policy: org admins can read their own org's installations
create policy "Org members can view their installations"
  on public.slack_installations
  for select
  using (
    organization_id in (
      select organization_id from public.account_organization_ids
      where account_id = auth.uid()
    )
  );

-- RLS policy: org admins can insert installations for their org
create policy "Org members can insert installations"
  on public.slack_installations
  for insert
  with check (
    organization_id in (
      select organization_id from public.account_organization_ids
      where account_id = auth.uid()
    )
  );

-- RLS policy: org admins can update their org's installations
create policy "Org members can update installations"
  on public.slack_installations
  for update
  using (
    organization_id in (
      select organization_id from public.account_organization_ids
      where account_id = auth.uid()
    )
  );

-- RLS policy: org admins can delete their org's installations
create policy "Org members can delete installations"
  on public.slack_installations
  for delete
  using (
    organization_id in (
      select organization_id from public.account_organization_ids
      where account_id = auth.uid()
    )
  );

-- Auto-update updated_at using existing trigger function
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.slack_installations
  FOR EACH ROW
  EXECUTE FUNCTION trigger_set_updated_at();
