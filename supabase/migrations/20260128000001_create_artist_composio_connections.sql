-- Create artist_composio_connections table
-- Maps Composio connected accounts to artists for toolkit-specific connections (e.g., TikTok)

CREATE TABLE IF NOT EXISTS "public"."artist_composio_connections" (
    "id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "artist_id" uuid NOT NULL,
    "toolkit_slug" text NOT NULL,
    "connected_account_id" text NOT NULL,
    "created_at" timestamp with time zone NOT NULL DEFAULT now(),
    "updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

-- Enable row level security
ALTER TABLE "public"."artist_composio_connections" ENABLE ROW LEVEL SECURITY;

-- Primary key
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'artist_composio_connections_pkey') THEN
        CREATE UNIQUE INDEX artist_composio_connections_pkey ON public.artist_composio_connections USING btree (id);
        ALTER TABLE "public"."artist_composio_connections" ADD CONSTRAINT "artist_composio_connections_pkey" PRIMARY KEY USING INDEX "artist_composio_connections_pkey";
    END IF;
END $$;

-- Foreign key to account_info table (artists)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'artist_composio_connections_artist_id_fkey') THEN
        ALTER TABLE "public"."artist_composio_connections" ADD CONSTRAINT "artist_composio_connections_artist_id_fkey"
            FOREIGN KEY (artist_id) REFERENCES account_info(id) ON DELETE CASCADE NOT VALID;
        ALTER TABLE "public"."artist_composio_connections" VALIDATE CONSTRAINT "artist_composio_connections_artist_id_fkey";
    END IF;
END $$;

-- Unique constraint on (artist_id, toolkit_slug) - one connection per toolkit per artist
CREATE UNIQUE INDEX IF NOT EXISTS artist_composio_connections_artist_toolkit_unique
    ON "public"."artist_composio_connections" ("artist_id", "toolkit_slug");

-- Index for faster lookups by artist_id
CREATE INDEX IF NOT EXISTS idx_artist_composio_connections_artist_id
    ON "public"."artist_composio_connections" ("artist_id");

-- Index for lookups by connected_account_id
CREATE INDEX IF NOT EXISTS idx_artist_composio_connections_connected_account_id
    ON "public"."artist_composio_connections" ("connected_account_id");

-- Updated_at trigger
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at' AND tgrelid = 'artist_composio_connections'::regclass) THEN
        CREATE TRIGGER set_updated_at
            BEFORE UPDATE ON artist_composio_connections
            FOR EACH ROW
            EXECUTE FUNCTION trigger_set_updated_at();
    END IF;
END $$;

-- RLS Policies: Service role has full access, deny others
CREATE POLICY "artist_composio_connections_service_role_policy"
    ON "public"."artist_composio_connections"
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

CREATE POLICY "artist_composio_connections_deny_anon"
    ON "public"."artist_composio_connections"
    FOR ALL
    TO anon
    USING (false);

CREATE POLICY "artist_composio_connections_deny_authenticated"
    ON "public"."artist_composio_connections"
    FOR ALL
    TO authenticated
    USING (false);

-- Grant permissions to service_role only (API access via service key)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.artist_composio_connections TO service_role;

-- Comment for documentation
COMMENT ON TABLE "public"."artist_composio_connections" IS 'Maps Composio connected accounts (e.g., TikTok) to artists. Each artist can have one connection per toolkit.';
