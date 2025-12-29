# EMERGENT HANDOVER: Novel Planning Suite Build

**Date:** 2025-12-29
**Project:** Novel Planning & Production Suite
**Location:** C:\Users\bermi\Projects\novel-planning-suite (to be created)
**Spec:** C:\Users\bermi\Projects\novel-writer\EMERGENT_PROMPT_Novel_Planning_Suite.md

---

## CURRENT STATE

### What Exists

| Component | Status | Location |
|-----------|--------|----------|
| Build Specification | ✅ Complete | `novel-writer/EMERGENT_PROMPT_Novel_Planning_Suite.md` |
| Database Schema | ✅ Complete | `novel-writer/migrations/002_planning_suite_schema.sql` |
| Supabase Project | ✅ Ready | ylcepmvbjjnwmzvevxid |
| Canon Data | ✅ Complete | `jesse-novel-factory/canon/CANON_SEED.json` |
| Agent Definitions | ✅ Complete | `jesse-novel-factory/agents/*.json` |
| n8n Workflows | ✅ Ready | `jesse-novel-factory/workflows/*.json` |
| SUNO API Key | ✅ Configured | d8038c1c9195ea0da6007532da395b28 |
| ElevenLabs Key | ✅ Configured | sk_ee0380a1d582835d18d086bb8802737805eb159ffc66f452 |

### What Needs Building

| Component | Priority | Description |
|-----------|----------|-------------|
| Next.js App | HIGH | Planning UI with chat interface |
| API Routes | HIGH | CRUD operations for all tables |
| OpenAI Integration | HIGH | Conversation logic |
| Suno Integration | MEDIUM | Song generation |
| Copyright Checker | LOW | Similarity detection |

---

## BUILD INSTRUCTIONS

### Phase 1: Create Project

```bash
cd C:\Users\bermi\Projects
npx create-next-app@latest novel-planning-suite --typescript --tailwind --eslint
cd novel-planning-suite
```

### Phase 2: Install Dependencies

```bash
npm install @supabase/supabase-js openai zustand lucide-react
npm install @radix-ui/react-dialog @radix-ui/react-tabs
```

### Phase 3: Environment Variables

Create `.env.local`:
```
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://ylcepmvbjjnwmzvevxid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<get from Supabase dashboard>
SUPABASE_SERVICE_ROLE_KEY=<get from Supabase dashboard>

# OpenAI
OPENAI_API_KEY=<from jesse-novel-factory .env>

# SUNO
SUNO_API_KEY=<from jesse-novel-factory .env>

# n8n
N8N_WEBHOOK_URL=http://192.168.50.246:5678/webhook/novel-writer
```

### Phase 4: Deploy Schema

Schema already exists at `C:\Users\bermi\Projects\novel-writer\migrations\002_planning_suite_schema.sql`

Deploy via Supabase SQL Editor or:
```bash
psql "postgresql://postgres.ylcepmvbjjnwmzvevxid:PASSWORD@aws-1-eu-west-3.pooler.supabase.com:5432/postgres" -f C:\Users\bermi\Projects\novel-writer\migrations\002_planning_suite_schema.sql
```

---

## INTEGRATION REQUIREMENTS

### Canon Data Access

Load canonical character/world data from jesse-novel-factory:
```javascript
// Path to canon
const CANON_PATH = 'C:\\Users\\bermi\\Documents\\GitHub\\jesse-novel-factory\\canon\\CANON_SEED.json';

// Or fetch via API if served
const canon = await fetch('/api/canon').then(r => r.json());
```

### Agent Prompts

When generating content, use agent prompts from:
`C:\Users\bermi\Documents\GitHub\jesse-novel-factory\prompts\`

- `showrunner.md` - Story oversight
- `canon_librarian.md` - Canon validation
- `continuity_qa.md` - Consistency checking
- `dialogue_punchup.md` - Dialogue polish
- `lyrics_room.md` - Song lyrics
- `structural_editor.md` - Chapter structure

### n8n Triggers

Trigger chapter generation:
```javascript
await fetch('http://192.168.50.246:5678/webhook/novel-writer', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    series_id: 'uuid',
    book_id: 'uuid',
    chapter_number: 1,
    scene_outline: 'outline text'
  })
});
```

---

## UI REQUIREMENTS

### Core Pages

1. **Dashboard** (`/`)
   - Active series list
   - Recent conversations
   - Quick actions

2. **Series View** (`/series/[id]`)
   - Books in series
   - Characters
   - World details
   - Story arcs

3. **Book View** (`/book/[id]`)
   - Chapter outlines
   - Scene breakdown
   - Songs
   - Quality scores

4. **Chat Interface** (`/chat`)
   - Full-width conversation
   - Context panel (characters, world, scenes)
   - Quick reference sidebar

5. **Music Studio** (`/music`)
   - Song list
   - Lyrics editor
   - SUNO generation
   - Audio preview

### Chat System Prompt

```
You are a collaborative novel planning assistant for the Jesse series.

CANON KNOWLEDGE:
- 10 characters: Jesse (dog), Kevin (dad), Emma, Amy, Laura, Ann, Grog, Lirian, Elandra, Malakar
- Magic: Collar grants speech in realm only, fades on Earth
- Tone: Irish banter, dry humor, no inspirational speeches

YOUR ROLE:
- Ask clarifying questions about plot and characters
- Suggest improvements and alternatives
- Maintain consistency with canon
- Reference past decisions

OUTPUT STRUCTURED JSON when making decisions:
{
  "topic": "character|plot|world|music",
  "decisions": [...],
  "next_steps": [...]
}
```

---

## GITHUB REPOSITORIES

| Repo | URL | Purpose |
|------|-----|---------|
| novel-writer | https://github.com/bermingham85/novel-writer | Specs & migrations |
| jesse-novel-factory | GitHub TBD | Canon & agents |
| self-improving-systems | https://github.com/zie619/self-improving-systems | Quality loops |

---

## SUCCESS CRITERIA

- [ ] Chat interface loads and responds
- [ ] Can create series/books/characters
- [ ] Canon validation works
- [ ] SUNO generates music
- [ ] n8n triggers chapter generation
- [ ] Quality scores display correctly
- [ ] All data persists to Supabase
