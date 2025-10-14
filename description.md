
---

##### Links:

- [Original Plugin](https://github.com/Unmanic/plugin.reorder_audio_streams_by_language)

---

##### Documentation:

This plugin is a modified version of the original "Re-order audio streams by language" plugin.

**Key Difference:** This plugin will process files even when the desired language is already in the first position, as long as the default disposition flag is not set.

**Use Case:** This is particularly useful for files that already have the correct audio stream order but lack the default flag (common in anime and other media where the language order is correct but the default audio track was never explicitly set).

In the plugin settings, specify a 'Search String'.

The plugin will search the files to find matching audio tracks.

The matching audio tracks will be:
1. Moved to the 1st audio track position (if not already there)
2. Marked with the default disposition flag

Examples of search strings:

- 'eng'
- 'en'
- 'jpn'
- 'fr'
- 'de'

---

##### How It Works:

The plugin checks two conditions:
1. Is the desired language audio stream already in the first position?
2. Does the first matching audio stream have the default disposition flag set?

Files will be processed if:
- The audio stream order needs to be changed, OR
- The default flag is not set on the first matching audio stream

This ensures that all your media files have both the correct audio order AND the default flag properly set.
