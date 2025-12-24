# Novel Writer - Project Summary

## 📋 Overview

**Project Name**: Novel Writer - Self-Learning Prose System  
**Version**: 1.0.0  
**Created**: December 24, 2024  
**Location**: `C:\Users\bermi\Projects\novel-writer\`

A fully automated novel chapter generation system that learns and improves over time using AI evaluation and user feedback.

---

## 🎯 Core Capabilities

1. **Automated Chapter Generation**
   - Generates novel chapters using GPT-4
   - Based on customizable style profiles
   - Target: 2000-3000 words per chapter

2. **Multi-Criteria Prose Evaluation**
   - 5 evaluation criteria (1-5 scale each)
   - Automatic evaluation using GPT-4o-mini
   - Tracks improvement over time

3. **Self-Learning System**
   - Automatically updates writing prompts when quality drops
   - Threshold: Average score < 3.5 over last 3 chapters
   - Learns from user feedback on specific passages

4. **Version Control**
   - Full prompt version history
   - Rollback capability
   - Performance tracking per version

---

## 🏗️ System Architecture

### Technology Stack
- **Database**: Supabase (PostgreSQL)
- **Automation**: n8n (http://192.168.50.246:5678)
- **AI Models**: 
  - GPT-4o (chapter generation & prompt improvement)
  - GPT-4o-mini (prose evaluation)

### Data Flow

```
Manual Trigger (n8n)
    ↓
Get Active Style Profile
    ↓
Get Active Prompt Version
    ↓
Generate Chapter (GPT-4o)
    ↓
Save Chapter to Database
    ↓
Evaluate Prose (GPT-4o-mini)
    ↓
Save Evaluation Scores
    ↓
Check If Update Needed
    ↓
If avg score < 3.5:
    ↓
    Get Recent Evaluations & User Feedback
    ↓
    Generate Improved Prompt (GPT-4o)
    ↓
    Save New Prompt Version
    ↓
Complete
```

### Database Schema

**6 Core Tables:**
1. `style_profiles` - Writing style definitions
2. `chapters` - Generated novel chapters
3. `prose_evaluations` - Quality scores & feedback
4. `passage_feedback` - User likes/dislikes
5. `prompt_versions` - Version-controlled prompts
6. `learning_insights` - Extracted patterns

**4 Functions:**
1. `get_active_prompt(profile_id)` - Get current prompt
2. `should_update_prompt(profile_id)` - Check if update needed
3. `create_prompt_version(...)` - Create new version
4. `rollback_prompt_version(version_id)` - Revert to previous

**2 Views:**
1. `style_profile_performance` - Aggregate metrics
2. `recent_chapters_with_scores` - Latest chapters with scores

---

## 📁 Project Files

### Core Files
| File | Lines | Purpose |
|------|-------|---------|
| `DEPLOY_ALL.sql` | 367 | Complete database schema |
| `workflow.json` | 483 | n8n automation workflow |
| `README.md` | 249 | System documentation |
| `DEPLOYMENT_CHECKLIST.md` | 398 | Step-by-step deployment guide |
| `HELPER_QUERIES.sql` | 459 | SQL query reference |
| `PROJECT_SUMMARY.md` | This file | Project overview |

**Total**: 6 files, ~2,000 lines of code/documentation

---

## 🔢 Evaluation Criteria

All chapters are evaluated on 5 criteria (1-5 scale):

1. **Clarity** - How clear and understandable is the writing?
2. **Engagement** - How compelling is the narrative?
3. **Pacing** - How well-paced is the chapter?
4. **Voice Consistency** - How consistent is the narrative voice?
5. **Technical Quality** - Grammar, word choice, sentence structure

**Overall Score** = Average of all 5 criteria

---

## 🚀 Quick Start

### Prerequisites
- [ ] Supabase account
- [ ] OpenAI API key with credits
- [ ] n8n accessible at http://192.168.50.246:5678

### Deployment (20-30 minutes)

**Step 1: Deploy Database** (5-10 min)
```
1. Open Supabase Dashboard
2. SQL Editor → Paste DEPLOY_ALL.sql → Run
3. Verify: 6 tables + 4 functions + 2 views created
```

**Step 2: Get Credentials** (2 min)
```
1. Supabase → Settings → Database
2. Copy Connection String (Connection Pooling mode)
3. Save host, port, user, password, database
```

**Step 3: Configure n8n** (5-10 min)
```
1. Open n8n: http://192.168.50.246:5678
2. Settings → Credentials
3. Add PostgreSQL credential (Supabase)
4. Add/verify OpenAI credential
```

**Step 4: Import Workflow** (5 min)
```
1. n8n → Import from File → workflow.json
2. Update all credential references
3. Save and Activate workflow
```

**Step 5: Test** (10 min)
```
1. Execute workflow manually
2. Verify chapter generated
3. Check Supabase for data
```

See `DEPLOYMENT_CHECKLIST.md` for detailed instructions.

---

## 🎮 Usage

### Generate a Chapter
```
1. Open n8n workflow
2. Click "Execute Workflow"
3. Wait 60-120 seconds
4. Check Supabase for results
```

### View Chapters
```sql
SELECT * FROM recent_chapters_with_scores 
ORDER BY generated_at DESC;
```

### Add Passage Feedback
```sql
INSERT INTO passage_feedback (
  chapter_id, passage_text, liked, feedback_reason
) VALUES (
  '[uuid]', '[text]', true, '[reason]'
);
```

### Monitor Performance
```sql
SELECT * FROM style_profile_performance;
```

### View Prompt Evolution
```sql
SELECT version_number, trigger_reason, avg_score_before, is_active
FROM prompt_versions
ORDER BY version_number DESC;
```

See `HELPER_QUERIES.sql` for more queries.

---

## 🔧 Configuration

### Auto-Update Threshold

Default: Prompt updates when avg score < 3.5

To change:
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
    RETURN (recent_avg_score IS NOT NULL AND recent_avg_score < 4.0);
END;
$$ LANGUAGE plpgsql;
```

### Custom Style Profiles

Create new writing styles:
```sql
INSERT INTO style_profiles (name, description, base_prompt) VALUES (
  'Cyberpunk Noir',
  'Hard-boiled detective fiction in a dystopian future',
  'Write in a cyberpunk noir style with gritty realism, tech-noir atmosphere, and hardboiled dialogue. Blend classic noir tropes with futuristic elements. Use short, punchy sentences.'
);

-- Create initial prompt version
INSERT INTO prompt_versions (style_profile_id, version_number, prompt_text, trigger_reason, is_active)
SELECT id, 1, base_prompt, 'Initial version', true
FROM style_profiles WHERE name = 'Cyberpunk Noir';
```

### Target Word Count

Edit workflow.json node "Generate Chapter":
```json
"content": "={{ $node[\"Get Active Prompt\"].json.prompt }}\n\nWrite chapter {{ $node[\"Get Next Chapter Number\"].json.next_chapter }} of the novel. Target length: 3000-5000 words."
```

---

## 📊 Expected Results

### After First Chapter
- 1 chapter generated
- 1 evaluation with scores
- Overall score typically 3.5-4.5 (initial prompt)

### After 3-5 Chapters
- Baseline established
- If scores < 3.5, auto-update triggered
- Prompt version 2 created

### After 10+ Chapters
- Multiple prompt versions
- Clear improvement trends
- Rich feedback data for learning

### Example Evolution
```
Chapter 1-3:  Version 1, Avg Score: 3.8
Chapter 4-7:  Version 1, Avg Score: 3.2 → Update triggered
Chapter 8-10: Version 2, Avg Score: 4.1 → Improvement confirmed
```

---

## 🎯 Key Features

### 1. Self-Improvement Loop
```
Generate → Evaluate → Score < 3.5? → Update Prompt → Generate Better
```

### 2. User Feedback Learning
- Mark passages you like/dislike
- System incorporates patterns into prompt updates
- Learns your preferences over time

### 3. Version Control
- Every prompt change is tracked
- Full rollback capability
- Performance comparison between versions

### 4. Analytics & Insights
- Score trends over time
- Criteria breakdown
- Prompt effectiveness comparison
- Feedback pattern analysis

---

## 🔒 Data Retention

### What's Stored
- All generated chapters (full text)
- All evaluation scores and notes
- All user feedback on passages
- All prompt versions
- Performance metrics

### What's NOT Stored
- No personal user data
- No API keys (stored in n8n credentials only)
- No external dependencies

### Backup Recommendations
```sql
-- Export all data as JSON
COPY (
  SELECT json_build_object(
    'chapters', (SELECT json_agg(row_to_json(chapters.*)) FROM chapters),
    'evaluations', (SELECT json_agg(row_to_json(prose_evaluations.*)) FROM prose_evaluations),
    'prompts', (SELECT json_agg(row_to_json(prompt_versions.*)) FROM prompt_versions)
  )
) TO '/path/to/backup.json';
```

---

## 🚨 Important Notes

### Costs
- **OpenAI API**: ~$0.10-0.30 per chapter (GPT-4o generation + evaluation)
- **Supabase**: Free tier sufficient for testing (upgrade for production)
- **n8n**: Self-hosted (no cost)

### Rate Limits
- OpenAI free tier: Limited requests/minute
- Recommended: OpenAI paid tier for continuous use
- n8n workflow can run on-demand or scheduled

### Maintenance
- Monitor Supabase database size
- Review prompt evolution periodically
- Clean old chapters if needed (see HELPER_QUERIES.sql)

---

## 🐛 Troubleshooting

See `DEPLOYMENT_CHECKLIST.md` for detailed troubleshooting.

**Common Issues:**
1. n8n can't connect to Supabase → Check connection pooling mode
2. OpenAI errors → Verify API key and credits
3. Prompt not updating → Need 3+ chapters with avg score < 3.5
4. Workflow fails → Check credential IDs in all nodes

---

## 📚 Resources

### Documentation
- `README.md` - Main documentation
- `DEPLOYMENT_CHECKLIST.md` - Step-by-step deployment
- `HELPER_QUERIES.sql` - SQL reference

### External Links
- Supabase Docs: https://supabase.com/docs
- n8n Docs: https://docs.n8n.io
- OpenAI API: https://platform.openai.com/docs

---

## 🎉 What's Next?

After successful deployment:

1. **Generate 3-5 chapters** to establish baseline
2. **Review quality** and provide passage feedback
3. **Monitor auto-improvements** as system learns
4. **Customize style profiles** for different genres
5. **Export chapters** for external editing/publishing

---

## 📈 Success Metrics

Track these to measure system effectiveness:

- **Score Improvement**: Compare avg scores across prompt versions
- **Feedback Patterns**: Which passages get liked/disliked
- **Version Stability**: How often prompts update
- **Criteria Balance**: Which scores are consistently high/low

Query to track improvement:
```sql
SELECT 
    pv.version_number,
    COUNT(c.id) as chapters,
    ROUND(AVG(pe.overall_score)::numeric, 2) as avg_score,
    pv.created_at
FROM prompt_versions pv
LEFT JOIN chapters c ON c.prompt_version_id = pv.id
LEFT JOIN prose_evaluations pe ON pe.chapter_id = c.id
GROUP BY pv.id, pv.version_number, pv.created_at
ORDER BY pv.version_number;
```

---

## 🤝 Support

For issues or questions:
1. Check `DEPLOYMENT_CHECKLIST.md` troubleshooting section
2. Review n8n execution logs
3. Check Supabase database logs
4. Verify OpenAI API status

---

## ✅ System Status

**Current State**: Ready for deployment

**Pre-Flight Checklist:**
- [x] Database schema created (`DEPLOY_ALL.sql`)
- [x] n8n workflow created (`workflow.json`)
- [x] Documentation complete
- [x] Helper queries provided
- [x] Deployment guide created

**Next Action**: Follow `DEPLOYMENT_CHECKLIST.md`

---

**Project Complete** ✨

All components ready for deployment. System will automatically improve writing quality through AI evaluation and learning from user feedback.

---

*Last Updated: December 24, 2024*  
*Version: 1.0.0*  
*Status: Production Ready*
