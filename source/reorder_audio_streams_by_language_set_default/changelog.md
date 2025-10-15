
---

### Version 1.0.0

**Date:** 2025-10-14

**Changes:**
- Initial release based on original plugin v1.2.0
- Added `check_default_disposition()` method to verify if default flag is set
- Modified `streams_to_be_reordered()` to process files even when order is correct but default flag is missing
- Updated plugin ID to `reorder_audio_streams_by_language_set_default`
- Updated import paths to match new plugin ID

**Purpose:**
This fork addresses the issue where files with correct audio stream order but missing default disposition flags were being skipped. This is particularly useful for anime collections where English audio is already first but not marked as default.

---
