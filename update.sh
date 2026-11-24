#!/usr/bin/env bash
# Refresh version.json from the live release manifest and pin the file's hash.
# Needs: curl, jq, nix (flakes enabled). Run after every new release.
set -euo pipefail
cd "$(dirname "$0")"
json=$(curl -fsSL https://asas.archiqueer.com/releases/latest.json)
version=$(jq -r .version <<<"$json")
url=$(jq -r '.platforms["linux-x86_64"].url' <<<"$json")
hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
jq -n --arg v "$version" --arg u "$url" --arg h "$hash" \
  '{version:$v, url:$u, hash:$h}' > version.json
echo "pinned $version  $hash"
