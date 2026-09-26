#!/usr/bin/env bash
# Usage: ./new-project.sh <path/to/project-name>   (e.g. ~/p/my-site or ../my-site)
# Scaffolds an Astro + shadcn project at that path, then copies the skills/MCP config into it.
set -euo pipefail

target="${1:?Usage: ./new-project.sh <path/to/project-name>}"
src="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$(dirname "$target")"
parent="$(cd "$(dirname "$target")" && pwd)"
name="$(basename "$target")"
dest="$parent/$name"

[ "$dest" = "$src" ] && { echo "Target can't be the template folder"; exit 1; }
[ -e "$dest" ] && { echo "$dest already exists"; exit 1; }

pnpm dlx shadcn@latest init -t astro -b base --no-monorepo -p maia -n "$name" --cwd "$parent"

rsync -a --exclude .git --exclude README.md --exclude CLAUDE.md --exclude LICENSE --exclude .gitignore --exclude new-project.sh --exclude .claude/settings.json "$src/" "$dest/"

cd "$dest"
git init -q
pnpm add gsap

echo "Done: $dest"
