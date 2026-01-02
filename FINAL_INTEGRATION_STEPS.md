# Final Integration Steps - Jesse Novel Factory

## ✅ Current Status

### Database (Supabase) - COMPLETE ✅
- **Project**: ylcepmvbjjnwmzvevxid (self learning composer)
- **Series**: Jesse and the Beanstalk (Fantasy Comedy)
- **Characters**: 10 (Jesse, Kevin, Emma, Amy, Laura, Ann, Malakar, Elandra, Grog, Thalon)
- **Books**: 2 (Book 1: Beanstalk in_progress, Book 2: Oz planned)
- **Worlds**: 2 (The Cloud Realm, Oz)
- **Chapters**: 6 (draft content)
- **Style Profile**: Jesse Irish Comedy (ID: f42bcc92-1e60-4cae-aeea-2d24b4c00fd9)

### n8n Container - RUNNING ✅
- **Container**: n8n-local (Up 34 hours)
- **Port**: 5678 → 5678
- **Network**: Accessible at http://192.168.50.246:5678 OR http://localhost:5678

### Story Forge Frontend - DEPLOYED ⚠️
- **URL**: https://story-forge-94.preview.emergentagent.com/
- **Status**: Shows 0 Series (NOT connected to Supabase)
- **Issue**: Database connection misconfigured

---

## 🎯 Step 1: Fix Story Forge Database Connection

**Problem**: Frontend shows "0 Series" despite database having data.

**Solution**: Emergent needs to configure Story Forge environment variables:

```env
# Supabase Connection (Story Forge .env)
NEXT_PUBLIC_SUPABASE_URL=https://ylcepmvbjjnwmzvevxid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[YOUR_ANON_KEY]
SUPABASE_SERVICE_ROLE_KEY=[YOUR_SERVICE_KEY]

# Database Direct Connection (for API)
DATABASE_URL=postgresql://postgres.ylcepmvbjjnwmzvevxid:Ballybought1985!@aws-1-eu-west-3.pooler.supabase.com:5432/postgres
```

**Action**: Ask Emergent to:
1. Add these environment variables to Story Forge deployment
2. Redeploy
3. Verify frontend loads "1 Series, 10 Characters" etc.

---

## 🎯 Step 2: Import n8n Workflow

### 2.1: Access n8n
1. Open browser to: http://192.168.50.246:5678
   - OR use: http://localhost:5678 (if on same machine)

### 2.2: Import Workflow
1. Click **"Workflows"** in left sidebar
2. Click **"Add Workflow"** or import icon
3. Click **"Import from File"**
4. Select file: `C:\Users\bermi\Projects\novel-writer\n8n-workflow-FIXED-complete.json`
   - (You'll need to get this from Emergent's build artifacts)

### 2.3: Configure Credentials

**Required Credentials:**

#### A. PostgreSQL (Supabase)
```
Name: Supabase Novel Writer
Type: Postgres
Host: aws-1-eu-west-3.pooler.supabase.com
Port: 5432
Database: postgres
User: postgres.ylcepmvbjjnwmzvevxid
Password: Ballybought1985!
SSL: Ignore SSL Issues (enabled)
```

#### B. OpenAI
```
Name: OpenAI - Jesse Factory
Type: OpenAI
API Key: [YOUR_OPENAI_API_KEY]
```

#### C. Anthropic (Claude)
```
Name: Anthropic Claude
Type: Anthropic
API Key: [YOUR_ANTHROPIC_API_KEY]
```

### 2.4: Activate Workflow
1. Set workflow to **Active** (toggle switch)
2. Save workflow

### 2.5: Set Jesse Style Profile ID
In workflow nodes that query style_profile, ensure:
```
style_profile_id = f42bcc92-1e60-4cae-aeea-2d24b4c00fd9
```

---

## 🎯 Step 3: Test End-to-End Flow

### Test 1: Manual Webhook Trigger
```bash
# Test chapter generation via n8n webhook
curl -X POST http://192.168.50.246:5678/webhook/generate-chapter \
  -H "Content-Type: application/json" \
  -d '{
    "series_id": "[JESSE_SERIES_ID]",
    "book_id": "[BOOK_1_ID]", 
    "chapter_number": 7,
    "scene_description": "Jesse discovers the cake vault"
  }'
```

**Expected Result:**
- n8n workflow executes
- Loads Jesse context (10 characters, 2 worlds)
- Generates chapter via Claude/OpenAI
- Quality review runs
- Chapter saved to `chapters` table
- Returns generated content

### Test 2: Frontend Integration
Once Story Forge is connected:
1. Open Story Forge: https://story-forge-94.preview.emergentagent.com/
2. Should now show: **1 Series, 10 Characters, 2 Worlds**
3. Click "Jesse and the Beanstalk" project
4. Go to Manuscript tab
5. Should show **6 existing chapters**
6. Click "Write New Chapter"
7. Should trigger n8n workflow
8. New chapter appears in manuscript

### Test 3: AI Chat with Context
1. Go to AI Chat tab
2. Select "Jesse and the Beanstalk" series
3. Ask: "Tell me about Jesse's personality"
4. Should respond with context from database (cake-obsessed, energetic, etc.)

---

## 🎯 Step 4: Verify Data Sync

Run this query in Supabase SQL Editor to verify all data:

```sql
-- Full system status
SELECT 
    'Series' as entity,
    COUNT(*)::text as count
FROM series
UNION ALL
SELECT 'Books', COUNT(*)::text FROM books
UNION ALL
SELECT 'Characters', COUNT(*)::text FROM characters
UNION ALL
SELECT 'Worlds', COUNT(*)::text FROM worlds
UNION ALL
SELECT 'Chapters', COUNT(*)::text FROM chapters
UNION ALL
SELECT 'Songs', COUNT(*)::text FROM songs
UNION ALL
SELECT 'Style Profiles', COUNT(*)::text FROM style_profiles
UNION ALL
SELECT 'Prompt Versions', COUNT(*)::text FROM prompt_versions;

-- Jesse series details
SELECT 
    s.name as series,
    s.genre,
    COUNT(DISTINCT b.id) as books,
    COUNT(DISTINCT c.id) as characters,
    COUNT(DISTINCT w.id) as worlds,
    COUNT(DISTINCT ch.id) as chapters
FROM series s
LEFT JOIN books b ON b.series_id = s.id
LEFT JOIN characters c ON c.series_id = s.id
LEFT JOIN worlds w ON w.series_id = s.id
LEFT JOIN chapters ch ON ch.style_profile_id IN (
    SELECT id FROM style_profiles WHERE description ILIKE '%jesse%'
)
GROUP BY s.id, s.name, s.genre;
```

**Expected Output:**
```
entity            | count
------------------+-------
Series            | 1
Books             | 2
Characters        | 10
Worlds            | 2
Chapters          | 6
Songs             | 0 (or 8 if seeded)
Style Profiles    | 1
Prompt Versions   | 1

series                      | genre          | books | characters | worlds | chapters
----------------------------+----------------+-------+------------+--------+----------
Jesse and the Beanstalk     | Fantasy Comedy | 2     | 10         | 2      | 6
```

---

## 📊 Success Criteria

### ✅ Phase 1: Database (COMPLETE)
- [x] Schema deployed with Jesse extensions
- [x] Series, characters, worlds seeded
- [x] Style profile and prompt versions created
- [x] 6 draft chapters exist

### ⏳ Phase 2: n8n Integration (IN PROGRESS)
- [ ] Workflow imported to local n8n
- [ ] Credentials configured
- [ ] Webhook tested successfully
- [ ] Chapter generation working

### ⏳ Phase 3: Frontend Connection (BLOCKED)
- [ ] Story Forge connected to Supabase
- [ ] Shows "1 Series, 10 Characters" on dashboard
- [ ] Can browse Jesse project data
- [ ] Can trigger chapter generation from UI
- [ ] AI Chat has series context

---

## 🚨 Known Issues & Blockers

### Issue 1: Story Forge Not Connected
**Status**: BLOCKING
**Impact**: Frontend unusable
**Solution**: Emergent must add Supabase env vars and redeploy

### Issue 2: n8n Workflow File Location
**Status**: MINOR
**Location**: Workflow JSON should be at:
- `C:\Users\bermi\Projects\novel-writer\workflows\n8n-workflow-FIXED-complete.json`
- OR provided by Emergent as artifact

**Solution**: Copy workflow JSON to novel-writer project

### Issue 3: MongoDB vs Supabase Context
**Note**: Emergent mentioned "31 context docs in MongoDB"
**Question**: Is frontend using MongoDB or Supabase?
**Resolution Needed**: Confirm Story Forge is configured for Supabase, not MongoDB

---

## 🎬 Next Actions

### For Emergent (Frontend Developer):
1. **Fix Story Forge database connection**
   - Add Supabase environment variables
   - Redeploy Story Forge
   - Verify data loads

2. **Provide n8n workflow file**
   - Share `n8n-workflow-FIXED-complete.json`
   - Or confirm location in project

3. **Clarify MongoDB usage**
   - Is Story Forge using MongoDB or Supabase?
   - If MongoDB, need to sync data from Supabase

### For You (User):
1. **Import n8n workflow**
   - Access http://192.168.50.246:5678
   - Import workflow JSON
   - Configure credentials

2. **Test workflow**
   - Trigger webhook manually
   - Verify chapter generation

3. **Verify Story Forge**
   - Once Emergent redeploys with Supabase config
   - Test frontend shows Jesse data
   - Test chapter generation from UI

---

## 📁 File Locations

```
C:\Users\bermi\Projects\novel-writer\
├── migrations\
│   ├── 002_planning_suite_schema.sql          ✅ Applied
│   ├── 003_jesse_extensions.sql               ✅ Applied
│   └── 004_jesse_seed_template.sql            ✅ Applied (filled & run)
├── workflows\
│   └── n8n-workflow-FIXED-complete.json       ⚠️ Need to locate/import
└── FINAL_INTEGRATION_STEPS.md                 📄 This file
```

---

## 🎯 TL;DR - Do These 3 Things:

1. **Tell Emergent**: "Story Forge needs Supabase env vars - it's showing 0 Series"
2. **Import n8n workflow**: Open http://192.168.50.246:5678, import workflow, configure credentials
3. **Test**: Once Story Forge reconnected, verify it shows Jesse data and can generate chapters

**When all 3 done, system is fully operational! 🎉**
