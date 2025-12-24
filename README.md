# Novel Writer - Self-Learning Prose System

A self-improving novel chapter generation system that evaluates prose quality, learns from feedback, and automatically updates its writing prompts to improve over time.

## 🎯 Features

- **Automated Chapter Generation**: Uses GPT-4 to generate novel chapters based on style profiles
- **5-Criteria Prose Evaluation**: Automatically evaluates chapters on clarity, engagement, pacing, voice consistency, and technical quality
- **Self-Learning**: When average scores drop below 3.5/5, the system automatically improves its writing prompt
- **User Feedback Learning**: Learn from liked/disliked passages to refine writing style
- **Prompt Version Control**: Full versioning with rollback capability
- **Performance Tracking**: Monitor improvement over time with built-in analytics views

## 📋 System Requirements

- Supabase account (PostgreSQL database)
- n8n instance (http://192.168.50.246:5678)
- OpenAI API key

## 🚀 Deployment Instructions

### Step 1: Deploy Database Schema

1. Open your Supabase dashboard: https://supabase.com/dashboard
2. Select your project (or create a new one)
3. Navigate to **SQL Editor**
4. Copy the entire contents of `DEPLOY_ALL.sql`
5. Paste into the SQL Editor
6. Click **Run** to execute

The script will create:
- 6 tables (style_profiles, chapters, prose_evaluations, passage_feedback, prompt_versions, learning_insights)
- 4 database functions (get_active_prompt, should_update_prompt, create_prompt_version, rollback_prompt_version)
- 2 analytics views (style_profile_performance, recent_chapters_with_scores)
- Sample "Default Literary Fiction" style profile

### Step 2: Get Supabase Connection String

1. In Supabase Dashboard → **Settings** → **Database**
2. Find **Connection String** section
3. Select **Connection pooling** mode (recommended for n8n)
4. Copy the connection string (format: `postgresql://postgres.[project-ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres`)
5. Save this for n8n configuration

Example format:
```
Host: aws-0-us-west-1.pooler.supabase.com
Port: 6543
Database: postgres
User: postgres.xxxxxxxxxxxx
Password: [your-password]
SSL: Required
```

### Step 3: Configure n8n Credentials

1. Open n8n: http://192.168.50.246:5678
2. Go to **Settings** → **Credentials**
3. Create **PostgreSQL** credential:
   - Name: `Supabase Novel Writer`
   - Use connection string from Step 2
   - Enable SSL
   - Test connection
4. Create **OpenAI** credential (if not already exists):
   - Name: `OpenAI`
   - API Key: Your OpenAI API key

### Step 4: Import n8n Workflow

1. In n8n, click **+** → **Import from File**
2. Select `workflow.json`
3. The workflow will be imported
4. Update credential references:
   - Replace `{{SUPABASE_CREDENTIALS_ID}}` with your Supabase credential ID
   - Replace `{{OPENAI_CREDENTIALS_ID}}` with your OpenAI credential ID
5. **Save** the workflow
6. **Activate** the workflow

## 🎮 How to Use

### Generate a Chapter

1. Open the "Novel Writer - Self-Learning Prose System" workflow
2. Click **Execute Workflow** (manual trigger)
3. The system will:
   - Fetch the active style profile
   - Get the current writing prompt
   - Generate the next chapter
   - Evaluate the prose quality (5 criteria)
   - Save chapter and evaluation
   - Check if prompt needs updating (if avg score < 3.5)
   - Auto-update prompt if needed

### Review Generated Chapters

Query Supabase to view chapters:
```sql
SELECT * FROM recent_chapters_with_scores ORDER BY generated_at DESC;
```

### Provide Passage Feedback

Mark passages you like or dislike to help the system learn:
```sql
INSERT INTO passage_feedback (
  chapter_id, 
  passage_text, 
  liked, 
  feedback_reason
) VALUES (
  '[chapter-uuid]',
  'The passage text you liked/disliked',
  true,  -- or false
  'Why you liked/disliked it'
);
```

### View Performance Metrics

```sql
SELECT * FROM style_profile_performance;
```

### Rollback Prompt Version

If a prompt update makes things worse:
```sql
SELECT rollback_prompt_version('[version-uuid]'::uuid);
```

## 📊 Database Schema Overview

### Core Tables

- **style_profiles**: Writing style definitions and base prompts
- **chapters**: Generated novel chapters with metadata
- **prose_evaluations**: Quality scores (1-5 on 5 criteria)
- **passage_feedback**: User likes/dislikes on specific passages
- **prompt_versions**: Version-controlled writing prompts
- **learning_insights**: Extracted patterns from feedback

### Key Functions

- `get_active_prompt(profile_id)`: Get current active writing prompt
- `should_update_prompt(profile_id)`: Check if avg score < 3.5 in last 3 chapters
- `create_prompt_version(...)`: Create new prompt version with tracking
- `rollback_prompt_version(version_id)`: Revert to previous prompt

## 🔧 Customization

### Create a New Style Profile

```sql
INSERT INTO style_profiles (name, description, base_prompt) VALUES (
  'Dark Gothic Horror',
  'Gothic horror with atmospheric dread and psychological tension',
  'Write in a gothic horror style with rich atmospheric details, psychological unease, and Victorian-era sensibilities. Use archaic language sparingly. Build tension through environment and implication rather than explicit horror.'
);

-- Create initial prompt version
INSERT INTO prompt_versions (style_profile_id, version_number, prompt_text, trigger_reason, is_active)
SELECT id, 1, base_prompt, 'Initial version', true
FROM style_profiles WHERE name = 'Dark Gothic Horror';
```

### Adjust Auto-Update Threshold

Edit the `should_update_prompt` function to change the score threshold (default: 3.5):

```sql
CREATE OR REPLACE FUNCTION should_update_prompt(p_style_profile_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    recent_avg_score NUMERIC(3,2);
BEGIN
    SELECT AVG(pe.overall_score) INTO recent_avg_score
    FROM prose_evaluations pe
    JOIN chapters c ON c.id = pe.chapter_id
    WHERE c.style_profile_id = p_style_profile_id
    ORDER BY pe.evaluated_at DESC
    LIMIT 3;
    
    -- Change 3.5 to your preferred threshold
    RETURN (recent_avg_score IS NOT NULL AND recent_avg_score < 3.8);
END;
$$ LANGUAGE plpgsql;
```

## 📈 Monitoring & Analytics

### View Prompt Evolution

```sql
SELECT 
  version_number,
  LEFT(prompt_text, 100) as prompt_preview,
  trigger_reason,
  avg_score_before,
  is_active,
  created_at
FROM prompt_versions
WHERE style_profile_id = '[your-profile-id]'
ORDER BY version_number DESC;
```

### Analyze Score Trends

```sql
SELECT 
  chapter_number,
  overall_score,
  clarity_score,
  engagement_score,
  pacing_score,
  generated_at
FROM recent_chapters_with_scores
WHERE style_profile = 'Default Literary Fiction'
ORDER BY chapter_number;
```

## 🐛 Troubleshooting

### Workflow Not Executing
- Check n8n credentials are properly configured
- Verify Supabase connection string is correct
- Ensure SSL is enabled for Supabase connection

### Chapters Not Generating
- Verify OpenAI API key is valid and has credits
- Check OpenAI API rate limits
- Review n8n execution logs

### Prompt Not Auto-Updating
- Verify average score is below threshold (< 3.5)
- Check that at least 3 chapters have been generated
- Review `should_update_prompt` function logic

## 📝 License

This project is provided as-is for personal use.

## 🤝 Support

For issues or questions, review the n8n execution logs and Supabase database logs.

---

**Created**: December 23, 2024
**Version**: 1.0.0
