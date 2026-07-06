module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation
        'style',    // Formatting
        'refactor', // Code restructuring
        'test',     // Adding tests
        'chore',    // Maintenance
        'ci',       // CI/CD changes
        'perf',     // Performance improvements
        'revert'    // Revert previous commit
      ]
    ],
    'subject-case': [0]
  }
};
