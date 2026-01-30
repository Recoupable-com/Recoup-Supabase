-- Create account_sandboxes table to track sandboxes per account
CREATE TABLE IF NOT EXISTS account_sandboxes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    sandbox_id TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(account_id, sandbox_id)
);

-- Create index on account_id for faster lookups
CREATE INDEX IF NOT EXISTS account_sandboxes_account_id_idx ON account_sandboxes(account_id);

-- Create index on sandbox_id for faster lookups
CREATE INDEX IF NOT EXISTS account_sandboxes_sandbox_id_idx ON account_sandboxes(sandbox_id);
