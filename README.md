# Novel Planning & Production Suite

**AI-Powered Novel Planning, Self-Learning Prose Generation, and Music Integration**

[![Phase 1](https://img.shields.io/badge/Phase%201-Complete-brightgreen)](migrations/DEPLOYMENT_SUMMARY.md)
[![Phase 2](https://img.shields.io/badge/Phase%202-In%20Progress-yellow)](https://github.com/bermingham85/novel-writer/issues/1)
[![Phase 3](https://img.shields.io/badge/Phase%203-Pending-lightgrey)](prompts/HANDOVER_Phase3_LLM_Integration.md)

## 🎯 Project Overview

A comprehensive system for planning and writing novels through conversational AI, combining:
- **Conversational Planning** - Natural language novel planning with GPT-4
- **Self-Learning Prose** - n8n workflow that improves writing over time
- **Music Integration** - Suno API for character themes and story songs
- **Quality Assurance** - Automated copyright and quality checks

## 📊 Current Status

### ✅ Phase 1: Database Schema (COMPLETE)

**Deployed:** 2025-12-24  
**Database:** Supabase (Project: ylcepmvbjjnwmzvevxid, Region: eu-west-3)

**12 Tables Created:**
- 📚 **Core:** series, books
- 👥 **Content:** characters, worlds, locations
- 📖 **Story:** story_arcs, scene_outlines
- 🎵 **Music:** songs (with Suno API fields)
- 💬 **Planning:** planning_conversations, ideas
- ✅ **Quality:** copyright_checks, content_quality_checks

**3 Helper Views:**
- `active_series_summary` - Series overview with counts
- `book_progress` - Writing progress tracking
- `character_relationships` - Character network visualization

**Sample Data:** "The Quantum Chronicles" series inserted for testing

[📄 View Full Deployment Summary](migrations/DEPLOYMENT_SUMMARY.md)

### 🚧 Phase 2: API Layer (IN PROGRESS)

**Status:** Assigned to Emergent (Design AI)  
**Issue:** [#1](https://github.com/bermingham85/novel-writer/issues/1)

**Deliverables:**
- REST API or Supabase Edge Functions
- Full CRUD operations for all 12 entities
- n8n webhook integration (http://192.168.50.246:5678)
- Suno API client (research + stub)
- OpenAI service interfaces (prep for Phase 3)
- Comprehensive API documentation

[📋 View Full Phase 2 Handover](prompts/HANDOVER_Phase2_API_Layer.md)

### ⏳ Phase 3: LLM Integration (PENDING)

**Status:** Blocked until Phase 2 complete  
**Scope:** OpenAI conversational planning with decision extraction

**Key Features:**
- Natural language conversations for novel planning
- Knowledge base retrieval from existing chapters/characters
- Automatic entity creation from conversation decisions
- Multi-topic planning (character, plot, world, music, scenes)
- Token-optimized context management

[📋 View Full Phase 3 Handover](prompts/HANDOVER_Phase3_LLM_Integration.md)

### 🎨 Phase 4: Frontend (NOT STARTED)

**Tech Stack:** Next.js  
**Features:** Chat interface, entity management, progress dashboards

### 🔗 Phase 5: Integrations (NOT STARTED)

**Integrations:** n8n novel-writer workflow, Suno music API, quality/copyright services

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Frontend (Phase 4)                   │
│                    Next.js Chat Interface                     │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────────┐
│                      API Layer (Phase 2)                      │
│              REST API / Supabase Edge Functions               │
├───────────────────────────────────────────────────────────────┤
│  │ CRUD Operations │ n8n Webhook │ Suno API │ OpenAI (P3) │ │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────────┐
│                   Database (Phase 1) ✅                       │
│                    Supabase PostgreSQL                        │
├───────────────────────────────────────────────────────────────┤
│  12 Tables │ 3 Views │ Multi-Project Partitioning            │
└───────────────────────────────────────────────────────────────┘
```

## 🗄️ Database Schema

### Multi-Project Architecture
All tables partition by `series_id` - supports multiple novels/series in one database.

### Core Entities
- **Series** → Books → Style Profiles → Chapters (existing n8n integration)
- **Characters** with relationships, traits, and arcs
- **Worlds** → Locations (hierarchical)
- **Story Arcs** with plot points
- **Scene Outlines** linking characters + locations
- **Songs** with Suno API integration fields
- **Planning Conversations** storing GPT-4 dialogues and decisions
- **Ideas** for brainstorming
- **Quality & Copyright Checks** with similarity scoring

### Integration Points
- `books.style_profile_id` → Links to n8n novel-writer workflow
- `songs.chapter_id` → Links songs to generated chapters
- `book_progress` view → Tracks writing completion

[📄 View SQL Schema](migrations/002_planning_suite_schema_safe.sql)

## 🔗 Existing Integration: n8n Novel Writer

**Status:** Operational ✅  
**URL:** http://192.168.50.246:5678  
**Workflow:** Self-learning prose generation system

**Capabilities:**
- Generates chapters using GPT-4o
- Evaluates prose quality with GPT-4o-mini
- Self-improves prompts based on evaluation feedback
- Stores chapters, evaluations, and prompt versions in database

[📄 View Workflow JSON](workflow.json)

## 📁 Project Structure

```
novel-writer/
├── migrations/
│   ├── 002_planning_suite_schema.sql      # Original migration
│   ├── 002_planning_suite_schema_safe.sql # Safe version (drops indexes first)
│   ├── DEPLOYMENT_SUMMARY.md              # Full deployment report
│   └── verify_series.sql                  # Verification queries
├── prompts/
│   ├── HANDOVER_Phase2_API_Layer.md       # Phase 2 specifications
│   └── HANDOVER_Phase3_LLM_Integration.md # Phase 3 specifications
├── DEPLOY_ALL.sql                         # Original novel-writer schema
├── workflow.json                          # n8n workflow definition
├── EMERGENT_PROMPT_Novel_Planning_Suite.md # Original planning prompt
└── [Various documentation files]
```

## 🚀 Getting Started (For Emergent/Claude)

### Phase 2 Implementation

1. **Read the handover:** [prompts/HANDOVER_Phase2_API_Layer.md](prompts/HANDOVER_Phase2_API_Layer.md)
2. **Access the issue:** [#1](https://github.com/bermingham85/novel-writer/issues/1)
3. **Design the API layer** (Supabase Functions or Node/Express)
4. **Create execution handover:** `prompts/HANDOVER_Phase2_EXECUTE.md`
5. **Assign back to Warp** for execution

### Database Connection (Phase 2 Needed)

```
Host: aws-1-eu-west-3.pooler.supabase.com
Port: 5432
Database: postgres
User: postgres.ylcepmvbjjnwmzvevxid
Password: [In handover document]
Project URL: https://ylcepmvbjjnwmzvevxid.supabase.co
```

## 🎯 Success Criteria by Phase

### Phase 2 (API)
- [ ] All 12 entity types have full CRUD
- [ ] API documented with examples
- [ ] Database connection working
- [ ] n8n webhook integration functional
- [ ] Suno API client stubbed
- [ ] OpenAI service interfaces defined
- [ ] Basic tests passing
- [ ] Execution handover created

### Phase 3 (LLM)
- [ ] Conversational planning works
- [ ] Knowledge base retrieval functional
- [ ] Decision extraction accurate
- [ ] Entities created from conversations
- [ ] Token usage optimized
- [ ] Streaming responses implemented

### Phase 4 (Frontend)
- [ ] Chat interface deployed
- [ ] Entity management UI complete
- [ ] Progress tracking dashboards live

### Phase 5 (Integrations)
- [ ] n8n workflow triggered from UI
- [ ] Suno music generation working
- [ ] Quality/copyright checks automated

## 👥 AI Agent Roles

Following strict role separation for optimal efficiency:

- **Warp (Execution AI)** - Deploys, executes, tests, commits code
- **Emergent/Claude (Design AI)** - Designs, architectures, documents, no execution
- **Handover Protocol** - Standardized prompts in `/prompts/` directory

## 📚 Documentation

- [Phase 1 Deployment Summary](migrations/DEPLOYMENT_SUMMARY.md)
- [Phase 2 Handover Prompt](prompts/HANDOVER_Phase2_API_Layer.md)
- [Phase 3 Handover Prompt](prompts/HANDOVER_Phase3_LLM_Integration.md)
- [Original Planning Document](EMERGENT_PROMPT_Novel_Planning_Suite.md)
- [n8n Workflow Specification](workflow.json)

## 🔐 Security Note

This is a **personal-use tool**. Authentication is basic (API keys or Supabase RLS). No enterprise security implemented.

## 📜 License

Private Project - All Rights Reserved

## 🤝 Contributing

**Phase 2 Contributors:** Emergent (Design AI) assigned to [Issue #1](https://github.com/bermingham85/novel-writer/issues/1)

---

**Built with:**
- Supabase (PostgreSQL)
- n8n (Workflow Automation)
- OpenAI GPT-4 (Planning + Generation)
- Suno API (Music)
- Next.js (Frontend - planned)

**Co-Authored-By:** Warp <agent@warp.dev>
