# Husky Git Hooks

This repository uses Husky to enforce commit message standards.

## Commit Message Format


<type>(<scope>): <subject>

<body>

<footer>

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `perf`: Performance improvements
- `revert`: Revert previous commit

### Examples:

bash
git commit -m "feat: add instance termination protection"
git commit -m "fix: resolve security group attachment issue"
git commit -m "docs: update README with usage examples"
git commit -m "chore: add husky for commit validation"

## Setup

bash
npm install
npm run prepare

## Testing Commit Message

bash
echo "test commit message" | npx commitlint
