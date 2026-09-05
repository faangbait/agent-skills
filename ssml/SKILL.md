---
name: ssml
description: "Teaches you how to use Speech Synthesis Markup Language for natural language processing / text-to-speech workflows. Use when asked to prepare text for text-to-speech output."
---

# Speech Synthesis Markup Language (SSML)

SSML is XML markup for controlling synthesized speech. Wrap all content in a `<speak>` tag:

```xml
<speak>Your content to be synthesized here</speak>
```

## Practical guidance

- `<prosody rate="0%">` is the default; `-10%` is slower and `100%` is twice as fast and may be unintelligible.
- Avoid `emotion="assertive"`, which can sound unnatural. Prefer `bright` or another fitting emotion, and use `<emphasis>` for emphasis within paragraphs.
- Use `<sub>` for pronunciation, for example `<sub alias="too doo dot m d">TODO.md</sub>`.
- Match emotion to the text. Short sentences and punctuation strengthen delivery: `!` for intensity, `?` for uncertainty, and `...` for hesitation or sadness.
- Combine emotion, prosody, emphasis, and breaks sparingly for finer control.
- Since this is spoken text, you must avoid fancy punctation (like em-dashes) in favor of commas, periods, or parentheticals.

## Escaping characters

Escape XML-sensitive characters before inserting plain text into SSML:

| Character | Escaped form |
| --- | --- |
| `&` | `&amp;` |
| `<` | `&lt;` |
| `>` | `&gt;` |
| `"` | `&quot;` |
| `'` | `&apos;` |

```xml
<!-- Original: Some "text" with 5 < 6 & 4 > 8 in it -->
<speak>Some &quot;text&quot; with 5 &lt; 6 &amp; 4 &gt; 8 in it</speak>
```

Escape `&` first so later replacements do not re-escape entities:

```ts
const escapeSSMLChars = (text: string) =>
  text
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
```

## Supported tags

### `<prosody>`

Controls pitch, rate, and volume.

| Attribute | Named values | Numeric values |
| --- | --- | --- |
| `pitch` | `x-low`, `low`, `medium` (default), `high`, `x-high` | `-83%` to `+100%` |
| `rate` | `x-slow`, `slow`, `medium` (default), `fast`, `x-fast` | `-50%` to `+9900%` |
| `volume` | `silent`, `x-soft`, `medium` (default), `loud`, `x-loud` | Decibels such as `-6dB`, or percentages such as `+20%` |

```xml
<speak>
  This is a normal speech pattern.
  <prosody pitch="high" rate="fast" volume="+20%">
    I'm speaking with a higher pitch, faster than usual, and louder!
  </prosody>
  Back to normal speech pattern.
</speak>
```

### `<break>`

Adds a pause. Set either `strength` or an explicit `time` from 0 to 10 seconds. See the [W3C specification](https://www.w3.org/TR/speech-synthesis11/#S3.2.3).

| `strength` | Approximate pause |
| --- | --- |
| `none` | 0 ms |
| `x-weak` | 250 ms |
| `weak` | 500 ms |
| `medium` | 750 ms |
| `strong` | 1000 ms |
| `x-strong` | 1250 ms |

Use `ms` or `s` for explicit durations, such as `100ms` or `1s`.

```xml
<speak>
  Let me tell you something important.
  <break time="750ms" />
  This is critical information.
</speak>
```

### `<emphasis>`

Adds or reduces emphasis without setting individual prosody attributes. Supported levels are `reduced`, `moderate`, and `strong`.

```xml
<speak>
  I already told you I <emphasis level="strong">really like</emphasis> that person.
</speak>
```

### `<sub>`

Speaks the `alias` instead of the enclosed text. See the [W3C specification](https://www.w3.org/TR/speech-synthesis11/#S3.1.11).

#### Text-to-alias mappings

**The Problem:** TTS systems read text linearly. Left unguided, they typically try to pronounce acronyms like "EC2" as a single word ("eek-two") or spell out alphanumeric strings completely ("k-eight-s" for K8s).

**The Solution:** Known developer colloquialisms (like saying "sequel" for SQL, "jason" for JSON) should be converted via <sub>.

```xml
<speak>
  Read the <sub alias="Frequently Asked Questions">FAQ</sub> section.
</speak>
```

Read [references/sub-alias-mapping.md](references/sub-alias-mapping.md) for more instruction on converting acronyms/jargon to TTS-compatible text.

### `<speechify:style>`

Controls voice emotion in Speechify.

| Emotion | Character |
| --- | --- |
| `angry` | Forceful, intense |
| `cheerful` | Upbeat, positive |
| `sad` | Downcast, melancholic |
| `terrified` | Extreme fear |
| `relaxed` | Calm, at ease |
| `fearful` | Anxious, worried |
| `surprised` | Astonished, unexpected |
| `calm` | Tranquil, peaceful |
| `assertive` | Confident, authoritative |
| `energetic` | Dynamic, lively |
| `warm` | Friendly, inviting |
| `direct` | Straightforward, clear |
| `bright` | Optimistic, cheerful |

```xml
<speak>
  <speechify:style emotion="cheerful">
    I'm so excited to tell you about our new features!
  </speechify:style>
  <break time="500ms" />
  <speechify:style emotion="calm">
    Now, let me explain how they work.
  </speechify:style>
</speak>
```
