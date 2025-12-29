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

-- Generate LaTeX callout box (no emojis) - HTML-style with colored text title and swooped left bar
function generateLatexCallout(calloutType, content)
  local config = callouts[calloutType]
  if not config then
    return nil
  end

  -- HTML-style: colored text title (no colored background), swooped left bar
  -- Code callouts: 1em title left margin, 0.5em content left/right
  -- Other callouts: 1em all around
  local contentMargins = ""
  local titleLeftMargin = "1em"

  if calloutType == "code" then
    contentMargins = ",\n  left=0.5em,\n  right=0.5em,\n  top=0.5em,\n  bottom=0.5em"
  else
    contentMargins = ",\n  left=1em,\n  right=1em,\n  top=0.5em,\n  bottom=0.5em"
  end

  -- Rounded box with colored text title and swooped left bar (HTML-style)
  local latex = string.format([[
\begin{tcolorbox}[
  colback=%s!5!white,
  coltitle=%s!75!black,
  title={\hspace{%s}\textcolor{%s!75!black}{\textbf{%s}}},
  fonttitle=\small,
  frame hidden,
  breakable,
  enhanced,
  rounded corners,
  arc=3pt,
  boxrule=0pt,
  toptitle=0.3em,
  bottomtitle=0.3em,
  overlay={
    \fill[%s!75!black]
      ([xshift=2pt,yshift=-3pt]interior.north west)
      to[out=90,in=180] ([xshift=0pt,yshift=0pt]interior.north west)
      to[out=0,in=90] ([xshift=2pt,yshift=-3pt]interior.north west)
      -- ([xshift=2pt,yshift=3pt]interior.south west)
      to[out=-90,in=180] ([xshift=0pt,yshift=0pt]interior.south west)
      to[out=0,in=-90] ([xshift=2pt,yshift=3pt]interior.south west)
      -- ([xshift=6pt,yshift=3pt]interior.south west)
      to[out=-90,in=0] ([xshift=0pt,yshift=0pt]interior.south west)
      to[out=180,in=-90] ([xshift=6pt,yshift=3pt]interior.south west)
      -- ([xshift=6pt,yshift=-3pt]interior.north west)
      to[out=90,in=0] ([xshift=0pt,yshift=0pt]interior.north west)
      to[out=180,in=90] ([xshift=6pt,yshift=-3pt]interior.north west)
      -- cycle;
  }%s
]
]], config.latexcolor, config.latexcolor, titleLeftMargin, config.latexcolor, config.title, config.latexcolor, contentMargins)

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
