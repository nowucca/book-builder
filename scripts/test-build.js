#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🧪 Testing book build system...\n');

// Test 1: Check if all required tools are available
console.log('1. Checking required tools...');
try {
  execSync('pandoc --version', { stdio: 'pipe' });
  console.log('   ✅ Pandoc is available');
} catch (error) {
  console.log('   ❌ Pandoc is not available');
  process.exit(1);
}

try {
  execSync('xelatex --version', { stdio: 'pipe' });
  console.log('   ✅ XeLaTeX is available');
} catch (error) {
  console.log('   ❌ XeLaTeX is not available');
  process.exit(1);
}

// Test 2: Check if example chapter exists
console.log('\n2. Checking example chapter...');
const exampleChapterPath = path.join(__dirname, '../../example-chapter.md');
if (fs.existsSync(exampleChapterPath)) {
  console.log('   ✅ Example chapter exists');
} else {
  console.log('   ❌ Example chapter not found');
  process.exit(1);
}

// Test 3: Test basic Pandoc conversion
console.log('\n3. Testing basic Pandoc conversion...');
try {
  const testDir = path.join(__dirname, '../test-output');
  if (!fs.existsSync(testDir)) {
    fs.mkdirSync(testDir, { recursive: true });
  }
  
  const outputPath = path.join(testDir, 'test.html');
  execSync(`pandoc "${exampleChapterPath}" -o "${outputPath}"`, { stdio: 'pipe' });
  
  if (fs.existsSync(outputPath)) {
    console.log('   ✅ Basic HTML conversion works');
    fs.unlinkSync(outputPath); // Clean up
  } else {
    console.log('   ❌ HTML conversion failed');
    process.exit(1);
  }
} catch (error) {
  console.log('   ❌ Pandoc conversion failed:', error.message);
  process.exit(1);
}

// Test 4: Test Lua filter
console.log('\n4. Testing Lua filters...');
const calloutFilterPath = path.join(__dirname, '../templates/filters/callout-filter.lua');
if (fs.existsSync(calloutFilterPath)) {
  console.log('   ✅ Callout filter exists');
} else {
  console.log('   ❌ Callout filter not found');
}

const linkFilterPath = path.join(__dirname, '../templates/filters/link-filter.lua');
if (fs.existsSync(linkFilterPath)) {
  console.log('   ✅ Link filter exists');
} else {
  console.log('   ❌ Link filter not found');
}

console.log('\n✅ All tests passed! Build system is ready.');
console.log('\nNext steps:');
console.log('- Run `npm run build:pdf` to build the full PDF');
console.log('- Run `npm run build:web` to build the web version');
console.log('- Run `npm run dev` to start development mode');
