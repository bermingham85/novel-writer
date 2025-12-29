# Novel Planning & Production Suite - Build Specification for Emergent

## Project Overview
Build an AI-powered conversational interface for collaborative novel planning that integrates with the existing novel-writer automation system. The system should facilitate natural dialogue to design novels, manage world-building, create music/songs, perform quality assessments, and handle copyright checks.

## Implementation Philosophy

### Database-First Architecture
**Core Principle**: Build from the data layer up, not from the UI down.

**Rationale**:
1. **Data is the foundation** - All functionality depends on proper data structure
2. **Multiple prose projects** - Need robust partitioning to manage different novels/series
3. **Reuse existing infrastructure** - Leverage current Supabase instance and tables
4. **LLM as a layer** - AI functionality wraps around solid data structures
5. **UI is presentation** - Frontend simply displays and manipulates underlying data

**Build Order**:
1. ✅ Database schema with multi-project support (FIRST)
2. ✅ API/backend for CRUD operations (SECOND)
3. ✅ LLM integration and conversation logic (THIRD)
4. ✅ Frontend chat interface (LAST)

**Personal Tool Considerations**:
- No enterprise security needed (just basic auth)
- No user management complexity
- Focus on functionality over polish
- Rapid iteration over perfection
- Simple deployment (local/QNAP)

## System Architecture

### Architecture Approach: Database-First
**Priority**: Build robust database schema first, then layer LLM and frontend on top

### Backend & Database (PRIMARY FOCUS)
- **Primary Database**: Existing Supabase instance (Project: "self learning composer")
  - Connection: `aws-1-eu-west-3.pooler.supabase.com:5432`
  - User: `postgres.ylcepmvbjjnwmzvevxid`
  - Database: `postgres`
  
- **Database Design Strategy**:
  - **Multi-Project Partitioning**: Support multiple prose projects in same database
  - Use `project_id` or `series_id` as partition key across all tables
  - Enables managing multiple novels/series independently
  - Shared infrastructure, isolated data per project
  
- **Optional Secondary Storage**: Notion for additional knowledge management (if needed)

### Frontend (Layer on top of database)
- **Technology**: Next.js with React (lightweight, simple)
- **Focus**: Thin UI layer over database
- **Features**:
  - Chat interface with OpenAI GPT-4 integration
  - Real-time conversation with context retention
  - Rich text display for outlines, character profiles, and world details
  - Music player/preview for Suno-generated songs
  - Quality assessment dashboard
  - Copyright check results viewer

### Security Considerations
- **Current Scope**: Personal tool - no enterprise security needed
- Basic authentication (simple password or API key)
- No complex auth flows or user management
- Focus on functionality over security hardening

### n8n Integration
- Connect to existing n8n instance: `http://192.168.50.246:5678`
- Use existing "Novel Writer - Self-Learning Prose System" workflow
- Trigger chapter generation from planning data

## Core Features

### 1. Conversational Novel Planning

**AI Personality**:
- Creative writing partner
- Asks clarifying questions about plot, characters, world
- Suggests improvements and alternatives
- Maintains consistency across conversations
- References past decisions and existing content

**Conversation Topics**:
- Story concept and premise
- Character development and arcs
- World-building and settings
- Plot structure and story beats
- Series arcs across multiple books
- Character interactions and relationships
- Themes and motifs

**Knowledge Retrieval**:
- Query existing chapters from `chapters` table
- Access character profiles
- Reference world-building documents
- Review series history
- Pull prose evaluation feedback from `prose_evaluations`

### 2. Structured Data Management

**Database-First Approach**: Create comprehensive schema before building UI

**Design Principles**:
- All tables include partition key for multi-project support
- Reuse existing tables where possible (chapters, prose_evaluations, etc.)
- Extend with new tables only where needed
- Support varied prose projects in same database instance

**New Supabase Tables to Create**:

```sql
-- Projects/Series Management (Top-level partition)
CREATE TABLE series (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    genre TEXT,
    target_audience TEXT,
    total_planned_books INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    -- Metadata for managing multiple projects
    project_type TEXT DEFAULT 'novel', -- 'novel', 'short_story', 'screenplay', etc.
    is_active BOOLEAN DEFAULT true
);

-- Books within Series
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID REFERENCES series(id),
    title TEXT NOT NULL,
    book_number INTEGER,
    synopsis TEXT,
    target_word_count INTEGER,
    status TEXT, -- 'planning', 'writing', 'complete'
    style_profile_id UUID REFERENCES style_profiles(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Characters
CREATE TABLE characters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID REFERENCES series(id),
    name TEXT NOT NULL,
    role TEXT, -- 'protagonist', 'antagonist', 'supporting', etc.
    description TEXT,
    background TEXT,
    personality_traits JSONB,
    relationships JSONB,
    character_arc TEXT,
    first_appearance_book_id UUID REFERENCES books(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- World Building
CREATE TABLE worlds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID REFERENCES series(id),
    name TEXT NOT NULL,
    description TEXT,
    history TEXT,
    geography TEXT,
    culture JSONB,
    magic_system TEXT,
    technology_level TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Story Arcs
CREATE TABLE story_arcs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id),
    series_id UUID REFERENCES series(id),
    arc_type TEXT, -- 'main', 'subplot', 'character', 'series'
    title TEXT,
    description TEXT,
    plot_points JSONB, -- Array of plot beats
    resolution TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Scenes/Chapter Outlines
CREATE TABLE scene_outlines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id),
    chapter_number INTEGER,
    scene_number INTEGER,
    location TEXT,
    characters_present UUID[],
    purpose TEXT,
    key_events TEXT,
    emotional_tone TEXT,
    pov_character_id UUID REFERENCES characters(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Songs/Music
CREATE TABLE songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id),
    chapter_id UUID REFERENCES chapters(id),
    title TEXT NOT NULL,
    lyrics TEXT,
    style TEXT,
    mood TEXT,
    suno_prompt TEXT,
    suno_audio_url TEXT,
    suno_song_id TEXT,
    purpose TEXT, -- Context in story
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Conversation History
CREATE TABLE planning_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_id UUID REFERENCES series(id),
    book_id UUID REFERENCES books(id),
    topic TEXT, -- 'character', 'plot', 'world', 'music', etc.
    conversation_data JSONB, -- Store full conversation thread
    decisions_made JSONB, -- Structured decisions from conversation
    created_at TIMESTAMP DEFAULT NOW()
);

-- Copyright Checks
CREATE TABLE copyright_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_type TEXT, -- 'chapter', 'character_name', 'world_name', 'song_lyrics'
    content_id UUID,
    content_text TEXT,
    check_status TEXT, -- 'pending', 'pass', 'warning', 'fail'
    similarity_results JSONB,
    flagged_content JSONB,
    recommendations TEXT,
    checked_at TIMESTAMP DEFAULT NOW()
);

-- Quality Assessments (extends existing prose_evaluations)
CREATE TABLE content_quality_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_type TEXT, -- 'chapter', 'outline', 'character', 'song'
    content_id UUID,
    check_type TEXT, -- 'consistency', 'originality', 'coherence', 'grammar'
    score DECIMAL(3,2),
    issues JSONB,
    suggestions TEXT,
    checked_at TIMESTAMP DEFAULT NOW()
);
```

### 3. Music Integration (Suno API)

**Song Creation Workflow**:
1. Discuss song context in chat (in-story performance, theme song, etc.)
2. Collaboratively write lyrics or generate with AI
3. Define musical style and mood
4. Generate Suno prompt
5. Call Suno API to create music
6. Store audio URL and metadata
7. Associate with chapter/scene

**Suno API Integration**:
```typescript
// Example Suno API structure
interface SunoRequest {
  prompt: string;
  lyrics?: string;
  style?: string;
  title?: string;
}

// Store in environment:
// SUNO_API_KEY=your_api_key
// SUNO_API_URL=https://api.suno.ai/v1/generate
```

**Features**:
- Generate songs from conversation
- Preview generated music
- Iterate on lyrics and style
- Link songs to specific chapters/scenes
- Track song usage across series

### 4. Quality Assessment System

**Automated Checks**:
- **Grammar & Style**: Integrate LanguageTool or similar
- **Consistency Checks**:
  - Character trait consistency
  - Timeline coherence
  - World rule adherence
  - Character relationship tracking
- **Originality Scoring**: 
  - Plot trope detection
  - Character archetype analysis
  - Compare against common patterns
- **Pacing Analysis**: Chapter length, scene variety, tension curves

**Integration with Existing System**:
- Enhance existing `prose_evaluations` table
- Add pre-generation quality gates
- Post-generation comprehensive review

### 5. Copyright Check System

**Multi-Level Checking**:

**Level 1 - Basic Text Similarity**:
- Use embeddings (OpenAI) to check against public domain texts
- Flag high similarity scores
- Check character names against known franchises

**Level 2 - Song Lyrics**:
- Check lyrics against known copyrighted songs
- Flag potential melody similarities (if Suno provides)
- Ensure generated content is original

**Level 3 - World Elements**:
- Check world names against existing fictional universes
- Verify magic system uniqueness
- Cross-reference place names

**Implementation**:
```typescript
// Pseudo-code
async function checkCopyright(content: string, type: string) {
  // Generate embedding
  const embedding = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: content
  });
  
  // Compare against known copyrighted content database
  const similarities = await vectorSearch(embedding);
  
  // Return assessment
  return {
    status: similarities.maxScore > 0.85 ? 'warning' : 'pass',
    flaggedContent: similarities.matches,
    recommendations: generateRecommendations(similarities)
  };
}
```

## User Workflows

### Workflow 1: Starting a New Series
1. Open chat interface
2. Discuss series concept with AI
3. Define genre, audience, scope
4. Create series in database
5. Plan first book outline
6. Develop main characters
7. Build world foundation

### Workflow 2: Planning a Chapter
1. Reference existing story context
2. Discuss scene objectives
3. Identify characters involved
4. Define emotional beats
5. Create scene outline
6. Generate quality pre-check
7. Trigger n8n workflow to write chapter

### Workflow 3: Creating Story Music
1. Identify song placement in story
2. Discuss song purpose (theme, in-story performance, etc.)
3. Collaboratively write/generate lyrics
4. Define musical style
5. Generate with Suno API
6. Review and iterate
7. Associate with chapter/scene

### Workflow 4: Quality & Copyright Review
1. Select content for review
2. Run automated checks
3. Review AI-generated suggestions
4. Make revisions
5. Re-check if needed
6. Approve for use

## Technical Implementation Details

### Frontend Components

```typescript
// Key React Components
- ChatInterface: Main conversation UI
- KnowledgeBasePanel: Browse series/characters/worlds
- OutlineBuilder: Visual story structure
- CharacterProfileEditor: Detailed character management
- MusicStudio: Song creation and preview
- QualityDashboard: Assessment results
- CopyrightReviewer: Flag management
```

### API Routes (Next.js)

```typescript
// API endpoints
POST /api/chat - Send message, get AI response
GET /api/series/:id - Get series details
POST /api/series - Create new series
GET /api/characters - List characters
POST /api/songs/generate - Create song with Suno
POST /api/quality/check - Run quality assessment
POST /api/copyright/check - Check for copyright issues
POST /api/n8n/trigger - Trigger chapter generation workflow
```

### Environment Variables

```env
# OpenAI
OPENAI_API_KEY=your_key

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://ylcepmvbjjnwmzvevxid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_key

# Suno API
SUNO_API_KEY=d8038c1c9195ea0da6007532da395b28
SUNO_API_URL=https://api.sunoaimusic.com/api/v1

# n8n
N8N_WEBHOOK_URL=http://192.168.50.246:5678/webhook/novel-writer

# Optional: Notion
NOTION_API_KEY=your_notion_key
NOTION_DATABASE_ID=your_database_id
```

## AI Conversation Patterns

### System Prompt for Planning AI

```
You are a collaborative novel planning assistant. Your role is to help authors develop compelling stories through natural conversation.

Core Responsibilities:
- Ask insightful questions about plot, characters, and world-building
- Suggest creative alternatives and improvements
- Maintain consistency across all story elements
- Reference past decisions and existing content
- Help structure ideas into actionable outlines
- Identify potential plot holes or inconsistencies
- Recommend quality improvements

Conversation Style:
- Friendly and encouraging
- Ask clarifying questions
- Build on the author's ideas
- Provide specific, actionable suggestions
- Reference story context naturally

Knowledge Access:
You have access to:
- All existing chapters and their evaluations
- Character profiles and relationships
- World-building documentation
- Series arcs and book outlines
- Previous planning conversations

Always ground your suggestions in this existing context.
```

### Structured Output Format

When conversations reach decisions, output structured JSON:

```json
{
  "topic": "character_development",
  "decisions": [
    {
      "type": "character",
      "action": "create",
      "data": {
        "name": "Elena Stormwind",
        "role": "protagonist",
        "traits": ["brave", "impulsive", "loyal"],
        "arc": "overcoming fear of magic"
      }
    }
  ],
  "next_steps": ["develop_backstory", "define_relationships"]
}
```

## Integration Requirements

### Connecting to Existing n8n Workflow

The chat interface should be able to:
1. Format chapter planning data for n8n workflow
2. Trigger workflow via webhook or API
3. Monitor workflow execution status
4. Retrieve generated chapters
5. Display evaluation results
6. Feed evaluation insights back into planning

### Data Flow

```
Planning Chat → Structured Outline → Supabase →
n8n Workflow → Chapter Generation → Quality Eval →
Feedback to Chat → Iterative Improvement
```

## Deployment Instructions

### PHASE 1: Database Setup (DO THIS FIRST)

**Priority**: Get database schema deployed and tested before any frontend work

1. **Create Database Migration File**:
   - Location: `C:\Users\bermi\Projects\novel-writer\migrations\`
   - File: `002_planning_suite_schema.sql`
   - Contains all new table definitions with partitioning

2. **Deploy to Supabase**:
   ```bash
   # Via Supabase SQL Editor (browser)
   # Or via psql command line:
   psql "postgresql://postgres.ylcepmvbjjnwmzvevxid:Ballybought1985!@aws-1-eu-west-3.pooler.supabase.com:5432/postgres" -f migrations/002_planning_suite_schema.sql
   ```

3. **Verify Database Structure**:
   - Check all tables created
   - Verify foreign key relationships
   - Test queries with partition keys
   - Create sample data for testing

4. **Test Multi-Project Partitioning**:
   - Create 2-3 test series
   - Verify data isolation
   - Test cross-series queries

### PHASE 2: API Layer (After Database is Complete)

5. **Create Simple API Service**:
   - Can start with just Node.js + Express (simpler than full Next.js)
   - Or use Supabase Edge Functions
   - Focus: CRUD operations for all tables
   - Test with curl/Postman before building UI

### PHASE 3: LLM Integration (After API Works)

6. **OpenAI Integration**:
   - Create conversation service
   - Test prompt engineering
   - Verify context retrieval from database
   - Test structured output parsing

### PHASE 4: Frontend (Final Layer)

7. **Next.js Application**:
   - Clone/create repo in `C:\Users\bermi\Projects\novel-planning-suite`
   - Install dependencies: `npm install`
   - Configure environment variables
   - Build UI components on top of working API
   - Run development server: `npm run dev`

### PHASE 5: Integrations

8. **n8n Configuration**:
   - Create webhook trigger for planning interface
   - Update workflow to accept planning data
   - Test integration

9. **Suno API Setup**:
   - Obtain API credentials
   - Test song generation
   - Configure audio storage (Supabase Storage or external)

## Success Criteria

✅ Natural conversation interface for novel planning
✅ Persistent knowledge base across conversations
✅ Structured data creation from freeform chat
✅ Character, world, and arc management
✅ Song/music generation with Suno API
✅ Quality assessment automation
✅ Copyright checking system
✅ Seamless integration with existing novel-writer workflow
✅ Context-aware AI that references past decisions
✅ Visual outlines and story structure

## Additional Considerations

### Security
- Secure API keys in environment variables
- Implement authentication for chat interface
- Protect Supabase credentials
- Rate limit AI API calls

### Performance
- Cache conversation context
- Optimize database queries
- Lazy load knowledge base data
- Stream AI responses

### User Experience
- Auto-save conversations
- Export outlines to PDF/Markdown
- Keyboard shortcuts for common actions
- Mobile-responsive design

## Deliverables for Emergent

Please create:
1. Complete Next.js application with all described features
2. Supabase migration SQL files
3. API route implementations
4. React component library
5. OpenAI integration with context management
6. Suno API integration
7. Quality assessment system
8. Copyright checking implementation
9. n8n webhook integration
10. Documentation for setup and usage

---

**Project Location**: `C:\Users\bermi\Projects\novel-planning-suite`
**Timeline**: Full implementation
**Priority**: High - This enables the complete novel production pipeline
