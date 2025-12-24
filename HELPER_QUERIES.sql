-- ============================================
-- HELPER QUERIES FOR NOVEL WRITER SYSTEM
-- ============================================
-- Quick reference SQL queries for common operations

-- ============================================
-- MONITORING & ANALYTICS
-- ============================================

-- View all chapters with scores
SELECT 
    c.chapter_number,
    c.title,
    c.word_count,
    c.generated_at,
    pe.overall_score,
    pe.clarity_score,
    pe.engagement_score,
    pe.pacing_score,
    pe.voice_consistency_score,
    pe.technical_quality_score,
    pv.version_number as prompt_version
FROM chapters c
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
LEFT JOIN prompt_versions pv ON pv.id = c.prompt_version_id
ORDER BY c.chapter_number;

-- Performance metrics by style profile
SELECT * FROM style_profile_performance;

-- Score trends over time
SELECT 
    chapter_number,
    overall_score,
    generated_at,
    LAG(overall_score) OVER (ORDER BY chapter_number) as previous_score,
    overall_score - LAG(overall_score) OVER (ORDER BY chapter_number) as score_change
FROM recent_chapters_with_scores
ORDER BY chapter_number;

-- Average scores by prompt version
SELECT 
    pv.version_number,
    pv.trigger_reason,
    COUNT(c.id) as chapter_count,
    AVG(pe.overall_score) as avg_overall_score,
    AVG(pe.clarity_score) as avg_clarity,
    AVG(pe.engagement_score) as avg_engagement,
    AVG(pe.pacing_score) as avg_pacing,
    pv.created_at
FROM prompt_versions pv
LEFT JOIN chapters c ON c.prompt_version_id = pv.id
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
GROUP BY pv.id, pv.version_number, pv.trigger_reason, pv.created_at
ORDER BY pv.version_number;

-- Latest chapter details
SELECT 
    c.chapter_number,
    c.title,
    c.word_count,
    c.generated_at,
    pe.overall_score,
    pe.evaluation_notes,
    pe.strengths,
    pe.weaknesses
FROM chapters c
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
ORDER BY c.generated_at DESC
LIMIT 1;

-- Passage feedback summary
SELECT 
    liked,
    COUNT(*) as feedback_count,
    COUNT(DISTINCT chapter_id) as chapters_with_feedback
FROM passage_feedback
GROUP BY liked;

-- ============================================
-- PROMPT VERSION MANAGEMENT
-- ============================================

-- View prompt evolution
SELECT 
    version_number,
    LEFT(prompt_text, 150) as prompt_preview,
    trigger_reason,
    avg_score_before,
    avg_score_after,
    is_active,
    rolled_back,
    created_at
FROM prompt_versions
WHERE style_profile_id = (SELECT id FROM style_profiles WHERE active = true LIMIT 1)
ORDER BY version_number DESC;

-- Get current active prompt (full text)
SELECT 
    sp.name as style_profile,
    pv.version_number,
    pv.prompt_text,
    pv.created_at
FROM prompt_versions pv
JOIN style_profiles sp ON sp.id = pv.style_profile_id
WHERE pv.is_active = true
  AND pv.rolled_back = false
  AND sp.active = true;

-- Check if prompt update is needed
SELECT 
    sp.name as style_profile,
    should_update_prompt(sp.id) as needs_update,
    (
        SELECT AVG(pe.overall_score)
        FROM prose_evaluations pe
        JOIN chapters c ON c.id = pe.chapter_id
        WHERE c.style_profile_id = sp.id
        ORDER BY pe.evaluated_at DESC
        LIMIT 3
    ) as recent_avg_score
FROM style_profiles sp
WHERE sp.active = true;

-- ============================================
-- CHAPTER MANAGEMENT
-- ============================================

-- Get specific chapter content
SELECT 
    chapter_number,
    title,
    content,
    word_count,
    generated_at
FROM chapters
WHERE chapter_number = 1; -- Change number as needed

-- Count chapters per style profile
SELECT 
    sp.name as style_profile,
    COUNT(c.id) as total_chapters,
    MAX(c.chapter_number) as latest_chapter,
    MIN(c.generated_at) as first_chapter_date,
    MAX(c.generated_at) as latest_chapter_date
FROM style_profiles sp
LEFT JOIN chapters c ON c.style_profile_id = sp.id
GROUP BY sp.id, sp.name;

-- Find chapters below quality threshold
SELECT 
    c.chapter_number,
    c.title,
    pe.overall_score,
    pe.evaluation_notes
FROM chapters c
JOIN prose_evaluations pe ON pe.chapter_id = c.id
WHERE pe.overall_score < 3.5
ORDER BY c.chapter_number;

-- ============================================
-- FEEDBACK MANAGEMENT
-- ============================================

-- Add liked passage feedback
-- Replace values before running
/*
INSERT INTO passage_feedback (
    chapter_id, 
    passage_text, 
    liked, 
    feedback_reason,
    tags
) VALUES (
    '[chapter-uuid]'::uuid,
    'The passage text you liked',
    true,
    'This passage has excellent pacing and vivid imagery',
    ARRAY['good-pacing', 'vivid-imagery']
);
*/

-- Add disliked passage feedback
-- Replace values before running
/*
INSERT INTO passage_feedback (
    chapter_id, 
    passage_text, 
    liked, 
    feedback_reason,
    tags
) VALUES (
    '[chapter-uuid]'::uuid,
    'The passage text you disliked',
    false,
    'This passage feels rushed and lacks detail',
    ARRAY['rushed', 'lacks-detail']
);
*/

-- View all feedback with chapter context
SELECT 
    c.chapter_number,
    c.title,
    pf.liked,
    LEFT(pf.passage_text, 100) as passage_preview,
    pf.feedback_reason,
    pf.tags,
    pf.created_at
FROM passage_feedback pf
JOIN chapters c ON c.id = pf.chapter_id
ORDER BY pf.created_at DESC;

-- Most common feedback tags
SELECT 
    unnest(tags) as tag,
    COUNT(*) as usage_count,
    SUM(CASE WHEN liked THEN 1 ELSE 0 END) as in_liked_passages,
    SUM(CASE WHEN NOT liked THEN 1 ELSE 0 END) as in_disliked_passages
FROM passage_feedback
WHERE tags IS NOT NULL
GROUP BY tag
ORDER BY usage_count DESC;

-- ============================================
-- STYLE PROFILE MANAGEMENT
-- ============================================

-- List all style profiles
SELECT 
    name,
    description,
    active,
    created_at,
    (SELECT COUNT(*) FROM chapters WHERE style_profile_id = sp.id) as chapter_count
FROM style_profiles sp
ORDER BY created_at DESC;

-- Create new style profile
-- Replace values before running
/*
INSERT INTO style_profiles (name, description, base_prompt, active) VALUES (
    'Dark Gothic Horror',
    'Gothic horror with atmospheric dread and psychological tension',
    'Write in a gothic horror style with rich atmospheric details, psychological unease, and Victorian-era sensibilities. Use archaic language sparingly. Build tension through environment and implication rather than explicit horror.',
    false  -- Set to true to activate, but deactivate others first
);

-- Create initial prompt version for new profile
INSERT INTO prompt_versions (style_profile_id, version_number, prompt_text, trigger_reason, is_active)
SELECT 
    id, 
    1, 
    base_prompt, 
    'Initial version', 
    true
FROM style_profiles 
WHERE name = 'Dark Gothic Horror';
*/

-- Switch active style profile
-- Replace profile name before running
/*
UPDATE style_profiles SET active = false; -- Deactivate all
UPDATE style_profiles SET active = true WHERE name = 'Dark Gothic Horror';
*/

-- ============================================
-- MAINTENANCE & CLEANUP
-- ============================================

-- Delete specific chapter and all related data
-- Replace chapter ID before running
/*
DELETE FROM chapters WHERE id = '[chapter-uuid]'::uuid;
-- This will CASCADE delete evaluations and feedback
*/

-- Reset system (delete all generated content, keep profiles)
/*
TRUNCATE TABLE passage_feedback CASCADE;
TRUNCATE TABLE prose_evaluations CASCADE;
TRUNCATE TABLE chapters CASCADE;
TRUNCATE TABLE learning_insights CASCADE;

-- Reset prompt versions to initial state
DELETE FROM prompt_versions WHERE version_number > 1;
UPDATE prompt_versions SET is_active = true WHERE version_number = 1;
*/

-- Full system reset (WARNING: Deletes everything including profiles)
/*
DROP TABLE IF EXISTS learning_insights CASCADE;
DROP TABLE IF EXISTS passage_feedback CASCADE;
DROP TABLE IF EXISTS prose_evaluations CASCADE;
DROP TABLE IF EXISTS chapters CASCADE;
DROP TABLE IF EXISTS prompt_versions CASCADE;
DROP TABLE IF EXISTS style_profiles CASCADE;
DROP VIEW IF EXISTS style_profile_performance;
DROP VIEW IF EXISTS recent_chapters_with_scores;
-- Then re-run DEPLOY_ALL.sql
*/

-- ============================================
-- ADVANCED QUERIES
-- ============================================

-- Identify patterns in liked vs disliked passages
SELECT 
    'Liked Passages' as feedback_type,
    AVG(LENGTH(passage_text)) as avg_length,
    AVG(array_length(regexp_split_to_array(passage_text, '\s+'), 1)) as avg_word_count,
    COUNT(*) as total_count
FROM passage_feedback
WHERE liked = true
UNION ALL
SELECT 
    'Disliked Passages' as feedback_type,
    AVG(LENGTH(passage_text)) as avg_length,
    AVG(array_length(regexp_split_to_array(passage_text, '\s+'), 1)) as avg_word_count,
    COUNT(*) as total_count
FROM passage_feedback
WHERE liked = false;

-- Correlation between criteria scores
SELECT 
    CORR(clarity_score, engagement_score) as clarity_engagement_corr,
    CORR(clarity_score, pacing_score) as clarity_pacing_corr,
    CORR(engagement_score, pacing_score) as engagement_pacing_corr,
    CORR(voice_consistency_score, technical_quality_score) as voice_technical_corr
FROM prose_evaluations;

-- Score distribution histogram
SELECT 
    ROUND(overall_score) as score_bucket,
    COUNT(*) as frequency,
    REPEAT('█', COUNT(*)::int) as histogram
FROM prose_evaluations
GROUP BY score_bucket
ORDER BY score_bucket DESC;

-- Prompt effectiveness comparison
WITH prompt_stats AS (
    SELECT 
        pv.id,
        pv.version_number,
        pv.trigger_reason,
        AVG(pe.overall_score) as avg_score,
        COUNT(c.id) as chapter_count,
        pv.created_at
    FROM prompt_versions pv
    LEFT JOIN chapters c ON c.prompt_version_id = pv.id
    LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
    GROUP BY pv.id, pv.version_number, pv.trigger_reason, pv.created_at
)
SELECT 
    version_number,
    trigger_reason,
    chapter_count,
    ROUND(avg_score::numeric, 2) as avg_score,
    ROUND((avg_score - LAG(avg_score) OVER (ORDER BY version_number))::numeric, 2) as improvement,
    created_at
FROM prompt_stats
WHERE chapter_count > 0
ORDER BY version_number;

-- Export chapter for review (with metadata)
SELECT 
    json_build_object(
        'chapter_number', c.chapter_number,
        'title', c.title,
        'word_count', c.word_count,
        'generated_at', c.generated_at,
        'content', c.content,
        'evaluation', json_build_object(
            'overall_score', pe.overall_score,
            'clarity_score', pe.clarity_score,
            'engagement_score', pe.engagement_score,
            'pacing_score', pe.pacing_score,
            'voice_consistency_score', pe.voice_consistency_score,
            'technical_quality_score', pe.technical_quality_score,
            'notes', pe.evaluation_notes,
            'strengths', pe.strengths,
            'weaknesses', pe.weaknesses
        ),
        'prompt_version', pv.version_number
    ) as chapter_json
FROM chapters c
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
LEFT JOIN prompt_versions pv ON pv.id = c.prompt_version_id
WHERE c.chapter_number = 1 -- Change as needed
LIMIT 1;

-- ============================================
-- TESTING & DEBUGGING
-- ============================================

-- Force prompt update (for testing)
-- WARNING: This makes the system always think an update is needed
/*
CREATE OR REPLACE FUNCTION should_update_prompt(p_style_profile_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN true; -- Always return true
END;
$$ LANGUAGE plpgsql;
*/

-- Restore normal prompt update logic
/*
CREATE OR REPLACE FUNCTION should_update_prompt(p_style_profile_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    recent_avg_score NUMERIC(3,2);
BEGIN
    SELECT AVG(pe.overall_score) INTO recent_avg_score
    FROM prose_evaluations pe
    JOIN chapters c ON c.id = pe.chapter_id
    WHERE c.style_profile_id = p_style_profile_id
    ORDER BY pe.evaluated_at DESC
    LIMIT 3;
    
    RETURN (recent_avg_score IS NOT NULL AND recent_avg_score < 3.5);
END;
$$ LANGUAGE plpgsql;
*/

-- Manually trigger prompt update
-- Replace values before running
/*
SELECT create_prompt_version(
    '[style-profile-uuid]'::uuid,
    'Your new improved prompt text here',
    'Manual update for testing',
    NULL
);
*/

-- Rollback to previous prompt version
-- Replace version ID before running
/*
SELECT rollback_prompt_version('[version-uuid]'::uuid);
*/

-- Verify database functions exist
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN ('get_active_prompt', 'should_update_prompt', 
                       'create_prompt_version', 'rollback_prompt_version')
ORDER BY routine_name;

-- ============================================
-- END OF HELPER QUERIES
-- ============================================

-- For more information, see README.md
