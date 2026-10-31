<p align="center">
  <img src="assets/BoneVim.png" alt="BoneVim — pixel-art skeleton in a violet hood above the BoneVim wordmark" width="640">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/editor-Neovim-FFE878?style=flat-square&amp;logo=neovim&amp;logoColor=FFE878&amp;labelColor=1C1226" alt="Editor: Neovim">
  <img src="https://img.shields.io/badge/config-LazyVim-B565F5?style=flat-square&amp;labelColor=1C1226" alt="Config: LazyVim">
  <img src="https://img.shields.io/badge/language-Lua-91BDF5?style=flat-square&amp;logo=lua&amp;logoColor=91BDF5&amp;labelColor=1C1226" alt="Language: Lua">
</p>

A personal Neovim configuration built on LazyVim, with project-specific language modules,
custom editing shortcuts, and a native theme inspired by the BoneVim artwork.

[Getting started](#getting-started) · [Project configuration](#project-configuration) ·
[Keybindings](#keybindings) · [Structure](#structure) · [Maintenance](#maintenance)

## Requirements and installation

- Neovim compatible with the installed LazyVim version, Git, and a Nerd Font for icons.
- `ripgrep` and `fd` for searching; language tools depend on your project's stack.
- For the optional setup script: Homebrew, npm, Python 3 with `venv`, and Java 17+ for Java tooling.

Place this repository at `~/.config/nvim`. Back up any existing configuration first.
Start Neovim and let lazy.nvim install the configured plugins, or run:

```sh
nvim --headless "+Lazy! sync" +qa
```

For broader machine setup, inspect and then run:

```sh
bash scripts/lazyvim-setup.sh
```

The script uses an existing Homebrew installation to install tools, creates
`~/.lazyvim-python`, installs global npm packages, syncs plugins, and requests LSP
installation through Mason. Review `:Mason` afterwards; server availability and package
names depend on the installed registry. This is a machine setup script, not a test command.

## Getting started

Open Neovim from your project directory. The dashboard provides file search, text search,
recent files, and access to this configuration. `<Space>` is the LazyVim leader key.

The theme uses bone yellow (`#FFE878`), violet (`#B565F5`), and blue (`#91BDF5`), with
dark violet surfaces. Errors, warnings, and Git changes retain distinct semantic colors.
The main editor and floating windows are transparent; use a black terminal background
to match the artwork.

## Project configuration

Run this command inside Neovim to create `.nvim.lua` in the current directory:

```vim
:GenerateNvimConfigFile
```

The generator opens the new file and refuses to overwrite an existing one. Edit its
`techs` list to keep only the modules your project needs. For example:

```lua
local techs = { "typescript", "html", "css" }

for _, tech in ipairs(techs) do
  local ok, err = pcall(require, "langs." .. tech)
  if not ok then
    vim.notify("Error loading config for " .. tech .. ": " .. err, vim.log.levels.ERROR)
  end
end
```

Available modules in `lua/langs/`: `angular`, `astro`, `bash`, `capacitor`, `css`,
`html`, `ionic`, `java`, `python`, `swift`, and `typescript`.
Check each module for the language tools it configures.

Markdown files (`.md`, `.MD`, `.markdown`, `.mdown`, `.mkd`, `.mkdn`, `.mdwn`, and `.mdx`)
open as plain text, without syntax highlighting, rendering, language services,
completion, automatic formatting, or spell checking. Remove `"markdown"` from existing
`.nvim.lua` files: the `langs.markdown` module has been removed.

**Trust local configuration files.** This profile enables `exrc` and `secure` and also
explicitly executes `.nvim.lua` from the current directory in `init.lua`. That Lua code
is not sandboxed by `secure`; review it before opening an unfamiliar project.

## Keybindings

These shortcuts are defined in `lua/config/keymaps.lua`, in addition to LazyVim defaults.

| Keys                    | Mode                                              | Action                                  |
| ----------------------- | ------------------------------------------------- | --------------------------------------- |
| `Ctrl+s`                | Normal, Visual, Insert                            | Save file                               |
| `Ctrl+h/j/k/l`          | Normal                                            | Focus the left/lower/upper/right window |
| `Ctrl+Shift+Left/Right` | Normal                                            | Focus the left/right window             |
| `Tab` / `Shift+Tab`     | Normal                                            | Next/previous buffer                    |
| `Ctrl+n`                | Normal                                            | Open current buffer in a vertical split |
| `<Space>t`              | Normal                                            | Open or focus an integrated terminal    |
| `<Space>rr`             | Normal                                            | Source `init.lua` again                 |
| `Ctrl+c`                | Normal, Visual, Select, Insert                    | Copy line or selection                  |
| `Ctrl+v`                | Normal, Visual, Select, Insert, Command, Terminal | Paste                                   |
| `Ctrl+x`                | Normal, Visual, Select                            | Cut line or selection                   |
| `Ctrl+z` / `Ctrl+y`     | Normal, Insert                                    | Undo/redo                               |
| `Ctrl+a`                | Normal, Visual, Insert                            | Select all                              |
| `Ctrl+Shift+Left/Right` | Insert, Visual                                    | Go to start/end of line                 |
| `Ctrl+Shift+Up/Down`    | Insert, Visual                                    | Move line/selection up/down             |
| `Ctrl+q`                | Insert                                            | Insert a backtick                       |

Some terminals cannot distinguish `Ctrl+Shift` combinations. Clipboard support uses
macOS tools, Wayland tools, or OSC 52 according to availability; terminal support matters.

## Structure

```text
init.lua                       Entry point and local configuration loading
lua/config/                    Options, keymaps, autocmds, and config generator
lua/plugins/                   LazyVim plugin overrides and UI configuration
lua/langs/                     Project-specific language modules
lua/skeletor/palette.lua        Shared BoneVim colors
colors/skeletor-cyan.lua        Native theme and plugin highlights
scripts/                       Machine setup and Mason installation helpers
lazy-lock.json                 Locked plugin revisions
lazyvim.json                   Enabled LazyVim extras
```

The existing `skeletor-cyan` theme name and `skeletor.palette` module remain stable
for configuration compatibility.

## Maintenance

- Use `:Lazy` to inspect plugins, `:Mason` for language tools, and `:checkhealth` for diagnostics.
- After configuration changes, check the loader without opening an interactive session:

  ```sh
  nvim --headless -u init.lua "+lua require('config.lazy')" +qa
  ```

- Format changed Lua files with StyLua (two spaces, 120 columns; see `stylua.toml`).
- Keep language modules and `scripts/install-lsps.lua` aligned when changing language support.
- Check Markdown plain-text behavior with
  `nvim --headless -u init.lua README.md "+luafile scripts/check-plain-markdown.lua" +qa`.
- See [AGENTS.md](AGENTS.md) for contributor guidelines. There is no standalone test suite;
  validate affected modules through Neovim itself.
