#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v idf.py >/dev/null 2>&1; then
  activation_script=""
  if [[ -n "${IDF_PATH:-}" && -f "${IDF_PATH}/export.sh" ]]; then
    activation_script="${IDF_PATH}/export.sh"
  else
    for candidate in "${HOME}/.espressif/tools"/activate_idf_v*.sh; do
      if [[ -f "${candidate}" ]]; then
        activation_script="${candidate}"
      fi
    done
  fi

  if [[ -n "${activation_script}" ]]; then
    exec bash -c 'source "$1" >/dev/null && cd "$2" && idf.py -B build.clang -D IDF_TOOLCHAIN=clang reconfigure' \
      bash "${activation_script}" "${project_root}"
  fi
fi

if ! command -v idf.py >/dev/null 2>&1; then
  echo "ESP-IDF was not found. Activate ESP-IDF first, then rerun this script." >&2
  exit 1
fi

cd "${project_root}"
idf.py -B build.clang -D IDF_TOOLCHAIN=clang reconfigure
