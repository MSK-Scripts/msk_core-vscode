# Contributing

Issues and pull requests are welcome.

## Structure

```
msk_core-vscode/
├── extension.js       Adds library/ to Lua.workspace.library
├── uninstall.js       Removes those entries again on uninstall
├── package.json
├── logo.png
├── .github/workflows/ ci.yml (package check), release.yml (publishing)
└── library/
    ├── config.json      Makes the folder usable as a LuaLS addon as well
    ├── msk.lua          The MSK handle and the flat functions
    ├── modules.lua      Module namespaces (MSK.Math, MSK.Context, MSK.Zones, ...)
    └── types.lua        Data structures, option tables and object types
```

The language server reads the whole folder. New files in `library/` are
picked up without any further configuration.

The definitions deliberately stay inside the extension folder and are
referenced from there. `cfxlua-vscode` moves them to `globalStorage` on first
start instead, and that breaks as soon as that folder gets cleared: the source
has already been moved, the settings point to nothing and a restart does not
fix it.

## Changing definitions

When the msk_core API changes, the changes belong in `library/`:

- `msk.lua` for the MSK handle, the flat functions and the exports. A new
  module also needs its `---@field` entry in the `---@class MSK` block there.
- `modules.lua` for the module namespaces, `types.lua` for their data types.

Both files are split into one section per module, grouped by topic
(utilities, communication, UI, world, server). Add a new module to the
matching group, and use the same order in `modules.lua`, `types.lua` and the
`---@class MSK` block.

Every type name may only be defined in one file, otherwise the language
server reports duplicates. You can check the library with the binary shipped
in the sumneko extension:

```
lua-language-server --check=library --checklevel=Warning
```

Warnings about `vector3` can be ignored, they come from the FiveM natives.

## Testing locally

```
npx @vscode/vsce package
```

Install the resulting `.vsix` via *Extensions: Install from VSIX...*.

## Releasing

1. Bump the version in `package.json` and add a section to `CHANGELOG.md`
   (heading format `## [x.y.z] - YYYY-MM-DD`).
2. Commit and push.
3. Create and push the tag:

   ```
   git tag v1.3.0
   git push origin v1.3.0
   ```

The `release.yml` workflow checks that the tag matches `package.json`, builds
the `.vsix`, publishes it to Open VSX (creating the namespace on the first
run), and creates a GitHub release with the changelog section and the `.vsix`
attached.

Repository secrets:

| Secret | Purpose |
|---|---|
| `OVSX_PAT` | Token for Open VSX (namespace `musiker15`) |
| `VSCE_PAT` | Optional. Token for the VS Code Marketplace (publisher `musiker15`) |

The VS Code Marketplace is currently updated by hand, because automated
publishing requires an Azure subscription. Without `VSCE_PAT` the workflow
skips the Marketplace and writes a download link for the `.vsix` and a link
to the publisher page into the job summary. Upload the file there via
**...** > **Update**.
