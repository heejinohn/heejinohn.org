-- Fill the CV's paper sections from papers.yaml.
-- In cv.md, write  ::: {.papers group="published"}  followed by  :::
-- and this filter replaces that block with the entries of that list.
-- "published" becomes a reverse-numbered list; other groups are paragraphs.

local stringify = pandoc.utils.stringify

-- Read papers.yaml by wrapping it as a metadata block, so pandoc parses the YAML.
local function read_papers(path)
  local f = assert(io.open(path, "r"), "cannot open " .. path)
  local text = f:read("a")
  f:close()
  return pandoc.read("---\n" .. text .. "\n---\n", "markdown").meta
end

local papers = read_papers("papers.yaml")
local me_full, me_short -- set from the CV's `author` field

-- "Heejin Ohn" -> "H. Ohn" (the CV abbreviates its own author)
local function abbreviate(name)
  local first, last = name:match("^(%S+).-(%S+)$")
  return first and (first:sub(1, 1) .. ". " .. last) or name
end

-- "A", "A and B", "A, B and C" (the CV's style: no serial comma)
local function author_list(authors)
  local names = {}
  for _, a in ipairs(authors) do
    local n = stringify(a)
    names[#names + 1] = (n == me_full) and me_short or n
  end
  if #names == 1 then return names[1] end
  return table.concat(names, ", ", 1, #names - 1) .. " and " .. names[#names]
end

-- One citation, written as Markdown and parsed back into pandoc elements,
-- so special characters (&, %, _) are escaped for LaTeX automatically.
local function citation(p)
  local f = function(key) return p[key] and stringify(p[key]) or nil end
  local url = (f("doi") and "https://doi.org/" .. f("doi")) or f("ssrn")
  local title = '"' .. f("title") .. '."'
  local md = author_list(p.authors) .. ". "
  if f("year") then md = md .. f("year") .. ". " end
  md = md .. (url and ("[" .. title .. "](" .. url .. ")") or title)
  if f("journal") then
    md = md .. " *" .. f("journal") .. "*"
    if f("volume") then md = md .. " " .. f("volume") end
    if f("issue") then md = md .. "(" .. f("issue") .. ")" end
    if f("pages") then md = md .. ": " .. f("pages") end
    md = md .. "."
  end
  return pandoc.read(md, "markdown").blocks[1].content
end

local function Div(el)
  if not el.classes:includes("papers") then return nil end
  local group = el.attributes.group
  local list = papers[group]
  if not list then error("papers.lua: no list '" .. tostring(group) .. "' in papers.yaml") end

  if group == "published" then
    local blocks = { pandoc.RawBlock("latex", "\\begin{etaremune}") }
    for _, p in ipairs(list) do
      local item = pandoc.Inlines({ pandoc.RawInline("latex", "\\item ") })
      item:extend(citation(p))
      blocks[#blocks + 1] = pandoc.Plain(item)
    end
    blocks[#blocks + 1] = pandoc.RawBlock("latex", "\\end{etaremune}")
    return blocks
  end

  local blocks = {}
  for _, p in ipairs(list) do blocks[#blocks + 1] = pandoc.Para(citation(p)) end
  return blocks
end

local function Meta(meta)
  me_full = stringify(meta.author)
  me_short = abbreviate(me_full)
end

-- Run Meta first (to learn the author's name), then Div.
return { { Meta = Meta }, { Div = Div } }
