#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
temporary="$root/catalog.json.tmp"
trap 'rm -f "$temporary"' EXIT HUP INT TERM

duplicate_ids=$(jq -r '.app.id' "$root"/recipes/*.json | sort | uniq -d)
if [ -n "$duplicate_ids" ]; then
	echo "Duplicate recipe IDs:"
	echo "$duplicate_ids"
	exit 1
fi

for recipe in "$root"/recipes/*.json; do
	filename=$(basename "$recipe" .json)
	identifier=$(jq -r '.app.id' "$recipe")
	if [ "$filename" != "$identifier" ]; then
		echo "$recipe: filename must match app.id ($identifier)"
		exit 1
	fi
done

jq -s '{version: 1, apps: (map(.app) | sort_by(.id))}' "$root"/recipes/*.json > "$temporary"
mv "$temporary" "$root/catalog.json"
trap - EXIT HUP INT TERM
