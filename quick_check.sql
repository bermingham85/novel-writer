-- Quick check: What's in the database?
SELECT 'Series Count' as check_name, COUNT(*)::text as result FROM series
UNION ALL
SELECT 'Characters Count', COUNT(*)::text FROM characters
UNION ALL
SELECT 'Books Count', COUNT(*)::text FROM books
UNION ALL
SELECT 'Worlds Count', COUNT(*)::text FROM worlds
UNION ALL
SELECT 'Songs Count', COUNT(*)::text FROM songs;

-- Check if Jesse extensions exist
SELECT 'Jesse Extensions Applied' as check_name, 
       CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='characters' AND column_name='voice_notes') 
       THEN 'YES' ELSE 'NO' END as result;

-- List all series
SELECT id, name, genre FROM series;
