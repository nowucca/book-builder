--[[
Callout Filter for Constellize Book
Processes custom callout syntax in markdown and converts to appropriate format
]]--

-- Callout configurations (without emoji icons for PDF compatibility)
local callouts = {
  info = {
    title = "Info",
    style = "info",
    latexcolor = "blue",
    htmlcolor = "#0066cc"
  },
  code = {
    title = "Code",
    style = "primary",
    latexcolor = "violet",
    htmlcolor = "#6f42c1"
  },
  success = {
    title = "Success",
    style = "success",
    latexcolor = "green",
    htmlcolor = "#28a745"
  },
  warning = {
    title = "Warning",
    style = "warning",
    latexcolor = "orange",
    htmlcolor = "#ffc107"
  },
  error = {
    title = "Error",
    style = "danger",
    latexcolor = "red",
    htmlcolor = "#dc3545"
  }
}

-- Generate LaTeX callout box (no emojis)
function generateLatexCallout(calloutType, content)
  local config = callouts[calloutType]
  if not config then
    return nil
  end
  
  local latex = string.format([[
\begin{tcolorbox}[
  colback=%s!5!white,
  colframe=%s!75!black,
  title={%s},
  breakable,
  enhanced,
  attach boxed title to top left={yshift=-2mm, xshift=2mm},
  boxed title style={size=small,colback=%s!75!black}
]
]], config.latexcolor, config.latexcolor, config.title, config.latexcolor)
  
  -- Add content
  for _, block in ipairs(content) do
    latex = latex .. pandoc.write(pandoc.Pandoc({block}), "latex") .. "\n"
  end
  
  latex = latex .. "\\end{tcolorbox}"
  
  return pandoc.RawBlock("latex", latex)
end

-- Generate HTML callout box (no emojis)
function generateHtmlCallout(calloutType, content)
  local config = callouts[calloutType]
  if not config then
    return nil
  end
  
  local html = string.format([[
<div class="callout callout-%s" style="border-left: 4px solid %s; background-color: %s10; padding: 1rem; margin: 1rem 0;">
  <div class="callout-title" style="font-weight: bold; color: %s; margin-bottom: 0.5rem;">
    %s
  </div>
  <div class="callout-content">
]], config.style, config.htmlcolor, config.htmlcolor, config.htmlcolor, config.title)
  
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

-- Main filter function for Div elements (fenced divs like ::: info)
function Div(elem)
  -- Check if this is a callout div
  if not elem.classes or #elem.classes == 0 then
    return elem
  end
  
  -- Get the callout type from the first class
  local calloutType = elem.classes[1]
  
  -- Check if it's a recognized callout type
  if not callouts[calloutType] then
    return elem -- Not a recognized callout, return unchanged
  end
  
  -- Generate appropriate output based on format
  if FORMAT:match "latex" then
    return generateLatexCallout(calloutType, elem.content)
  elseif FORMAT:match "html" then
    return generateHtmlCallout(calloutType, elem.content)
  else
    -- For other formats, return enhanced div
    return elem
  end
end

-- Return the filter
return {
  {
    Div = Div
  }
}
