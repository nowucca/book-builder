--[[
Minted Filter for Pandoc
Converts code blocks to use minted package instead of default highlighting
]]--

function CodeBlock(block)
  -- Only process for LaTeX output
  if not FORMAT:match "latex" then
    return block
  end

  -- Get the language (first class if available)
  local lang = 'text'
  if block.classes and #block.classes > 0 then
    lang = block.classes[1]
  end

  -- Get the code content
  local code = block.text

  -- Generate minted environment
  local minted = string.format('\\begin{minted}{%s}\n%s\n\\end{minted}', lang, code)

  return pandoc.RawBlock('latex', minted)
end

-- Return the filter
return {
  {
    CodeBlock = CodeBlock
  }
}
