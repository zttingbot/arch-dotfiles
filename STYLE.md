# Comment and organization conventions

How files in this repo are commented and organized, whatever the tool or
language. Examples use `#` for comments; in a file that comments with `--`,
`;` or `//`, keep the same shapes and swap the character.

## File header

Every file opens with a header comment, in this order:

1. **What the file is**, in one line: `# <Tool> configuration.`
2. **How it is loaded, and the ordering rule it follows.** Say who reads the
   file and when, and why its order matters, for example "variables are
   substituted at parse time, so each is defined before the lines that read
   it".
3. **A link to the tool's full reference.**
4. **Optional lists** for facts that span the whole file:
   - `Colors` or `Conventions`: the palette and what each color means.
   - `Kept in sync with <path>`: every value tied to another file.

```sh
# <Tool> configuration.
#
# Loaded by <loader> at <when>. <Why the order below matters.>
# Full reference: <url>
#
# Colors
#   - Base #rrggbb: <where it is used>.
#   - Accent #rrggbb: <what it marks>.
#
# Kept in sync with <path>
#   - <value here> matches <value there>.
```

A coupling is stated once, in the header, and both files list it, each naming
the other. The comment at the value points back ("see "Kept in sync" above")
instead of repeating it.

## Sections

Top-level sections use a banner 79 columns wide:

```sh
# =============================================================================
# <Section>
# =============================================================================
```

Sub-sections use a dashed heading, padded with dashes to 79 columns:

```sh
# --- <Sub-section> -----------------------------------------------------------
```

Use sub-headings when a section holds several independent things, such as one
per component, plugin or group of bindings. Leave one blank line after every
heading and between groups.

## Order

1. **Dependencies first.** Anything that is read is defined earlier: a variable
   before the lines that use it, an initialization step before whatever relies
   on it, and top-level keys before the first nested table. A step that wraps
   everything loaded before it, such as a plugin that hooks other plugins,
   loads last. The header says why the order matters.
2. **Then the order the user sees.** When entries correspond to things on
   screen, list them in the order they appear there, and keep every related
   list in that same order.
3. **Related lines stay together**: a mode and the key that enters it, a
   setting and its variant, the members of a series.
4. **Local overrides last.** Machine-specific settings go in an untracked file,
   such as `<file>.local`, loaded at the very end.

## Comments

- **Explain why, not what.** Say what a line is for and the reason for its
  value. Leave out what the line already says.
- **Write full sentences in the present tense**, wrapped at 79 columns.
- **Put the comment above** the line or group it describes.
- **Start with the name of the thing** when a section serves several
  components: `# <Component>: <what these entries do>.`
- **Explain magic numbers with their units**: `size = 4096  # bytes, one page`.
- **Explain surprising settings**, where the obvious alternative breaks:
  `# Must be <X>: <the obvious Y> <fails in this way>.`
- **Keep a comment true to the code.** If the code moves, the comment moves
  with it. Never claim "must come last" above something that is not last.
- **Name every glyph** in a trailing comment, using its name in the icon font,
  since the glyph itself may not render in an editor.
- **Name every color** in the header palette, with what it means.

### Tables and lists

For a column-aligned table, add a header comment naming each column:

```sh
#             <col1>  <col2>  <col3>
<row-name-a>  <value> <value> <value>
<row-name-b>  <value> <value> <value>
```

When a list of options needs a note for each one, put the list in a comment
above them:

```sh
# <What this group achieves>:
#   <OPTION_A>  <what it does>
#   <OPTION_B>  <what it does>
```

Put per-entry labels in trailing comments, aligned within their group:

```sh
<short_key> = <value>       # <label>
<longer_key_name> = <value> # <label>
```

### Disabled lines

Give the reason, then the commented-out line with a space after the comment
character:

```sh
# Disabled: <reason>.
# <original line>
```
