# Novel Writer Deployment Checklist

Complete these steps in order to deploy the system.

## ✅ Pre-Deployment Checklist

- [ ] Supabase account created
- [ ] OpenAI API key ready (with credits)
- [ ] n8n instance accessible at http://192.168.50.246:5678
- [ ] Files verified in `C:\Users\bermi\Projects\novel-writer\`:
  - [ ] `DEPLOY_ALL.sql`
  - [ ] `workflow.json`
  - [ ] `README.md`

---

## 📦 Step 1: Deploy Database (5-10 minutes)

### 1.1 Open Supabase Dashboard
- Navigate to: https://supabase.com/dashboard
- Select your project OR create new project

### 1.2 Execute SQL Schema
1. Click **SQL Editor** in left sidebar
2. Click **New Query**
3. Open `DEPLOY_ALL.sql` from `C:\Users\bermi\Projects\novel-writer\`
4. Copy entire contents (367 lines)
5. Paste into SQL Editor
6. Click **Run** (or Ctrl+Enter)

### 1.3 Verify Deployment
Check for success message:
```
✅ Novel Writer database schema deployed successfully!
```

Run verification query:
```sql
SELECT COUNT(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('style_profiles', 'chapters', 'prose_evaluations', 
                     'passage_feedback', 'prompt_versions', 'learning_insights');
```
**Expected Result**: `table_count = 6`

### 1.4 Verify Sample Data
```sql
SELECT name, description FROM style_profiles WHERE active = true;
```
**Expected Result**: Should show "Default Literary Fiction" profile

---

## 🔑 Step 2: Get Connection Credentials (2 minutes)

### 2.1 Navigate to Database Settings
- Supabase Dashboard → **Settings** → **Database**

### 2.2 Copy Connection String
- Find **Connection String** section
- Select **Connection pooling** tab (NOT Transaction mode)
- Click **Show** to reveal password
- Copy the full connection string

**Connection String Format:**
```
postgresql://postgres.[project-ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres
```

### 2.3 Parse Connection Details
From the connection string, note:
- **Host**: `aws-0-[region].pooler.supabase.com`
- **Port**: `6543`
- **Database**: `postgres`
- **User**: `postgres.[project-ref]`
- **Password**: `[your-password]`
- **SSL**: `Required` (always enabled)

**SAVE THESE** - You'll need them for n8n configuration.

---

## 🤖 Step 3: Configure n8n (5-10 minutes)

### 3.1 Access n8n Instance
- Open: http://192.168.50.246:5678
- Verify you can access the interface

### 3.2 Create Supabase Credential

1. Click **Settings** (gear icon) → **Credentials**
2. Click **Add Credential**
3. Search for and select **Postgres**
4. Fill in the connection details:

| Field | Value |
|-------|-------|
| **Credential Name** | `Supabase Novel Writer` |
| **Host** | `aws-0-[region].pooler.supabase.com` |
| **Database** | `postgres` |
| **User** | `postgres.[project-ref]` |
| **Password** | `[your-password]` |
| **Port** | `6543` |
| **SSL** | `allow` or `require` |

5. Click **Test Connection**
   - ✅ Should show: "Connection successful"
6. Click **Save**
7. **COPY THE CREDENTIAL ID** (you'll need it next)

### 3.3 Create/Verify OpenAI Credential

#### If OpenAI credential doesn't exist:
1. Click **Add Credential**
2. Search for and select **OpenAI**
3. Fill in:
   - **Credential Name**: `OpenAI`
   - **API Key**: Your OpenAI API key
4. Click **Save**
5. **COPY THE CREDENTIAL ID**

#### If OpenAI credential exists:
1. Find existing OpenAI credential
2. **COPY THE CREDENTIAL ID**

---

## 📥 Step 4: Import Workflow (5 minutes)

### 4.1 Import Workflow File
1. In n8n, click **+** (top right) → **Import from File**
2. Navigate to: `C:\Users\bermi\Projects\novel-writer\workflow.json`
3. Select file and click **Open**
4. Workflow "Novel Writer - Self-Learning Prose System" will appear

### 4.2 Update Credential IDs

You need to update credential references in ALL postgres and OpenAI nodes:

1. Click on **first PostgreSQL node** ("Get Active Style Profile")
2. In the node panel, find **Credentials** section
3. Select your `Supabase Novel Writer` credential from dropdown
4. **Repeat for ALL PostgreSQL nodes** (there are 8 total):
   - Get Active Style Profile
   - Get Active Prompt
   - Get Next Chapter Number
   - Save Chapter
   - Save Evaluation
   - Check If Update Needed
   - Get Recent Evaluations
   - Get Passage Feedback
   - Save New Prompt Version

5. Update **OpenAI nodes** (there are 2):
   - Generate Chapter
   - Evaluate Prose Quality
   - Generate Improved Prompt

### 4.3 Save and Activate
1. Click **Save** (top right)
2. Toggle workflow to **Active**
3. You should see: "Workflow activated"

---

## 🧪 Step 5: Test the System (10 minutes)

### 5.1 Execute First Chapter Generation

1. Open the "Novel Writer - Self-Learning Prose System" workflow
2. Click **Execute Workflow** button (play icon, top right)
3. Watch the workflow execute through each node
4. Expected execution time: 60-120 seconds

### 5.2 Verify Execution

**Expected Result**: All nodes should show green checkmarks ✅

If any node fails:
- Click on the failed node
- Check error message
- Refer to Troubleshooting section below

### 5.3 Verify Data in Supabase

Go to Supabase → **SQL Editor** and run:

```sql
-- Check chapter was created
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

```sql
-- Check evaluation was created
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

**Expected**: 1 row with scores (1.00-5.00 range)

```sql
-- Check prompt version tracking
SELECT 
  version_number,
  is_active,
  trigger_reason
FROM prompt_versions 
ORDER BY created_at DESC;
```

**Expected**: 1 row, version_number = 1, is_active = true

### 5.4 Generate Second Chapter

1. Return to n8n workflow
2. Click **Execute Workflow** again
3. Verify execution completes successfully
4. Repeat verification queries above

---

## 🎉 Step 6: System Ready

Your novel-writer system is now operational!

### Quick Reference

**Generate Chapter:**
- n8n → Open workflow → Click "Execute Workflow"

**View Chapters:**
```sql
SELECT * FROM recent_chapters_with_scores ORDER BY generated_at DESC;
```

**View Performance:**
```sql
SELECT * FROM style_profile_performance;
```

**Add Passage Feedback:**
```sql
INSERT INTO passage_feedback (chapter_id, passage_text, liked, feedback_reason)
VALUES ('[chapter-id]', '[passage text]', true, '[reason]');
```

---

## 🐛 Troubleshooting

### Issue: SQL Deployment Fails

**Symptoms**: Errors when running DEPLOY_ALL.sql

**Solutions**:
- Ensure you're using PostgreSQL (Supabase uses Postgres)
- Check if tables already exist - drop them first if re-deploying
- Verify you have admin/owner permissions on the project

**Drop All Tables** (if needed):
```sql
DROP TABLE IF EXISTS learning_insights CASCADE;
DROP TABLE IF EXISTS passage_feedback CASCADE;
DROP TABLE IF EXISTS prose_evaluations CASCADE;
DROP TABLE IF EXISTS chapters CASCADE;
DROP TABLE IF EXISTS prompt_versions CASCADE;
DROP TABLE IF EXISTS style_profiles CASCADE;
DROP VIEW IF EXISTS style_profile_performance;
DROP VIEW IF EXISTS recent_chapters_with_scores;
DROP FUNCTION IF EXISTS get_active_prompt(UUID);
DROP FUNCTION IF EXISTS should_update_prompt(UUID);
DROP FUNCTION IF EXISTS create_prompt_version(UUID, TEXT, TEXT, UUID);
DROP FUNCTION IF EXISTS rollback_prompt_version(UUID);
DROP FUNCTION IF EXISTS update_updated_at();
```

Then re-run DEPLOY_ALL.sql.

### Issue: n8n Cannot Connect to Supabase

**Symptoms**: "Connection failed" or timeout errors

**Solutions**:
1. Verify connection string is correct
2. Ensure you're using **Connection Pooling** mode (port 6543, not 5432)
3. Check SSL is set to `allow` or `require`
4. Verify Supabase project is not paused (free tier pauses after inactivity)
5. Check firewall/network allows outbound connections to Supabase

**Test Connection Manually:**
```powershell
Test-NetConnection aws-0-us-west-1.pooler.supabase.com -Port 6543
```

### Issue: OpenAI API Errors

**Symptoms**: "Invalid API key" or "Rate limit exceeded"

**Solutions**:
1. Verify API key is correct and active
2. Check OpenAI account has available credits
3. Check rate limits: https://platform.openai.com/account/rate-limits
4. If using free tier, consider upgrading for higher limits

### Issue: Workflow Node Fails

**Symptoms**: Red X on specific node

**Solutions**:

**"Get Active Style Profile" fails:**
- Run: `SELECT * FROM style_profiles WHERE active = true;`
- Ensure at least one profile exists and active = true

**"Generate Chapter" or "Evaluate Prose" fails:**
- Check OpenAI credential is valid
- Verify API has credits
- Check for rate limiting

**"Save Chapter" or "Save Evaluation" fails:**
- Check Supabase credential is correct
- Verify tables exist
- Check for data type mismatches

**"Generate Improved Prompt" not triggering:**
- This only triggers when avg score < 3.5
- Generate at least 3 chapters first
- Check: `SELECT should_update_prompt('[profile-id]'::uuid);`

### Issue: Chapters Generated But No Auto-Update

**Expected Behavior**: Prompt only updates if average of last 3 chapters < 3.5

**To Force Update** (for testing):
```sql
-- Temporarily lower threshold to 5.0 to force update
CREATE OR REPLACE FUNCTION should_update_prompt(p_style_profile_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN true; -- Always return true for testing
END;
$$ LANGUAGE plpgsql;
```

Remember to restore original function after testing!

---

## 📞 Support Resources

- **Supabase Docs**: https://supabase.com/docs
- **n8n Docs**: https://docs.n8n.io
- **OpenAI API Docs**: https://platform.openai.com/docs

---

## ✅ Deployment Complete

Once all steps are completed and tests pass, your system is ready for production use.

**System Status:**
- [ ] Database deployed
- [ ] Credentials configured
- [ ] Workflow imported and activated
- [ ] Test chapter generated successfully
- [ ] Data verified in Supabase

**Next Steps:**
- Generate 3-5 chapters to establish baseline
- Review chapter quality
- Add passage feedback for liked/disliked content
- Monitor prompt evolution
- Customize style profiles as needed

---

**Deployed**: [Current Date]  
**Version**: 1.0.0  
**Location**: C:\Users\bermi\Projects\novel-writer\
