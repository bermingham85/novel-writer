# Novel Writer - Local Docker n8n Setup

## ✅ Current Status

**n8n Instance**: Local Docker container  
**Container Name**: `n8n-local`  
**Status**: Running ✅  
**URL**: http://localhost:5678  
**Port**: 5678

---

## 🚀 Quick Setup (15 minutes)

### Step 1: Deploy Database to Supabase ✅ (Already Opened)

1. **Supabase Dashboard** (already open in browser)
2. Click **SQL Editor** → **New Query**
3. Copy contents from `DEPLOY_ALL.sql` (already open in Notepad)
4. Paste into SQL Editor
5. Click **Run** (Ctrl+Enter)

**Expected Result:**
```
✅ Novel Writer database schema deployed successfully!
```

**Verify:**
```sql
SELECT COUNT(*) FROM style_profiles;
```
Should return: 1 row (Default Literary Fiction)

---

### Step 2: Get Supabase Connection String

In **Supabase Dashboard**:
1. Go to **Settings** → **Database**
2. Find **Connection String** section
3. Select **Connection pooling** tab (NOT Transaction)
4. Click **Show** to reveal password
5. Copy the entire string

**Format:**
```
postgresql://postgres.[project-ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres
```

**Parse it to:**
- Host: `aws-0-[region].pooler.supabase.com`
- Port: `6543`
- Database: `postgres`
- User: `postgres.[project-ref]`
- Password: `[your-password]`

---

### Step 3: Configure n8n Credentials

**Your n8n is at: http://localhost:5678** (already open)

#### 3.1 Create Supabase Credential

1. In n8n, click **Settings** (⚙️ gear icon) → **Credentials**
2. Click **Add Credential**
3. Search for "Postgres" → Select **Postgres**
4. Fill in:

| Field | Value |
|-------|-------|
| Credential Name | `Supabase Novel Writer` |
| Host | `aws-0-[region].pooler.supabase.com` |
| Database | `postgres` |
| User | `postgres.[project-ref]` |
| Password | `[from connection string]` |
| Port | `6543` |
| SSL Mode | `allow` or `require` |

5. Click **Test Connection** → Should show "Connection successful" ✅
6. Click **Save**
7. **IMPORTANT**: Copy the credential ID (shown in URL or list)

#### 3.2 Create/Verify OpenAI Credential

**If you already have OpenAI credential:**
1. Find it in Credentials list
2. Note the credential ID

**If you need to create it:**
1. Click **Add Credential**
2. Search for "OpenAI" → Select **OpenAI**
3. Fill in:
   - Credential Name: `OpenAI`
   - API Key: `[your-openai-api-key]`
4. Click **Save**
5. Note the credential ID

---

### Step 4: Import Workflow

1. In n8n, click **+** (top right) → **Import from File**
2. Navigate to: `C:\Users\bermi\Projects\novel-writer\workflow.json`
3. Click **Open**
4. Workflow will load with title: "Novel Writer - Self-Learning Prose System"

---

### Step 5: Update Credential References

**IMPORTANT**: You need to update credentials in all nodes

#### PostgreSQL Nodes (9 total):
Click each node and select your `Supabase Novel Writer` credential:

1. Get Active Style Profile
2. Get Active Prompt
3. Get Next Chapter Number
4. Save Chapter
5. Save Evaluation
6. Check If Update Needed
7. Get Recent Evaluations
8. Get Passage Feedback
9. Save New Prompt Version

#### OpenAI Nodes (3 total):
Click each node and select your `OpenAI` credential:

1. Generate Chapter
2. Evaluate Prose Quality
3. Generate Improved Prompt

**Tip**: Click on each node, find the "Credentials" dropdown in the right panel, select the appropriate credential.

---

### Step 6: Save & Activate

1. Click **Save** (top right)
2. Toggle workflow to **Active** (switch at top)
3. You should see "Workflow activated" ✅

---

### Step 7: Test with First Chapter

1. In the workflow editor, click **Execute Workflow** (▶️ play button, top right)
2. Watch the workflow execute through each node
3. **Expected duration**: 60-120 seconds
4. All nodes should show green checkmarks ✅

**If any node fails:**
- Click on the failed node
- Check error message
- Verify credentials are correct
- Check OpenAI API has credits

---

## 🧪 Verify in Supabase

After successful execution, run these queries in Supabase SQL Editor:

### Check Chapter Created
```sql
SELECT 
  chapter_number, 
  title, 
  word_count, 
  generated_at 
FROM chapters 
ORDER BY generated_at DESC 
LIMIT 1;
```
**Expected**: 1 row showing Chapter 1

### Check Evaluation Scores
```sql
SELECT 
  overall_score,
  clarity_score,
  engagement_score,
  pacing_score,
  voice_consistency_score,
  technical_quality_score,
  evaluation_notes
FROM prose_evaluations 
ORDER BY evaluated_at DESC 
LIMIT 1;
```
**Expected**: 1 row with scores between 1.00-5.00

### View Full Chapter Details
```sql
SELECT * FROM recent_chapters_with_scores 
ORDER BY generated_at DESC 
LIMIT 1;
```

---

## 🎮 Daily Usage

### Generate New Chapter
1. Open http://localhost:5678
2. Open "Novel Writer - Self-Learning Prose System" workflow
3. Click **Execute Workflow**
4. Wait 60-120 seconds
5. Check results in Supabase

### View All Chapters
```sql
SELECT * FROM recent_chapters_with_scores 
ORDER BY chapter_number;
```

### Monitor Performance
```sql
SELECT * FROM style_profile_performance;
```

---

## 🐛 Troubleshooting

### n8n Not Accessible

**Check if container is running:**
```powershell
docker ps | Select-String "n8n-local"
```

**If stopped, start it:**
```powershell
docker start n8n-local
```

**Check logs:**
```powershell
docker logs n8n-local --tail 50
```

### Database Connection Fails

**Verify connection string:**
- Must use **Connection Pooling** mode (port 6543, not 5432)
- SSL must be enabled
- Check Supabase project is not paused

**Test from PowerShell:**
```powershell
Test-NetConnection aws-0-us-west-1.pooler.supabase.com -Port 6543
```

### OpenAI API Errors

**Common issues:**
- Invalid API key → Verify in OpenAI dashboard
- No credits → Add credits at platform.openai.com
- Rate limit → Wait or upgrade tier

### Workflow Execution Fails

**Get Active Style Profile fails:**
```sql
-- Verify profile exists
SELECT * FROM style_profiles WHERE active = true;
```

**Generate Chapter fails:**
- Check OpenAI credential is valid
- Verify API key has credits
- Check rate limits

**Save operations fail:**
- Verify Supabase credential is correct
- Check tables exist
- Review n8n execution logs

---

## 🔧 Docker Commands

### View Container Status
```powershell
docker ps | Select-String "n8n"
```

### View Logs
```powershell
docker logs n8n-local --tail 100 --follow
```

### Restart Container
```powershell
docker restart n8n-local
```

### Stop Container
```powershell
docker stop n8n-local
```

### Start Container
```powershell
docker start n8n-local
```

### Container Info
```powershell
docker inspect n8n-local
```

---

## 📊 System Architecture

```
Local Machine (Windows)
    ↓
Docker Desktop
    ↓
n8n-local container (port 5678)
    ↓
    ├─→ Supabase (PostgreSQL) - Database
    └─→ OpenAI API - AI Generation
```

**Data Flow:**
1. You trigger workflow in local n8n (http://localhost:5678)
2. n8n queries Supabase for style profile & prompt
3. n8n calls OpenAI to generate chapter
4. n8n saves chapter to Supabase
5. n8n calls OpenAI to evaluate prose
6. n8n saves evaluation to Supabase
7. n8n checks if prompt update needed
8. If needed, n8n improves prompt and saves new version

---

## ✅ Checklist

### Initial Setup
- [ ] Supabase SQL deployed (DEPLOY_ALL.sql)
- [ ] Connection string obtained
- [ ] Supabase credential created in n8n
- [ ] OpenAI credential created/verified in n8n
- [ ] workflow.json imported
- [ ] All node credentials updated
- [ ] Workflow saved and activated

### First Test
- [ ] Workflow executed successfully
- [ ] Chapter appears in Supabase `chapters` table
- [ ] Evaluation appears in `prose_evaluations` table
- [ ] Prompt version exists in `prompt_versions` table

### Verification
- [ ] Overall score is between 1.0-5.0
- [ ] Chapter has reasonable word count (1500-3500)
- [ ] No error messages in n8n execution log

---

## 🎉 Success Criteria

**System is working when:**
1. ✅ n8n workflow executes without errors
2. ✅ New chapter appears in Supabase
3. ✅ Evaluation scores are recorded
4. ✅ Overall score is calculated
5. ✅ Prompt version tracking is active

**You're ready to generate chapters!**

---

## 📞 Quick Reference

**Local n8n**: http://localhost:5678  
**Container**: `n8n-local` (Docker)  
**Supabase**: https://supabase.com/dashboard  
**Files**: `C:\Users\bermi\Projects\novel-writer\`

**Generate Chapter**: n8n → Execute Workflow  
**View Results**: Supabase → Table Editor → `chapters`  
**Monitor**: `SELECT * FROM style_profile_performance;`

---

**Ready to deploy? Follow the steps above!** 🚀

**Estimated Time**: 15-20 minutes from start to first chapter
