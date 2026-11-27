# Field Notes example extension

This directory is the complete example used by
[Build a complete extension](../06-complete-demo.md).

It targets the current Nota extension API, `v2.5`, and demonstrates:

- a multi-file Lua extension loaded through `require`;
- commands, menus and an accelerator;
- a live-on-demand panel with the host-owned panel DSL;
- document reads, an undoable cursor insertion and editor rejection handling;
- manifest settings and plugin-owned data;
- English source strings with a Chinese translation table;
- pure Lua unit tests and a packaging checklist.

The plugin does not contain Chinese identifiers, does not request network or
filesystem access, and does not replace the whole document.

## Try it

Copy this directory into the Nota user plugin directory:

```text
~/.local/share/nota/plugins/nota.example.field-notes/
```

Restart Nota, enable **Field Notes** under **Settings > Extensions**, then open
the panel from the extension dock or use **Extensions > Capture snapshot**.

## Run the tests

From this directory:

```sh
lua tests/inspect_test.lua
```

## Package it

With a checkout of `Nota-plugins`:

```sh
python3 tools/pack-plugin.py /path/to/field-notes
```

The output is `nota.example.field-notes-1.0.0.nota-plugin`.
