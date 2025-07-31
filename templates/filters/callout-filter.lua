--[[
Callout Filter for Constellize Book
Processes custom callout syntax in markdown and converts to appropriate format
]]--

-- Callout configurations
local callouts = {
  codeReference = {
    icon = "📁",
    title = "Code Reference",
    style = "info",
    color = "#0066cc"
  },
  architecture = {
    icon = "🏗️",
    title = "System Architecture", 
    style = "primary",
    color = "#6f42c1"
  },
  narrative = {
    icon = "📖",
    title = "Narrative Context",
    style = "secondary", 
    color = "#6c757d"
  },
  implementation = {
    icon = "⚡",
    title = "Implementation Pattern",
    style = "success",
    color = "#28a745"
  },
  crossReference = {
    icon = "🔗",
    title = "Related Components",
    style = "warning",
    color = "#ffc107"
  }
}

-- Helper function to detect callout type from content
function detectCalloutType(content)
  local text = pandoc.utils.stringify(content)
  
  if text:match("📁.*Code Reference") then
    return "codeReference"
  elseif text:match("🏗️.*System Architecture") then
    return "architecture"
  elseif text:match("📖.*Narrative Context") then
    return "narrative"
  elseif text:match("⚡.*Implementation Pattern") then
    return "implementation"
  elseif text:match("🔗.*Related Components") then
    return "crossReference"
  end
  
  return nil
end

-- Extract title and content from callout
function parseCallout(blockquote)
  local content = {}
  local title = ""
  local link = ""
  
  -- Get the first paragraph which should contain the title
  if blockquote.content[1] and blockquote.content[1].t == "Para" then
    local firstPara = blockquote.content[1]
    
    -- Extract title from strong text
    for i, inline in ipairs(firstPara.content) do
      if inline.t == "Strong" then
        local strongText = pandoc.utils.stringify(inline)
        -- Extract title and link if present
        local titleMatch = strongText:match("([^:]+):%s*%[(.-)%]%((.-)%)")
        if titleMatch then
          title = titleMatch
          -- The link is in the next part
        else
          title = strongText:gsub("^[^:]+:%s*", "")
        end
        break
      end
    end
    
    -- Add remaining paragraphs as content
    for i = 2, #blockquote.content do
      table.insert(content, blockquote.content[i])
    end
  end
  
  return title, content
end

-- Generate LaTeX callout box
function generateLatexCallout(calloutType, title, content)
  local config = callouts[calloutType]
  if not config then
    return nil
  end
  
  local latex = string.format([[
\begin{tcolorbox}[
  colback=%s!5!white,
  colframe=%s!75!black,
  title={%s %s},
  breakable,
  enhanced,
  attach boxed title to top left={yshift=-2mm, xshift=2mm},
  boxed title style={size=small,colback=%s!75!black}
]
]], config.color, config.color, config.icon, config.title, config.color)
  
  -- Add content
  for _, block in ipairs(content) do
    latex = latex .. pandoc.write(pandoc.Pandoc({block}), "latex") .. "\n"
  end
  
  latex = latex .. "\\end{tcolorbox}"
  
  return pandoc.RawBlock("latex", latex)
end

-- Generate HTML callout box
function generateHtmlCallout(calloutType, title, content)
  local config = callouts[calloutType]
  if not config then
    return nil
  end
  
  local html = string.format([[
<div class="callout callout-%s" style="border-left: 4px solid %s; background-color: %s10; padding: 1rem; margin: 1rem 0;">
  <div class="callout-title" style="font-weight: bold; color: %s; margin-bottom: 0.5rem;">
    <span class="callout-icon">%s</span> %s
  </div>
  <div class="callout-content">
]], config.style, config.color, config.color, config.color, config.icon, config.title)
  
  -- Add content
  for _, block in ipairs(content) do
    html = html .. pandoc.write(pandoc.Pandoc({block}), "html") .. "\n"
  end
  
  html = html .. [[
  </div>
</div>
]]
  
  return pandoc.RawBlock("html", html)
end

-- Main filter function
function BlockQuote(elem)
  -- Check if this is a callout blockquote
  if not elem.content or #elem.content == 0 then
    return elem
  end
  
  local calloutType = detectCalloutType(elem.content)
  if not calloutType then
    return elem -- Not a callout, return unchanged
  end
  
  local title, content = parseCallout(elem)
  
  -- Generate appropriate output based on format
  if FORMAT:match "latex" then
    return generateLatexCallout(calloutType, title, content)
  elseif FORMAT:match "html" then
    return generateHtmlCallout(calloutType, title, content)
  else
    -- For other formats, return enhanced blockquote
    local enhancedContent = {}
    local config = callouts[calloutType]
    
    -- Add title as first paragraph
    table.insert(enhancedContent, pandoc.Para({
      pandoc.Strong({pandoc.Str(config.icon .. " " .. config.title .. ": " .. title)})
    }))
    
    -- Add original content
    for _, block in ipairs(content) do
      table.insert(enhancedContent, block)
    end
    
    return pandoc.BlockQuote(enhancedContent)
  end
end

-- Return the filter
return {
  {
    BlockQuote = BlockQuote
  }
}
