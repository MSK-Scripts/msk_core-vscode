# MSK Core (FiveM) IntelliSense

Autocompletion, Signaturen und Typprüfung für die `MSK.*` API der
[msk_core](https://github.com/musiker15/msk_core) Library.

Die Extension trägt ihre Definitionen global in `Lua.workspace.library` ein.
Sie wirken damit in jedem Projekt, ohne dass pro Resource etwas konfiguriert
werden muss.

## Voraussetzungen

`sumneko.lua` (Lua Language Server). Wird als Abhängigkeit automatisch
mitinstalliert.

Für die FiveM Natives zusätzlich `communityox.cfxlua-vscode-cox` oder das
Addon [fivem-lls-addon](https://github.com/overextended/fivem-lls-addon).
Beides ist unabhängig von dieser Extension, sie ergänzen sich.

## Was abgedeckt ist

Stand msk_core **3.3.1**.

- Das globale `MSK` Handle mit allen Modul-Namespaces
- `MSK.Player` inklusive der Laufzeitfelder, die der 100ms-Thread pflegt
- Alle Module: Math, String, Table, Vector, Timeout, Callback, Context, Menu,
  Input, Numpad, Progress, TextUI, Coords, Points, Request, Scaleform, Cron,
  Check, Society, Offline
- Die flachen Funktionen aus Ace, Ban, Command, Entities, Notify, Vehicle
  und World
- Die Backwards-Compat-Aliase aus `aliases.lua` inklusive der abweichenden
  Bool-Semantik von `MSK.Trim`
- Die gebräuchlichen Export-Proxies wie `MSK.Round` oder `MSK.Progressbar`
- Optionstabellen als eigene Typen: `MSKProgressData`, `MSKContextOption`,
  `MSKMenuItem`, `MSKCommandProperties`, `MSKPointProperties` und weitere

### Client und Server

Wo sich die Signaturen unterscheiden, ist die Client-Variante die
Hauptsignatur und die Server-Variante eine Überladung. Auf dem Server nimmt
fast jede UI-Funktion die Ziel-Spieler-ID als erstes Argument:

```lua
MSK.Notification('Titel', 'Text', 'success')        -- Client
MSK.Notification(source, 'Titel', 'Text', 'success') -- Server
```

Der Language Server akzeptiert beide Formen. Eine Trennung nach Seite ist
nicht möglich, solange Client- und Server-Dateien im selben Workspace liegen.

## Einrichtung im Projekt

In der `fxmanifest.lua` der eigenen Resource:

```lua
lua54 'yes'

shared_script '@msk_core/import.lua'
```

Optional lassen sich Module vorziehen, statt sie lazy zu laden:

```lua
msk_core 'Callback'
msk_core 'Player'
```

## Einstellungen

| Einstellung | Standard | Wirkung |
|---|---|---|
| `mskCore.enableLibrary` | `true` | Bindet die Definitionen in `Lua.workspace.library` ein. |

Befehle in der Command Palette:

- `MSK Core: Definitionen neu einbinden`
- `MSK Core: Pfad der Definitionen anzeigen`

## Unbekannte Felder

`import.lua` leitet jeden Namen, der weder Modul noch Alias ist, automatisch
an `exports.msk_core:<Name>` weiter. Die gebräuchlichen davon sind als Typ
hinterlegt, aber nicht jeder denkbare.

Ein selten genutzter Export kann deshalb als `undefined-field` angemerkt
werden, obwohl er zur Laufzeit funktioniert. Das ist ein bewusster
Kompromiss, denn dieselbe Prüfung fängt Tippfehler ab. Wer sie nicht möchte,
schaltet sie in den Settings ab:

```json
"Lua.diagnostics.disable": ["undefined-field"]
```

Sinnvoller ist es allerdings, den fehlenden Export in `library/msk.lua`
nachzutragen.

## Nutzung ohne die Extension

Der Ordner `library/` enthält eine `config.json` und funktioniert damit auch
als eigenständiges LuaLS-Addon. Dazu das Repo in ein Addon-Verzeichnis legen
und in den Settings eintragen:

```json
"Lua.workspace.userThirdParty": ["~\\lua-addons"]
```

## Aufbau

```
msk_core-vscode/
├── extension.js       Trägt library/ in Lua.workspace.library ein
├── package.json
├── logo.png
└── library/
    ├── config.json    Macht den Ordner zusätzlich zum LuaLS-Addon
    ├── types.lua      Datenstrukturen und Optionstabellen
    ├── modules.lua    Modul-Namespaces (MSK.Math, MSK.Context, ...)
    └── msk.lua        Das MSK Handle und die flachen Funktionen
```

Die Definitionen liegen bewusst direkt im Extension-Ordner und werden von dort
referenziert. `cfxlua-vscode` verschiebt sie stattdessen beim ersten Start nach
`globalStorage`, und genau daran geht es kaputt, sobald dieser Ordner geleert
wird: die Quelle ist dann bereits verschoben, die Settings zeigen ins Leere und
ein Neustart repariert nichts.

## Pflege

Ändert sich die API von msk_core, gehören die Änderungen in `library/`.
Danach `vsce package` und die neue `.vsix` installieren. Die Extension räumt
Einträge älterer Versionen aus den Settings selbst weg.

## Lizenz

MIT
