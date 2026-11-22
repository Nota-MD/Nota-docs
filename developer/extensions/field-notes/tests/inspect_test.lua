package.path = "./?.lua;" .. package.path

local inspect = require("inspect")

local record = {
  now_ms = 1234,
  revision = 7,
  chars = 42,
  words = 9,
  lines = 3,
  title = "Daily\tnote",
  path = "/tmp/a|b.md",
}

local line = inspect.record_line(record)
assert(line:find("\tDaily note\t", 1, true), "tabs and pipes must be sanitized")

local history = inspect.append_record("", record, 3)
local parsed = inspect.parse_records(history)
assert(#parsed == 1)
assert(parsed[1].revision == 7)
assert(parsed[1].words == 9)
assert(parsed[1].title == "Daily note")

for index = 1, 5 do
  local next_record = {}
  for key, value in pairs(record) do next_record[key] = value end
  next_record.revision = index
  history = inspect.append_record(history, next_record, 3)
end

parsed = inspect.parse_records(history)
assert(#parsed == 3)
assert(parsed[1].revision == 3)
assert(parsed[3].revision == 5)

local fields = inspect.snapshot_fields(
  { chars = 12, words = 4, lines = 2, revision = 8 },
  { title = "", path = "/tmp/demo.md", dirty = true },
  {
    document = "Document",
    untitled = "Untitled",
    words = "Words",
    characters = "Characters",
    lines = "Lines",
    revision = "Revision",
    path = "Path",
  },
  true
)
assert(fields[1].value == "Untitled")
assert(fields[#fields].label == "Path")

print("field-notes inspect tests: OK")
