# Installation Guide for the **pls** Skill

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/vijayneelakantan/precise-lean-streamlined/main/install-pls.sh | bash
```

This script downloads the latest version of the `pls` skill, installs it, and verifies the installation.

## What the script does

1. Downloads the `pls` installer (`install-pls.sh`) from the repository.
2. Runs the installer which places the `pls` executable on your `$PATH`.
3. Checks that the `pls` command is now available and prints a success or warning message.

## Verify the installation

After the script finishes, run:

```bash
pls --help
```

You should see the usage information for the `pls` command, confirming that the skill is correctly installed.

## Homebrew installation (macOS users)

If you prefer Homebrew:

```bash
brew tap vijayneelakantan/tools && brew install pls
```

Then verify with `pls --help` as above.

## Optional: VS Code extension recommendation

Create a file at `.vscode/extensions.json` with the following content to have VS Code suggest the extension automatically when the repo is opened:

```json
{
  "recommendations": ["vijayneelakantan.pls-skill"]
}
```

---

*For any issues, ensure your terminal’s `$PATH` includes the directory where the installer placed the `pls` executable.*
