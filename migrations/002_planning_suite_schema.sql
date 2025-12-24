-- Novel Planning Suite - Database Schema Migration
-- Version: 002
-- Date: 2025-12-24
-- Purpose: Add tables for conversational novel planning, music, quality checks, and copyright
-- Strategy: Multi-project partitioning - all tables use series_id as partition key

-- ============================================================================
-- CORE MANAGEMENT TABLES
-- ============================================================================

-- Projects/Series Management (Top-level partition key)
CREATE TABLE IF NOT EXISTS series (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    genre TEXT,
    target_audience TEXT,
    total_planned_books INTEGER,
    project_type TEXT DEFAULT 'novel', -- 'novel', 'short_story', 'screenplay', etc.
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_series_active ON series(is_active);
CREATE INDEX idx_series_type ON series(project_type);

-- Books within Series
CREATE TABLE IF NOT EXISTS books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    book_number INTEGER,
    synopsis TEXT,
    target_word_count INTEGER,
    status TEXT DEFAULT 'planning', -- 'planning', 'writing', 'complete', 'published'
    style_profile_id UUID REFERENCES style_profiles(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_books_series ON books(series_id);
CREATE INDEX idx_books_status ON books(status);

-- ============================================================================
-- CONTENT TABLES
-- ============================================================================

-- Characters
CREATE TABLE IF NOT EXISTS characters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    role TEXT, -- 'protagonist', 'antagonist', 'supporting', 'minor'
    description TEXT,
    background TEXT,
    personality_traits JSONB, -- Array of traits
    relationships JSONB, -- {character_id: relationship_description}
    character_arc TEXT,
    first_appearance_book_id UUID REFERENCES books(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_characters_series ON characters(series_id);
CREATE INDEX idx_characters_role ON characters(role);
CREATE INDEX idx_characters_name ON characters(name);

-- World Building
CREATE TABLE IF NOT EXISTS worlds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    history TEXT,
    geography TEXT,
    culture JSONB,
    magic_system TEXT,
    technology_level TEXT,
    rules JSONB, -- World rules and constraints
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_worlds_series ON worlds(series_id);

-- Locations within Worlds
CREATE TABLE IF NOT EXISTS locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    world_id UUID NOT NULL REFERENCES worlds(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    location_type TEXT, -- 'city', 'building', 'region', 'landmark'
    parent_location_id UUID REFERENCES locations(id),
    significance TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_locations_world ON locations(world_id);
CREATE INDEX idx_locations_parent ON locations(parent_location_id);

-- ============================================================================
-- STORY STRUCTURE TABLES
-- ============================================================================

-- Story Arcs
CREATE TABLE IF NOT EXISTS story_arcs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    arc_type TEXT, -- 'main', 'subplot', 'character', 'series'
    title TEXT NOT NULL,
    description TEXT,
    plot_points JSONB, -- Ordered array of plot beats
    resolution TEXT,
    status TEXT DEFAULT 'planning', -- 'planning', 'in_progress', 'complete'
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_story_arcs_series ON story_arcs(series_id);
CREATE INDEX idx_story_arcs_book ON story_arcs(book_id);
CREATE INDEX idx_story_arcs_type ON story_arcs(arc_type);

-- Scenes/Chapter Outlines
CREATE TABLE IF NOT EXISTS scene_outlines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    chapter_number INTEGER,
    scene_number INTEGER,
    location_id UUID REFERENCES locations(id),
    characters_present UUID[], -- Array of character IDs
    purpose TEXT,
    key_events TEXT,
    emotional_tone TEXT,
    pov_character_id UUID REFERENCES characters(id),
    notes TEXT,
    word_count_target INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_scene_outlines_book ON scene_outlines(book_id);
CREATE INDEX idx_scene_outlines_chapter ON scene_outlines(chapter_number);

-- ============================================================================
-- MUSIC & SONGS TABLES
-- ============================================================================

-- Songs/Music
CREATE TABLE IF NOT EXISTS songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id),
    chapter_id UUID REFERENCES chapters(id),
    title TEXT NOT NULL,
    lyrics TEXT,
    style TEXT, -- Musical style/genre
    mood TEXT, -- Emotional mood
    tempo TEXT,
    suno_prompt TEXT, -- Full prompt sent to Suno
    suno_audio_url TEXT, -- URL to generated audio
    suno_song_id TEXT, -- Suno's ID for the song
    suno_metadata JSONB, -- Additional Suno response data
    purpose TEXT, -- Context in story (theme song, character song, in-story performance)
    performed_by_character_id UUID REFERENCES characters(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_songs_series ON songs(series_id);
CREATE INDEX idx_songs_book ON songs(book_id);
CREATE INDEX idx_songs_chapter ON songs(chapter_id);
CREATE INDEX idx_songs_suno_id ON songs(suno_song_id);

-- ============================================================================
-- CONVERSATION & PLANNING TABLES
-- ============================================================================

-- Conversation History
CREATE TABLE IF NOT EXISTS planning_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id),
    topic TEXT, -- 'character', 'plot', 'world', 'music', 'general'
    conversation_data JSONB, -- Full conversation thread [{role, content, timestamp}]
    decisions_made JSONB, -- Structured decisions extracted from conversation
    context_used JSONB, -- What knowledge base items were referenced
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_planning_conversations_series ON planning_conversations(series_id);
CREATE INDEX idx_planning_conversations_book ON planning_conversations(book_id);
CREATE INDEX idx_planning_conversations_topic ON planning_conversations(topic);
CREATE INDEX idx_planning_conversations_created ON planning_conversations(created_at DESC);

-- Ideas & Brainstorming
CREATE TABLE IF NOT EXISTS ideas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id),
    idea_type TEXT, -- 'plot', 'character', 'world', 'scene', 'dialogue', 'other'
    title TEXT,
    description TEXT,
    status TEXT DEFAULT 'new', -- 'new', 'considered', 'accepted', 'rejected', 'implemented'
    related_entity_id UUID, -- ID of related character, arc, etc.
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_ideas_series ON ideas(series_id);
CREATE INDEX idx_ideas_book ON ideas(book_id);
CREATE INDEX idx_ideas_type ON ideas(idea_type);
CREATE INDEX idx_ideas_status ON ideas(status);

-- ============================================================================
-- QUALITY & COPYRIGHT TABLES
-- ============================================================================

-- Copyright Checks
CREATE TABLE IF NOT EXISTS copyright_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    content_type TEXT, -- 'chapter', 'character_name', 'world_name', 'song_lyrics', 'location_name'
    content_id UUID, -- ID of the content being checked
    content_text TEXT, -- The actual content checked
    check_status TEXT DEFAULT 'pending', -- 'pending', 'pass', 'warning', 'fail'
    similarity_score DECIMAL(5,4), -- 0.0000 to 1.0000
    similarity_results JSONB, -- Detailed similarity matches
    flagged_content JSONB, -- Specific flagged phrases/elements
    recommendations TEXT,
    checked_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_copyright_checks_series ON copyright_checks(series_id);
CREATE INDEX idx_copyright_checks_type ON copyright_checks(content_type);
CREATE INDEX idx_copyright_checks_status ON copyright_checks(check_status);
CREATE INDEX idx_copyright_checks_content ON copyright_checks(content_id);

-- Quality Assessments (extends existing prose_evaluations)
CREATE TABLE IF NOT EXISTS content_quality_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID NOT NULL REFERENCES series(id) ON DELETE CASCADE,
    content_type TEXT, -- 'chapter', 'outline', 'character', 'song', 'scene'
    content_id UUID,
    check_type TEXT, -- 'consistency', 'originality', 'coherence', 'grammar', 'pacing'
    score DECIMAL(3,2), -- 0.00 to 5.00
    issues JSONB, -- Array of identified issues
    suggestions TEXT,
    passed BOOLEAN,
    checked_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_quality_checks_series ON content_quality_checks(series_id);
CREATE INDEX idx_quality_checks_type ON content_quality_checks(content_type);
CREATE INDEX idx_quality_checks_check_type ON content_quality_checks(check_type);
CREATE INDEX idx_quality_checks_content ON content_quality_checks(content_id);

-- ============================================================================
-- HELPER VIEWS
-- ============================================================================

-- Active series with book counts
CREATE OR REPLACE VIEW active_series_summary AS
SELECT 
    s.id,
    s.name,
    s.genre,
    s.project_type,
    COUNT(DISTINCT b.id) as book_count,
    COUNT(DISTINCT c.id) as character_count,
    COUNT(DISTINCT w.id) as world_count,
    s.created_at,
    s.updated_at
FROM series s
LEFT JOIN books b ON b.series_id = s.id
LEFT JOIN characters c ON c.series_id = s.id
LEFT JOIN worlds w ON w.series_id = s.id
WHERE s.is_active = true
GROUP BY s.id, s.name, s.genre, s.project_type, s.created_at, s.updated_at;

-- Book progress view
CREATE OR REPLACE VIEW book_progress AS
SELECT 
    b.id,
    b.title,
    b.series_id,
    s.name as series_name,
    b.status,
    b.target_word_count,
    COUNT(DISTINCT ch.id) as chapters_written,
    SUM(ch.word_count) as current_word_count,
    ROUND((SUM(ch.word_count)::DECIMAL / NULLIF(b.target_word_count, 0)) * 100, 2) as completion_percentage
FROM books b
JOIN series s ON s.id = b.series_id
LEFT JOIN chapters ch ON ch.style_profile_id = b.style_profile_id
GROUP BY b.id, b.title, b.series_id, s.name, b.status, b.target_word_count;

-- Character relationship network
CREATE OR REPLACE VIEW character_relationships AS
SELECT 
    c.id as character_id,
    c.name as character_name,
    c.series_id,
    c.role,
    jsonb_array_elements(c.relationships) as relationship
FROM characters c
WHERE c.relationships IS NOT NULL;

-- ============================================================================
-- SAMPLE DATA (for testing)
-- ============================================================================

-- Insert a sample series for testing
INSERT INTO series (name, description, genre, target_audience, project_type)
VALUES 
    ('The Quantum Chronicles', 'A sci-fi series about time travelers', 'Science Fiction', 'Young Adult', 'novel')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================

-- Verify tables created
SELECT 
    schemaname,
    tablename
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN (
    'series', 'books', 'characters', 'worlds', 'locations',
    'story_arcs', 'scene_outlines', 'songs', 
    'planning_conversations', 'ideas',
    'copyright_checks', 'content_quality_checks'
)
ORDER BY tablename;
