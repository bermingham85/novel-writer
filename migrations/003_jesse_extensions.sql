-- JESSE NOVEL FACTORY - Extended Schema
-- Run AFTER 002_planning_suite_schema.sql
-- Adds Jesse-specific fields and structures

-- ============================================================================
-- EXTEND CHARACTERS TABLE
-- ============================================================================

-- Add Jesse-specific columns if they don't exist
DO $$ 
BEGIN
    -- Voice notes for dialogue generation
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='voice_notes') THEN
        ALTER TABLE characters ADD COLUMN voice_notes TEXT;
    END IF;
    
    -- Hard rules that must never be broken
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='hard_rules') THEN
        ALTER TABLE characters ADD COLUMN hard_rules JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Running jokes/gags for this character
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='running_jokes') THEN
        ALTER TABLE characters ADD COLUMN running_jokes JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Sample dialogue lines
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='sample_dialogue') THEN
        ALTER TABLE characters ADD COLUMN sample_dialogue JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Species (for non-human characters)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='species') THEN
        ALTER TABLE characters ADD COLUMN species TEXT DEFAULT 'Human';
    END IF;
    
    -- Age or age description
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='age') THEN
        ALTER TABLE characters ADD COLUMN age TEXT;
    END IF;
    
    -- ElevenLabs voice ID for audiobook
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='voice_id') THEN
        ALTER TABLE characters ADD COLUMN voice_id TEXT;
    END IF;
END $$;

-- ============================================================================
-- EXTEND WORLDS TABLE
-- ============================================================================

DO $$ 
BEGIN
    -- Time rules (like time warp ratios)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='worlds' AND column_name='time_rules') THEN
        ALTER TABLE worlds ADD COLUMN time_rules JSONB DEFAULT '{}'::jsonb;
    END IF;
    
    -- Artifacts in this world
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='worlds' AND column_name='artifacts') THEN
        ALTER TABLE worlds ADD COLUMN artifacts JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Tone rules for writing in this world
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='worlds' AND column_name='tone_rules') THEN
        ALTER TABLE worlds ADD COLUMN tone_rules JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Deprecated content warnings
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='worlds' AND column_name='deprecated_content') THEN
        ALTER TABLE worlds ADD COLUMN deprecated_content JSONB DEFAULT '{}'::jsonb;
    END IF;
END $$;

-- ============================================================================
-- EXTEND BOOKS TABLE
-- ============================================================================

DO $$ 
BEGIN
    -- Chapter outline as structured data
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='books' AND column_name='chapter_outline') THEN
        ALTER TABLE books ADD COLUMN chapter_outline JSONB DEFAULT '[]'::jsonb;
    END IF;
    
    -- Completion percentage
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='books' AND column_name='completion_pct') THEN
        ALTER TABLE books ADD COLUMN completion_pct INTEGER DEFAULT 0;
    END IF;
    
    -- Key plot points
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='books' AND column_name='plot_points') THEN
        ALTER TABLE books ADD COLUMN plot_points JSONB DEFAULT '[]'::jsonb;
    END IF;
END $$;

-- ============================================================================
-- EXTEND SONGS TABLE
-- ============================================================================

DO $$ 
BEGIN
    -- Song type (opening, i_want, villain, finale, etc)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='songs' AND column_name='song_type') THEN
        ALTER TABLE songs ADD COLUMN song_type TEXT;
    END IF;
    
    -- Key lyrics snippets
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='songs' AND column_name='key_lyrics') THEN
        ALTER TABLE songs ADD COLUMN key_lyrics TEXT;
    END IF;
END $$;

-- ============================================================================
-- CREATE CANON RULES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS canon_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    rule_type TEXT NOT NULL, -- 'magic', 'character', 'world', 'tone', 'deprecated'
    rule_name TEXT NOT NULL,
    rule_description TEXT,
    evidence TEXT, -- Source/proof for this rule
    confidence TEXT DEFAULT 'high', -- 'high', 'medium', 'low'
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_canon_rules_series ON canon_rules(series_id);
CREATE INDEX IF NOT EXISTS idx_canon_rules_type ON canon_rules(rule_type);

-- ============================================================================
-- CREATE TIMELINE TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS timeline_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id),
    event_order INTEGER NOT NULL,
    event_description TEXT NOT NULL,
    chapter_reference TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_timeline_series ON timeline_events(series_id);
CREATE INDEX IF NOT EXISTS idx_timeline_book ON timeline_events(book_id);
CREATE INDEX IF NOT EXISTS idx_timeline_order ON timeline_events(event_order);

-- ============================================================================
-- CREATE QUALITY THRESHOLDS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS quality_thresholds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    metric_name TEXT NOT NULL, -- 'prose_quality', 'voice_consistency', 'pacing', 'dialogue', 'show_vs_tell'
    pass_threshold DECIMAL(3,2) DEFAULT 4.0,
    suggestion_threshold DECIMAL(3,2) DEFAULT 3.5,
    rewrite_threshold DECIMAL(3,2) DEFAULT 3.5,
    weight DECIMAL(3,2) DEFAULT 1.0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_quality_thresholds_series ON quality_thresholds(series_id);

-- ============================================================================
-- HELPFUL VIEWS
-- ============================================================================

-- Full character view with all Jesse-specific fields
CREATE OR REPLACE VIEW character_full AS
SELECT 
    c.id,
    c.series_id,
    s.name as series_name,
    c.name,
    c.species,
    c.role,
    c.age,
    c.description,
    c.voice_notes,
    c.hard_rules,
    c.running_jokes,
    c.sample_dialogue,
    c.personality_traits,
    c.relationships,
    c.voice_id,
    c.created_at
FROM characters c
JOIN series s ON s.id = c.series_id;

-- Book with chapter count
CREATE OR REPLACE VIEW book_summary AS
SELECT 
    b.id,
    b.series_id,
    s.name as series_name,
    b.title,
    b.book_number,
    b.status,
    b.completion_pct,
    b.target_word_count,
    jsonb_array_length(COALESCE(b.chapter_outline, '[]'::jsonb)) as chapter_count,
    jsonb_array_length(COALESCE(b.plot_points, '[]'::jsonb)) as plot_point_count
FROM books b
JOIN series s ON s.id = b.series_id;

-- Series dashboard view
CREATE OR REPLACE VIEW series_dashboard AS
SELECT 
    s.id,
    s.name,
    s.genre,
    s.description,
    s.total_planned_books,
    COUNT(DISTINCT b.id) as books_count,
    COUNT(DISTINCT c.id) as characters_count,
    COUNT(DISTINCT w.id) as worlds_count,
    COUNT(DISTINCT so.id) as songs_count,
    COUNT(DISTINCT cr.id) as canon_rules_count
FROM series s
LEFT JOIN books b ON b.series_id = s.id
LEFT JOIN characters c ON c.series_id = s.id
LEFT JOIN worlds w ON w.series_id = s.id
LEFT JOIN songs so ON so.series_id = s.id
LEFT JOIN canon_rules cr ON cr.series_id = s.id
WHERE s.is_active = true
GROUP BY s.id;

-- ============================================================================
-- RPC FUNCTIONS FOR API
-- ============================================================================

-- Get full series data in one call
CREATE OR REPLACE FUNCTION get_series_full(p_series_id UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'series', (SELECT row_to_json(s) FROM series s WHERE s.id = p_series_id),
        'books', (SELECT json_agg(row_to_json(b)) FROM books b WHERE b.series_id = p_series_id),
        'characters', (SELECT json_agg(row_to_json(c)) FROM character_full c WHERE c.series_id = p_series_id),
        'worlds', (SELECT json_agg(row_to_json(w)) FROM worlds w WHERE w.series_id = p_series_id),
        'songs', (SELECT json_agg(row_to_json(so)) FROM songs so WHERE so.series_id = p_series_id),
        'canon_rules', (SELECT json_agg(row_to_json(cr)) FROM canon_rules cr WHERE cr.series_id = p_series_id),
        'timeline', (SELECT json_agg(row_to_json(t) ORDER BY t.event_order) FROM timeline_events t WHERE t.series_id = p_series_id)
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Get character context for AI prompts
CREATE OR REPLACE FUNCTION get_character_context(p_series_id UUID)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT json_agg(json_build_object(
            'name', c.name,
            'species', c.species,
            'role', c.role,
            'voice_notes', c.voice_notes,
            'hard_rules', c.hard_rules,
            'running_jokes', c.running_jokes,
            'sample_dialogue', c.sample_dialogue
        ))
        FROM characters c
        WHERE c.series_id = p_series_id
    );
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- VERIFICATION QUERY
-- ============================================================================

SELECT 
    'Extended schema ready' as status,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'characters' AND column_name = 'voice_notes') as characters_extended,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'worlds' AND column_name = 'tone_rules') as worlds_extended,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'books' AND column_name = 'chapter_outline') as books_extended,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'canon_rules') as canon_rules_table,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'timeline_events') as timeline_table;
