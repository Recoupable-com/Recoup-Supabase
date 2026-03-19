-- Migrate all org API keys to personal account fb678396-a68f-4294-ae50-b8cacf9ce77b
--
-- Background: Org API keys are being deprecated in favor of personal API keys.
-- Org API keys are identified by their `account` column pointing to an organization
-- account (i.e., any account that appears as `organization_id` in
-- account_organization_ids, meaning it has members).
--
-- This migration reassigns all such keys to the personal account
-- fb678396-a68f-4294-ae50-b8cacf9ce77b so they remain usable.
--
-- Keys confirmed to be impacted at review time (2026-03-19):
--
--   id                                   | org account (account)                | name                              | created_at
--   ------------------------------------ | ------------------------------------ | --------------------------------- | -----------------------------
--   0908ff25-7b2a-401d-a82d-415355d69985 | cebcc866-34c3-451c-8cd7-f63309acff0a | org key                           | 2025-12-15 21:28:48.775769+00
--   c593136e-763b-439a-872a-27f6e5240f12 | 82bde32c-7565-4769-bad6-a8d98999cb18 | Delete                            | 2026-01-14 15:40:56.424396+00
--   26fdc0e2-e002-4897-9f0a-b8dbc4af05df | 04e3aba9-c130-4fb8-8b92-34e95d43e66b | Recoup-Tasks                      | 2026-01-14 20:10:39.387523+00
--   362c641a-1ebc-4ae8-930a-476e2dce3b90 | cebcc866-34c3-451c-8cd7-f63309acff0a | test                              | 2026-02-10 21:48:05.16776+00
--   61a28fa4-84a0-48f5-a556-624836a84f5b | cebcc866-34c3-451c-8cd7-f63309acff0a | content-pipeline                  | 2026-02-12 19:24:12.096582+00
--   e9c4714a-a8be-4631-951f-1162f76444d9 | 04e3aba9-c130-4fb8-8b92-34e95d43e66b | Recoup-API                        | 2026-02-18 01:25:59.29671+00
--   64d8708d-8a85-4188-9e4f-5db88fa2bfd0 | 82bde32c-7565-4769-bad6-a8d98999cb18 | Test                              | 2026-01-17 02:24:33.281494+00
--   eca2d416-c694-4657-b1a3-d63161f85704 | 6e544578-2220-48e9-95ac-212e06bcd407 | test                              | 2026-01-17 03:12:29.704499+00
--   b19ed833-9b8e-4d1c-8eca-f85f8efe952d | 460c4cda-a12b-479e-80da-f702fdafd264 | Igor                              | 2026-01-19 22:31:08.117126+00
--   cb64973a-320f-41db-ad87-68e3f7907137 | 04e3aba9-c130-4fb8-8b92-34e95d43e66b | Recoup-API-Test                   | 2026-02-28 16:44:23.531807+00
--   0d74c60c-ecbc-4541-b0d0-183a1f7d5fef | cebcc866-34c3-451c-8cd7-f63309acff0a | Slack_Bot_Recoup_Label_Agent      | 2026-03-13 17:18:21.182669+00
--   a5a2d7b9-4f1b-45ee-91cd-24fe7fa0c596 | cebcc866-34c3-451c-8cd7-f63309acff0a | Test_Slack_Bot_Recoup_Label_Agent | 2026-03-13 17:39:20.328877+00

UPDATE public.account_api_keys
SET account = 'fb678396-a68f-4294-ae50-b8cacf9ce77b'
WHERE account IN (
  SELECT DISTINCT organization_id
  FROM public.account_organization_ids
  WHERE organization_id IS NOT NULL
)
AND account != 'fb678396-a68f-4294-ae50-b8cacf9ce77b';
