#!/usr/bin/env bash

set -euo pipefail

revision="${1:-HEAD}"
output_dir="${2:-dist}"

mkdir -p "$output_dir"

declare -A archive_names=()
skill_count=0

while IFS= read -r -d '' skill_file; do
  skill_dir="${skill_file%/SKILL.md}"
  skill_name="${skill_dir##*/}"
  archive_path="$output_dir/$skill_name.zip"

  if [[ -n "${archive_names[$skill_name]:-}" ]]; then
    printf 'Duplicate skill directory name "%s": %s and %s\n' \
      "$skill_name" "${archive_names[$skill_name]}" "$skill_dir" >&2
    exit 1
  fi

  archive_names["$skill_name"]="$skill_dir"
  git archive \
    --format=zip \
    --prefix="$skill_name/" \
    --output="$archive_path" \
    "$revision:$skill_dir"

  printf 'Created %s from %s\n' "$archive_path" "$skill_dir"
  ((skill_count += 1))
done < <(
  git ls-tree -r --name-only -z "$revision" |
    while IFS= read -r -d '' path; do
      if [[ "$path" == */SKILL.md ]]; then
        printf '%s\0' "$path"
      fi
    done
)

if ((skill_count == 0)); then
  printf 'No directories containing SKILL.md found at %s\n' "$revision" >&2
  exit 1
fi
