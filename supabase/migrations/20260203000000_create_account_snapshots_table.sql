CREATE TABLE account_snapshots (
  account_id UUID PRIMARY KEY REFERENCES accounts(id),
  snapshot_id TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL
);
