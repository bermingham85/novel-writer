-- JESSE AND THE BEANSTALK - Complete Seed Data
-- Run in Supabase SQL Editor: https://supabase.com/dashboard/project/ylcepmvbjjnwmzvevxid/sql
-- Run AFTER: 002_planning_suite_schema.sql and 003_jesse_extensions.sql

-- ============================================================================
-- STEP 1: CLEAR EXISTING DATA (safe re-run)
-- ============================================================================

DELETE FROM quality_thresholds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM canon_rules WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM timeline_events WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM songs WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM characters WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM books WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM worlds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;
DELETE FROM series WHERE id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid;

-- ============================================================================
-- STEP 2: CREATE SERIES
-- ============================================================================

INSERT INTO series (id, name, description, genre, target_audience, total_planned_books, project_type, is_active)
VALUES (
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Jesse and the Beanstalk',
    'A border collie named Jesse accidentally eats magic seeds, triggering a beanstalk that carries her into a magical realm above the clouds. Her Irish family—dad Kevin, and daughters Emma (17), Amy (middle), and Laura (youngest)—climb after her. In the realm, Jesse''s magical collar lets her speak, and she becomes an unlikely hero fighting the sorcerer Malakar. Mother Ann is perpetually at a conference, later getting her own Oz adventure via ruby slippers. The series blends dry Irish family humor, absurdist fantasy, profanity-laced warmth, and genuine emotional moments.',
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
    'A realm above the clouds accessible via the sentient beanstalk. Features floating castle with towering spires, weathered carvings of mythical beasts and war-torn heroes, gold-veined walls. Courtyard with enchanted creatures: fairies carrying fruits, dwarves at forge, talking squirrels chastising rabbits, pixies playing tag leaving shimmering dust trails. Grand hall with towering pillars, ancient tattered tapestries, dimly lit by enchanted lanterns, massive throne on raised dais encrusted with dark jagged gems. Once vibrant but now devastated by Malakar''s Shadow Stalkers - dark clouds, fire patches, injured creatures limping through barren wastelands.',
    'Collar grants speech ONLY in magical realm - crackles, flickers, vanishes when returning to Earth. Can short out mid-song. Time warp: 3 Earth days = 2 realm years. Beanstalk is SENTIENT - saves family from falling, provides food from vines, speaks with Irish accent. Sisterly bond between Emma/Amy/Laura is dormant power that can shatter Malakar''s dark magic - he fears it above all. Shadow Stalkers are Malakar''s minions - twisted forms, red gleaming eyes, feed on misery, circle like predators.',
    '{"earth_to_realm_ratio": "3 days = 2 years", "note": "Creates urgency and confusion"}'::jsonb,
    '[
        {"name": "Jesse''s Collar", "properties": "Grants speech in realm only, crackles/vanishes on Earth, can short out mid-song"},
        {"name": "Malakar''s Staff", "properties": "Source of power, breaks constantly (running gag) - That''s the second one this week, the little shits"},
        {"name": "Magic Seeds", "properties": "Grow beanstalk, shimmer faintly, taste oddly delightful"},
        {"name": "Ruby Slippers", "properties": "Transport to Oz, won''t come off once worn, create indoor tornado"},
        {"name": "Elvira''s Tablet", "properties": "Sparkling wine-colored, electronics bleeping, it was on offer"}
    ]'::jsonb,
    '[
        "Mam not Mom - always use Irish terminology",
        "Pop culture references ALWAYS fail - Skippy bombs completely",
        "Natural Irish profanity - fuck, shit, piss, wanker used freely but not forced",
        "NO inspirational speeches unless immediately undercut",
        "Laura nervous farts at tense moments - major running gag",
        "Dark moments balanced by absurdist deflection",
        "Everyone says Why do I have to do everything - family complaint",
        "Kevin denies Ann swears - girls prove him wrong with quotes",
        "Jesse misunderstands kindness - thinks cakes left FOR her (actually stealing)",
        "Characters relieved when Jesse can''t sing - but lie politely"
    ]'::jsonb,
    '{"morgrim": "DO NOT USE - use MALAKAR instead", "gregor": "DO NOT USE - use GROG instead", "anne_early": "Ann at conference until Book 2 climax, then Oz adventure"}'::jsonb
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
    'Jesse eats magic seed in garden shed, beanstalk erupts and drags her to magical realm above clouds. Irish family (Kevin, Emma, Amy, Laura) climbs after her through bickering and Laura''s nervous farts. In realm, Jesse meets allies: Grog the crude ogre, graceful elf Lirian, elderly fairy Elvira, centaur Thalon, sly sprite Zeffa. Gets collar from Elvira allowing speech. Confronts Malakar the sorcerer who fears the sisters'' dormant bond. Grog snaps Malakar''s staff (running gag). Jesse''s powerful bark shatters Malakar into light and shadow - not destroyed, fragmented. Victory song interrupted when collar vanishes mid-line: "It blows my mi—" CRACKLE. "Woof." Friends pretend they loved it.',
    60000,
    'writing',
    70,
    '[
        {"chapter": 1, "title": "The Misadventure Begins", "summary": "Breakfast chaos, treehouse project announced, Jesse finds seeds in shed, eats one, beanstalk erupts dragging her up, family scrambles to follow, Laura''s first nervous fart"},
        {"chapter": 2, "title": "The Castle in the Clouds", "summary": "Jesse arrives at castle, sneezing flower, courtyard creatures, ogre falls in fountain cursing fairies, dark musical number foreshadowing Malakar"},
        {"chapter": 3, "title": "The Greetings", "summary": "Grand hall, meets Elandra/Elvira/Thalon/Grog/Zeffa, Malakar appears, casts dark net, Jesse''s power awakens - BACK OFF!, mirror shows family climbing"},
        {"chapter": 4, "title": "A Quick Turnaround", "summary": "Family tumbles over beanstalk, bickering, Amy''s GAA zinger, find Jesse speaking, collar explained, Malakar banishes family back to Earth"},
        {"chapter": 5, "title": "Malakar''s Backstory", "summary": "Villain origin - boy Alleric betrayed by family with sisterly bond magic, villain song with flair"},
        {"chapter": 6, "title": "Unlocking Jesse''s Power", "summary": "Egg scene dark comedy, Hall of Enchantments, collar found on pedestal, Grog: we''re putting hopes in S&M kit, Elvira''s cheap tablet gift"},
        {"chapter": 7, "title": "The Confrontation", "summary": "Throne room battle, Grog snaps staff (second one this week), Jesse''s blast shatters Malakar, cake misunderstanding revealed, interrupted song, collar vanishes"}
    ]'::jsonb,
    '[
        "Jesse eats magic seed - tastes oddly delightful",
        "Beanstalk erupts dragging Jesse to clouds",
        "Laura''s nervous fart breaks climbing tension",
        "Jesse''s power awakens - growl causes shutter, speaks BACK OFF",
        "Malakar shows mirror - fears sisterly bond",
        "Jesse gets collar - Grog: fucking S&M kit",
        "Grog snaps Malakar''s staff - second one this week",
        "Jesse''s bark shatters Malakar into light and shadow",
        "Cake misunderstanding - Jesse thinks family leaves them FOR her",
        "Song interrupted: It blows my mi— CRACKLE. Woof.",
        "Friends lie: That was just... lovely"
    ]'::jsonb
),
(
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Return to the Realm',
    2,
    'Beanstalk returns glowing. Kevin ignores it reading newspaper: That''s nice dear. Skippy reference bombs completely. Emma told to change from crop top. Sentient beanstalk attacks then saves family, provides food, speaks with Irish accent. Realm devastated - Shadow Stalkers attack. Grog and Lirian rescue with brutal efficiency. Time warp revealed. Ann gets swept to Oz via ruby slippers while shopping for Emma''s 18th birthday gift at Curio & Co. Antiques. Malakar returns from fragments. Sisters activate dormant bond to defeat him permanently.',
    65000,
    'planning',
    25,
    '[
        {"chapter": 10, "title": "The Magical Resurgence", "summary": "Beanstalk returns glowing, Kevin ignores, Skippy bombs, Emma change from crop top, girls prove Ann swears, Laura grabs factor 50"},
        {"chapter": 8, "title": "Mind the Gap", "summary": "Sentient beanstalk whips family, girls flung into abyss, beanstalk saves them, provides food, speaks Irish, tucks them in for rest"},
        {"chapter": 9, "title": "The Devastated Realm", "summary": "Realm now shadow, Shadow Stalkers attack, Grog/Lirian rescue - Get away from them you little bastards, six bodies scattered"},
        {"chapter": 12, "title": "Twister of Fate", "summary": "Ann at antique shop, finds ruby slippers, Jesse warns, shoes won''t come off, indoor tornado sweeps them to Oz, Yellow Brick Road ahead"}
    ]'::jsonb,
    '[
        "Beanstalk returns glowing - Kevin: That''s nice dear",
        "Skippy reference bombs - Dad WTF?",
        "Amy sent back to change - crop top and side boob",
        "Girls prove Ann swears with quotes",
        "Sentient beanstalk saves family from falling",
        "Beanstalk speaks: No bother at all. Sure, you are grand, young ones.",
        "Shadow Stalkers attack - twisted forms, red eyes",
        "Grog/Lirian rescue - decapitations, gore, superhero pose",
        "Time warp: 3 days = 2 years",
        "Ann finds ruby slippers - OZ Original tag",
        "Jesse warns Ann frantically - ignored",
        "Indoor tornado sweeps Ann and Jesse to Oz",
        "Sisters activate dormant bond - defeats Malakar permanently"
    ]'::jsonb
);

-- ============================================================================
-- STEP 5: CREATE CHARACTERS
-- ============================================================================

-- JESSE - Border Collie Protagonist
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Jesse',
    'Border Collie',
    'protagonist',
    NULL,
    'Border collie protagonist. Energetic, curious, slightly chaotic. Cake-obsessed. Brave when family threatened. Thinks family leaves cakes FOR her (actually stealing them). Loves to knock Ann over when she arrives home. Past adventures include Golden Chicken theft, bog frog army, Scepter of Lost Left Feet from Bog of Infinite Socks.',
    'Energetic, curious, slightly chaotic. Brave when family threatened. Speaks with enthusiasm and wonder in magical realm. Confused about human customs. Obsessed with cake to comic degree.',
    '["Can ONLY speak with collar in magical realm", "Collar crackles, flickers, vanishes when returning to Earth", "Always tries to eat cake, never finishes alone", "Thinks cakes are left FOR her - doesn''t realize she''s stealing", "Loves to knock Ann over when she arrives home"]'::jsonb,
    '["for cake''s sake!", "Accidental heroism - stumbles into saving the day", "Squeaky bark when magic misfires", "Song interrupted mid-line when collar vanishes", "Past adventure references - Golden Chicken, bog frogs, Scepter"]'::jsonb,
    '["BACK OFF!", "Amy? It''s me!", "For cake''s sake!", "It blows my mi— [CRACKLE] Woof.", "I can never finish them though, so I always leave them some for the morning"]'::jsonb,
    '["Loyal", "Enthusiastic", "Naive", "Brave", "Cake-obsessed"]'::jsonb
);

-- KEVIN - Irish Dad
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Kevin',
    'Human',
    'supporting',
    'Middle-aged',
    'Irish dad, practical but overwhelmed. Swears under pressure. Makes outdated pop culture references that ALWAYS fail. Old GAA injuries. Tool belt useless in magic realm. Denies Ann swears despite girls'' evidence.',
    'Practical Irish dad voice. Frustrated but loving. Swears naturally when stressed. Tries to be funny with old references - always bombs. Mutters under breath when fraying.',
    '["Says feck, Christ Almighty, Jesus Mary and Joseph, for fuck''s sake", "Makes Skippy the Bush Kangaroo references that ALWAYS fail", "DENIES Ann swears - girls prove him wrong", "Tool belt useless in magic realm", "Old GAA injuries - Amy teases him"]'::jsonb,
    '["Skippy reference bombs completely - What''s that Skip? / Dad WTF?", "Delegates chores during crisis - Emma, empty the dishwasher", "First instinct always practical - Emma, grab the Roundup", "Worries about Ann''s reaction - your mother will go ape", "Forgets Emma''s 18th birthday coming up"]'::jsonb,
    '["All right, girls! Today we''re building the treehouse. It''s going to be epic!", "Girls, stop it! We don''t have time for this!", "Just a little further girls. We''re nearly there girls for fuck''s sake!", "No, no, no, no, no, no, no! We are not going anywhere!", "What''s that, Skip? A girl has fallen down the well?", "We have to be back soon or your mother will go ape!", "Holy shit..."]'::jsonb,
    '["Practical", "Overwhelmed", "Loving", "Outdated", "Denial-prone"]'::jsonb
);

-- EMMA - Eldest Daughter
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c3b2c3d4-0001-0001-0001-000000000003'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Emma',
    'Human',
    'supporting',
    '17, turning 18',
    'Eldest daughter. Responsible, practical. Eye-rolls constantly. Takes adult tone in chaos. Secretly soft spot for Jesse. Prepared fluffy pancakes in opening. About to turn 18 - Kevin worried about forgetting.',
    'Responsible eldest sister voice. Eye-rolls audible. Adult tone when taking charge. Competitive with Amy. Uses piss which annoys Kevin.',
    '["Says why do I have to do everything - running line others mock", "Uses piss which annoys Kevin", "About to turn 18 - Kevin worried about forgetting", "Takes charge in chaos with adult tone", "Prepared fluffy pancakes in opening"]'::jsonb,
    '["Eye-rolls at everything - birdhouse that turned into squirrel mansion", "Competitive with Amy - I''ll go first, you''re too slow", "Adult check before adventures - Has everybody gone for a piss?", "Challenges Kevin on Ann''s swearing"]'::jsonb,
    '["Dad, you say that every time you start a project. Remember the birdhouse that turned into a squirrel mansion?", "Why do I have to do everything?", "Has everybody gone for a piss? We are not stopping off anywhere.", "In fairness Amy, it''s really not the time for a crop top and side boob.", "But mom says it!"]'::jsonb,
    '["Responsible", "Practical", "Eye-rolling", "Secretly caring", "Competitive"]'::jsonb
);

-- AMY - Middle Daughter
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c4b2c3d4-0001-0001-0001-000000000004'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Amy',
    'Human',
    'supporting',
    'Middle daughter',
    'Middle daughter. Competitive, athletic, sharp. Fashion-conscious at wrong moments. Sports focused - chatters about sports escapades. Gets sent back to change during crisis.',
    'Sharp, competitive middle child voice. Athletic confidence. Fashion commentary at inappropriate times. Zingers that land hard.',
    '["References crop top/side boob inappropriately", "Argues with Emma constantly", "Sports focused - chatters about sports escapades", "Gets sent back to change during crisis", "Competitive jabs at Emma"]'::jsonb,
    '["Fashion timing disasters - sent back to change for crop top", "Zingers about Kevin''s GAA injuries - Your old GAA injuries can''t take it", "Narrator: Miao! The claws are out!", "Competitive spotlight hogging accusations", "Lagging behind and grumbling"]'::jsonb,
    '["No way, Emma. You always hog the spotlight!", "That''s what happens when you keep training into your forties dad. Your old GAA injuries can''t take it.", "What? Why?", "OMG, you are so embarrassing.", "Yeah, mom says piss all the time."]'::jsonb,
    '["Competitive", "Athletic", "Sharp", "Fashion-conscious", "Sarcastic"]'::jsonb
);

-- LAURA - Youngest Daughter
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c5b2c3d4-0001-0001-0001-000000000005'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Laura',
    'Human',
    'supporting',
    'Youngest daughter',
    'Youngest daughter. Quiet, artistic - hands covered in colourful paint. Most attuned to Jesse. First to spot danger and magic changes. Nervous under pressure which manifests physically.',
    'Quiet, observant voice. Nervous but perceptive. Closest to Jesse emotionally. Notices things others miss. Whispers to magical beings.',
    '["NERVOUS FARTS at tense moments - major running gag", "Carries art supplies, hands covered in colourful paint", "First to spot danger/magic changes", "Closest to Jesse emotionally", "Gets nervous under pressure"]'::jsonb,
    '["Nervous farts break tension - Sorry. I get nervous. (face beet red)", "First to notice beanstalk - Dad, the beanstalk! It''s back!", "First to feel something''s wrong", "Grabs factor 50 - I think we''ll need it", "Whispers thank you to beanstalk"]'::jsonb,
    '["Sorry. I get nervous.", "Dad, the beanstalk! It''s back!", "Both of you shut up! We need to find Jesse!", "Thank you.", "I think we''ll need it.", "Emma, you''ll be diabetic before your birthday next week."]'::jsonb,
    '["Quiet", "Artistic", "Observant", "Nervous", "Perceptive"]'::jsonb
);

-- ANN - Mother
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c6b2c3d4-0001-0001-0001-000000000006'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Ann',
    'Human',
    'supporting',
    'Mother, 4''7"',
    'Mother of the family. 4''7" tall. Professional, stressed. Swears freely despite Kevin''s denial. At conference during Books 1-2. Gets own Oz adventure via ruby slippers. Wizard of Oz was her childhood favorite - used to wrap feet in red tin foil pretending.',
    'Professional stressed mother voice. Swears naturally and often. Not present for main adventure until Oz twist. Nostalgic about Wizard of Oz.',
    '["AT CONFERENCE during Book 1 and early Book 2", "Swears freely - Kevin denies it", "Gets swept to Oz via ruby slippers", "4''7\" tall - not used to high heels", "Wizard of Oz childhood favorite"]'::jsonb,
    '["Conference extensions - never actually home", "Girls proving she swears - Piss head, piss off you wanker...", "Kevin''s denial - Your mom doesn''t swear!", "Jesse loves to knock her over when she arrives", "Ruby slippers won''t come off"]'::jsonb,
    '["Jesse, I have a feeling... we''re not in Dublin anymore.", "Piss head, piss off you wanker, does anybody need to piss before we go...", "Well, Dorothy, I''m not in Kansas, but these are pretty fabulous.", "Well, I did always say I wanted a little adventure of my own."]'::jsonb,
    '["Professional", "Stressed", "Sweary", "Nostalgic", "Adventurous"]'::jsonb
);

-- GROG - Ogre Ally
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c7b2c3d4-0001-0001-0001-000000000007'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Grog',
    'Ogre',
    'ally',
    NULL,
    'Ogre ally. Protector of the Great Woodland, occasional pie thief, sworn enemy of Malakar the Vile. Crude but genuinely kind. Massive frame. Carries Jesse under arm. Covered in gore but gentle.',
    'Crude, blunt, affectionate voice. Swears constantly but means well. Dramatic at unexpected moments. Booming roar that shakes ground. Honest in ways Jesse appreciates.',
    '["Says little shits/bastards affectionately", "DRAMATIC BOWING at inappropriate times - resembles small landslide", "Carries Jesse under arm", "Covered in gore but kind", "Occasional pie thief"]'::jsonb,
    '["Gore-covered entrances", "Dramatic bowing - Oh, where are my manners!", "Blunt relief - Oh thank fuck for that (when song interrupted)", "Crude but protective - Get away from them, you little bastards!", "S&M kit joke about collar"]'::jsonb,
    '["Get away from them, you little bastards!", "Little shits thought they could get the jump on you, huh? Not on my watch.", "Oh my god, really - she gets a fucking collar? We''re dead!", "We are putting our hopes into a fucking piece of S&M kit.", "If you don''t get your fingers out of your asses, we ain''t going to win anything.", "Oh thank fuck for that.", "I am Grog, protector of the Great Woodland, occasional pie thief, and sworn enemy of Malakar the Vile."]'::jsonb,
    '["Crude", "Protective", "Honest", "Dramatic", "Loyal"]'::jsonb
);

-- LIRIAN - Elf Warrior
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c8b2c3d4-0001-0001-0001-000000000008'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Lirian',
    'Elf',
    'ally',
    NULL,
    'Elf warrior ally. Graceful, precise, deadly. Silver blade flashing. Maternal toward Jesse. Can lie to children convincingly. Barely winded after brutal combat. Perfect superhero poses.',
    'Graceful, composed warrior voice. Fluid and precise. Can pivot to gentle maternal tone for Jesse. Diplomatic deflection of chaos. Smooth lies when needed.',
    '["Perfect superhero pose after battle", "Silver blade, precise strikes", "Movements fluid, every bit graceful warrior", "Can lie to children convincingly", "Barely winded after combat"]'::jsonb,
    '["Superhero poses next to Grog after battle", "Slight nod meaning You''re safe now", "Graceful lie when song interrupted - That was just... lovely", "Decapitates three in rapid succession", "Restores Jesse''s collar with golden light spell"]'::jsonb,
    '["Well, Jesse, I thought that was just... lovely.", "You''re safe now.", "Get away from them, you little bastards!"]'::jsonb,
    '["Graceful", "Deadly", "Maternal", "Composed", "Diplomatic"]'::jsonb
);

-- ELVIRA - Elderly Fairy
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c9b2c3d4-0001-0001-0001-000000000009'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Elvira',
    'Fairy',
    'ally',
    'Elderly',
    'Elderly fairy ally with frayed wings. Scholar type. Created/gave Jesse''s collar. Defensive about cheap gifts. Gets emotional at victories. Spectacles. Hands clasp too quickly when relieved.',
    'Elderly, wise but defensive voice. Teary when emotional. Mumbles defensively about gift quality. Academic knowledge dumps at wrong moments.',
    '["Says it was on offer about gifts - defensive", "Created/gave Jesse''s collar", "Gets teary at victories", "Frayed wings", "Spectacles"]'::jsonb,
    '["Cheap gift defense - It was on offer, anyway, do you want it or not?", "Teary moments - You are so good, Jesse. You are so kind.", "Hands clasp too quickly when relieved", "Too-wide smile when collar vanishes - Oh no. That''s... unfortunate."]'::jsonb,
    '["There are no accidents in this realm, Jesse. Every visitor has a purpose.", "It was on offer.", "You are so good, Jesse. You are so kind.", "Oh no. That''s... that''s unfortunate.", "Yes! Ahem, y-yes, of course."]'::jsonb,
    '["Wise", "Defensive", "Emotional", "Scholarly", "Kind"]'::jsonb
);

-- MALAKAR - Sorcerer Villain
INSERT INTO characters (id, series_id, name, species, role, age, description, voice_notes, hard_rules, running_jokes, sample_dialogue, personality_traits)
VALUES (
    'c10b2c3d4-0001-0001-0001-00000000010'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Malakar',
    'Sorcerer',
    'antagonist',
    NULL,
    'Main villain. Tall, hooded sorcerer with cold piercing eyes, black robes woven with silver thread. Real name Alleric - boy betrayed by own family who had sisterly bond magic. Shattered into light and shadow in Book 1, returns from fragments in Book 2. Fears family bonds above all.',
    'Cold, menacing, sinister voice. Dramatic pronouncements. Overconfident until challenged. Quiet venom when truly threatened. Theatrical villain with moments of genuine menace.',
    '["STAFF BREAKS frequently - running gag", "Real name Alleric, betrayed by family", "Shattered in Book 1, returns Book 2", "Fears sisterly bond above all", "Defeated ONLY by sisters'' dormant bond"]'::jsonb,
    '["Staff breaking at worst moments - That''s the second one this week, the little shits", "Dramatic exits when outmatched", "Underestimates Jesse constantly", "Villain song with flair after director intervention"]'::jsonb,
    '["There you are. I''ve been looking for you.", "An intruder. You will regret setting foot in my domain.", "That''s the second one this week, the little shits.", "I don''t need your love, I don''t need your tears, I''m a villain now baby bring on the cheers.", "Their sisterly bond is a magic so potent it can shatter my spells. I cannot allow them to reach you.", "Impossible.", "This is not over."]'::jsonb,
    '["Menacing", "Theatrical", "Vengeful", "Overconfident", "Fearful of bonds"]'::jsonb
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
    'Irish folk pop, upbeat chaos',
    'Chaotic, warm, frantic',
    'Establishes Jackson family chaos in real world - breakfast mayhem, sibling bickering, Kevin''s failed projects',
    'Another bloody Monday in the Jackson household / Emma''s flipping pancakes while the chaos unfolds / Amy''s talking sports, Laura''s covered in paint / Kevin''s got a plan but we know it ain''t great'
),
(
    's2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Just One Slice',
    'i_want',
    'Comedic ballad, longing',
    'Longing, absurd, sweet',
    'Jesse''s I Want song - her deep desire for cake, completely misunderstanding that she''s been stealing them',
    'Just one slice, is that too much to ask? / They leave it out for me, such a simple task / I never finish it, I leave them some too / Because sharing cake is what good dogs do'
),
(
    's3b2c3d4-0001-0001-0001-000000000003'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'A Cake for Me',
    'comedy',
    'Upbeat musical theatre, triumphant',
    'Triumphant, interrupted, comedic',
    'Jesse''s victory celebration song - interrupted when collar vanishes mid-line. Friends pretend they loved it.',
    'Every time I see a cake it means I''m loved / Sent down from the kitchen like a gift from above / It blows my mi— [CRACKLE] Woof.'
),
(
    's4b2c3d4-0001-0001-0001-000000000004'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'Home Again',
    'finale',
    'Warm acoustic, Irish folk',
    'Bittersweet, hopeful, warm',
    'Return home triumphant - family reunited, Jesse back where she belongs, but knowing adventure awaits again',
    'Home again where the kettle''s on / Back to the chaos where we belong / The beanstalk''s gone but the magic stays / In the Jackson family''s crazy ways'
),
-- Book 2 Songs
(
    's5b2c3d4-0001-0001-0001-000000000005'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Conference Call From Hell',
    'opening',
    'Stressed office pop, frantic',
    'Frantic, comedic, stressed',
    'Ann''s work stress before the Oz twist - setting up her separate adventure while family deals with beanstalk',
    'Another conference call from hell / PowerPoints and deadlines, can''t you tell / While my family''s climbing beanstalks in the sky / I''m stuck here wondering why, why, why'
),
(
    's6b2c3d4-0001-0001-0001-000000000006'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Malakar''s Return',
    'villain',
    'Dark theatrical, Broadway villain',
    'Sinister, dramatic, campy',
    'Villain song with staff breaking gag mid-number. After director intervention for more flair.',
    'I don''t need your love, I don''t need your tears / I''m a villain now, baby bring on the cheers / Your family bond, I''ll tear it apart / While I''m rocking this stage with all my villainous heart'
),
(
    's7b2c3d4-0001-0001-0001-000000000007'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'Sisters United',
    'ensemble',
    'Power ballad building, Celtic undertones',
    'Building tension, determined, powerful',
    'Emma, Amy, Laura discovering their dormant bond - building toward activation',
    'We fight, we bicker, we drive each other mad / But underneath it all, we''re the best friends we''ve had / Sisters united, our bond won''t break / Together we''ll fight for our family''s sake'
),
(
    's8b2c3d4-0001-0001-0001-000000000008'::uuid,
    'a1b2c3d4-0001-0001-0001-000000000001'::uuid,
    'b2b2c3d4-0001-0001-0001-000000000002'::uuid,
    'The Bond That Breaks',
    'finale',
    'Epic orchestral, triumphant',
    'Triumphant, emotional, powerful',
    'Sisterly bond activation defeats Malakar permanently - the power he always feared',
    'The bond that breaks the darkest spell / The love that casts the villain to hell / Three sisters standing hand in hand / The magic he could never understand'
);

-- ============================================================================
-- STEP 7: CREATE CANON RULES
-- ============================================================================

INSERT INTO canon_rules (series_id, rule_type, rule_name, rule_description, evidence, confidence)
VALUES 
-- Magic rules
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Collar Speech Only', 'Jesse can ONLY speak with collar in magical realm. No collar = no speech.', 'Collar crackles, flickers, vanishes mid-song: It blows my mi— CRACKLE. Woof.', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Collar Vanishes on Earth', 'Collar crackles, flickers, and completely vanishes when returning to Earth.', 'Multiple scenes of collar failing at transition points', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Time Warp', '3 Earth days = 2 realm years. Creates urgency and emotional stakes.', 'Lirian explains time difference on reunion - Jesse gone "three days" but two years passed in realm', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Sentient Beanstalk', 'Beanstalk is SENTIENT - saves family from falling, provides food from vines, speaks with Irish accent.', 'Beanstalk whispers: No bother at all. Sure, you are grand, young ones.', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Sisterly Bond Power', 'Emma/Amy/Laura have dormant power that can shatter Malakar''s spells. He fears it above all.', 'Malakar: Their sisterly bond is a magic so potent it can shatter my spells', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Ruby Slippers Transport', 'Ruby slippers transport wearer to Oz. Won''t come off once worn. Create indoor tornado.', 'Ann swept to Oz via slippers in Chapter 12', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'magic', 'Malakar Staff Breaking', 'Malakar''s staff breaks frequently - running gag. "That''s the second one this week, the little shits"', 'Staff snapped by Grog, breaks during villain song', 'high'),

-- Tone rules
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Mam Not Mom', 'Always use "Mam" for mother, never "Mom" - Irish family setting', 'Consistent throughout source material', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Skippy Always Bombs', 'Kevin''s Skippy the Bush Kangaroo references ALWAYS fail completely. No one gets them.', 'What''s that Skip? / Dad WTF? / You know Skippy? / OMG you are so embarrassing', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Natural Profanity', 'Irish profanity natural, not forced - fuck, shit, piss, wanker used freely', 'Kevin: for fuck''s sake, Grog: little shits, Ann: piss off you wanker', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'No Inspirational Speeches', 'NO inspirational speeches unless immediately undercut by comedy or chaos', 'Consistent deflection of earnest moments', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Laura Nervous Farts', 'Laura has nervous farts at tense moments - major running gag. Face turns beet red.', 'Sorry. I get nervous. (face beet red) - breaks tension repeatedly', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Kevin Denial', 'Kevin DENIES Ann swears. Girls prove him wrong by quoting her extensively.', 'Your mom doesn''t swear! vs Piss head, piss off you wanker...', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Cake Misunderstanding', 'Jesse thinks family leaves cakes FOR her. She''s actually been stealing them. Doesn''t realize.', 'I can never finish them though, so I always leave them some for the morning', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'tone', 'Song Relief', 'Characters relieved when Jesse can''t sing - but lie politely. Grog: Oh thank fuck for that.', 'Lirian: That was just... lovely. (lying)', 'high'),

-- Deprecated content
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'deprecated', 'Morgrim', 'DO NOT USE - old villain name. Use MALAKAR instead.', 'Canon update from source review', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'deprecated', 'Gregor', 'DO NOT USE - old giant name. Use GROG (ogre) instead.', 'Canon update from source review', 'high'),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'deprecated', 'Anne Early Appearance', 'Ann should NOT appear early. She is AT CONFERENCE during Books 1-2, then gets Oz adventure.', 'Canon structure requirement', 'high');

-- ============================================================================
-- STEP 8: CREATE QUALITY THRESHOLDS
-- ============================================================================

INSERT INTO quality_thresholds (series_id, metric_name, pass_threshold, suggestion_threshold, rewrite_threshold, weight)
VALUES 
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'prose_quality', 4.0, 3.5, 3.0, 1.0),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'voice_consistency', 4.0, 3.5, 3.0, 1.2),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'pacing', 4.0, 3.5, 3.0, 1.0),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'dialogue', 4.0, 3.5, 3.0, 1.1),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'show_vs_tell', 4.0, 3.5, 3.0, 1.0),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'humor_timing', 4.0, 3.5, 3.0, 1.1),
('a1b2c3d4-0001-0001-0001-000000000001'::uuid, 'irish_authenticity', 4.0, 3.5, 3.0, 1.0);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 
    'JESSE SEED COMPLETE' as status,
    (SELECT COUNT(*) FROM series WHERE id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as series,
    (SELECT COUNT(*) FROM books WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as books,
    (SELECT COUNT(*) FROM characters WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as characters,
    (SELECT COUNT(*) FROM worlds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as worlds,
    (SELECT COUNT(*) FROM songs WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as songs,
    (SELECT COUNT(*) FROM canon_rules WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as canon_rules,
    (SELECT COUNT(*) FROM quality_thresholds WHERE series_id = 'a1b2c3d4-0001-0001-0001-000000000001'::uuid) as thresholds;

-- Expected output:
-- status              | series | books | characters | worlds | songs | canon_rules | thresholds
-- JESSE SEED COMPLETE |   1    |   2   |     10     |   1    |   8   |     18      |     7
