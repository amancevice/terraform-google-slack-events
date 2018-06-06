const { exec } = require('child_process');
const pkg = require('./package.json');
const gulp = require('gulp');

// Run `npm install`
gulp.task('npm-install', () => {
  return exec('npm install');
});

// Travis deploy check
gulp.task('travis', () => {
  return new Promise((resolve, reject) => {
    if (process.env.TRAVIS_TAG !== pkg.version) {
      reject(new Error('$TRAVIS_TAG and package.json do not match'));
    }
    resolve();
  });
});

// Default
gulp.task('default', gulp.series(['npm-install']));
