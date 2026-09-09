# Änderungen

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
