#!/usr/bin/env bash

# Shared helpers for the asdf-b2 plugin.
#
# Sourced by every script under bin/. Keep this file small — it runs
# on every asdf invocation that touches the plugin.

set -euo pipefail

# GitHub repository hosting the B2 CLI release binaries.
readonly GH_REPO="https://github.com/Backblaze/B2_Command_Line_Tool"

# Tool name shown in error messages.
readonly TOOL_NAME="b2"

# The single binary the plugin installs into <install_path>/bin/.
readonly BIN_NAME="b2"

# fail prints msg to stderr and exits 1.
fail() {
  echo "asdf-${TOOL_NAME}: $*" >&2
  exit 1
}

# Detect operating system. Only Linux is supported — Backblaze stopped
# publishing pre-built macOS binaries starting v4.0.0. macOS users can
# install via Homebrew (`brew install b2-tools`) or pip (`pip install b2`).
detect_os() {
  local kernel
  kernel="$(uname -s)"
  case "$kernel" in
    Linux)
      echo "linux"
      ;;
    Darwin)
      fail "macOS is not supported — Backblaze stopped publishing macOS binaries in v4.x. Install via 'brew install b2-tools' or 'pip install b2' instead."
      ;;
    *)
      fail "unsupported OS: $kernel"
      ;;
  esac
}

# Detect architecture. Backblaze publishes x86_64 (the default
# `b2-linux` asset, no suffix) and aarch64 (`b2-linux-aarch64`).
detect_arch_suffix() {
  case "$(uname -m)" in
    x86_64 | amd64)
      echo ""
      ;;
    aarch64 | arm64)
      echo "-aarch64"
      ;;
    *)
      fail "unsupported architecture: $(uname -m)"
      ;;
  esac
}

# Construct the download URL for a given version.
release_url() {
  local version="$1"
  local os arch_suffix
  os="$(detect_os)"
  arch_suffix="$(detect_arch_suffix)"

  echo "${GH_REPO}/releases/download/v${version}/b2-${os}${arch_suffix}"
}

# Sort versions semantically (1.10 > 1.9).
sort_versions() {
  sed 's/^v//' \
    | LC_ALL=C sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n -k 5,5n -k 6,6n
}

# List all release tags from the upstream repo, stripped of the leading v.
# Uses git ls-remote (no GitHub API rate limit) and filters out the {} suffix
# git emits for annotated tag targets.
list_all_versions() {
  git ls-remote --tags --refs "${GH_REPO}.git" \
    | awk -F/ '{print $NF}' \
    | grep -v '\^' \
    | sed 's/^v//' \
    | sort_versions
}
