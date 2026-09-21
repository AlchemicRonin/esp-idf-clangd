#!/usr/bin/env bash
set -euo pipefail

pipeline_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_root="${1:-$(dirname "${pipeline_root}")}"
target_root="$(cd -- "${target_root}" && pwd)"

copy_if_missing() {
  local source_path="$1"
  local target_path="$2"

  if [[ -e "${target_path}" ]]; then
    if cmp -s "${source_path}" "${target_path}"; then
      echo "Unchanged: ${target_path}"
    else
      echo "Not overwritten; merge manually: ${target_path}" >&2
    fi
    return
  fi

  mkdir -p "$(dirname "${target_path}")"
  cp "${source_path}" "${target_path}"
  echo "Installed: ${target_path}"
}

copy_if_missing "${pipeline_root}/template/.clangd" "${target_root}/.clangd"
copy_if_missing "${pipeline_root}/template/reconfigure-clang.sh" "${target_root}/scripts/reconfigure-clang.sh"
copy_if_missing "${pipeline_root}/template/reconfigure-clang.bat" "${target_root}/scripts/reconfigure-clang.bat"
copy_if_missing "${pipeline_root}/template/tasks.json" "${target_root}/.vscode/tasks.json"
copy_if_missing "${pipeline_root}/template/settings.json" "${target_root}/.vscode/settings.json"

chmod +x "${target_root}/scripts/reconfigure-clang.sh"

gitignore_path="${target_root}/.gitignore"
if [[ ! -f "${gitignore_path}" ]] || ! grep -Fxq "build.clang/" "${gitignore_path}"; then
  printf '\nbuild.clang/\n' >>"${gitignore_path}"
  echo "Added build.clang/ to ${gitignore_path}"
fi

echo "Run ${target_root}/scripts/reconfigure-clang.sh to generate the clang database."
