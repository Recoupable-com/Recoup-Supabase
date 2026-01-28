-- Seed onboarding task templates into agent_templates table
-- These are system templates (creator = NULL) available to all users (is_private = false)
-- Tags include 'onboarding' for filtering and 'role:*' for role-specific filtering
-- Prompts contain {artistName} and {userEmail} placeholders for interpolation

INSERT INTO agent_templates (title, description, prompt, tags, creator, is_private, created_at) VALUES

-- Competitive Analysis - Good for managers, labels, marketing
('Competitive Analysis Report',
 'Analyze your top 3 competitors and get actionable insights delivered to your email.',
 'Research the top 3 competitor artists for {artistName} across Spotify, Instagram, and Twitter. Analyze their recent releases, content strategy, engagement rates, and what''s working for them. Identify opportunities where {artistName} can differentiate or improve.

Create a detailed report with:
1. Competitor overview (followers, engagement, recent releases)
2. Content strategies that are working for them
3. Gaps and opportunities for {artistName}
4. 3 actionable recommendations

After completing the analysis, use the send_email tool to email the full report to {userEmail} with the subject "Competitive Analysis Report for {artistName}".',
 ARRAY['onboarding', 'role:manager', 'role:label', 'role:marketing'], NULL, false, now()),

-- Content Trends - Good for artists, marketing, PR
('Content Trends Analysis',
 'Discover trending content formats and topics in your genre with recommendations sent to your email.',
 'Analyze current content trends for artists similar to {artistName}. Research what''s trending on TikTok, Instagram Reels, and YouTube Shorts in their genre.

Look at:
1. Viral content formats (challenges, behind-the-scenes, fan interactions)
2. Trending audio and hashtags
3. Posting times and frequency patterns
4. Engagement tactics that are working

Create a report with:
1. Top 5 trending content formats with examples
2. Recommended content ideas specifically for {artistName}
3. Best posting schedule based on audience activity
4. Quick-win content that can be created this week

After completing the analysis, use the send_email tool to email the full report to {userEmail} with the subject "Content Trends Report for {artistName}".',
 ARRAY['onboarding', 'role:artist', 'role:marketing', 'role:pr'], NULL, false, now()),

-- Press & Playlist Opportunities - Good for PR, managers, labels
('Press & Playlist Opportunities',
 'Find press contacts and playlist curators who cover artists like you, delivered to your email.',
 'Research press and playlist opportunities for {artistName}. Find journalists, bloggers, and playlist curators who have recently covered similar artists in the genre.

Identify:
1. Music blogs and publications that cover this genre
2. Journalists who have written about similar artists
3. Spotify and Apple Music playlists that feature comparable artists
4. Podcast hosts who interview musicians in this space

Create a report with:
1. Top 10 press contacts with recent relevant articles
2. Top 10 playlist curators with submission info where available
3. 5 podcast opportunities
4. Outreach tips for each category

After completing the research, use the send_email tool to email the full report to {userEmail} with the subject "Press & Playlist Opportunities for {artistName}".',
 ARRAY['onboarding', 'role:pr', 'role:manager', 'role:label'], NULL, false, now())

ON CONFLICT (title) DO NOTHING;
