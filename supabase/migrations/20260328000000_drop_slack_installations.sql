-- Revert slack_installations table created in 20260327000000
-- Drop trigger first, then policies, index, and table

DROP TRIGGER IF EXISTS set_updated_at ON public.slack_installations;

DROP POLICY IF EXISTS "Org members can delete installations" ON public.slack_installations;
DROP POLICY IF EXISTS "Org members can update installations" ON public.slack_installations;
DROP POLICY IF EXISTS "Org members can insert installations" ON public.slack_installations;
DROP POLICY IF EXISTS "Org members can view their installations" ON public.slack_installations;

DROP INDEX IF EXISTS idx_slack_installations_organization_id;

DROP TABLE IF EXISTS public.slack_installations;
