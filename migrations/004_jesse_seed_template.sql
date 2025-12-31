-- JESSE NOVEL FACTORY - Seed Template
-- Fill in the placeholders and run in Supabase SQL Editor
-- Supabase URL: https://supabase.com/dashboard/project/ylcepmvbjjnwmzvevxid/sql

-- ============================================================================
-- STEP 1: CLEAR EXISTING (if re-seeding)
-- ============================================================================

-- Uncomment these lines to clear existing Jesse data
-- DELETE FROM timeline_events WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM canon_rules WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM songs WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM characters WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM books WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM worlds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
-- DELETE FROM series WHERE id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;

-- ============================================================================
-- STEP 2: CREATE SERIES
-- ============================================================================

INSERT INTO series (id, name, description, genre, target_audience, total_planned_books, project_type, is_active)
VALUES (
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Jesse and the Beanstalk',
    '{{SERIES_DESCRIPTION}}',
    'Fantasy/Comedy',
    'Family (8-adult)',
    24,
    'novel',
    true
);

-- ============================================================================
-- STEP 3: CREATE WORLD
-- ============================================================================

INSERT INTO worlds (id, series_id, name, description, magic_system, time_rules, artifacts, tone_rules, deprecated_content)
VALUES (
    'w1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'The Magical Realm',
    '{{WORLD_DESCRIPTION}}',
    '{{MAGIC_SYSTEM}}',
    '{"earth_to_realm_ratio": "3 days = 2 years", "note": "Time warp creates urgency"}'::jsonb,
    '{{ARTIFACTS_JSON}}'::jsonb,
    '{{TONE_RULES_JSON}}'::jsonb,
    '{"morgrim": "Use MALAKAR instead", "gregor": "Use GROG instead", "anne_early": "Ann at conference until Book 2 climax"}'::jsonb
);

-- ============================================================================
-- STEP 4: CREATE BOOKS
-- ============================================================================

INSERT INTO books (id, series_id, title, book_number, synopsis, target_word_count, status, completion_pct, chapter_outline, plot_points)
VALUES 
(
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Jesse and the Beanstalk',
    1,
    '{{BOOK_1_SYNOPSIS}}',
    60000,
    'writing',
    70,
    '{{BOOK_1_CHAPTERS_JSON}}'::jsonb,
    '{{BOOK_1_PLOT_POINTS_JSON}}'::jsonb
),
(
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Return to the Realm',
    2,
    '{{BOOK_2_SYNOPSIS}}',
    65000,
    'planning',
    25,
    '{{BOOK_2_CHAPTERS_JSON}}'::jsonb,
    '{{BOOK_2_PLOT_POINTS_JSON}}'::jsonb
);

-- ============================================================================
-- STEP 5: CREATE CHARACTERS
-- ============================================================================

-- JESSE
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Jesse',
    'Border Collie',
    'protagonist',
    NULL,
    '{{JESSE_DESCRIPTION}}',
    '{{JESSE_VOICE_NOTES}}',
    '{{JESSE_HARD_RULES_JSON}}'::jsonb,
    '{{JESSE_RUNNING_JOKES_JSON}}'::jsonb,
    '{{JESSE_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL -- ElevenLabs voice ID TBD
);

-- KEVIN
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Kevin',
    'Human',
    'supporting',
    'Middle-aged',
    '{{KEVIN_DESCRIPTION}}',
    '{{KEVIN_VOICE_NOTES}}',
    '{{KEVIN_HARD_RULES_JSON}}'::jsonb,
    '{{KEVIN_RUNNING_JOKES_JSON}}'::jsonb,
    '{{KEVIN_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- EMMA
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c3b2c3d4-0001-0001-0001-000000000003'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Emma',
    'Human',
    'supporting',
    '17, turning 18',
    '{{EMMA_DESCRIPTION}}',
    '{{EMMA_VOICE_NOTES}}',
    '{{EMMA_HARD_RULES_JSON}}'::jsonb,
    '{{EMMA_RUNNING_JOKES_JSON}}'::jsonb,
    '{{EMMA_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- AMY
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c4b2c3d4-0001-0001-0001-000000000004'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Amy',
    'Human',
    'supporting',
    'Middle daughter',
    '{{AMY_DESCRIPTION}}',
    '{{AMY_VOICE_NOTES}}',
    '{{AMY_HARD_RULES_JSON}}'::jsonb,
    '{{AMY_RUNNING_JOKES_JSON}}'::jsonb,
    '{{AMY_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- LAURA
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c5b2c3d4-0001-0001-0001-000000000005'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Laura',
    'Human',
    'supporting',
    'Youngest daughter',
    '{{LAURA_DESCRIPTION}}',
    '{{LAURA_VOICE_NOTES}}',
    '{{LAURA_HARD_RULES_JSON}}'::jsonb,
    '{{LAURA_RUNNING_JOKES_JSON}}'::jsonb,
    '{{LAURA_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- ANN
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c6b2c3d4-0001-0001-0001-000000000006'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Ann',
    'Human',
    'supporting',
    'Mother',
    '{{ANN_DESCRIPTION}}',
    '{{ANN_VOICE_NOTES}}',
    '{{ANN_HARD_RULES_JSON}}'::jsonb,
    '{{ANN_RUNNING_JOKES_JSON}}'::jsonb,
    '{{ANN_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- GROG
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c7b2c3d4-0001-0001-0001-000000000007'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Grog',
    'Ogre',
    'ally',
    NULL,
    '{{GROG_DESCRIPTION}}',
    '{{GROG_VOICE_NOTES}}',
    '{{GROG_HARD_RULES_JSON}}'::jsonb,
    '{{GROG_RUNNING_JOKES_JSON}}'::jsonb,
    '{{GROG_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- LIRIAN
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c8b2c3d4-0001-0001-0001-000000000008'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Lirian',
    'Elf',
    'ally',
    NULL,
    '{{LIRIAN_DESCRIPTION}}',
    '{{LIRIAN_VOICE_NOTES}}',
    '{{LIRIAN_HARD_RULES_JSON}}'::jsonb,
    '{{LIRIAN_RUNNING_JOKES_JSON}}'::jsonb,
    '{{LIRIAN_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- ELVIRA
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c9b2c3d4-0001-0001-0001-000000000009'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Elvira',
    'Fairy',
    'ally',
    'Elderly',
    '{{ELVIRA_DESCRIPTION}}',
    '{{ELVIRA_VOICE_NOTES}}',
    '{{ELVIRA_HARD_RULES_JSON}}'::jsonb,
    '{{ELVIRA_RUNNING_JOKES_JSON}}'::jsonb,
    '{{ELVIRA_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- MALAKAR
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, voice_id)
VALUES (
    'c10b2c3d4-0001-0001-0001-00000000010'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Malakar',
    'Sorcerer',
    'antagonist',
    NULL,
    '{{MALAKAR_DESCRIPTION}}',
    '{{MALAKAR_VOICE_NOTES}}',
    '{{MALAKAR_HARD_RULES_JSON}}'::jsonb,
    '{{MALAKAR_RUNNING_JOKES_JSON}}'::jsonb,
    '{{MALAKAR_SAMPLE_DIALOGUE_JSON}}'::jsonb,
    NULL
);

-- ============================================================================
-- STEP 6: CREATE SONGS
-- ============================================================================

-- Book 1 Songs
INSERT INTO songs (id, series_id, book_id, title, song_type, style, mood, purpose, key_lyrics)
VALUES 
(
    's1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Another Bloody Monday',
    'opening',
    'Irish folk pop',
    'Chaotic, warm',
    'Establishes family chaos in real world',
    '{{SONG_1_LYRICS}}'
),
(
    's2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Just One Slice',
    'i_want',
    'Comedic ballad',
    'Longing, absurd',
    'Jesse wants cake',
    '{{SONG_2_LYRICS}}'
),
(
    's3b2c3d4-0001-0001-0001-000000000003'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'A Cake for Me',
    'comedy',
    'Upbeat musical theatre',
    'Triumphant, interrupted',
    'Jesse victory song - collar vanishes mid-line',
    'It blows my mi— [CRACKLE] Woof.'
),
(
    's4b2c3d4-0001-0001-0001-000000000004'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Home Again',
    'finale',
    'Warm acoustic',
    'Bittersweet, hopeful',
    'Return home triumphant',
    '{{SONG_4_LYRICS}}'
),
-- Book 2 Songs
(
    's5b2c3d4-0001-0001-0001-000000000005'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Conference Call From Hell',
    'opening',
    'Stressed office pop',
    'Frantic, comedic',
    'Ann work stress before Oz twist',
    '{{SONG_5_LYRICS}}'
),
(
    's6b2c3d4-0001-0001-0001-000000000006'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Malakar''s Return',
    'villain',
    'Dark theatrical',
    'Sinister, dramatic',
    'Villain song with staff breaking gag',
    'I don''t need your love, I don''t need your tears / I''m a villain now, baby bring on the cheers'
),
(
    's7b2c3d4-0001-0001-0001-000000000007'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Sisters United',
    'ensemble',
    'Power ballad building',
    'Building tension',
    'Building to sisterly bond activation',
    '{{SONG_7_LYRICS}}'
),
(
    's8b2c3d4-0001-0001-0001-000000000008'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'The Bond That Breaks',
    'finale',
    'Epic orchestral',
    'Triumphant, emotional',
    'Sisterly power defeats Malakar permanently',
    '{{SONG_8_LYRICS}}'
);

-- ============================================================================
-- STEP 7: CREATE CANON RULES
-- ============================================================================

INSERT INTO canon_rules (series_id, rule_type, rule_name, rule_description, evidence, confidence)
VALUES 
-- Magic rules
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Collar Speech', 'Jesse can ONLY speak with collar in magical realm', 'Collar crackles, flickers, vanishes mid-song: "It blows my mi—" CRACKLE. "Woof."', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Time Warp', '3 Earth days = 2 realm years', 'Lirian explains time difference on reunion', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Sentient Beanstalk', 'Beanstalk is SENTIENT - saves family, provides food, speaks with Irish accent', 'Beanstalk whispers: "No bother at all. Sure, you are grand, young ones."', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Sisterly Bond', 'Emma/Amy/Laura dormant power that can shatter Malakar''s spells', 'Malakar fears it: "Their sisterly bond is a magic so potent it can shatter my spells"', 'high'),

-- Tone rules
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Mam not Mom', 'Always use "Mam" for mother, never "Mom"', 'Irish family setting', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Skippy Bombs', 'Pop culture references ALWAYS fail - Skippy reference bombs completely', 'Kevin: "What''s that Skip?" Emma: "Dad WTF?"', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Natural Profanity', 'Irish profanity natural, not forced - fuck, shit, piss, wanker used freely', 'Multiple examples throughout', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'No Speeches', 'NO inspirational speeches unless immediately undercut', 'Tone guide', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Laura Farts', 'Laura nervous farts at tense moments - major running gag', '"Sorry. I get nervous." (face beet red)', 'high'),

-- Deprecated
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'deprecated', 'Morgrim', 'DO NOT USE - use MALAKAR instead', 'Canon update', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'deprecated', 'Gregor', 'DO NOT USE - use GROG instead', 'Canon update', 'high');

-- ============================================================================
-- STEP 8: CREATE QUALITY THRESHOLDS
-- ============================================================================

INSERT INTO quality_thresholds (series_id, metric_name, pass_threshold, suggestion_threshold, rewrite_threshold, weight)
VALUES 
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'prose_quality', 4.0, 3.5, 3.5, 1.0),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'voice_consistency', 4.0, 3.5, 3.5, 1.2),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'pacing', 4.0, 3.5, 3.5, 1.0),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'dialogue', 4.0, 3.5, 3.5, 1.1),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'show_vs_tell', 4.0, 3.5, 3.5, 1.0);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Seed complete' as status,
    (SELECT COUNT(*) FROM series WHERE name = 'Jesse and the Beanstalk') as series,
    (SELECT COUNT(*) FROM books WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as books,
    (SELECT COUNT(*) FROM characters WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as characters,
    (SELECT COUNT(*) FROM worlds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as worlds,
    (SELECT COUNT(*) FROM songs WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as songs,
    (SELECT COUNT(*) FROM canon_rules WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as canon_rules;
