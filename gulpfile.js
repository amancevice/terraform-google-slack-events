const { exec } = require('child_process');
const pkg = require('./package.json');
const gulp = require('gulp');
const file = require('gulp-file');
const zip = require('gulp-zip');

// Run `npm install`
gulp.task('npm-install', () => {
  return exec('npm install');
});

// Build artifacts
gulp.task('build', () => {
  return gulp.src([
      'src/.gitignore',
      'src/README',
      'src/config.tpl',
      'src/terraform.tf'
    ])
    .pipe(file('VERSION', pkg.version))
    .pipe(file('terraform.tfvars', ''))
    .pipe(gulp.dest('build/slack-drive'));
});

// Dist artifact
gulp.task('dist', () => {
  return gulp.src(['build/**'], {dot: true})
    .pipe(zip(`slack-event-publisher-${pkg.version}.zip`))
    .pipe(gulp.dest('dist'));
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
gulp.task('default', gulp.series(['npm-install', 'build', 'dist']));
