# ESP-IDF clangd pipeline

Portable clangd setup for ESP-IDF projects on macOS, Linux, and Windows. It
creates a separate Clang compilation database in `build.clang`; it does not
replace the project's normal ESP-IDF `build` directory.

## Install into a project

Clone or extract this repository inside the target ESP-IDF project, then run an
installer from the pipeline directory:

```bash
./install.sh
```

On Windows:

```bat
install.bat
```

Pass the target project directory as the first argument when the pipeline is
stored elsewhere:

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

It appends `build.clang/` to `.gitignore`. Existing files are never overwritten;
the installer reports any files that need a manual merge.

## Generate the database

From the target project root:

```bash
./scripts/reconfigure-clang.sh
```

On Windows:

```bat
scripts\reconfigure-clang.bat
```

The scripts use an active ESP-IDF environment or the standard ESP-IDF
installation location. Regenerate the database after changing the target,
`sdkconfig`, CMake/component dependencies, or ESP-IDF version.

## Editors

- **Neovim:** Configure `esp32.nvim` once in your user configuration, then run
  `:ESPReconfigure` for a target project.
- **VS Code:** Install the
  [clangd extension](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd).
  Run the **ESP-IDF: Reconfigure clangd database** workspace task, then reload
  the VS Code window. Configure Espressif clangd in VS Code user settings, or
  start VS Code from an activated ESP-IDF environment where `clangd` is on
  `PATH`.

The workspace disables the Microsoft C/C++ IntelliSense engine so it does not
parse ESP-IDF headers as host-platform code. Use clangd as the sole C/C++
language engine for ESP-IDF. Without the clangd extension, completion,
diagnostics, go-to-definition, references, and rename are unavailable.

## Troubleshooting

If completion or navigation is incomplete after updating ESP-IDF or Espressif
clangd, close the editor and delete `build.clang/.cache/clangd/index`. Restart
the editor to rebuild the index. Regenerate `build.clang` first if its
compilation database is missing or outdated.

The project templates contain no user names, absolute paths, or ESP-IDF version
numbers. Tool locations belong in editor user settings and are discovered
locally on each machine.
