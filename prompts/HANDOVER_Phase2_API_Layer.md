# HANDOVER: Novel Planning Suite - Phase 2 API Layer Implementation

**From:** Warp Agent (Execution AI)
**To:** Emergent/Claude (Design AI)
**Date:** 2025-12-24
**Phase:** 2 - API Layer Development
**Status:** Phase 1 (Database) COMPLETE ✅

---

## CONTEXT: What Has Been Completed

### Phase 1: Database Schema - DEPLOYED ✅

The database foundation is live on Supabase (Project: "self learning composer", ID: ylcepmvbjjnwmzvevxid, Region: eu-west-3).

**12 Tables Created:**
- `series` - Multi-project container (partition key for all other tables)
- `books` - Books within series, linked to `style_profiles` for novel-writer integration
- `characters` - Characters with relationships, traits, arcs
- `worlds` - World building with culture, history, rules
- `locations` - Hierarchical locations within worlds
- `story_arcs` - Plot arcs with beat tracking
- `scene_outlines` - Chapter/scene planning with characters and locations
- `songs` - Music with Suno API fields (suno_prompt, suno_audio_url, suno_song_id, suno_metadata)
- `planning_conversations` - Full conversation history with decisions extraction
- `ideas` - Brainstorming with status tracking
- `copyright_checks` - Similarity detection with detailed results
- `content_quality_checks` - Multi-type quality assessment

**3 Helper Views:**
- `active_series_summary` - Series overview with counts
- `book_progress` - Writing progress tracking
- `character_relationships` - Relationship network

**Database Connection:**
```
Host: aws-1-eu-west-3.pooler.supabase.com:5432
Database: postgres
User: postgres.ylcepmvbjjnwmzvevxid
Password: Ballybought1985!
Project URL: https://ylcepmvbjjnwmzvevxid.supabase.co
```

**Key Design Principles:**
- Multi-project architecture via `series_id` partition key
- CASCADE DELETE from series ensures data integrity
- Integration points: `books.style_profile_id` → existing n8n workflow, `songs.chapter_id` → generated chapters
- JSONB for flexible schema-less data (traits, relationships, decisions, plot_points, etc.)

---

## YOUR TASK: Design & Implement API Layer

### Objective
Build a RESTful API or Supabase Edge Functions to provide CRUD operations and business logic for the Novel Planning Suite.

### Requirements

#### 1. Technology Stack Decision
**Choose ONE approach:**

**Option A: Supabase Edge Functions (Recommended)**
- Pros: Native integration, auto-auth, direct DB access, serverless
- Cons: Deno runtime (not Node.js)
- Location: Supabase Dashboard → Edge Functions

**Option B: Node.js/Express API**
- Pros: Full Node ecosystem, easier LLM SDK integration
- Cons: Requires separate hosting, auth setup
- Stack: Express + Supabase JS client

**Decision Required:** Document your choice and rationale in `docs/API_ARCHITECTURE.md`

#### 2. Core API Endpoints

Design and implement endpoints for all entities. Minimum required:

**Series Management:**
- `POST /series` - Create new series/project
- `GET /series` - List all active series
- `GET /series/:id` - Get series details with counts
- `PATCH /series/:id` - Update series
- `DELETE /series/:id` - Soft delete (set is_active=false)

**Books:**
- `POST /series/:seriesId/books` - Create book
- `GET /series/:seriesId/books` - List books in series
- `GET /books/:id` - Get book with progress stats
- `PATCH /books/:id` - Update book
- `DELETE /books/:id` - Delete book

**Characters:**
- `POST /series/:seriesId/characters` - Create character
- `GET /series/:seriesId/characters` - List characters (with filtering by role)
- `GET /characters/:id` - Get character details with relationships
- `PATCH /characters/:id` - Update character
- `PATCH /characters/:id/relationships` - Update character relationships
- `DELETE /characters/:id` - Delete character

**Worlds & Locations:**
- `POST /series/:seriesId/worlds` - Create world
- `GET /series/:seriesId/worlds` - List worlds
- `POST /worlds/:worldId/locations` - Create location
- `GET /worlds/:worldId/locations` - List locations (hierarchical)
- Similar PATCH/DELETE endpoints

**Story Arcs:**
- `POST /series/:seriesId/arcs` - Create arc
- `GET /series/:seriesId/arcs` - List arcs (filter by book, type, status)
- `PATCH /arcs/:id/plot-points` - Update plot beats
- Similar full CRUD

**Scene Outlines:**
- `POST /books/:bookId/scenes` - Create scene outline
- `GET /books/:bookId/scenes` - List scenes by chapter
- Similar full CRUD

**Songs:**
- `POST /series/:seriesId/songs` - Create song
- `POST /songs/:id/generate-suno` - Trigger Suno API generation
- `GET /songs/:id` - Get song with audio URL
- Similar full CRUD

**Planning Conversations:**
- `POST /series/:seriesId/conversations` - Start conversation
- `POST /conversations/:id/messages` - Add message to conversation
- `GET /conversations/:id` - Get full conversation thread
- `POST /conversations/:id/extract-decisions` - Extract structured decisions from conversation

**Ideas:**
- `POST /series/:seriesId/ideas` - Create idea
- `GET /series/:seriesId/ideas` - List ideas (filter by type, status)
- `PATCH /ideas/:id/status` - Update idea status
- Similar full CRUD

**Quality & Copyright:**
- `POST /copyright-check` - Run copyright check
- `POST /quality-check` - Run quality assessment
- `GET /series/:seriesId/checks` - List all checks for series

#### 3. Business Logic Requirements

**Validation:**
- Series name required
- Book must have valid series_id
- Character relationships must reference valid character IDs
- Location parent_location_id must reference valid location in same world

**Computed Fields:**
- Book progress percentage (from book_progress view)
- Character count per series (from active_series_summary view)
- Scene ordering by chapter_number + scene_number

**Cascade Behavior:**
- Deleting series → cascade deletes all related entities (already handled by DB)
- Deleting world → cascade deletes all locations
- Soft delete series (set is_active=false) preferred over hard delete

#### 4. Integration Endpoints

**n8n Novel Writer Webhook:**
- `POST /books/:bookId/start-writing` - Trigger n8n workflow
- Payload: `{ style_profile_id, book_id, series_id }`
- Target: http://192.168.50.246:5678 (per user rules)

**Suno Music Generation:**
- `POST /songs/:id/generate` - Generate music via Suno API
- Update `suno_prompt`, `suno_audio_url`, `suno_song_id`, `suno_metadata`
- Suno API docs: [research required]

#### 5. OpenAI Integration (Prep for Phase 3)

Create placeholder service structure:
- `services/openai-conversation.js` - Conversation handler (to be implemented in Phase 3)
- `services/decision-extractor.js` - Extract decisions from conversation (to be implemented in Phase 3)
- `services/knowledge-base.js` - Retrieve context from chapters/evaluations (to be implemented in Phase 3)

Document the interfaces these services should implement.

---

## DELIVERABLES

### 1. Architecture Document
**File:** `C:\Users\bermi\Projects\novel-writer\docs\API_ARCHITECTURE.md`

**Contents:**
- Technology choice (Supabase Functions vs Node/Express) with rationale
- Project structure
- Authentication strategy (Supabase Auth or API keys for personal use)
- Error handling approach
- Logging strategy
- Environment variables list

### 2. API Implementation
**Location:** 
- If Supabase: `C:\Users\bermi\Projects\novel-writer\supabase\functions\`
- If Node: `C:\Users\bermi\Projects\novel-writer\api\`

**Structure:**
```
api/
├── routes/
│   ├── series.js
│   ├── books.js
│   ├── characters.js
│   ├── worlds.js
│   ├── locations.js
│   ├── arcs.js
│   ├── scenes.js
│   ├── songs.js
│   ├── conversations.js
│   ├── ideas.js
│   └── checks.js
├── services/
│   ├── database.js (Supabase client)
│   ├── suno.js (Suno API client - stub for now)
│   ├── n8n-webhook.js (n8n trigger client)
│   ├── openai-conversation.js (stub for Phase 3)
│   ├── decision-extractor.js (stub for Phase 3)
│   └── knowledge-base.js (stub for Phase 3)
├── middleware/
│   ├── auth.js (if needed)
│   ├── validation.js
│   └── error-handler.js
├── utils/
│   └── response.js (standardized responses)
├── config/
│   └── database.js
├── .env.example
├── package.json
├── README.md
└── server.js (or index.js)
```

### 3. API Documentation
**File:** `C:\Users\bermi\Projects\novel-writer\docs\API_REFERENCE.md`

**Format:** OpenAPI/Swagger spec or detailed markdown with:
- All endpoints with HTTP methods
- Request/response examples
- Error codes
- Authentication requirements

### 4. Environment Setup Guide
**File:** `C:\Users\bermi\Projects\novel-writer\docs\API_SETUP.md`

**Contents:**
- Installation instructions
- Environment variables configuration
- Database connection setup
- Running locally
- Testing endpoints (provide curl examples or Postman collection)

### 5. Integration Stubs
**Files:**
- `services/suno.js` - Suno API client (research API, implement basic structure)
- `services/n8n-webhook.js` - n8n trigger (implement, should be simple HTTP POST)
- `services/openai-conversation.js` - OpenAI service interface (stub only)

### 6. Test Suite (Basic)
**File:** `C:\Users\bermi\Projects\novel-writer\api\tests\`

**Minimum:**
- Basic endpoint smoke tests
- Database connection test
- Example request/response tests for at least 3 endpoints

---

## DESIGN CONSTRAINTS

### Must Follow

1. **Database-First:** Do NOT modify database schema. Use existing tables/columns only.

2. **No Self-Execution:** You are DESIGN AI. Do NOT:
   - Run npm install
   - Start servers
   - Execute tests
   - Deploy code
   - Modify files outside the project directory
   
   **Create handover document for Warp when ready for execution.**

3. **Personal Use:** Basic auth is sufficient (API keys or Supabase RLS). No enterprise security needed.

4. **n8n Instance:** All n8n integrations must use http://192.168.50.246:5678 (per user rules).

5. **Integration Readiness:** Design with Phase 3 (LLM) and Phase 4 (Frontend) in mind. Services should be easily consumable by Next.js frontend.

---

## RESEARCH REQUIRED

You'll need to research:

1. **Suno API:**
   - API endpoint
   - Authentication method
   - Request/response format for music generation
   - Rate limits
   - Pricing (document for user)

2. **n8n Webhook:**
   - Best way to trigger workflow programmatically
   - Webhook URL format
   - Required payload structure
   - Authentication if needed

3. **Supabase Edge Functions vs Node/Express:**
   - Pros/cons for this use case
   - LLM SDK compatibility (OpenAI SDK works in both?)
   - Development experience
   - Cold start performance

---

## SUCCESS CRITERIA

Phase 2 is complete when:

✅ All 12 entity types have full CRUD operations
✅ API is documented (endpoints, examples, setup)
✅ Database connection working
✅ n8n webhook integration working (can trigger workflow)
✅ Suno API client structure ready (even if stub)
✅ OpenAI service interfaces defined for Phase 3
✅ Basic tests pass
✅ README with setup instructions exists
✅ Handover document created for Warp to execute/deploy

---

## HANDOVER BACK TO WARP

When your design is complete, create:

**File:** `C:\Users\bermi\Projects\novel-writer\prompts\HANDOVER_Phase2_EXECUTE.md`

**Contents:**
- Summary of what was designed
- File locations
- Installation commands for Warp to run
- Environment setup steps
- Testing commands
- Deployment steps (if applicable)
- Any issues/blockers encountered

**Format:**
```markdown
# EXECUTE: Phase 2 API Layer

## Summary
[Brief overview of what was implemented]

## Files Created
[List all files with descriptions]

## Warp: Execute These Commands
[Step-by-step commands to install, setup, test]

## Verification Steps
[How to verify API is working]

## Integration Tests
[Commands to test n8n webhook, database connection]

## Known Issues
[Any blockers or decisions needed]

## Ready for Phase 3?
[Yes/No with explanation]
```

---

## QUESTIONS/CLARIFICATIONS

If you need clarification on any requirements, document questions in:

**File:** `C:\Users\bermi\Projects\novel-writer\docs\PHASE2_QUESTIONS.md`

Tag user for review before proceeding if critical decisions are needed.

---

## PROJECT PHILOSOPHY REMINDER

**Database-First:** The data layer is the source of truth. API is a thin layer exposing database operations.

**LLM Integration:** Phase 3 will add OpenAI conversational planning. Keep API design compatible with streaming responses, long-running operations, and context retrieval.

**Frontend Ready:** Phase 4 will build Next.js UI consuming this API. Think about what frontend developers will need (filtering, sorting, pagination, search).

---

**BEGIN PHASE 2 DESIGN & IMPLEMENTATION NOW.**

Co-Authored-By: Warp <agent@warp.dev>
