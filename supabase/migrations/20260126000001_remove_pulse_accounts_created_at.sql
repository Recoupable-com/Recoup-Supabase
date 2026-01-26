-- Remove created_at column from pulse_accounts table

ALTER TABLE public.pulse_accounts DROP COLUMN created_at;
