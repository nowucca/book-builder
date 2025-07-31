#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Comprehensive emoji detection regex covering major Unicode blocks
const emojiRegex = new RegExp([
  // Emoticons
  '[\u{1F600}-\u{1F64F}]',
  // Miscellaneous Symbols and Pictographs
  '[\u{1F300}-\u{1F5FF}]',
  // Transport and Map Symbols
  '[\u{1F680}-\u{1F6FF}]',
  // Miscellaneous Symbols
  '[\u{2600}-\u{26FF}]',
  // Dingbats
  '[\u{2700}-\u{27BF}]',
  // Miscellaneous Symbols and Arrows
  '[\u{2B00}-\u{2BFF}]',
  // Supplemental Symbols and Pictographs
  '[\u{1F900}-\u{1F9FF}]',
  // Symbols and Pictographs Extended-A
  '[\u{1FA70}-\u{1FAFF}]',
  // Additional emoji ranges
  '[\u{1F004}\u{1F0CF}]',
  '[\u{1F170}-\u{1F251}]',
  '[\u{1F004}-\u{1F0CF}]',
  '[\u{1F18E}]',
  '[\u{3030}\u{303D}]',
  '[\u{3297}\u{3299}]',
  // Fitzpatrick modifiers
  '[\u{1F3FB}-\u{1F3FF}]',
  // Zero Width Joiner sequences (simplified detection)
  '[\u{200D}]',
  // Variation selectors for emoji
  '[\u{FE0F}]'
].join('|'), 'gu');

// Approved emojis that are safe for PDF rendering
// These are simple Unicode characters that render well in most contexts
const approvedEmojis = new Set([
  '✓', // Check mark (U+2713)
  '✔', // Heavy check mark (U+2714)
  '✅', // White heavy check mark (U+2705) - keeping for now but may need review
  '❌', // Cross mark (U+274C) - keeping for now but may need review
  '⚠', // Warning sign (U+26A0)
  '⚡', // High voltage (U+26A1)
  '⭐', // White medium star (U+2B50)
  '🔍', // Left-pointing magnifying glass (U+1F50D) - keeping for now but may need review
  '📝', // Memo (U+1F4DD) - keeping for now but may need review
  '🚀', // Rocket (U+1F680) - keeping for now but may need review
  '️', // Variation Selector-16 (U+FE0F) - invisible formatting character for emoji presentation
]);

// File patterns for book content (same as strip-emojis.js)
const bookContentPatterns = [
  /^ch\d+.*\.md$/,     // Chapter files (ch1.md, ch2.md, etc.)
  /^app[A-Z].*\.md$/,  // Appendix files (appA.md, appB.md, etc.)
  /^foreword.*\.md$/,  // Foreword files
  /^README\.md$/,      // Main README
  /^tone\.md$/         // Tone guide
];

// Patterns to exclude (narrative and development files)
const excludePatterns = [
  /^codepromptu\//,
  /^narrative-/,
  /^memory-bank\//,
  /^marketing\//,
  /^tools\//,
  /^build\//,
  /^\.git/,
  /^node_modules\//,
  /example-chapter\.md$/,
  /ch1-revised\.md$/,
  /ch4a\.md$/,
  /README-teaser\.md$/
];

function shouldProcessFile(filePath) {
  const relativePath = path.relative(process.cwd(), filePath);
  
  // Exclude narrative and development files
  for (const pattern of excludePatterns) {
    if (pattern.test(relativePath)) {
      return false;
    }
  }
  
  // Only include book content files
  const fileName = path.basename(relativePath);
  for (const pattern of bookContentPatterns) {
    if (pattern.test(fileName)) {
      return true;
    }
  }
  
  return false;
}

function findEmojisInText(text) {
  const matches = [];
  let match;
  
  while ((match = emojiRegex.exec(text)) !== null) {
    matches.push({
      emoji: match[0],
      index: match.index
    });
  }
  
  return matches;
}

function getLineAndColumn(text, index) {
  const lines = text.substring(0, index).split('\n');
  return {
    line: lines.length,
    column: lines[lines.length - 1].length + 1
  };
}

function validateEmojis() {
  console.log('🔍 Validating emoji usage in book content files...\n');
  
  // Find all markdown files
  const markdownFiles = glob.sync('**/*.md', {
    ignore: ['node_modules/**', 'build/**', '.git/**']
  });
  
  // Filter to book content files
  const bookFiles = markdownFiles.filter(shouldProcessFile);
  
  console.log(`Found ${bookFiles.length} book content files to validate:\n`);
  
  let hasErrors = false;
  const violations = [];
  
  for (const filePath of bookFiles) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const emojis = findEmojisInText(content);
      
      if (emojis.length > 0) {
        console.log(`📄 Checking ${filePath}:`);
        
        const fileViolations = [];
        
        for (const { emoji, index } of emojis) {
          if (!approvedEmojis.has(emoji)) {
            const { line, column } = getLineAndColumn(content, index);
            const violation = {
              file: filePath,
              emoji,
              line,
              column,
              unicode: `U+${emoji.codePointAt(0).toString(16).toUpperCase().padStart(4, '0')}`
            };
            
            fileViolations.push(violation);
            violations.push(violation);
            hasErrors = true;
            
            console.log(`  ❌ Line ${line}, Column ${column}: "${emoji}" (${violation.unicode}) - NOT APPROVED`);
          } else {
            const { line, column } = getLineAndColumn(content, index);
            console.log(`  ✅ Line ${line}, Column ${column}: "${emoji}" - approved`);
          }
        }
        
        if (fileViolations.length === 0) {
          console.log(`  ✅ All ${emojis.length} emoji(s) are approved`);
        }
        console.log();
      } else {
        console.log(`✅ ${filePath} - no emojis found`);
      }
    } catch (error) {
      console.error(`❌ Error reading ${filePath}: ${error.message}`);
      hasErrors = true;
    }
  }
  
  console.log('\n📊 Validation Summary:');
  console.log(`   Files checked: ${bookFiles.length}`);
  console.log(`   Violations found: ${violations.length}`);
  
  if (hasErrors) {
    console.log('\n❌ EMOJI VALIDATION FAILED');
    console.log('\nUnapproved emojis detected in book content files:');
    
    for (const violation of violations) {
      console.log(`  ${violation.file}:${violation.line}:${violation.column} - "${violation.emoji}" (${violation.unicode})`);
    }
    
    console.log('\nTo fix these issues:');
    console.log('1. Remove the unapproved emojis from the files listed above');
    console.log('2. Replace with approved alternatives if needed');
    console.log('3. Or add the emoji to the approved list in tools/scripts/validate-emojis.js');
    console.log('\nApproved emojis:', Array.from(approvedEmojis).join(' '));
    
    process.exit(1);
  } else {
    console.log('\n✅ EMOJI VALIDATION PASSED');
    console.log('All emojis in book content files are approved for PDF rendering.');
  }
}

// Run validation if called directly
if (require.main === module) {
  validateEmojis();
}

module.exports = { validateEmojis, approvedEmojis };
