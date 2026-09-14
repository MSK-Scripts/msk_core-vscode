---@meta
--- Modul-Namespaces, die mit msk_core 4.1.0 neu dazugekommen sind.
--- Erreichbar als MSK.<Modul>, geladen per Lazy-Loading über import.lua.
---
--- Wo sich Client und Server unterscheiden, steht die Client-Signatur als
--- Hauptsignatur und die Server-Signatur als @overload.
---
--- TxAdmin und der Zone Creator haben keine öffentliche API. TxAdmin wird über
--- Config.TxAdmin geschaltet, der Zone Creator über den Command aus
--- Config.ZoneCreator.

---@class MSK
---@field Alert MSKAlert
---@field Anim MSKAnim Nur Client.
---@field Array MSKArray
---@field Cache MSKCache
---@field Class MSKClass
---@field Clipboard MSKClipboard Nur Client.
---@field Controls MSKControls Nur Client.
---@field Dui MSKDui Nur Client.
---@field Events MSKEvents Nur Server.
---@field Files MSKFiles Nur Server.
---@field Grid MSKGrid
---@field Hook MSKHook
---@field Keybind MSKKeybindModule Nur Client.
---@field Locale MSKLocale
---@field Logger MSKLogger Nur Server.
---@field Marker MSKMarker Nur Client.
---@field Print MSKPrint
---@field Radial MSKRadial Nur Client.
---@field Require MSKRequire
---@field Selector MSKSelector
---@field Settings MSKSettings Nur Client.
---@field Skillcheck MSKSkillcheck
---@field Timer MSKTimer
---@field VehicleProperties MSKVehiclePropertiesModule Get nur Client, Set auf beiden Seiten.
---@field Zones MSKZones Nur Client.

--------------------------------------------------------------------------------
-- Alert
--------------------------------------------------------------------------------

---@class MSKAlert
---@overload fun(data: MSKAlertData): MSKAlertResult|nil Kurzform für Show.
---@overload fun(playerId: number, data: MSKAlertData): MSKAlertResult|nil Kurzform für Show auf dem Server.
local Alert = {}

---Zeigt einen modalen Dialog und wartet auf die Antwort (yielding).
---Liefert nil, wenn der Dialog per Code geschlossen oder durch einen neuen
---ersetzt wurde. Auf dem Server kommt die Antwort vom Client, also wie jede
---andere Client-Eingabe behandeln.
---@param data MSKAlertData
---@return MSKAlertResult|nil
---@overload fun(playerId: number, data: MSKAlertData): MSKAlertResult|nil
function Alert.Show(data) end

---Schließt den offenen Dialog. Nur Client.
function Alert.Close() end

---Ob gerade ein Dialog offen ist. Nur Client.
---@return boolean
function Alert.Active() end

--------------------------------------------------------------------------------
-- Anim (nur Client)
--------------------------------------------------------------------------------

---@class MSKAnim
---@overload fun(ped: number|nil, dict: string, clip: string, options?: MSKAnimOptions) Kurzform für Play.
local Anim = {}

---Spielt eine Animation ab und kümmert sich um Laden und Freigeben des Dictionaries.
---@param ped? number nil ist der eigene Ped.
---@param dict string
---@param clip string
---@param options? MSKAnimOptions
function Anim.Play(ped, dict, clip, options) end

---@param ped? number nil ist der eigene Ped.
---@param dict string
---@param clip string
---@param blendOut? number Standard 1.0
function Anim.Stop(ped, dict, clip, blendOut) end

---@param ped? number nil ist der eigene Ped.
---@param dict string
---@param clip string
---@return boolean
function Anim.IsPlaying(ped, dict, clip) end

---Startet ein Szenario an Ort und Stelle, etwa "WORLD_HUMAN_SMOKING".
---@param ped? number nil ist der eigene Ped.
---@param scenario string
---@param playEnter? boolean Standard true.
function Anim.Scenario(ped, scenario, playEnter) end

---Beendet alles, was der Ped gerade tut, Animationen und Szenarien eingeschlossen.
---@param ped? number nil ist der eigene Ped.
---@param immediately? boolean Sofort statt mit Übergang.
function Anim.Clear(ped, immediately) end

--------------------------------------------------------------------------------
-- Array
--------------------------------------------------------------------------------

---Funktionale Helfer für Sequenzen (Schlüssel 1..n). Keine Funktion ändert die
---Eingabe, Ergebnisse sind einfache Tabellen und überleben auch einen Export.
---@class MSKArray
local Array = {}

---Neue Liste mit fn(value, index) auf jedes Element angewendet.
---@param list any[]
---@param fn fun(value: any, index: integer): any
---@return any[]
function Array.Map(list, fn) end

---Neue Liste mit allen Elementen, für die fn truthy liefert.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return any[]
function Array.Filter(list, fn) end

---Faltet die Liste zu einem Wert. Ohne initial ist das erste Element der
---Startwert und die Faltung beginnt beim zweiten.
---@param list any[]
---@param fn fun(accumulator: any, value: any, index: integer): any
---@param initial? any
---@return any
function Array.Reduce(list, fn, initial) end

---Erstes Element, für das fn truthy ist, plus dessen Index.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return any value, integer? index
function Array.Find(list, fn) end

---Index des ersten passenden Elements, sonst nil.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return integer?
function Array.FindIndex(list, fn) end

---True, wenn fn für mindestens ein Element truthy ist.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return boolean
function Array.Some(list, fn) end

---True, wenn fn für jedes Element truthy ist, auch bei leerer Liste.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return boolean
function Array.Every(list, fn) end

---Ruft fn für jedes Element auf. Gibt fn false zurück, endet die Schleife.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean?
function Array.ForEach(list, fn) end

---True, wenn value ein Element der Liste ist (einfacher Vergleich).
---@param list any[]
---@param value any
---@return boolean
function Array.Includes(list, value) end

---Hängt beliebig viele Listen zu einer neuen zusammen.
---@param ... any[]
---@return any[]
function Array.Concat(...) end

---Ausschnitt von from bis to, beide inklusive. Negative Werte zählen vom Ende,
---das letzte Element ist dann -1.
---@param list any[]
---@param from? integer
---@param to? integer
---@return any[]
function Array.Slice(list, from, to) end

---Liste ohne Duplikate, das erste Vorkommen bleibt. keyFn legt fest, was als
---gleich gilt, standardmäßig der Wert selbst.
---@param list any[]
---@param keyFn? fun(value: any): any
---@return any[]
function Array.Unique(list, keyFn) end

---Glättet verschachtelte Listen depth Ebenen tief (Standard 1, math.huge für alle).
---@param list any[]
---@param depth? number
---@return any[]
function Array.Flatten(list, depth) end

---Gruppiert nach dem Schlüssel, den fn liefert: { [key] = { elemente } }.
---@param list any[]
---@param fn fun(value: any, index: integer): any
---@return table<any, any[]>
function Array.GroupBy(list, fn) end

---Neue Liste in zufälliger Reihenfolge (Fisher-Yates).
---@param list any[]
---@return any[]
function Array.Shuffle(list) end

---Teilt die Liste in Listen mit je size Elementen. Die letzte kann kürzer sein.
---@param list any[]
---@param size integer Mindestens 1.
---@return any[][]
function Array.Chunk(list, size) end

---Zahlenliste von from bis to in Schritten von step.
---@param from number
---@param to number
---@param step? number Standard 1 bzw. -1, wenn from größer als to ist. Darf nicht 0 sein.
---@return number[]
function Array.Range(from, to, step) end

--------------------------------------------------------------------------------
-- Cache
--------------------------------------------------------------------------------

---Merkt sich Ergebnisse unter einem Schlüssel. Der Cache gehört der Resource,
---die ihn nutzt, andere Resources sehen ihn nicht.
---@class MSKCache
---@overload fun(key: any, fn?: function|any, ttl?: number): any Kurzform für Get.
local Cache = {}

---Liefert den gecachten Wert. Fehlt er oder ist er abgelaufen, läuft fn und
---das Ergebnis wird gespeichert. fn darf auch ein einfacher Wert sein.
---Ein nil-Ergebnis wird nicht gespeichert.
---@param key any
---@param fn? function|any
---@param ttl? number Millisekunden. Ohne Angabe bleibt der Wert bis Clear.
---@return any
function Cache.Get(key, fn, ttl) end

---Speichert value unter key und ersetzt den alten Wert.
---@param key any
---@param value any
---@param ttl? number Millisekunden.
function Cache.Set(key, value, ttl) end

---@param key any
---@return boolean
function Cache.Has(key) end

---Entfernt key, ohne Argument den gesamten Cache.
---@param key? any
function Cache.Clear(key) end

--------------------------------------------------------------------------------
-- Class
--------------------------------------------------------------------------------

---Kleines Klassensystem. Eine Klasse ist gleichzeitig die Metatable ihrer Instanzen.
---@class MSKClass
---@overload fun(name: string, parent?: MSKClassObject): MSKClassObject Kurzform für New.
local Class = {}

---Legt eine neue Klasse an, optional als Kind von parent.
---@param name string Nicht leer.
---@param parent? MSKClassObject
---@return MSKClassObject
function Class.New(name, parent) end

---True, wenn value eine Klasse ist (keine Instanz).
---@param value any
---@return boolean
function Class.IsClass(value) end

---True, wenn value eine Instanz von cls oder einer Kindklasse davon ist.
---@param value any
---@param cls MSKClassObject
---@return boolean
function Class.IsInstance(value, cls) end

--------------------------------------------------------------------------------
-- Clipboard (nur Client)
--------------------------------------------------------------------------------

---@class MSKClipboard
local Clipboard = {}

---Kopiert Text in die Zwischenablage des Spielers.
---@param text string|number
function Clipboard.Set(text) end

--------------------------------------------------------------------------------
-- Controls (nur Client)
--------------------------------------------------------------------------------

---Deaktiviert Controls ohne eigene Wait(0)-Schleife. Deaktivieren wird
---gezählt: zwei Stellen, die denselben Control sperren, müssen ihn auch beide
---wieder freigeben.
---@class MSKControls
local Controls = {}

---Deaktiviert die angegebenen Controls (Zahlen oder Listen von Zahlen).
---@param ... number|number[]
function Controls.Disable(...) end

---Nimmt ein Disable pro angegebenem Control zurück.
---@param ... number|number[]
function Controls.Enable(...) end

---Gibt die Controls unabhängig vom Zähler frei. Ohne Argumente alle Controls
---dieser Resource.
---@param ... number|number[]
function Controls.Clear(...) end

---@param control number
---@return boolean
function Controls.IsDisabled(control) end

---Alle Controls, die diese Resource gerade sperrt, sortiert.
---@return number[]
function Controls.GetDisabled() end

--------------------------------------------------------------------------------
-- Dui (nur Client)
--------------------------------------------------------------------------------

---@class MSKDui
local Dui = {}

---Rendert eine Webseite in eine Spieltextur. Jede DUI einer Resource wird beim
---Stoppen der Resource entfernt.
---@param data MSKDuiData
---@return MSKDuiInstance
function Dui.New(data) end

--------------------------------------------------------------------------------
-- Events (nur Server)
--------------------------------------------------------------------------------

---Serialisiert die Argumente einmal und schickt dieselbe Nutzlast an alle Ziele.
---@class MSKEvents
local Events = {}

---Schickt eventName an einen Spieler, mehrere Spieler oder -1 für alle.
---@param eventName string
---@param targets number|number[]
---@param ... any
function Events.TriggerClients(eventName, targets, ...) end

---IDs aller Spieler, deren Ped höchstens radius von coords entfernt ist.
---@param coords vector3|table
---@param radius number
---@return number[]
function Events.GetPlayersInRange(coords, radius) end

---Schickt eventName an alle Spieler im Umkreis.
---@param eventName string
---@param coords vector3|table
---@param radius number
---@param ... any
---@return number[] targets Die Spieler, die das Event bekommen haben.
function Events.TriggerClientsInRange(eventName, coords, radius, ...) end

--------------------------------------------------------------------------------
-- Files (nur Server)
--------------------------------------------------------------------------------

---@class MSKFiles
local Files = {}

---Namen der Dateien (keine Ordner) direkt in path der Resource, alphabetisch
---sortiert. Pfade mit Anführungszeichen, $, Backticks oder .. werden abgelehnt.
---@param resource? string Standard ist die aufrufende Resource.
---@param path string Ordner relativ zum Resource-Root.
---@param pattern? string Lua-Pattern, auf das der Name passen muss.
---@return string[]
function Files.List(resource, path, pattern) end

--------------------------------------------------------------------------------
-- Grid
--------------------------------------------------------------------------------

---Spatial Hash über die X/Y-Ebene. Grundlage von MSK.Zones.
---@class MSKGrid
local Grid = {}

---Legt ein Grid mit Zellen der Kantenlänge cellSize an.
---@param cellSize? number Größer als 0, Standard 250.
---@return MSKGridInstance
function Grid.New(cellSize) end

--------------------------------------------------------------------------------
-- Hook
--------------------------------------------------------------------------------

---Lässt andere Resources in eine Aktion eingreifen und sie verhindern. Die
---Registry liegt in msk_core, je eine pro Seite. Hooks einer Resource werden
---beim Stoppen der Resource entfernt.
---@class MSKHook
local Hook = {}

---Registriert einen Hook. Ein Hook verhindert die Aktion nur, wenn er exakt
---false zurückgibt. Wirft er einen Fehler, wird das geloggt und übersprungen.
---@param event string Nicht leer.
---@param cb fun(payload: any): boolean?
---@param options? MSKHookOptions
---@return integer id
function Hook.Register(event, cb, options) end

---Entfernt einen Hook. Nur die Resource, die ihn registriert hat, darf das.
---@param id integer
---@return boolean removed
function Hook.Remove(id) end

---Führt alle Hooks von event nach Priorität aus. Liefert false plus den Namen
---der ablehnenden Resource, sobald ein Hook false zurückgibt, sonst true.
---@param event string
---@param payload? any
---@return boolean allowed, string? refusedBy
function Hook.Trigger(event, payload) end

---@param event string
---@return boolean
function Hook.Has(event) end

--------------------------------------------------------------------------------
-- Keybind (nur Client)
--------------------------------------------------------------------------------

---@class MSKKeybindModule
local Keybind = {}

---Legt eine Tastenbelegung an, die der Spieler in den GTA-Einstellungen ändern
---kann. Fehler, wenn der Name schon existiert.
---@param data MSKKeybindData
---@return MSKKeybind
function Keybind.Add(data) end

---@param name string
---@return MSKKeybind|nil
function Keybind.Get(name) end

---Alle Belegungen dieser Resource, nach Name.
---@return table<string, MSKKeybind>
function Keybind.GetAll() end

--------------------------------------------------------------------------------
-- Locale
--------------------------------------------------------------------------------

---Übersetzungen aus locales/<sprache>.json der nutzenden Resource. Verschachtelte
---Objekte werden zu Punkt-Schlüsseln. Sprache: SetLanguage, dann die
---Spielereinstellung (nur Client), dann die Convar msk:locale, dann "en".
---Fehlende Schlüssel fallen auf en.json zurück. Auf dem Client müssen die
---JSON-Dateien in der fxmanifest unter files stehen.
---@class MSKLocale
---@overload fun(key: string, ...: any): string Kurzform für T.
local Locale = {}

---(Neu-)Lädt die Übersetzungen. Ohne lang wird die Sprache neu bestimmt.
---@param lang? string
---@return boolean found Ob eine Datei für die Sprache existiert.
function Locale.Load(lang) end

---Die Übersetzung für key. Eine Tabelle als einziges weiteres Argument füllt
---${name}-Platzhalter, andere Argumente gehen durch string.format. ${andere.key}
---ohne passendes Tabellenfeld zieht eine andere Übersetzung herein. Ein
---fehlender Schlüssel liefert den Schlüssel selbst.
---@param key string
---@param ... any
---@return string
function Locale.T(key, ...) end

---Eine Übersetzung aus dem locales-Ordner einer anderen Resource, in der
---Sprache, die diese Resource verwendet. Argumente wie bei T.
---@param resource string
---@param key string
---@param ... any
---@return string
function Locale.GetFrom(resource, key, ...) end

---Erzwingt eine Sprache für diese Resource. nil kehrt zur automatischen Wahl zurück.
---@param lang? string
function Locale.SetLanguage(lang) end

---@return string
function Locale.GetLanguage() end

---@param key string
---@return boolean
function Locale.Has(key) end

---Kopie aller Übersetzungen der aktiven Sprache, nach Punkt-Schlüssel.
---@return table<string, string>
function Locale.GetAll() end

--------------------------------------------------------------------------------
-- Logger (nur Server)
--------------------------------------------------------------------------------

---Schickt Log-Einträge gebündelt an Grafana Loki, Datadog oder Fivemanage.
---Konfiguriert über Convars (set msk:logger "loki" usw.), immer mit set, nie mit
---setr, sonst landet der API-Key bei jedem Client.
---@class MSKLogger
local Logger = {}

---Stellt einen Eintrag in die Warteschlange. Für einen Spieler kommen Name und
---alle Identifier außer der IP dazu.
---@param source? number Spieler-ID, 0 oder nil für den Server.
---@param event string Kurzer, maschinenlesbarer Name, etwa "shop:purchase".
---@param message string
---@param extra? table Zusätzliche, JSON-serialisierbare Daten.
---@param tags? MSKLoggerTags
---@return boolean queued false, wenn kein Log-Dienst konfiguriert ist.
function Logger.Log(source, event, message, extra, tags) end

---True, wenn ein Log-Dienst konfiguriert ist und Einträge verschickt werden.
---@return boolean
function Logger.IsEnabled() end

--------------------------------------------------------------------------------
-- Marker (nur Client)
--------------------------------------------------------------------------------

---@class MSKMarker
local Marker = {}

---Legt einen Marker mit festen Einstellungen an. Zeichnen per marker:Draw() in jedem Frame.
---@param data MSKMarkerData
---@return MSKMarkerInstance
function Marker.New(data) end

---Zeichnet einen Marker nur für diesen Frame, ohne ein Objekt zu behalten.
---@param data MSKMarkerData
function Marker.Draw(data) end

--------------------------------------------------------------------------------
-- Print
--------------------------------------------------------------------------------

---Konsolenausgabe mit Levels, pro Resource zur Laufzeit umschaltbar:
---setr msk:printlevel "warn" oder setr msk:printlevel:<resource> "debug".
---Reihenfolge von leise nach laut: error, warn, info (Standard), verbose, debug.
---@class MSKPrint
---@overload fun(...: any) Kurzform für Info.
local Print = {}

---@param ... any Tabellen werden als JSON ausgegeben.
function Print.Error(...) end

---@param ... any
function Print.Warn(...) end

---@param ... any
function Print.Info(...) end

---@param ... any
function Print.Verbose(...) end

---@param ... any
function Print.Debug(...) end

---Überschreibt das Level für diese Resource bis zum nächsten Neustart.
---nil kehrt zu den Convars zurück.
---@param level? MSKPrintLevel
function Print.SetLevel(level) end

---Name des aktiven Levels dieser Resource.
---@return MSKPrintLevel
function Print.GetLevel() end

---True, wenn eine Meldung dieses Levels ausgegeben würde. Praktisch, um teure
---Debug-Strings gar nicht erst zu bauen.
---@param level MSKPrintLevel
---@return boolean
function Print.IsEnabled(level) end

--------------------------------------------------------------------------------
-- Radial (nur Client)
--------------------------------------------------------------------------------

---Radialmenü, das Scripts mit eigenen Einträgen füllen. Geöffnet per Taste aus
---Config.Radial. Einträge und Untermenüs verschwinden, wenn ihre Resource stoppt.
---@class MSKRadial
local Radial = {}

---Fügt der ersten Ebene einen Eintrag oder eine Liste von Einträgen hinzu.
---Ein Eintrag mit bereits vorhandener ID ersetzt den alten.
---@param items MSKRadialItem|MSKRadialItem[]
function Radial.Add(items) end

---Entfernt einen Eintrag der ersten Ebene per ID.
---@param id string
---@return boolean removed
function Radial.Remove(id) end

---Entfernt alle Einträge der ersten Ebene, die die aufrufende Resource angelegt hat.
function Radial.Clear() end

---Registriert ein Untermenü, das Einträge über ihr Feld menu öffnen.
---@param menu MSKRadialMenu
function Radial.Register(menu) end

---@param id string
function Radial.Unregister(id) end

---Öffnet das Menü. Tut nichts, wenn es deaktiviert ist oder keine Einträge hat.
function Radial.Show() end

function Radial.Hide() end

---Deaktiviert (true, Standard) oder aktiviert (false) das Radialmenü.
---@param state? boolean
function Radial.Disable(state) end

---@return boolean
function Radial.IsOpen() end

---ID des offenen Untermenüs, nil auf der ersten Ebene oder wenn geschlossen.
---@return string|nil
function Radial.GetCurrentId() end

--------------------------------------------------------------------------------
-- Require
--------------------------------------------------------------------------------

---Lädt Lua- und JSON-Dateien zur Laufzeit, aus dieser oder einer anderen
---Resource. Pfade: "shared.utils" oder "@my_lib/client/helpers.lua". Ohne
---Schrägstrich trennen Punkte die Ordner. Auf dem Client muss die Datei in der
---fxmanifest der besitzenden Resource unter files stehen.
---@class MSKRequire
---@overload fun(path: string): any Kurzform für Load.
local Require = {}

---Führt eine Lua-Datei einmal aus und cached ihren Rückgabewert, wie require().
---Ohne Rückgabe wird true gecached. Zirkuläre Abhängigkeiten werfen einen Fehler.
---@param path string
---@return any
function Require.Load(path) end

---Liest und dekodiert eine JSON-Datei. Nicht gecached.
---@param path string
---@return any
function Require.Json(path) end

---Rohinhalt einer Datei. Der Pfad wird unverändert genommen, ohne Endung und
---ohne Punkte in Ordner umzuwandeln.
---@param path string
---@return string
function Require.File(path) end

---Verwirft ein gecachtes Lua-Modul, damit Load die Datei erneut ausführt.
---@param path string
---@return boolean dropped
function Require.Unload(path) end

--------------------------------------------------------------------------------
-- Selector
--------------------------------------------------------------------------------

---Zufallsauswahl aus Listen, mit oder ohne Gewichtung.
---@class MSKSelector
local Selector = {}

---Ein zufälliges Element plus dessen Index. nil bei leerer Liste.
---@param list any[]
---@return any value, integer? index
function Selector.Pick(list) end

---amount zufällige Elemente. Mit unique (Standard true) wird kein Element
---doppelt gezogen, das Ergebnis ist also höchstens so lang wie die Liste.
---@param list any[]
---@param amount integer
---@param unique? boolean
---@return any[]
function Selector.PickMany(list, amount, unique) end

---Ein zufälliger Wert, bei dem jeder Eintrag nach seinem Anteil am Gesamtgewicht zieht.
---@param entries MSKSelectorWeightedEntry[]
---@return any value, integer? index
function Selector.Weighted(entries) end

---amount gewichtete Ziehungen. Mit unique (Standard true) verlässt ein Eintrag
---nach dem Ziehen den Pool.
---@param entries MSKSelectorWeightedEntry[]
---@param amount integer
---@param unique? boolean
---@return any[]
function Selector.WeightedMany(entries, amount, unique) end

---Legt einen Pool benannter Sets an, optional vorbefüllt mit { [name] = entries }.
---@param sets? table<string, any[]>
---@return MSKSelectorPool
function Selector.New(sets) end

--------------------------------------------------------------------------------
-- Settings (nur Client)
--------------------------------------------------------------------------------

---Einstellungen pro Spieler, lokal per Resource-KVP gespeichert. Änderungen
---lösen das Event msk_core:settingChanged (key, value) aus.
---@class MSKSettings
local Settings = {}

---Eine Einstellung, ohne key eine Kopie aller.
---@param key? MSKSettingKey
---@return any
---@overload fun(): MSKSettingsValues
function Settings.Get(key) end

---Kopie aller Einstellungen.
---@return MSKSettingsValues
function Settings.GetAll() end

---Ändert eine Einstellung. false, wenn der Wert für sie nicht gültig ist.
---Fehler bei einem unbekannten Schlüssel.
---@param key MSKSettingKey
---@param value any
---@return boolean changed
function Settings.Set(key, value) end

---Öffnet das Einstellungsmenü.
function Settings.Open() end

--------------------------------------------------------------------------------
-- Skillcheck
--------------------------------------------------------------------------------

---@class MSKSkillcheck
---@overload fun(difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean Kurzform für Start.
---@overload fun(playerId: number, difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean Kurzform für Start auf dem Server.
local Skillcheck = {}

---Startet einen Skillcheck und wartet auf das Ergebnis (yielding). true nur,
---wenn jede Runde bestanden wurde. Läuft schon einer, kommt sofort false.
---Das Ergebnis meldet der Client, also nicht allein über Geld oder Items entscheiden lassen.
---@param difficulty? MSKSkillcheckDifficulty Standard "easy".
---@param inputs? string[] Tasten, aus denen pro Runde gewählt wird, Standard { "e" }.
---@return boolean passed
---@overload fun(playerId: number, difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean
function Skillcheck.Start(difficulty, inputs) end

---Beendet einen laufenden Skillcheck als nicht bestanden. Nur Client.
function Skillcheck.Cancel() end

---Ob gerade ein Skillcheck läuft. Nur Client.
---@return boolean
function Skillcheck.Active() end

--------------------------------------------------------------------------------
-- Timer
--------------------------------------------------------------------------------

---@class MSKTimer
local Timer = {}

---Legt einen Countdown über duration Millisekunden an. Er startet sofort,
---außer autoStart ist false.
---@param duration number Mindestens 0.
---@param onEnd? fun(timer: MSKTimerInstance)
---@param autoStart? boolean
---@return MSKTimerInstance
function Timer.New(duration, onEnd, autoStart) end

--------------------------------------------------------------------------------
-- VehicleProperties
--------------------------------------------------------------------------------

---@class MSKVehiclePropertiesModule
local VehicleProperties = {}

---Die Properties eines Fahrzeugs, nil wenn es nicht existiert. Nur Client.
---@param vehicle number
---@return MSKVehicleProperties|nil
function VehicleProperties.Get(vehicle) end

---Wendet Properties an. Felder, die nil sind, bleiben unverändert. Mit
---fixVehicle wird vorher repariert und der gespeicherte Schaden übersprungen.
---Auf dem Client wirkt es nur beim Besitzer des Fahrzeugs. Auf dem Server
---landen die Properties in einem State Bag, der besitzende Client wendet sie an.
---@param vehicle number Client: Entity-Handle. Server: Server-Entity-Handle.
---@param props MSKVehicleProperties
---@param fixVehicle? boolean
---@return boolean applied Auf dem Server: in den State Bag geschrieben.
function VehicleProperties.Set(vehicle, props, fixVehicle) end

--------------------------------------------------------------------------------
-- Zones (nur Client)
--------------------------------------------------------------------------------

---Bereiche, die beim Betreten und Verlassen reagieren. Geprüft wird viermal
---pro Sekunde gegen die Grid-Zelle des Spielers. Zonen gehören der Resource,
---die sie angelegt hat.
---@class MSKZones
local Zones = {}

---@param data MSKZoneSphereData
---@return MSKZone
function Zones.Sphere(data) end

---@param data MSKZoneBoxData
---@return MSKZone
function Zones.Box(data) end

---@param data MSKZonePolyData
---@return MSKZone
function Zones.Poly(data) end

---Alle Zonen dieser Resource, nach ID.
---@return table<number, MSKZone>
function Zones.GetAll() end

---Die Zonen, in denen der Spieler gerade ist.
---@return MSKZone[]
function Zones.GetInside() end

---@param id number
---@return boolean removed
function Zones.Remove(id) end
