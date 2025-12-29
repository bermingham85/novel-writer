# Jesse Novel Factory Integration

## Overview

The Novel Planning Suite integrates with jesse-novel-factory for canon data, character definitions, and voice configurations.

## Repository Locations

| Repo | Location | Purpose |
|------|----------|---------|
| jesse-novel-factory | `C:\Users\bermi\Documents\GitHub\jesse-novel-factory` | Canon & content |
| novel-writer | `C:\Users\bermi\Projects\novel-writer` | Emergent platform |
| self-improving-systems | `C:\Users\bermi\Documents\GitHub\self-improving-systems` | Quality loops |

## Canon Data Source

**File:** `jesse-novel-factory/canon/CANON_SEED.json`

Contains:
- 10 canonical characters (Jesse, Kevin, Emma, Amy, Laura, Ann, Grog, Lirian, Elandra, Malakar)
- Magic rules (collar speech, time warp, sisterly bond)
- Artifacts (collar, staff, seeds, golden chicken, mirror)
- Timeline (17 events across 2 books)
- Tone rules (Irish banter, profanity, pop culture fails)
- Deprecated content warnings (Morgrim/Gregor version)

## Agent Definitions

**Location:** `jesse-novel-factory/agents/`

| Agent | Platform | File |
|-------|----------|------|
| Showrunner | Claude | showrunner.json |
| Canon Librarian | OpenAI | canon_librarian.json |
| Continuity QA | OpenAI | continuity_qa.json |
| Structural Editor | Claude | structural_editor.json |
| Dialogue Punchup | OpenAI | dialogue_punchup.json |
| Lyrics Room | Claude | lyrics_room.json |
| Suno Producer | n8n HTTP | suno_producer.json |
| Voice Director | ElevenLabs | voice_director.json |
| Packager | n8n Code | packager.json |

## Voice Assignments

**File:** `jesse-novel-factory/agents/voice_director.json`

Characters requiring ElevenLabs voice IDs:
- narrator, jesse, kevin, emma, amy, laura, ann
- grog, lirian, elandra, malakar

## Shared API Keys

Both systems use:
```
SUNO_API_KEY=d8038c1c9195ea0da6007532da395b28
ELEVENLABS_API_KEY=sk_ee0380a1d582835d18d086bb8802737805eb159ffc66f452
```

## Data Flow

```
novel-writer (planning)
    ↓
jesse-novel-factory (canon validation)
    ↓
self-improving-systems (chapter generation + quality)
    ↓
jesse-novel-factory (voice + music production)
    ↓
n8n (assembly + export)
```

## Integration Queries

When planning in novel-writer, query jesse-novel-factory canon:

```javascript
// Load canon for validation
const canonPath = 'C:\\Users\\bermi\\Documents\\GitHub\\jesse-novel-factory\\canon\\CANON_SEED.json';
const canon = JSON.parse(fs.readFileSync(canonPath));

// Validate character name
function isCanonCharacter(name) {
  return canon.characters.some(c => c.name === name);
}

// Check magic rules
function validateMagicRule(action) {
  return canon.magic_rules.some(r => r.rule.includes(action));
}
```

## Build Status

- [x] Canon data in jesse-novel-factory
- [x] Agent definitions complete
- [x] SUNO API key configured
- [ ] ElevenLabs voice IDs assigned
- [ ] novel-writer Next.js app built
- [ ] Full integration tested
