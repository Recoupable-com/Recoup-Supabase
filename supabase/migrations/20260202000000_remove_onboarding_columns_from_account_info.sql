-- Remove unused onboarding columns from account_info table
-- These columns were not created correctly and are being cleaned up

ALTER TABLE "public"."account_info"
DROP COLUMN IF EXISTS "onboarding_data",
DROP COLUMN IF EXISTS "onboarding_status";
