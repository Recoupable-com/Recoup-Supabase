-- Migration: Enable Row Level Security for account_sandboxes table

ALTER TABLE public.account_sandboxes ENABLE ROW LEVEL SECURITY;
