#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

ADDITIONAL_ARGS=()

if [[ -n "${FLATPAK_ID:-}" && -n "${XDG_RUNTIME_DIR:-}" ]]; then
  export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
fi

if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
  # TODO: Rework this when application upgrades to Electron 38
  ADDITIONAL_ARGS+=("--enable-features=UseOzonePlatform")
  ADDITIONAL_ARGS+=("--enable-wayland-ime")
  ADDITIONAL_ARGS+=("--ozone-platform-hint=auto")
  ADDITIONAL_ARGS+=("--wayland-text-input-version=3")
fi

if [[ "${RI_DEBUG_ENABLED:-}" == "true" ]]; then
  printf "ADDITIONAL_ARGS: [%s]\n" "${ADDITIONAL_ARGS[*]:-}"
  printf "TMPDIR: %s\n" "${TMPDIR:-}"
  printf "XDG_CURRENT_DESKTOP: %s\n" "${XDG_CURRENT_DESKTOP:-}"
  printf "XDG_SESSION_TYPE: %s\n" "${XDG_SESSION_TYPE:-}"
fi

exec zypak-wrapper "/app/redisinsight/redisinsight" "${ADDITIONAL_ARGS[@]}" "$@"
