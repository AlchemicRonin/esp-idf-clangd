# ESP-IDF clangd pipeline

Portable clangd setup for ESP-IDF projects on macOS, Linux, and Windows.
It creates an ignored `build.clang` database and leaves the normal `build`
directory unchanged.

## Install

Clone or extract this repository in the target project, then run:

```bash
./install.sh
```

On Windows:

```bat
install.bat
```

When this repository is outside the target project:

```bash
./install.sh /path/to/esp-idf-project
```

The installer adds only these portable files when they do not already exist:

```text
.clangd
scripts/reconfigure-clang.sh
scripts/reconfigure-clang.bat
.vscode/settings.json
.vscode/tasks.json
```

It adds `build.clang/` to `.gitignore`. Existing files are not overwritten.

## Generate

```bash
./scripts/reconfigure-clang.sh
```

```bat
scripts\reconfigure-clang.bat
```

Run again after changing the target, `sdkconfig`, CMake dependencies, or
ESP-IDF version.

## Editors

- **Neovim:** Configure `esp32.nvim` in user settings and use
  `:ESPReconfigure`.
- **VS Code:** Install the [clangd extension](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd),
  configure Espressif clangd in user settings, then run **ESP-IDF:
  Reconfigure clangd database** and reload the window.

The workspace disables Microsoft C/C++ IntelliSense to prevent host-platform
parsing; clangd supplies completion, diagnostics, navigation, and rename.

## Recovery

If navigation is incomplete after an ESP-IDF or clangd update, close the editor,
delete `build.clang/.cache/clangd/index`, and reopen it.
