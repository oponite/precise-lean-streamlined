#!/usr/bin/env bash
set -e
curl -fsSL https://raw.githubusercontent.com/vijayneelakantan/precise-lean-streamlined/main/pls.sh | bash
if command -v pls >/dev/null; then
  echo "✅ pls installed successfully"
else
  echo "⚠️  pls command not found – check your PATH"
fi