# HANDOVER: Novel Planning Suite - Phase 3 LLM Integration

**From:** Warp Agent (Execution AI)
**To:** Emergent/Claude (Design AI)
**Date:** 2025-12-24
**Phase:** 3 - OpenAI Conversational Planning
**Status:** BLOCKED - Requires Phase 2 API completion first

---

## PREREQUISITES

**Phase 2 must be complete before starting Phase 3:**
✅ API layer fully implemented
✅ All CRUD endpoints working
✅ Database integration verified
✅ Basic tests passing

**Do NOT start Phase 3 until Phase 2 handover is complete.**

---

## CONTEXT: What This Phase Adds

Phase 3 transforms the Novel Planning Suite from a data management system into an **AI-powered conversational novel planning assistant**.

### Core Capability
User has natural language conversations with GPT-4 to:
- Brainstorm and develop novel concepts
- Create and refine characters, worlds, story arcs
- Design plot structures and scene outlines
- Generate songs/music concepts for the story
- Make decisions that automatically populate the database

### Key Features
1. **Conversational Planning** - Natural dialogue for creative development
2. **Knowledge Base Retrieval** - Context from existing chapters, evaluations, characters
3. **Decision Extraction** - Structured data from freeform conversation
4. **Multi-Turn Context** - Maintain conversation history and decisions
5. **Entity Management** - Create/update database entities via conversation

---

## YOUR TASK: Design & Implement LLM Integration

### Objective
Build an OpenAI-powered conversational system that helps users plan novels through natural language interaction.

### Requirements

#### 1. Conversational Planning Service

**File:** `services/openai-conversation.js` (or TypeScript equivalent)

**Capabilities:**
- Accept user messages
- Maintain conversation context
- Retrieve relevant knowledge base items
- Generate intelligent responses
- Extract structured decisions from conversation
- Create/update database entities based on decisions

**Core Functions:**
```javascript
// Start new planning conversation
async function startConversation(seriesId, topic, initialMessage)

// Continue existing conversation
async function continueConversation(conversationId, userMessage)

// Get conversation history
async function getConversationHistory(conversationId)

// Extract and apply decisions
async function extractAndApplyDecisions(conversationId)
```

**Conversation Topics:**
- `character` - Character development
- `plot` - Story structure and arcs
- `world` - World building
- `music` - Song/music concepts
- `scene` - Scene planning
- `general` - Open-ended planning

#### 2. Knowledge Base Retrieval

**File:** `services/knowledge-base.js`

**Purpose:** Provide context to GPT-4 from existing data

**Retrieval Sources:**
- Existing chapters (from `chapters` table)
- Prose evaluations (from `prose_evaluations` table)
- Characters in series (from `characters` table)
- Worlds and locations (from `worlds`, `locations` tables)
- Story arcs (from `story_arcs` table)
- Previous conversation decisions (from `planning_conversations` table)
- Songs already created (from `songs` table)

**Core Functions:**
```javascript
// Get relevant chapters for context
async function getRelevantChapters(seriesId, query, limit = 5)

// Get character summaries
async function getCharacterContext(seriesId)

// Get world context
async function getWorldContext(seriesId)

// Get story arc summaries
async function getStoryArcContext(seriesId, bookId = null)

// Search existing content (semantic search or keyword)
async function searchContent(seriesId, query)

// Get recent conversation decisions
async function getRecentDecisions(seriesId, limit = 10)
```

**Context Building:**
- Summarize relevant context for GPT-4 system prompt
- Keep context under token limits (e.g., 8K tokens for context, leave room for conversation)
- Prioritize most recent and relevant information

#### 3. Decision Extraction Service

**File:** `services/decision-extractor.js`

**Purpose:** Parse conversation into structured data and create/update database entities

**Decision Types:**
- Character creation/updates
- World/location creation
- Story arc definition
- Scene outline creation
- Song/music concepts
- Plot point additions
- Ideas captured

**Core Functions:**
```javascript
// Extract structured decisions from conversation
async function extractDecisions(conversationData)

// Apply decisions to database (create/update entities)
async function applyDecisions(seriesId, decisions)

// Parse character decisions
async function parseCharacterDecisions(conversationText)

// Parse plot decisions
async function parsePlotDecisions(conversationText)

// Parse world-building decisions
async function parseWorldDecisions(conversationText)

// Parse song concepts
async function parseSongDecisions(conversationText)
```

**Decision Format (Example):**
```json
{
  "decisions": [
    {
      "type": "character_create",
      "data": {
        "name": "Elena Thornwood",
        "role": "protagonist",
        "description": "A brilliant quantum physicist...",
        "personality_traits": ["curious", "determined", "empathetic"],
        "background": "Grew up in...",
        "character_arc": "Learns to trust..."
      }
    },
    {
      "type": "story_arc_create",
      "data": {
        "title": "The Quantum Paradox",
        "arc_type": "main",
        "description": "Elena discovers...",
        "plot_points": [
          "Discovery of time anomaly",
          "First jump into past",
          "Meeting her future self",
          "Resolution at quantum level"
        ]
      }
    },
    {
      "type": "song_create",
      "data": {
        "title": "Echoes Through Time",
        "purpose": "Elena's character theme",
        "style": "Ambient electronic with orchestral elements",
        "mood": "Mysterious, hopeful",
        "lyrics": "Through the fabric of space and time..."
      }
    }
  ]
}
```

#### 4. GPT-4 System Prompts

**File:** `prompts/system-prompts.js`

Create tailored system prompts for each conversation topic:

**Character Planning Prompt:**
```
You are a creative writing assistant helping develop compelling characters for a novel.

Current Series: {series_name} ({genre})

Existing Characters:
{character_context}

Help the user:
- Develop character personalities, backgrounds, and arcs
- Create meaningful character relationships
- Ensure character consistency with world/plot
- Suggest character development opportunities

When decisions are made (character name, traits, arc), clearly state them in structured form.
```

**Plot Planning Prompt:**
```
You are a story structure expert helping develop plot and story arcs.

Current Series: {series_name}
Books: {books_context}
Existing Arcs: {arcs_context}

Help the user:
- Develop main plot and subplots
- Create compelling story arcs
- Structure plot beats and turning points
- Ensure plot consistency across series
- Connect character arcs to plot

Clearly state plot decisions in structured form.
```

**World Building Prompt:**
```
You are a world-building expert helping create rich, consistent fictional worlds.

Current Series: {series_name}
Existing Worlds: {worlds_context}

Help the user:
- Develop world history, geography, culture
- Create magic systems or technology frameworks
- Design locations and their significance
- Establish world rules and constraints
- Ensure world consistency

Clearly state world-building decisions in structured form.
```

**Music/Song Prompt:**
```
You are a creative consultant helping develop songs and music for a novel.

Current Series: {series_name}
Characters: {character_context}
Story Context: {story_context}

Help the user:
- Develop song concepts tied to story/characters
- Write lyrics that fit the narrative
- Define musical style and mood
- Plan song placement in story (theme song, character song, in-story performance)

Format song decisions for Suno API generation.
```

**General Planning Prompt:**
```
You are a novel planning assistant helping develop a comprehensive novel/series.

Series: {series_name} ({genre}, {target_audience})

Current State:
- Books: {book_count}
- Characters: {character_count}
- Worlds: {world_count}
- Chapters Written: {chapter_count}

Help the user with any aspect of novel planning. Draw connections between elements. Suggest what to develop next based on current state.
```

#### 5. Conversation Storage

**Database Integration:**
- Store full conversation in `planning_conversations.conversation_data` (JSONB array)
- Extract and store decisions in `planning_conversations.decisions_made` (JSONB)
- Track what context was used in `planning_conversations.context_used` (JSONB)

**Conversation Data Format:**
```json
{
  "messages": [
    {
      "role": "user",
      "content": "I want to create a character...",
      "timestamp": "2025-12-24T19:00:00Z"
    },
    {
      "role": "assistant",
      "content": "Great! Let's develop this character...",
      "timestamp": "2025-12-24T19:00:05Z"
    }
  ]
}
```

**Context Used Format:**
```json
{
  "chapters": [
    {"id": "uuid", "title": "Chapter 1", "relevance": "high"}
  ],
  "characters": [
    {"id": "uuid", "name": "Elena Thornwood"}
  ],
  "evaluations": [
    {"id": "uuid", "chapter_id": "uuid", "scores": {...}}
  ]
}
```

#### 6. API Endpoints (Extend Phase 2 API)

**New Endpoints:**

```
POST /conversations
  Body: { series_id, book_id?, topic, initial_message }
  Returns: { conversation_id, response }

POST /conversations/:id/messages
  Body: { message }
  Returns: { response, decisions_extracted? }

GET /conversations/:id
  Returns: { conversation_data, decisions_made, context_used, created_at }

POST /conversations/:id/extract-decisions
  Returns: { decisions: [...], entities_created: [...] }

GET /conversations/:id/context
  Returns: { chapters: [...], characters: [...], worlds: [...] }

POST /conversations/:id/regenerate
  Body: { from_message_index }
  Returns: { new_response }
```

#### 7. Streaming Support (Optional but Recommended)

Implement Server-Sent Events (SSE) for streaming GPT-4 responses:

```
GET /conversations/:id/stream
  Query: ?message=...
  Returns: SSE stream of response chunks
```

**Benefits:**
- Better UX (see response as it generates)
- Faster perceived performance
- Allows long responses without timeout

---

## DELIVERABLES

### 1. LLM Integration Architecture
**File:** `docs/LLM_ARCHITECTURE.md`

**Contents:**
- OpenAI API integration approach
- Token management strategy
- Context retrieval algorithm
- Decision extraction methodology
- Error handling for API failures
- Rate limiting strategy
- Cost estimation and optimization

### 2. Service Implementations
**Files:**
- `services/openai-conversation.js` - Main conversation handler
- `services/knowledge-base.js` - Context retrieval
- `services/decision-extractor.js` - Decision parsing and application
- `prompts/system-prompts.js` - GPT-4 system prompts
- `utils/token-counter.js` - Token counting and management

### 3. Extended API Routes
**Files:**
- `routes/conversations.js` - Conversation endpoints
- `routes/context.js` - Context retrieval endpoints (if separate)

### 4. Configuration
**Files:**
- `.env.example` - Add OPENAI_API_KEY
- `config/openai.js` - OpenAI client configuration

### 5. Documentation
**File:** `docs/CONVERSATION_GUIDE.md`

**Contents:**
- How to start conversations
- Example conversation flows
- Decision extraction examples
- Context retrieval mechanics
- Token limits and management
- Best practices for prompting

### 6. Testing
**Files:**
- `tests/conversation.test.js` - Conversation flow tests
- `tests/decision-extraction.test.js` - Decision parsing tests
- `tests/knowledge-base.test.js` - Context retrieval tests

**Test Scenarios:**
- Create character via conversation
- Develop plot arc through dialogue
- Extract multiple decisions from long conversation
- Retrieve relevant context from existing chapters
- Handle conversation errors gracefully

---

## DESIGN CONSTRAINTS

### Must Follow

1. **API Key Security:** OPENAI_API_KEY must be stored in environment variables, never in code.

2. **Token Management:** 
   - GPT-4 has token limits (e.g., 8K context, 128K for extended)
   - Budget tokens: ~70% context, ~30% response
   - Implement truncation strategies

3. **Cost Awareness:**
   - GPT-4 is expensive (~$0.03-0.06 per 1K tokens)
   - Implement caching where possible
   - Provide cost estimates in documentation
   - Consider GPT-3.5-turbo for decision extraction (cheaper)

4. **No Self-Execution:** You are DESIGN AI. Create handover for Warp to execute.

5. **Database Integration:** Use existing tables. Store conversations in `planning_conversations`, apply decisions to entity tables.

6. **Context Quality > Quantity:** Better to provide 3 highly relevant chapters than 10 marginally relevant ones.

---

## RESEARCH REQUIRED

1. **OpenAI API:**
   - Latest API version and endpoints
   - Streaming support (chat completions with stream=true)
   - Token counting methods
   - Rate limits and error codes
   - Best practices for system prompts

2. **Decision Extraction:**
   - Function calling vs prompt engineering
   - Structured output techniques
   - JSON mode (if available)
   - Reliability of extraction methods

3. **Context Retrieval:**
   - Semantic search options (embeddings? pgvector in Supabase?)
   - Keyword search vs vector search
   - Cost/complexity tradeoffs
   - Simple SQL queries vs advanced RAG

4. **Token Optimization:**
   - Summarization techniques
   - Context pruning strategies
   - Efficient prompt design

---

## ADVANCED FEATURES (If Time Permits)

### 1. Embeddings & Semantic Search
Use OpenAI embeddings for better context retrieval:
- Store chapter/character embeddings in database
- Use pgvector extension in Supabase
- Semantic search for relevant context

### 2. Multi-Agent Conversations
Different "expert" personalities for different topics:
- Character expert
- Plot expert
- World-building expert
- Music/lyrics expert

### 3. Conversation Branches
Allow users to branch conversations:
- Try different plot directions
- Compare character variations
- A/B test ideas

### 4. Auto-Generation Features
- Auto-generate scene outlines from story arcs
- Auto-suggest character relationships based on plot
- Auto-create world locations based on scenes

---

## SUCCESS CRITERIA

Phase 3 is complete when:

✅ Users can start conversations by topic
✅ GPT-4 provides intelligent, context-aware responses
✅ Knowledge base retrieval works (pulls relevant chapters/characters)
✅ Decisions are automatically extracted from conversations
✅ Extracted decisions create/update database entities
✅ Conversation history is stored properly
✅ Token usage is optimized and within limits
✅ Error handling for OpenAI API failures works
✅ Documentation shows example conversation flows
✅ Tests verify decision extraction accuracy
✅ Handover document created for Warp to execute

---

## HANDOVER BACK TO WARP

When your design is complete, create:

**File:** `prompts/HANDOVER_Phase3_EXECUTE.md`

**Similar format to Phase 2 handover:**
- Summary of implementation
- Files created
- Commands to execute
- Testing steps
- Verification process
- Known issues
- Ready for Phase 4?

---

## PROJECT PHILOSOPHY REMINDER

**Conversational Intelligence:** The LLM should feel like a creative partner, not a rigid form-filling system. Natural dialogue that makes planning enjoyable.

**Context-Aware:** Always pull relevant existing content. User shouldn't repeat themselves or contradict established lore.

**Decision Transparency:** User should understand what's being created/updated. Confirm before applying major decisions.

---

**WAIT FOR PHASE 2 COMPLETION BEFORE STARTING PHASE 3.**

Co-Authored-By: Warp <agent@warp.dev>
