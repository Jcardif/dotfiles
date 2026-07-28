#!/usr/bin/env bash
# Installs the shared agent skills into ~/.agents/skills, then points the
# Claude Code and Codex skill folders at that one directory.
#
# The skills are not stored in this repository. Run this script by hand when
# you set up a machine. install.sh does not call it.
set -euo pipefail

add() {
  local repo="$1" skill="$2"
  echo "==> $skill"
  npx skills add "$repo" --skill "$skill"
}

add https://github.com/github/awesome-copilot aspire
add https://github.com/github/awesome-copilot containerize-aspnetcore
add https://github.com/openai/skills aspnet-core
add https://github.com/upstash/context7 find-docs
add https://github.com/yctimlin/mcp_excalidraw excalidraw-skill
add https://github.com/Jcardif/agent-skills markdownlint
add https://github.com/vercel-labs/next-skills next-best-practices
add https://github.com/anthropics/skills pdf
add https://github.com/anthropics/skills xlsx
add https://github.com/anthropics/skills frontend-design
add https://github.com/wshobson/agents rust-async-patterns
add https://github.com/apollographql/skills rust-best-practices
add https://github.com/mattpocock/skills write-a-prd
add https://github.com/mattpocock/skills teach
add https://github.com/mattpocock/skills wayfinder

echo "==> linking skill folders"

# ln follows an existing real directory and puts the link inside it. Refuse that
# case, so the caller moves the directory instead of hiding it.
link() {
  local path="$1"
  if [ -d "$path" ] && [ ! -L "$path" ]; then
    echo "skipped $path: it is a real directory. Move it, then run this script again."
    return
  fi
  ln -sfn "$HOME/.agents/skills" "$path"
  echo "linked $path"
}

link "$HOME/.claude/skills"
link "$HOME/.codex/skills"
