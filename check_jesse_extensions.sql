-- Check if Jesse extensions are applied
SELECT column_name 
FROM information_schema.columns 
WHERE table_name='characters' 
AND column_name IN ('voice_notes','hard_rules','species','age','voice_id')
ORDER BY column_name;

-- Check if new tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema='public' 
AND table_name IN ('canon_rules','timeline_events','quality_thresholds')
ORDER BY table_name;

-- Check if new views exist
SELECT table_name 
FROM information_schema.views 
WHERE table_schema='public' 
AND table_name IN ('character_full','book_summary','series_dashboard')
ORDER BY table_name;

-- Check if functions exist
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema='public' 
AND routine_name IN ('get_series_full','get_character_context')
ORDER BY routine_name;
