local inspect = require("inspect")

local M = {}
local T = function(text) return text end
local HISTORY_FILE = "history.txt"

local function setting(nota, key, fallback)
  local ok, value = pcall(nota.settings.get, key)
  if not ok or value == nil then return fallback end
  return value
end

local function history_limit(nota)
  return inspect.clamp_int(setting(nota, "history_limit", 8), 8, 3, 30)
end

local function include_path(nota)
  return setting(nota, "include_path", false) == true
end

local function note_label(nota)
  local value = setting(nota, "note_label", "Field note")
  if type(value) ~= "string" or value:match("^%s*$") then return "Field note" end
  return value
end

local function snapshot(nota)
  local stats = nota.document.stats()
  return {
    now_ms = nota.time.now().now_ms,
    revision = stats.revision,
    chars = stats.chars,
    words = stats.words,
    lines = stats.lines,
    title = nota.document.get_title(),
    path = nota.document.get_path(),
    dirty = nota.document.is_dirty(),
  }, stats
end

local function read_history(nota)
  local ok, value = pcall(nota.data.read, HISTORY_FILE)
  if ok and type(value) == "string" then return value end
  return ""
end

local function labels()
  return {
    document = T("Document"),
    untitled = T("Untitled"),
    words = T("Words"),
    characters = T("Characters"),
    lines = T("Lines"),
    revision = T("Revision"),
    path = T("Path"),
  }
end

local function capture(nota)
  local meta, stats = snapshot(nota)
  if stats.lines == 0 and stats.chars == 0 then
    nota.ui.notify(T("There is no document to inspect."), "warn")
    return { ok = false, reason = "empty-document" }
  end

  local line = inspect.append_record(read_history(nota), meta, history_limit(nota))
  local ok, err = pcall(nota.data.write, HISTORY_FILE, line)
  if not ok then
    nota.ui.notify(T("Could not save the snapshot: %s", tostring(err)), "error")
    return { ok = false, error = tostring(err) }
  end

  nota.ui.refresh("field-notes")
  nota.ui.notify(T("Snapshot saved."), "success")
  return { ok = true, revision = meta.revision, words = meta.words }
end

local function insert_summary(nota)
  local meta, stats = snapshot(nota)
  if stats.lines == 0 and stats.chars == 0 then
    nota.ui.notify(T("There is no document to inspect."), "warn")
    return { ok = false, reason = "empty-document" }
  end

  local text = inspect.summary(meta, stats, note_label(nota), labels())
  local ok, inserted = pcall(nota.document.insert_at_cursor, text)
  if not ok or inserted ~= true then
    local reason = ok and T("The editor rejected the insertion.") or tostring(inserted)
    nota.ui.notify(T("Could not insert the summary: %s", reason), "error")
    return { ok = false, error = reason }
  end

  nota.ui.notify(T("Summary inserted at the cursor."), "success")
  return { ok = true }
end

local function panel_content(nota)
  local meta, stats = snapshot(nota)
  local records = inspect.parse_records(read_history(nota))
  local blocks = {
    {
      kind = "hero",
      title = T("Field Notes"),
      subtitle = T("Inspect the active document without leaving the page."),
    },
    {
      kind = "fields",
      items = inspect.snapshot_fields(stats, meta, labels(), include_path(nota)),
    },
    {
      kind = "buttons",
      items = {
        { label = T("Capture snapshot"), command = "capture", style = "primary" },
        { label = T("Insert summary at cursor"), command = "insert-summary" },
      },
    },
    { kind = "separator" },
    { kind = "heading", text = T("Recent snapshots") },
  }

  if #records == 0 then
    blocks[#blocks + 1] = {
      kind = "empty",
      text = T("No snapshots yet. Use Capture snapshot."),
    }
  else
    local items = {}
    for index = #records, 1, -1 do
      local record = records[index]
      items[#items + 1] = {
        title = inspect.display_title(record, T("Untitled")),
        subtitle = T("%s words · %s characters · revision %s",
          tostring(record.words), tostring(record.chars), tostring(record.revision)),
        badge = tostring(record.revision),
        tone = "muted",
      }
    end
    blocks[#blocks + 1] = { kind = "list", items = items }
  end

  return blocks
end

function M.on_load(nota)
  T = function(fmt, ...)
    local translated = nota.i18n and nota.i18n.text(fmt) or nil
    translated = translated or fmt
    if select("#", ...) > 0 then return string.format(translated, ...) end
    return translated
  end

  nota.command.register("capture", function() return capture(nota) end)
  nota.command.register("insert-summary", function() return insert_summary(nota) end)

  nota.ui.register_panel({
    id = "field-notes",
    title = T("Field Notes"),
    location = "right",
    render = function() return panel_content(nota) end,
  })

  nota.ui.register_menu({
    label = T("Capture snapshot"),
    command = "capture",
    menu = "plugins",
    accelerator = "Ctrl+Alt+Shift+N",
  })
  nota.ui.register_menu({
    label = T("Insert summary at cursor"),
    command = "insert-summary",
    menu = "plugins",
  })

  nota.log.info("field-notes loaded with API " .. tostring(nota.api_version))
end

function M.on_unload() end

return M
