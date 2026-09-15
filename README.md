# MSK Core (FiveM) IntelliSense

Autocompletion, signatures and type checking for the `MSK.*` API of the
[msk_core](https://github.com/MSK-Scripts/msk_core) library for FiveM.
Documentation of the library itself: [docu.msk-scripts.de](https://docu.msk-scripts.de).

The extension adds its definitions globally to `Lua.workspace.library`, so
they work in every project without configuring anything per resource.

## Installation

Search for **MSK Core** in the Extensions view, or run:

```
ext install musiker15.msk-core-lua
```

## Requirements

`sumneko.lua` (Lua Language Server). It is installed automatically as a
dependency.

For the FiveM natives, additionally use `communityox.cfxlua-vscode-cox` or the
[fivem-lls-addon](https://github.com/overextended/fivem-lls-addon). Both are
independent of this extension and complement it.

## What is covered

Based on msk_core **4.1.0**.

- The global `MSK` handle with all module namespaces
- `MSK.Player` including the runtime fields maintained by the 100 ms thread
- All modules: Alert, Anim, Array, Cache, Callback, Check, Class, Clipboard,
  Context, Controls, Coords, Cron, Dui, Events, Files, Grid, Hook, Input,
  Keybind, Locale, Logger, Marker, Math, Menu, Numpad, Offline, Points, Print,
  Progress, Radial, Request, Require, Scaleform, Selector, Settings,
  Skillcheck, Society, String, Table, TextUI, Timeout, Timer, Vector,
  VehicleProperties, VehicleStore and Zones
- The flat functions from Ace, Ban, Command, Entities, Notify, Vehicle and
  World
- The backwards compatibility aliases from `aliases.lua`, including the
  different boolean semantics of `MSK.Trim`
- Common export proxies such as `MSK.Round` or `MSK.Progressbar`
- Option tables as their own types: `MSKProgressData`, `MSKContextOption`,
  `MSKMenuItem`, `MSKCommandProperties`, `MSKPointProperties` and more

### Client and server

Where signatures differ, the client variant is the main signature and the
server variant is an overload. On the server, almost every UI function takes
the target player ID as its first argument:

```lua
MSK.Notification({ title = 'Title', message = 'Text', type = 'success' })         -- Client
MSK.Notification(source, { title = 'Title', message = 'Text', type = 'success' }) -- Server
```

Since msk_core 4.1.0 the UI functions take a table. The old parameter forms
still work and are marked as deprecated, so the language server shows them
struck through in the suggestion list.

The language server accepts both forms. Separating them by side is not
possible as long as client and server files live in the same workspace.

## Project setup

In the `fxmanifest.lua` of your resource:

```lua
lua54 'yes'

shared_script '@msk_core/import.lua'
```

Optionally, modules can be loaded eagerly instead of lazily:

```lua
msk_core 'Callback'
msk_core 'Player'
```

## Settings

| Setting | Default | Effect |
|---|---|---|
| `mskCore.enableLibrary` | `true` | Adds the definitions to `Lua.workspace.library` (user settings). |
| `mskCore.setRuntime` | `true` | Sets `Lua.runtime.version` to `Lua 5.4` for the workspace, but only if it contains a `fxmanifest.lua` and no runtime is set there yet. Other Lua projects are not touched. |

Commands in the Command Palette:

- `MSK Core: Reload definitions`
- `MSK Core: Show definitions path`

When the extension is uninstalled, it removes its own library entries from
your settings again.

## Unknown fields

`import.lua` forwards every name that is neither a module nor an alias to
`exports.msk_core:<Name>`. The common ones are typed, but not every possible
one.

A rarely used export can therefore be reported as `undefined-field` even
though it works at runtime. This is a deliberate trade-off, because the same
check catches typos. If you don't want it, disable it in your settings:

```json
"Lua.diagnostics.disable": ["undefined-field"]
```

A better option is to open an issue or a pull request so the export gets
added to `library/msk.lua`.

## Using the definitions without the extension

The `library/` folder contains a `config.json` and therefore also works as a
standalone LuaLS addon. Put the repository into an addon directory and add it
to your settings:

```json
"Lua.workspace.userThirdParty": ["~\\lua-addons"]
```

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
