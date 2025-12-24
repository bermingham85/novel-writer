-- Novel Writer Database Schema
-- Self-learning prose evaluation and chapter generation system

-- ============================================
-- Style Profiles Table
-- ============================================
CREATE TABLE IF NOT EXISTS style_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    base_prompt TEXT NOT NULL,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Chapters Table
-- ============================================
CREATE TABLE IF NOT EXISTS chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    style_profile_id UUID REFERENCES style_profiles(id) ON DELETE CASCADE,
    chapter_number INTEGER NOT NULL,
    title TEXT,
    content TEXT NOT NULL,
    word_count INTEGER,
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    prompt_version_id UUID,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- ============================================
-- Prose Evaluations Table
-- ============================================
CREATE TABLE IF NOT EXISTS prose_evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chapter_id UUID REFERENCES chapters(id) ON DELETE CASCADE,
    
    -- 5 evaluation criteria (1-5 scale)
    clarity_score NUMERIC(3,2) CHECK (clarity_score >= 1 AND clarity_score <= 5),
    engagement_score NUMERIC(3,2) CHECK (engagement_score >= 1 AND engagement_score <= 5),
    pacing_score NUMERIC(3,2) CHECK (pacing_score >= 1 AND pacing_score <= 5),
    voice_consistency_score NUMERIC(3,2) CHECK (voice_consistency_score >= 1 AND voice_consistency_score <= 5),
    technical_quality_score NUMERIC(3,2) CHECK (technical_quality_score >= 1 AND technical_quality_score <= 5),
    
    -- Overall average
    overall_score NUMERIC(3,2) GENERATED ALWAYS AS (
        (clarity_score + engagement_score + pacing_score + voice_consistency_score + technical_quality_score) / 5
    ) STORED,
    
    -- Evaluation details
    evaluation_notes TEXT,
    evaluated_at TIMESTAMPTZ DEFAULT NOW(),
    evaluator TEXT DEFAULT 'auto',
    
    -- Detailed feedback for learning
    strengths TEXT[],
    weaknesses TEXT[]
);

-- ============================================
-- Passage Feedback Table (User Likes/Dislikes)
-- ============================================
CREATE TABLE IF NOT EXISTS passage_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chapter_id UUID REFERENCES chapters(id) ON DELETE CASCADE,
    passage_text TEXT NOT NULL,
    passage_start_pos INTEGER,
    passage_end_pos INTEGER,
    
    -- User feedback
    liked BOOLEAN NOT NULL,
    feedback_reason TEXT,
    tags TEXT[],
    
    -- Context for learning
    context_before TEXT,
    context_after TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Prompt Versions Table (Version Control)
-- ============================================
CREATE TABLE IF NOT EXISTS prompt_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    style_profile_id UUID REFERENCES style_profiles(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    prompt_text TEXT NOT NULL,
    
    -- What triggered this version
    trigger_reason TEXT,
    triggered_by_evaluation_id UUID REFERENCES prose_evaluations(id),
    
    -- Performance tracking
    avg_score_before NUMERIC(3,2),
    avg_score_after NUMERIC(3,2),
    
    -- Rollback capability
    is_active BOOLEAN DEFAULT true,
    rolled_back BOOLEAN DEFAULT false,
    parent_version_id UUID REFERENCES prompt_versions(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(style_profile_id, version_number)
);

-- ============================================
-- Learning Insights Table
-- ============================================
CREATE TABLE IF NOT EXISTS learning_insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    style_profile_id UUID REFERENCES style_profiles(id) ON DELETE CASCADE,
    
    -- What was learned
    insight_type TEXT NOT NULL, -- 'liked_pattern', 'disliked_pattern', 'improvement', etc.
    insight_text TEXT NOT NULL,
    confidence_score NUMERIC(3,2),
    
    -- Supporting data
    based_on_feedback_ids UUID[],
    based_on_evaluation_ids UUID[],
    
    -- Application tracking
    applied_in_prompt_version_id UUID REFERENCES prompt_versions(id),
    effectiveness_rating NUMERIC(3,2),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Indexes for Performance
-- ============================================
CREATE INDEX idx_chapters_style_profile ON chapters(style_profile_id);
CREATE INDEX idx_chapters_prompt_version ON chapters(prompt_version_id);
CREATE INDEX idx_evaluations_chapter ON prose_evaluations(chapter_id);
CREATE INDEX idx_evaluations_score ON prose_evaluations(overall_score);
CREATE INDEX idx_feedback_chapter ON passage_feedback(chapter_id);
CREATE INDEX idx_feedback_liked ON passage_feedback(liked);
CREATE INDEX idx_prompt_versions_active ON prompt_versions(style_profile_id, is_active);
CREATE INDEX idx_learning_insights_profile ON learning_insights(style_profile_id);

-- ============================================
-- Functions for Auto-Update Logic
-- ============================================

-- Function to get current active prompt for a style profile
CREATE OR REPLACE FUNCTION get_active_prompt(p_style_profile_id UUID)
RETURNS TEXT AS $$
    SELECT prompt_text 
    FROM prompt_versions 
    WHERE style_profile_id = p_style_profile_id 
      AND is_active = true 
      AND rolled_back = false
    ORDER BY version_number DESC 
    LIMIT 1;
$$ LANGUAGE sql;

-- Function to check if prompt update is needed
CREATE OR REPLACE FUNCTION should_update_prompt(p_style_profile_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    recent_avg_score NUMERIC(3,2);
BEGIN
    -- Get average score of last 3 chapters
    SELECT AVG(pe.overall_score) INTO recent_avg_score
    FROM prose_evaluations pe
    JOIN chapters c ON c.id = pe.chapter_id
    WHERE c.style_profile_id = p_style_profile_id
    ORDER BY pe.evaluated_at DESC
    LIMIT 3;
    
    -- Return true if average score < 3.5
    RETURN (recent_avg_score IS NOT NULL AND recent_avg_score < 3.5);
END;
$$ LANGUAGE plpgsql;

-- Function to create new prompt version
CREATE OR REPLACE FUNCTION create_prompt_version(
    p_style_profile_id UUID,
    p_new_prompt TEXT,
    p_trigger_reason TEXT,
    p_triggered_by_eval_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_new_version_number INTEGER;
    v_current_version_id UUID;
    v_avg_score_before NUMERIC(3,2);
    v_new_version_id UUID;
BEGIN
    -- Get current version
    SELECT id, version_number INTO v_current_version_id, v_new_version_number
    FROM prompt_versions
    WHERE style_profile_id = p_style_profile_id
      AND is_active = true
    ORDER BY version_number DESC
    LIMIT 1;
    
    -- Calculate average score before update
    SELECT AVG(pe.overall_score) INTO v_avg_score_before
    FROM prose_evaluations pe
    JOIN chapters c ON c.id = pe.chapter_id
    WHERE c.style_profile_id = p_style_profile_id
      AND c.prompt_version_id = v_current_version_id;
    
    -- Deactivate current version
    UPDATE prompt_versions 
    SET is_active = false 
    WHERE id = v_current_version_id;
    
    -- Create new version
    INSERT INTO prompt_versions (
        style_profile_id,
        version_number,
        prompt_text,
        trigger_reason,
        triggered_by_evaluation_id,
        avg_score_before,
        parent_version_id,
        is_active
    ) VALUES (
        p_style_profile_id,
        COALESCE(v_new_version_number, 0) + 1,
        p_new_prompt,
        p_trigger_reason,
        p_triggered_by_eval_id,
        v_avg_score_before,
        v_current_version_id,
        true
    ) RETURNING id INTO v_new_version_id;
    
    RETURN v_new_version_id;
END;
$$ LANGUAGE plpgsql;

-- Function to rollback to previous prompt version
CREATE OR REPLACE FUNCTION rollback_prompt_version(p_version_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_parent_version_id UUID;
    v_style_profile_id UUID;
BEGIN
    -- Get parent version
    SELECT parent_version_id, style_profile_id INTO v_parent_version_id, v_style_profile_id
    FROM prompt_versions
    WHERE id = p_version_id;
    
    IF v_parent_version_id IS NULL THEN
        RETURN false; -- No parent to rollback to
    END IF;
    
    -- Mark current version as rolled back
    UPDATE prompt_versions SET is_active = false, rolled_back = true WHERE id = p_version_id;
    
    -- Reactivate parent version
    UPDATE prompt_versions SET is_active = true WHERE id = v_parent_version_id;
    
    RETURN true;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Trigger to Auto-Update Timestamps
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER style_profiles_updated_at
    BEFORE UPDATE ON style_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- ============================================
-- Initial Sample Data
-- ============================================
INSERT INTO style_profiles (name, description, base_prompt) VALUES
(
    'Default Literary Fiction',
    'Balanced literary fiction with focus on character development and atmospheric prose',
    'Write in a literary fiction style with rich character interiority, vivid sensory details, and measured pacing. Focus on showing rather than telling. Use varied sentence structures and sophisticated vocabulary without being pretentious. Maintain consistent third-person limited POV.'
);

-- Create initial prompt version
INSERT INTO prompt_versions (style_profile_id, version_number, prompt_text, trigger_reason, is_active)
SELECT 
    id,
    1,
    base_prompt,
    'Initial version',
    true
FROM style_profiles
WHERE name = 'Default Literary Fiction';

-- ============================================
-- Views for Easy Querying
-- ============================================

-- View: Latest performance metrics per style profile
CREATE OR REPLACE VIEW style_profile_performance AS
SELECT 
    sp.id as style_profile_id,
    sp.name as style_name,
    pv.version_number as current_version,
    COUNT(DISTINCT c.id) as total_chapters,
    AVG(pe.overall_score) as avg_overall_score,
    AVG(pe.clarity_score) as avg_clarity,
    AVG(pe.engagement_score) as avg_engagement,
    AVG(pe.pacing_score) as avg_pacing,
    AVG(pe.voice_consistency_score) as avg_voice_consistency,
    AVG(pe.technical_quality_score) as avg_technical_quality,
    COUNT(DISTINCT pf.id) FILTER (WHERE pf.liked = true) as liked_passages,
    COUNT(DISTINCT pf.id) FILTER (WHERE pf.liked = false) as disliked_passages
FROM style_profiles sp
LEFT JOIN prompt_versions pv ON pv.style_profile_id = sp.id AND pv.is_active = true
LEFT JOIN chapters c ON c.style_profile_id = sp.id
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
LEFT JOIN passage_feedback pf ON pf.chapter_id = c.id
GROUP BY sp.id, sp.name, pv.version_number;

-- View: Recent chapters with scores
CREATE OR REPLACE VIEW recent_chapters_with_scores AS
SELECT 
    c.id,
    c.chapter_number,
    c.title,
    c.word_count,
    c.generated_at,
    sp.name as style_profile,
    pv.version_number as prompt_version,
    pe.overall_score,
    pe.clarity_score,
    pe.engagement_score,
    pe.pacing_score,
    pe.voice_consistency_score,
    pe.technical_quality_score
FROM chapters c
JOIN style_profiles sp ON sp.id = c.style_profile_id
LEFT JOIN prompt_versions pv ON pv.id = c.prompt_version_id
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
ORDER BY c.generated_at DESC;

-- ============================================
-- Grant Permissions (adjust as needed)
-- ============================================
-- Note: Replace 'anon' and 'authenticated' with your actual Supabase roles
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO authenticated;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;

-- ============================================
-- Completion Message
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✅ Novel Writer database schema deployed successfully!';
    RAISE NOTICE '📊 Tables created: style_profiles, chapters, prose_evaluations, passage_feedback, prompt_versions, learning_insights';
    RAISE NOTICE '🔧 Functions available: get_active_prompt, should_update_prompt, create_prompt_version, rollback_prompt_version';
    RAISE NOTICE '📈 Views available: style_profile_performance, recent_chapters_with_scores';
    RAISE NOTICE '🎯 Sample style profile created: Default Literary Fiction';
END $$;
