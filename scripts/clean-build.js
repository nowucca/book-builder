#!/usr/bin/env node

/**
 * Clean Build Script
 * Removes build artifacts and temporary files
 */

const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');

const config = require('../config/book.config.js');

async function clean() {
  console.log(chalk.blue('🧹 Cleaning build artifacts...'));
  
  const rootDir = config.source.root;
  const buildDir = path.resolve(rootDir, 'build');
  
  try {
    // Remove build directory
    if (await fs.pathExists(buildDir)) {
      await fs.remove(buildDir);
      console.log(chalk.green('✅ Removed build directory'));
    } else {
      console.log(chalk.gray('Build directory does not exist'));
    }
    
    // Remove any temporary files
    const tempFiles = [
      path.resolve(rootDir, 'temp-input.md'),
      path.resolve(rootDir, '*.tmp')
    ];
    
    for (const tempFile of tempFiles) {
      if (await fs.pathExists(tempFile)) {
        await fs.remove(tempFile);
        console.log(chalk.green(`✅ Removed ${path.basename(tempFile)}`));
      }
    }
    
    console.log(chalk.green('🎉 Clean completed successfully!'));
    
  } catch (error) {
    console.error(chalk.red('❌ Clean failed:', error.message));
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  clean();
}

module.exports = clean;
