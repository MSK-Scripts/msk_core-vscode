# Änderungen

## [1.2.0] - 2026-09-13

Definitionen auf den Stand von **msk_core 4.1.0** gebracht.

### Hinzugefügt

- Die neuen Module als eigene Namespaces in `library/modules_new.lua` mit
  ihren Typen in `library/types_new.lua`: `MSK.Alert`, `Anim`, `Array`,
  `Cache`, `Class`, `Clipboard`, `Controls`, `Dui`, `Events`, `Files`, `Grid`,
  `Hook`, `Keybind`, `Locale`, `Logger`, `Marker`, `Print`, `Radial`,
  `Require`, `Selector`, `Settings`, `Skillcheck`, `Timer`,
  `VehicleProperties` und `Zones`. Kurzformen wie `MSK.Cache(key, fn, ttl)`
  oder `MSK.Locale(key)` sind als Überladung hinterlegt.
- Objekttypen für Instanzen: Klassen, DUI, Grid, Marker, Selector-Pool, Timer,
  Keybind, Zone und das Scaleform-Movie aus `MSK.Scaleform.New`.
- `MSKVehicleProperties` mit allen Feldern im Format von ox_lib und QBCore.
- Math: `Clamp`, `Lerp`, `InverseLerp`, `Remap`, `HexToRgb`, `RgbToHex`,
  `ToScalars`, `ToVector`, `NormalToRotation`, `ToHex`, `ToRgba`.
- Table: `Freeze`, `IsFrozen`, `Merge`, `Matches`, `Keys`, `Values`, `Wipe`.
  String: `RandomPattern`. Vector: `GetRelativeCoords`.
- `MSK.Input.Dialog` mit allen Feldtypen, `MSK.Numpad.Input`,
  `MSK.Progress.Circle`, `MSK.Menu.SetOptions`, `MSK.Points.GetNearbyPoints`.
- Request: `AudioBank`, `WeaponAsset`, `CameraRaycast`, `RaycastFromCoords`,
  `StartCameraRaycast`, `ReadRaycast`.
- Cron: `Schedule`, `Unschedule`, `GetNextRun`, `IsValid`.
- `MSK.TriggerAwait` für Client und Server, `MSK.OnPlayer`,
  `MSK.SpawnVehicle`, `MSK.GetNearbyPeds`, `GetNearbyObjects`,
  `GetNearbyVehicles`, `GetNearbyPlayers`, `GetClosestPed`, `GetClosestObject`.
- Neue Export-Proxies, unter anderem `InputDialog`, `AlertDialog`,
  `Skillcheck`, `SetClipboard`, die Settings-, Radial-, Hook- und Cron-Exports,
  `GetVehicleProperties`, `SetVehicleProperties` und `LoggerLog`.

### Geändert

- `MSK.Notification`, `MSK.Progress.Start`, `MSK.TextUI.Show` und
  `MSK.Numpad.Open` nehmen eine Tabelle. Die alten Parameter-Formen stehen als
  veraltete Überladung daneben, `MSK.Input.Open` und `ScaleformAnnounce` sind
  als `@deprecated` markiert.
- Alle Loader in `MSK.Request` haben einen `timeout`, Standard 30000 ms.
  `Request.Raycast` liefert die Entity oder `false`.
- `GetClosestEntity`, `GetClosestVehicle` und `GetClosestPlayer` kennen
  `maxDistance`.
- `MSK.Register` liefert `boolean`, Callbacks gehören der aufrufenden Resource.
- Command-Parameter kennen den Typ `longString`.
- Server-`GetPedVehicleSeat` liefert bei keinem Treffer `false`,
  `GetPedMugshot` hat einen `timeout`.

### Richtiggestellt

- `MSKCronDate` beschreibt die Felder, die msk_core wirklich liest (`m`, `h`,
  `d`, `w` sowie `atH`, `atM`, `atD`). Der Callback von `Cron.Create` bekommt
  `(uniqueId, data, info)`. `Cron.Create` gibt seit msk_core 4.1.0 die ID
  zurück, bei ungültigen Argumenten nil. Ohne `atM` läuft ein Uhrzeit-Job zur
  vollen Stunde, ohne `atD` jeden Tag.
- `MSK.CheckVersion` nimmt nur eine Tabelle.
- `Table.Dump`, `Table.Index`, `Table.Find`, `Table.Sort` und `Math.Random`
  haben die Rückgabetypen aus dem Code.
- `MSK.TriggerCallback` war fälschlich als nicht blockierend beschrieben.

## [1.1.0] - 2026-09-09

Definitionen auf den Stand von **msk_core 4.0.0** gebracht.

### Hinzugefügt

- Typen für das vereinheitlichte Spielerobjekt: `MSKPlayerData`,
  `MSKPlayerObject` mit allen Methoden, `MSKJobDefinition` und `MSKJobGrade`.
- Typen für `MSK.VehicleStore`: `MSKVehicleSchema`, `MSKVehicleRow`,
  `MSKVehicleInsert`, `MSKVehicleBrowseOptions` und `MSKVehicleBrowseResult`.
- `MSK.GetJobs`, `MSK.GetGangs`, `MSK.GetPlayerData`, `MSK.IsPlayerLoaded`,
  `MSK.IsPlayerDead`, `MSK.Society.GetProvider` und
  `MSK.Offline.GetPlayerTable`.

### Geändert

- `MSKBridgeFramework` kennt `Qbox` statt `OXCORE`. ox_core wird von
  msk_core 4.0.0 nicht mehr unterstützt.
- Signatur von `MSK.HasItem` richtiggestellt.
- Alle deutschen Texte in den Annotationsdateien, im README und in
  `extension.js` stehen jetzt mit echten Umlauten statt in ASCII-Umschreibung.

## [1.0.0] - 2026-09-08

Erste Ausgabe. Bindet die `MSK.*`-Definitionen über
`Lua.workspace.library` ein, hebt die Runtime auf Lua 5.4 und räumt beim
Deaktivieren den eigenen Eintrag wieder aus den Einstellungen.
