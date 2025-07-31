--[[
Link Filter for Constellize Book
Processes repository links and ensures they work correctly in different output formats
]]--

-- Helper function to check if a link is a repository link
function isRepositoryLink(url)
  return url:match("{REPO_BASE}") ~= nil
end

-- Helper function to check if a link points to a code file
function isCodeLink(url)
  local codeExtensions = {".java", ".js", ".ts", ".py", ".go", ".rs", ".cpp", ".c", ".h", ".hpp", ".md", ".yml", ".yaml", ".json", ".xml", ".sql", ".sh", ".dockerfile"}
  
  for _, ext in ipairs(codeExtensions) do
    if url:lower():match(ext:gsub("%.", "%%%.") .. "$") or url:lower():match(ext:gsub("%.", "%%%.") .. "#") then
      return true
    end
  end
  
  return false
end

-- Helper function to extract line numbers from URL fragment
function extractLineNumbers(url)
  local lineMatch = url:match("#L(%d+)%-?L?(%d*)")
  if lineMatch then
    local startLine = tonumber(lineMatch)
    local endLine = lineMatch:match("%-L(%d+)") and tonumber(lineMatch:match("%-L(%d+)")) or startLine
    return startLine, endLine
  end
  return nil, nil
end

-- Helper function to get file type from extension
function getFileType(url)
  if url:match("%.java$") or url:match("%.java#") then
    return "Java"
  elseif url:match("%.js$") or url:match("%.js#") then
    return "JavaScript"
  elseif url:match("%.ts$") or url:match("%.ts#") then
    return "TypeScript"
  elseif url:match("%.py$") or url:match("%.py#") then
    return "Python"
  elseif url:match("%.md$") or url:match("%.md#") then
    return "Markdown"
  elseif url:match("%.yml$") or url:match("%.yml#") or url:match("%.yaml$") or url:match("%.yaml#") then
    return "YAML"
  elseif url:match("%.json$") or url:match("%.json#") then
    return "JSON"
  elseif url:match("%.sql$") or url:match("%.sql#") then
    return "SQL"
  elseif url:match("%.sh$") or url:match("%.sh#") then
    return "Shell"
  elseif url:match("[Dd]ockerfile") then
    return "Docker"
  else
    return "Code"
  end
end

-- Enhanced link processing for LaTeX output
function processLinkForLatex(elem)
  local url = elem.target
  local text = pandoc.utils.stringify(elem.content)
  
  if isRepositoryLink(url) then
    if isCodeLink(url) then
      local fileType = getFileType(url)
      local startLine, endLine = extractLineNumbers(url)
      
      -- Create enhanced link with file type and line info
      local linkText = text
      if startLine then
        if endLine and endLine ~= startLine then
          linkText = linkText .. " (lines " .. startLine .. "-" .. endLine .. ")"
        else
          linkText = linkText .. " (line " .. startLine .. ")"
        end
      end
      
      -- For PDF, we want the link to be clickable but also show the URL in a footnote
      local footnoteText = "\\footnote{\\url{" .. url .. "}}"
      
      return {
        pandoc.Link(elem.content, url, elem.title),
        pandoc.RawInline("latex", footnoteText)
      }
    end
  end
  
  return elem
end

-- Enhanced link processing for HTML output
function processLinkForHtml(elem)
  local url = elem.target
  local text = pandoc.utils.stringify(elem.content)
  
  if isRepositoryLink(url) then
    if isCodeLink(url) then
      local fileType = getFileType(url)
      local startLine, endLine = extractLineNumbers(url)
      
      -- Add CSS classes and data attributes for styling
      local attributes = {
        class = "repo-link code-link",
        ["data-file-type"] = fileType:lower(),
        target = "_blank",
        rel = "noopener noreferrer"
      }
      
      if startLine then
        attributes["data-start-line"] = tostring(startLine)
        if endLine and endLine ~= startLine then
          attributes["data-end-line"] = tostring(endLine)
        end
      end
      
      -- Create enhanced link element
      local link = pandoc.Link(elem.content, url, elem.title)
      link.attributes = attributes
      
      return link
    else
      -- Regular repository link
      local attributes = {
        class = "repo-link",
        target = "_blank",
        rel = "noopener noreferrer"
      }
      
      local link = pandoc.Link(elem.content, url, elem.title)
      link.attributes = attributes
      
      return link
    end
  end
  
  return elem
end

-- Main link processing function
function Link(elem)
  -- Skip processing if URL is empty or not a string
  if not elem.target or type(elem.target) ~= "string" then
    return elem
  end
  
  -- Process based on output format
  if FORMAT:match "latex" then
    return processLinkForLatex(elem)
  elseif FORMAT:match "html" then
    return processLinkForHtml(elem)
  else
    -- For other formats, return as-is
    return elem
  end
end

-- Process code blocks that might contain repository references
function CodeBlock(elem)
  -- Look for repository URLs in code comments
  local content = elem.text
  
  -- Replace {REPO_BASE} in code blocks (useful for configuration examples)
  if content:match("{REPO_BASE}") then
    -- Note: The actual replacement should have been done by the build script
    -- This is just a fallback
    content = content:gsub("{REPO_BASE}", "https://github.com/yourusername/constellize-book/blob/main")
    return pandoc.CodeBlock(content, elem.attr)
  end
  
  return elem
end

-- Process inline code that might contain repository references
function Code(elem)
  local content = elem.text
  
  -- Replace {REPO_BASE} in inline code
  if content:match("{REPO_BASE}") then
    content = content:gsub("{REPO_BASE}", "https://github.com/yourusername/constellize-book/blob/main")
    return pandoc.Code(content, elem.attr)
  end
  
  return elem
end

-- Return the filter functions
return {
  {
    Link = Link,
    CodeBlock = CodeBlock,
    Code = Code
  }
}
