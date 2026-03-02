.PHONY: quality lint link-check

quality: lint link-check
	@echo "All quality checks passed."

lint:
	npx markdownlint-cli2 "**/*.md"

link-check:
	npx --yes markdown-link-check README.md specification/FCP.md CONTRIBUTING.md GOVERNANCE.md SECURITY.md
