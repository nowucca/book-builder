#!/usr/bin/env node

/**
 * Build All Versions Script
 * Generates all book formats: development, digital, print, and web
 */

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// Available targets
const TARGETS = ['development', 'digital', 'print', 'web'];

console.log('🚀 Building all book versions...\n');

const startTime = Date.now();
const results = {};

for (const target of TARGETS) {
  console.log(`📖 Building ${target} version...`);
  
  try {
    const buildStart = Date.now();
    
    // Execute the build command
    execSync(`node scripts/build-book.js --target ${target}`, {
      cwd: path.resolve(__dirname, '..'),
      stdio: 'inherit'
    });
    
    const buildTime = Date.now() - buildStart;
    results[target] = { success: true, time: buildTime };
    
    console.log(`✅ ${target} version completed in ${(buildTime / 1000).toFixed(1)}s\n`);
    
  } catch (error) {
    const buildTime = Date.now() - buildStart;
    results[target] = { success: false, time: buildTime, error: error.message };
    
    console.error(`❌ ${target} version failed after ${(buildTime / 1000).toFixed(1)}s`);
    console.error(`Error: ${error.message}\n`);
  }
}

// Summary
const totalTime = Date.now() - startTime;
const successful = Object.values(results).filter(r => r.success).length;
const failed = TARGETS.length - successful;

console.log('📊 Build Summary:');
console.log('================');

for (const [target, result] of Object.entries(results)) {
  const status = result.success ? '✅' : '❌';
  const time = (result.time / 1000).toFixed(1);
  console.log(`${status} ${target.padEnd(12)} ${time}s`);
}

console.log(`\n🏁 Total time: ${(totalTime / 1000).toFixed(1)}s`);
console.log(`✅ Successful: ${successful}`);
if (failed > 0) {
  console.log(`❌ Failed: ${failed}`);
}

// List output files
console.log('\n📁 Generated files:');
const buildDir = path.resolve(__dirname, '../../build');

if (fs.existsSync(buildDir)) {
  for (const target of TARGETS) {
    if (results[target]?.success) {
      const targetDir = path.join(buildDir, target);
      if (fs.existsSync(targetDir)) {
        const files = fs.readdirSync(targetDir);
        const bookFiles = files.filter(f => f.startsWith('constellize-book'));
        for (const file of bookFiles) {
          console.log(`   ${target}/${file}`);
        }
      }
    }
  }
}

// Exit with error code if any builds failed
if (failed > 0) {
  process.exit(1);
}

console.log('\n🎉 All versions built successfully!');
