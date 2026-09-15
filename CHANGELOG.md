# Changelog

## [1.3.0] - 2026-09-15

Preparation for publishing on the VS Code Marketplace and Open VSX.

### Changed

- The Lua runtime is no longer set to Lua 5.4 globally. The extension now
  only sets it for the workspace, and only if the workspace contains a
  `fxmanifest.lua` and no runtime is configured there yet. Other Lua projects
  are left untouched. Can be turned off with `mskCore.setRuntime`.
- The library entry is kept when VS Code closes. Previously it was removed on
  every shutdown and written again on the next start, and with Settings Sync
  that change bounced across all machines. Cleanup now only happens on
  uninstall through the `vscode:uninstall` hook (`uninstall.js`), which also
  covers profiles, Insiders, VSCodium and Cursor.
- The repository moved to
  [MSK-Scripts/msk_core-vscode](https://github.com/MSK-Scripts/msk_core-vscode).
- Everything is now in English: README, CHANGELOG, settings, command titles
  and all hover documentation in `library/`. Maintenance notes moved to
  `CONTRIBUTING.md`.
- `library/modules_new.lua` and `library/types_new.lua` are merged into
  `modules.lua` and `types.lua`. The modules are grouped by topic instead of
  by the version they were added in. No definition was added, removed or
  changed.

### Added

- `mskCore.setRuntime` setting.
- GitHub Actions: package check on every push, and automatic publishing to
  both stores when a `v*` tag is pushed. Uses the v7 actions on Node.js 24.

### Changed files

- `extension.js`
- `uninstall.js` (new)
- `package.json`
- `.vscodeignore`
- `README.md`
- `CONTRIBUTING.md` (new)
- `CHANGELOG.md`
- `.github/workflows/ci.yml` (new)
- `.github/workflows/release.yml` (new)
- `library/msk.lua`
- `library/modules.lua`
- `library/types.lua`
- `library/modules_new.lua` (removed)
- `library/types_new.lua` (removed)

## [1.2.0] - 2026-09-13

Definitions updated to **msk_core 4.1.0**.

### Added

- The new modules as their own namespaces in `library/modules_new.lua`, with
  their types in `library/types_new.lua`: `MSK.Alert`, `Anim`, `Array`,
  `Cache`, `Class`, `Clipboard`, `Controls`, `Dui`, `Events`, `Files`, `Grid`,
  `Hook`, `Keybind`, `Locale`, `Logger`, `Marker`, `Print`, `Radial`,
  `Require`, `Selector`, `Settings`, `Skillcheck`, `Timer`,
  `VehicleProperties` and `Zones`. Short forms such as
  `MSK.Cache(key, fn, ttl)` or `MSK.Locale(key)` are available as overloads.
- Object types for instances: classes, DUI, Grid, Marker, Selector pool,
  Timer, Keybind, Zone and the Scaleform movie returned by `MSK.Scaleform.New`.
- `MSKVehicleProperties` with all fields in the ox_lib and QBCore format.
- Math: `Clamp`, `Lerp`, `InverseLerp`, `Remap`, `HexToRgb`, `RgbToHex`,
  `ToScalars`, `ToVector`, `NormalToRotation`, `ToHex`, `ToRgba`.
- Table: `Freeze`, `IsFrozen`, `Merge`, `Matches`, `Keys`, `Values`, `Wipe`.
  String: `RandomPattern`. Vector: `GetRelativeCoords`.
- `MSK.Input.Dialog` with all field types, `MSK.Numpad.Input`,
  `MSK.Progress.Circle`, `MSK.Menu.SetOptions`, `MSK.Points.GetNearbyPoints`.
- Request: `AudioBank`, `WeaponAsset`, `CameraRaycast`, `RaycastFromCoords`,
  `StartCameraRaycast`, `ReadRaycast`.
- Cron: `Schedule`, `Unschedule`, `GetNextRun`, `IsValid`.
- `MSK.TriggerAwait` for client and server, `MSK.OnPlayer`,
  `MSK.SpawnVehicle`, `MSK.GetNearbyPeds`, `GetNearbyObjects`,
  `GetNearbyVehicles`, `GetNearbyPlayers`, `GetClosestPed`, `GetClosestObject`.
- New export proxies, including `InputDialog`, `AlertDialog`, `Skillcheck`,
  `SetClipboard`, the Settings, Radial, Hook and Cron exports,
  `GetVehicleProperties`, `SetVehicleProperties` and `LoggerLog`.

### Changed

- `MSK.Notification`, `MSK.Progress.Start`, `MSK.TextUI.Show` and
  `MSK.Numpad.Open` take a table. The old parameter forms remain as deprecated
  overloads, `MSK.Input.Open` and `ScaleformAnnounce` are marked as
  `@deprecated`.
- All loaders in `MSK.Request` have a `timeout`, default 30000 ms.
  `Request.Raycast` returns the entity or `false`.
- `GetClosestEntity`, `GetClosestVehicle` and `GetClosestPlayer` accept
  `maxDistance`.
- `MSK.Register` returns `boolean`, callbacks belong to the calling resource.
- Command parameters support the `longString` type.
- Server-side `GetPedVehicleSeat` returns `false` when nothing is found,
  `GetPedMugshot` has a `timeout`.

### Fixed

- `MSKCronDate` describes the fields msk_core actually reads (`m`, `h`, `d`,
  `w` as well as `atH`, `atM`, `atD`). The callback of `Cron.Create` receives
  `(uniqueId, data, info)`. Since msk_core 4.1.0 `Cron.Create` returns the ID,
  or nil for invalid arguments. Without `atM` a time based job runs on the full
  hour, without `atD` every day.
- `MSK.CheckVersion` only takes a table.
- `Table.Dump`, `Table.Index`, `Table.Find`, `Table.Sort` and `Math.Random`
  have the return types from the code.
- `MSK.TriggerCallback` was wrongly described as non-blocking.

## [1.1.0] - 2026-09-09

Definitions updated to **msk_core 4.0.0**.

### Added

- Types for the unified player object: `MSKPlayerData`, `MSKPlayerObject`
  with all methods, `MSKJobDefinition` and `MSKJobGrade`.
- Types for `MSK.VehicleStore`: `MSKVehicleSchema`, `MSKVehicleRow`,
  `MSKVehicleInsert`, `MSKVehicleBrowseOptions` and `MSKVehicleBrowseResult`.
- `MSK.GetJobs`, `MSK.GetGangs`, `MSK.GetPlayerData`, `MSK.IsPlayerLoaded`,
  `MSK.IsPlayerDead`, `MSK.Society.GetProvider` and
  `MSK.Offline.GetPlayerTable`.

### Changed

- `MSKBridgeFramework` knows `Qbox` instead of `OXCORE`. ox_core is no longer
  supported by msk_core 4.0.0.
- Fixed the signature of `MSK.HasItem`.
- All German texts in the annotation files, the README and `extension.js` now
  use real umlauts instead of ASCII transliteration.

## [1.0.0] - 2026-09-08

Initial release. Adds the `MSK.*` definitions through
`Lua.workspace.library`, raises the runtime to Lua 5.4 and removes its own
entry from the settings again on deactivation.
