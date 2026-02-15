# zCOBOL REPLACE

Zane Hambly, December 2025. Per FIPS PUB 21-2, Section XII.

---

REPLACE is a compiler directive that does text substitution before
the source reaches the macro assembler. It lives in `zc390.java`,
not in a macro. The old `REPLACE.MAC` stub was removed because the
preprocessor handles REPLACE before macro expansion ever runs.

## Syntax

```cobol
REPLACE ==pseudo-text-1== BY ==pseudo-text-2== ...
REPLACE OFF
```

Format 1 activates substitution. Format 2 turns it off. A new
REPLACE replaces the previous one — they don't stack.

## How It Works

`zc390.java` intercepts the REPLACE keyword during tokenisation,
parses the `==text==` pairs, and stores them. On every subsequent
source line, all active patterns are applied via string replacement
before the line gets tokenised. REPLACE OFF clears the table.

The implementation is in `process_replace()` (lines 1760-1866 of
`zc390.java`). Pattern storage is a pair of arrays, capped at 100
replacement pairs.

## Files

| File              | What Changed                                 |
|-------------------|----------------------------------------------|
| `src/zc390.java`  | Added REPLACE parsing and text substitution  |
| `REPLACE.MAC`     | Removed — preprocessor handles it now        |

## Test

`zcobol/tests/TESTREPL.CBL` exercises both formats:

```cobol
REPLACE ==AAA== BY ==BBB==.
01  WS-AAA-FIELD     PIC X(20) VALUE 'TEST VALUE 1'.

REPLACE OFF.
01  WS-AAA-KEPT      PIC X(15) VALUE 'NOT REPLACED'.
```

First declaration becomes `WS-BBB-FIELD`. Second stays `WS-AAA-KEPT`.
The test verifies multiple replacement pairs and COPY member
interaction.

```
bat\CBLCLG zcobol\tests\TESTREPL
```

## Limitations

- 100 replacement pairs max
- Pseudo-text must use `==` delimiters
- Each REPLACE replaces (not extends) prior replacements

## Reference

FIPS PUB 21-2 (1985), section XII-3 (The REPLACE Statement).
Incorporates ANSI X3.23-1985 and ISO 1989-1985.
