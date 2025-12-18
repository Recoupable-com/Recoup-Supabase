-- Create memory_emails table
-- Stores the relationship between emails and memories

CREATE TABLE public.memory_emails (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  email_id uuid NOT NULL,
  memory uuid NOT NULL,
  message_id text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT memory_emails_pkey PRIMARY KEY (id),
  CONSTRAINT memory_emails_email_id_unique UNIQUE (email_id),
  CONSTRAINT memory_emails_message_id_unique UNIQUE (message_id),
  CONSTRAINT memory_emails_memory_fkey FOREIGN KEY (memory) 
    REFERENCES memories(id) ON UPDATE CASCADE ON DELETE CASCADE
) TABLESPACE pg_default;

-- Enable Row Level Security
ALTER TABLE public.memory_emails ENABLE ROW LEVEL SECURITY;

-- Create index on memory for faster lookups
CREATE INDEX IF NOT EXISTS memory_emails_memory_idx 
  ON public.memory_emails(memory);

-- Create index on email_id for faster lookups
CREATE INDEX IF NOT EXISTS memory_emails_email_id_idx 
  ON public.memory_emails(email_id);

-- Create index on message_id for faster lookups
CREATE INDEX IF NOT EXISTS memory_emails_message_id_idx 
  ON public.memory_emails(message_id);

-- Create index on created_at for sorting
CREATE INDEX IF NOT EXISTS memory_emails_created_at_idx 
  ON public.memory_emails(created_at);
