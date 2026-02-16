# Contributing to FCP

Thank you for your interest in contributing to the Food Context Protocol!

## Code of Conduct

Be respectful, inclusive, and collaborative. We're building infrastructure for the food AI ecosystem.

See [GOVERNANCE.md](GOVERNANCE.md) for our full Code of Conduct.

## How to Contribute

### Reporting Issues

1. Check if issue already exists
2. Use [GitHub Issues](https://github.com/Food-Context-Protocol/fcp/issues)
3. Provide clear description:
   - What you expected
   - What actually happened
   - Steps to reproduce
   - Protocol version

**Template:**
```markdown
**Description:** Brief summary

**Expected Behavior:** What should happen

**Actual Behavior:** What actually happens

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Protocol Version:** v1.1

**Environment:**
- Implementation: Python server / Custom
- Runtime: Python 3.11 / Node.js 18
```

### Proposing Specification Changes

**For major changes** (new capabilities, breaking changes):

1. **Start a Discussion**
   - Open [GitHub Discussion](https://github.com/Food-Context-Protocol/fcp/discussions)
   - Use template: "Specification Proposal: [Title]"
   - Describe problem and proposed solution
   - Include example use cases

2. **Gather Feedback**
   - Minimum 2-week community discussion
   - Address concerns and questions
   - Iterate on proposal

3. **Submit Pull Request**
   - Update `specification/FCP.md`
   - Update relevant JSON schemas in `specification/schema/`
   - Add/update documentation in `docs/`
   - Include migration guide if breaking

4. **Technical Council Review**
   - TC reviews and votes
   - May request changes
   - Approved PRs are merged

**For minor changes** (clarifications, typos, examples):

1. Submit PR directly with clear description
2. Maintainer review and merge

### Contributing Documentation

1. Fork the repository
2. Create a feature branch: `git checkout -b docs/improve-getting-started`
3. Make changes in `docs/` directory
4. Test locally: `mkdocs serve`
5. Submit pull request

**Documentation Standards:**
- Use clear, concise language
- Include code examples
- Test all examples work
- Follow existing structure

### Implementing the Protocol

Want to implement FCP in another language?

1. Read [specification/FCP.md](specification/FCP.md) thoroughly
2. Implement core capabilities first (nutrition, recipes, safety)
3. Add tests to verify protocol compliance
4. Share your implementation via [Discussions](https://github.com/Food-Context-Protocol/fcp/discussions)

**We'd love to list your implementation in the README!**

## Development Setup

### Prerequisites

- Git
- Python 3.11+ (for MkDocs)
- Text editor

### Clone Repository

```bash
git clone https://github.com/Food-Context-Protocol/fcp.git
cd fcp
```

### Install MkDocs (for Documentation)

```bash
uv add mkdocs mkdocs-material
```

### Serve Documentation Locally

```bash
mkdocs serve
# Visit http://localhost:8000
```

### Repository Structure

```
fcp/
├── specification/          # Protocol spec (canonical)
├── specification/schema/   # JSON schemas for capabilities
├── docs/                   # MkDocs documentation
├── GOVERNANCE.md           # Governance model
├── CONTRIBUTING.md         # This file
└── README.md               # Protocol overview
```

## Pull Request Process

### Before Submitting

- [ ] Read the specification thoroughly
- [ ] Test your changes (if documentation, verify examples work)
- [ ] Update relevant documentation
- [ ] Write clear commit messages
- [ ] Ensure PR description explains what and why

### PR Template

```markdown
## Description
Brief summary of changes

## Motivation
Why is this change needed?

## Changes
- Change 1
- Change 2

## Testing
How did you test this?

## Breaking Changes
Does this break existing implementations? If yes, provide migration guide.

## Checklist
- [ ] Updated specification
- [ ] Updated schemas (if applicable)
- [ ] Updated documentation
- [ ] Added examples
- [ ] Tested changes
```

### Review Process

1. Maintainer reviews within 3 business days
2. Address feedback
3. TC approval required for spec changes
4. Merge to main

## Specification Standards

### Writing Style

- Use clear, precise language
- Define all terms in glossary
- Include examples for complex concepts
- Use RFC 2119 keywords (MUST, SHOULD, MAY)

### Schema Guidelines

- Use JSON Schema Draft 2020-12
- Include descriptions for all fields
- Provide examples
- Use consistent naming (snake_case)

### Example Quality

All examples MUST:
- Be valid according to schemas
- Include realistic data
- Demonstrate common use cases
- Be testable

## Communication Channels

- **Specification Proposals:** [GitHub Discussions](https://github.com/Food-Context-Protocol/fcp/discussions)
- **Bug Reports:** [GitHub Issues](https://github.com/Food-Context-Protocol/fcp/issues)
- **General Questions:** [Discussions](https://github.com/Food-Context-Protocol/fcp/discussions)
- **Security Issues:** security@fcp.dev (private)

## Recognition

Contributors are recognized in:
- README.md (significant contributions)
- Release notes
- Annual contributor highlights

## License

By contributing, you agree to license your work under Apache-2.0.

You will be asked to sign a Contributor License Agreement (CLA) via automated GitHub bot on your first PR.

## Questions?

Open a [Discussion](https://github.com/Food-Context-Protocol/fcp/discussions) or reach out to maintainers.

---

**Thank you for contributing to FCP!** 🍽️
