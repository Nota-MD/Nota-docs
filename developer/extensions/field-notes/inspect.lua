local M = {}

local function clean(value)
  local text = tostring(value or "")
  return text:gsub("[\t\r\n|]", " ")
end

local function number(value, fallback)
  value = tonumber(value)
  if value == nil or value ~= value then return fallback end
  return value
end

function M.clamp_int(value, fallback, low, high)
  value = math.floor(number(value, fallback))
  if value < low then return low end
  if value > high then return high end
  return value
end

function M.record_line(record)
  return table.concat({
    number(record.now_ms, 0),
    number(record.revision, 0),
    number(record.chars, 0),
    number(record.words, 0),
    number(record.lines, 0),
    clean(record.title),
    clean(record.path),
  }, "\t")
end

function M.append_record(history, record, limit)
  limit = M.clamp_int(limit, 8, 3, 30)
  local lines = {}
  for line in tostring(history or ""):gmatch("[^\r\n]+") do
    if line ~= "" then lines[#lines + 1] = line end
  end
  lines[#lines + 1] = M.record_line(record)
  while #lines > limit do table.remove(lines, 1) end
  return table.concat(lines, "\n") .. "\n"
end

function M.parse_line(line)
  local fields = {}
  for field in tostring(line or ""):gmatch("([^\t]*)\t?") do
    fields[#fields + 1] = field
  end
  if #fields < 7 then return nil end
  return {
    now_ms = number(fields[1], 0),
    revision = number(fields[2], 0),
    chars = number(fields[3], 0),
    words = number(fields[4], 0),
    lines = number(fields[5], 0),
    title = fields[6],
    path = fields[7],
  }
end

function M.parse_records(history)
  local records = {}
  for line in tostring(history or ""):gmatch("[^\r\n]+") do
    local record = M.parse_line(line)
    if record then records[#records + 1] = record end
  end
  return records
end

function M.display_title(record, untitled)
  local title = clean(record and record.title)
  if title ~= "" then return title end
  return untitled
end

function M.snapshot_fields(stats, meta, labels, include_path)
  local items = {
    { label = labels.document, value = M.display_title(meta, labels.untitled) },
    { label = labels.words, value = tostring(number(stats.words, 0)) },
    { label = labels.characters, value = tostring(number(stats.chars, 0)) },
    { label = labels.lines, value = tostring(number(stats.lines, 0)) },
    {
      label = labels.revision,
      value = tostring(number(stats.revision, 0)),
      tone = meta.dirty and "warn" or "muted",
    },
  }
  if include_path and meta.path and meta.path ~= "" then
    items[#items + 1] = { label = labels.path, value = clean(meta.path) }
  end
  return items
end

function M.summary(meta, stats, heading, labels)
  labels = labels or {}
  local title = M.display_title(meta, labels.untitled or "Untitled")
  return table.concat({
    "## " .. clean(heading),
    "",
    "- " .. (labels.document or "Document") .. ": " .. title,
    "- " .. (labels.words or "Words") .. ": " .. tostring(number(stats.words, 0)),
    "- " .. (labels.characters or "Characters") .. ": " .. tostring(number(stats.chars, 0)),
    "- " .. (labels.lines or "Lines") .. ": " .. tostring(number(stats.lines, 0)),
    "- " .. (labels.revision or "Revision") .. ": " .. tostring(number(stats.revision, 0)),
    "",
  }, "\n")
end

return M
