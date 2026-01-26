-- Create pulse_accounts table
-- Tracks account pulse feature activation status

CREATE TABLE public.pulse_accounts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  account_id uuid NOT NULL,
  active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT pulse_accounts_pkey PRIMARY KEY (id),
  CONSTRAINT pulse_accounts_account_id_fkey FOREIGN KEY (account_id)
    REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT pulse_accounts_account_id_unique UNIQUE (account_id)
) TABLESPACE pg_default;

-- Enable Row Level Security
ALTER TABLE public.pulse_accounts ENABLE ROW LEVEL SECURITY;

-- Create index on account_id for faster lookups
CREATE INDEX IF NOT EXISTS pulse_accounts_account_id_idx
  ON public.pulse_accounts(account_id);

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.pulse_accounts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.pulse_accounts TO service_role;
