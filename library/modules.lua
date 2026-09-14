---@meta
--- Modul-Namespaces der msk_core Library (FiveM).
--- Erreichbar als MSK.<Modul>, geladen per Lazy-Loading über import.lua.
---
--- Wo sich Client und Server unterscheiden, steht die Client-Signatur als
--- Hauptsignatur und die Server-Signatur als @overload. Auf dem Server nimmt
--- fast jede UI-Funktion die Ziel-Spieler-ID als erstes Argument.

--------------------------------------------------------------------------------
-- Math
--------------------------------------------------------------------------------

---@class MSKMath
local Math = {}

---Erzeugt eine zufällige Ziffernfolge mit der angegebenen Stellenzahl.
---Auch als Math.Number erreichbar.
---@param length number Anzahl der Stellen.
---@return string
function Math.Random(length) end

---Alias für Math.Random.
---@param length number
---@return string
function Math.Number(length) end

---Rundet auf die angegebene Nachkommastelle. Halbe Werte runden von null weg
---(2.5 wird 3, -2.5 wird -3). Negative Stellen runden auf Zehner, Hunderter
---und so weiter, Math.Round(1234, -2) ergibt 1200.
---@param num number
---@param decimal? number Nachkommastellen, Standard 0. Darf negativ sein.
---@return number
function Math.Round(num, decimal) end

---Formatiert eine Zahl mit Tausendertrennzeichen.
---@param int number
---@param tag? string Trennzeichen, Standard Punkt.
---@return string
function Math.Comma(int, tag) end

---Begrenzt einen Wert auf den Bereich zwischen min und max. Vertauschte
---Grenzen werden selbst korrigiert.
---@param value number
---@param min number
---@param max number
---@return number
function Math.Clamp(value, min, max) end

---Lineare Interpolation: t = 0 liefert from, t = 1 liefert to. Funktioniert
---mit Zahlen und Vektoren.
---@generic T : number|vector2|vector3|vector4
---@param from T
---@param to T
---@param t number
---@return T
function Math.Lerp(from, to, t) end

---Gegenstück zu Lerp: wo value zwischen from und to liegt, als Faktor
---(0 bei from, 1 bei to). Sind from und to gleich, kommt 0 zurück.
---@param from number
---@param to number
---@param value number
---@return number
function Math.InverseLerp(from, to, value) end

---Überträgt einen Wert von einem Bereich auf einen anderen, etwa 0 bis 100
---Leben auf 0 bis 1000.
---@param value number
---@param inMin number
---@param inMax number
---@param outMin number
---@param outMax number
---@param clamp? boolean Hält das Ergebnis im Zielbereich.
---@return number
function Math.Remap(value, inMin, inMax, outMin, outMax, clamp) end

---Wandelt '#rgb', '#rgba', '#rrggbb' oder '#rrggbbaa' (mit oder ohne '#') in
---Kanäle von 0 bis 255. Alpha ist nil, wenn die Eingabe keinen hat.
---@param hex string
---@return integer r, integer g, integer b, integer? a
function Math.HexToRgb(hex) end

---Wandelt Farbkanäle von 0 bis 255 in '#rrggbb', mit a in '#rrggbbaa'.
---Werte außerhalb des Bereichs werden begrenzt.
---@param r number
---@param g number
---@param b number
---@param a? number
---@return string
function Math.RgbToHex(r, g, b, a) end

---Liest Zahlen aus einem Vektor, einer Tabelle ({ x =, y =, z =, w = } oder
---{ 1, 2, 3 }) oder einer Zeichenkette ('1.0, 2, 3' oder 'vector3(1.0, 2, 3)').
---@param input any
---@return number ...
function Math.ToScalars(input) end

---Ein vector2, vector3 oder vector4, je nachdem wie viele Zahlen input enthält.
---Nimmt alles an, was Math.ToScalars versteht. Bei nur einer Zahl kommt diese
---unverändert zurück.
---@param input any
---@return vector2|vector3|vector4|number
function Math.ToVector(input) end

---Rotation in Grad, die die Hochachse eines Objekts auf eine Flächennormale
---kippt, etwa die aus einem Raycast. Die Blickrichtung bleibt 0.
---@param normal vector3
---@return vector3
function Math.NormalToRotation(normal) end

---Ganze Zahl als Hex-String mit 0x-Präfix, etwa 255 zu '0xff'.
---@param value number
---@param upper? boolean Großbuchstaben ('0xFF').
---@return string
function Math.ToHex(value, upper) end

---Farbe als vector4(r, g, b, a), Rot, Grün und Blau von 0 bis 255, Alpha von
---0 bis 1 (Standard 1). Versteht Hex ('#rgb', '#rrggbb', '#rrggbbaa'),
---'rgb(255, 0, 0)', 'rgba(255, 0, 0, 0.5)', '255, 0, 0', { r =, g =, b =, a = },
---{ 255, 0, 0 } und Vektoren. Werte außerhalb des Bereichs werfen einen Fehler.
---@param input string|table|vector3|vector4
---@return vector4
function Math.ToRgba(input) end

--------------------------------------------------------------------------------
-- String
--------------------------------------------------------------------------------

---@class MSKString
local String = {}

---Erzeugt eine zufällige Zeichenkette aus Buchstaben.
---@param length number
---@return string
function String.Random(length) end

---Zufällige Zeichenkette nach einem Muster, etwa für Kennzeichen oder
---Telefonnummern. 1 = Ziffer, A = Großbuchstabe, a = Kleinbuchstabe,
---. = Buchstabe oder Ziffer. Alle anderen Zeichen bleiben stehen, ^ macht das
---nächste Zeichen wörtlich ('^1' ergibt eine echte 1).
---Mit length hat das Ergebnis genau so viele Zeichen: ein kürzeres Muster wird
---wiederholt, ein längeres Ergebnis abgeschnitten.
---@param pattern string Etwa '11AAA111'.
---@param length? number
---@return string
function String.RandomPattern(pattern, length) end

---Prüft, ob str mit startStr beginnt.
---@param str string
---@param startStr string
---@return boolean
function String.StartsWith(str, startStr) end

---Entfernt Leerzeichen.
---@param str string
---@param bool? boolean true entfernt alle Leerzeichen, sonst nur außen.
---@return string
function String.Trim(str, bool) end

---Wie Trim, aber mit der invertierten Bool-Semantik aus msk_core v2.
---Erreichbar als MSK.Trim, während exports.msk_core:Trim auf String.Trim zeigt.
---@param str string
---@param bool? boolean
---@return string
function String.TrimLegacy(str, bool) end

---Zerlegt eine Zeichenkette am ganzen Trennzeichen (keine Pattern-Suche).
---Leere Teile fallen weg.
---@param str string
---@param delimiter string Darf nicht leer sein.
---@return string[]
function String.Split(str, delimiter) end

--------------------------------------------------------------------------------
-- Table
--------------------------------------------------------------------------------

---@class MSKTable
local Table = {}

---Ob val in tbl enthalten ist. Ist val selbst eine Tabelle, reicht ein
---gemeinsamer Wert.
---@param tbl table
---@param val any Darf false sein, aber nicht nil.
---@return boolean
function Table.Contains(tbl, val) end

---Die Tabelle als eingerücktes JSON. Andere Werte per tostring.
---@param tbl any
---@return string
function Table.Dump(tbl) end

---Rekursive Ausgabe im Stil von Lua-Quelltext.
---@param tbl any
---@param n? number Einrückungstiefe.
---@return string
function Table.DumpString(tbl, n) end

---Zählt alle Einträge, auch bei nicht fortlaufenden Schlüsseln.
---@param tbl table
---@return number
function Table.Size(tbl) end

---Erster Index von val in einer Liste.
---@param tbl table
---@param val any
---@return number index -1, wenn nicht gefunden.
function Table.Index(tbl, val) end

---Letzter Index von val in einer Liste.
---@param tbl table
---@param val any
---@return number index -1, wenn nicht gefunden.
function Table.LastIndex(tbl, val) end

---Erster Index und Wert von val in einer Liste.
---@param tbl table
---@param val any
---@return number|nil index, any value
function Table.Find(tbl, val) end

---Neue Liste in umgekehrter Reihenfolge.
---@param tbl table
---@return table
function Table.Reverse(tbl) end

---Tiefe Kopie der Tabelle, inklusive Metatable.
---@param tbl table
---@return table
function Table.Clone(tbl) end

---Iterator über tbl, sortiert nach Schlüsseln.
---@param tbl table
---@param order? fun(tbl: table, a: any, b: any): boolean Eigene Sortierung.
---@return fun(): any, any
function Table.Sort(tbl, order) end

---Schreibgeschützte Sicht auf tbl. Schreiben wirft einen Fehler, Lesen, pairs,
---ipairs und # funktionieren wie gewohnt. Die Originaltabelle bleibt
---beschreibbar, die Sicht zeigt deren Änderungen.
---@param tbl table
---@param deep? boolean Verschachtelte Tabellen kommen ebenfalls eingefroren zurück.
---@return table
function Table.Freeze(tbl, deep) end

---Ob tbl eine Sicht aus Table.Freeze ist.
---@param tbl any
---@return boolean
function Table.IsFrozen(tbl) end

---Neue Tabelle aus base, überschrieben mit den Einträgen aus override.
---Keine der beiden Eingaben wird verändert.
---@param base table
---@param override table
---@param deep? boolean Verschachtelte Tabellen werden zusammengeführt statt ersetzt.
---@return table
function Table.Merge(base, override, deep) end

---Tiefer Vergleich: gleiche Schlüssel und gleiche Werte, verschachtelte
---Tabellen nach Inhalt statt nach Identität.
---@param a any
---@param b any
---@return boolean
function Table.Matches(a, b) end

---Liste aller Schlüssel.
---@param tbl table
---@return any[]
function Table.Keys(tbl) end

---Liste aller Werte.
---@param tbl table
---@return any[]
function Table.Values(tbl) end

---Leert tbl an Ort und Stelle und gibt sie zurück. Anders als eine neue
---Tabelle zuzuweisen, sieht jede Referenz die leere Tabelle.
---@param tbl table
---@return table
function Table.Wipe(tbl) end

--------------------------------------------------------------------------------
-- Vector
--------------------------------------------------------------------------------

---@class MSKVector
local Vector = {}

---Formatiert Koordinaten als 'vector3(...)' oder 'vector4(...)'.
---@param coords vector3|vector4|table
---@return string
function Vector.CoordsToString(coords) end

---Macht aus einem vector4 einen vector3, alles andere bleibt unverändert.
---@param vec any
---@return any
function Vector.VectorToVector(vec) end

---Wandelt eine Koordinatentabelle in einen Vektor. Die Blickrichtung kommt
---aus h, w oder heading.
---@param coords table
---@param toType "vector3"|"vector4"
---@return vector3|vector4|nil
function Vector.TableToVector(coords, toType) end

---Weltposition eines Versatzes relativ zu Position und Blickrichtung, etwa
---ein Punkt zwei Meter vor einem Fahrzeug. Der Versatz ist (rechts, vorn, oben).
---@param coords vector3|vector4|table
---@param rotation number|vector3 Heading in Grad, oder eine Rotation, deren z genutzt wird.
---@param offset vector3|table
---@return vector3
function Vector.GetRelativeCoords(coords, rotation, offset) end

--------------------------------------------------------------------------------
-- Timeout
--------------------------------------------------------------------------------

---@class MSKTimeout
---@overload fun(ms: number, cb: fun(data: any), data?: any): number Kurzform für Set.
local Timeout = {}

---Führt cb nach ms Millisekunden aus.
---@param ms number
---@param cb fun(data: any)
---@param data? any Wird an cb übergeben.
---@return number requestId ID für Timeout.Clear.
function Timeout.Set(ms, cb, data) end

---Bricht einen laufenden Timeout ab. Nach dem Auslösen aufgerufen, passiert nichts.
---@param requestId number
function Timeout.Clear(requestId) end

---Wartet, bis cb einen Wert ungleich nil liefert. Läuft die Zeit ab, wirft
---die Funktion einen Fehler.
---@param timeout number|false|nil Millisekunden, nil heißt 1000, false wartet ohne Grenze.
---@param cb fun(): any
---@param errMessage? string Meldung beim Auslaufen.
---@return any
function Timeout.Await(timeout, cb, errMessage) end

--------------------------------------------------------------------------------
-- Callback
--------------------------------------------------------------------------------

---@class MSKCallback
local Callback = {}

---Registriert einen Callback, den die Gegenseite per Trigger aufrufen kann.
---Der erste Parameter von cb ist die Server-ID (auf dem Server die des
---Aufrufers). Ein Callback gehört der Resource, die ihn registriert hat: eine
---andere Resource kann ihn nicht überschreiben, und er verschwindet, wenn
---seine Resource stoppt. Fehler im Handler werden sofort beantwortet, statt
---die Gegenseite warten zu lassen.
---@param eventName string
---@param cb fun(playerId: number, ...): ...
---@return boolean registered false, wenn der Name schon einer anderen Resource gehört.
function Callback.Register(eventName, cb) end

---Ruft einen Callback der Gegenseite auf und wartet auf das Ergebnis.
---Die Wartezeit steuert der Convar msk:callbackTimeout (Standard 5000 ms),
---danach kommt nil zurück und eine Meldung in der Konsole. Auch mehrere
---Rückgabewerte mit nil dazwischen kommen vollständig an.
---Auf dem Server ohne Warten nil, wenn der Spieler nicht existiert.
---@param eventName string
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, ...: any): ...
function Callback.Trigger(eventName, ...) end

---Wie Trigger, aber der Server-Handler bekommt eine Antwortfunktion statt
---einen Rückgabewert zu liefern: Register(name, function(playerId, cb, ...) end).
---Nur die erste Antwort zählt. Wartet ebenfalls blockierend. Nur Client.
---@param eventName string
---@param ... any
---@return any ...
function Callback.TriggerCallback(eventName, ...) end

---Wie Trigger, aber mit eigener Zeitgrenze, für Callbacks, die länger als
---msk:callbackTimeout brauchen (Datenbank, externe Anfragen, Dialoge).
---Auf dem Server endet das Warten auch, wenn der Spieler geht, dann kommt nil.
---Client: TriggerAwait(eventName, timeout, ...).
---Server: TriggerAwait(eventName, playerId, timeout, ...).
---@param eventName string
---@param timeout? number|false Millisekunden, nil oder false wartet ohne Grenze.
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, timeout?: number|false, ...: any): ...
function Callback.TriggerAwait(eventName, timeout, ...) end

--------------------------------------------------------------------------------
-- Context
--------------------------------------------------------------------------------

---Ein Kontextmenü gehört der Resource, die es registriert hat. Stoppt sie,
---wird es entfernt und, falls offen, geschlossen.
---@class MSKContext
---@overload fun(idOrData: string|MSKContextData) Kurzform für Show.
local Context = {}

---Registriert ein Kontextmenü unter einer ID. Ist genau dieses Menü offen,
---zeigt es sofort die neue Fassung. Nur Client.
---@param id string
---@param data MSKContextData
---@return MSKContextData|nil entry
function Context.Register(id, data) end

---Öffnet ein Kontextmenü, per ID oder als Inline-Definition.
---Auf dem Server wird die Ziel-Spieler-ID vorangestellt. Über das Netzwerk
---kommen keine Funktionen an, dort also event, serverEvent und args nutzen
---oder das Menü vorher auf dem Client registrieren.
---@param idOrData string|MSKContextData
---@overload fun(playerId: number, idOrData: string|MSKContextData)
function Context.Show(idOrData) end

---Ändert einen einzelnen Eintrag eines Menüs (teilweise). Ist es offen, wird
---es sofort aktualisiert. Nur Client.
---@param contextId string
---@param dataId string ID der Option.
---@param updatedData MSKContextOption
function Context.Update(contextId, dataId, updatedData) end

---Schließt das Kontextmenü.
---@param fireExit? boolean Löst onExit aus.
---@overload fun(playerId: number)
function Context.Hide(fireExit) end

---Liefert die ID des offenen Kontextmenüs. Nur Client.
---@return string|nil
function Context.GetOpen() end

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------

---Tastaturmenü ohne NUI-Fokus, der Spieler kann weiterlaufen oder fahren.
---Ein Menü gehört der Resource, die es registriert hat.
---@class MSKMenu
---@overload fun(idOrData: string|MSKMenuData, startIndex?: number) Kurzform für Show.
local Menu = {}

---Registriert ein Menü unter einer ID. Nur Client.
---@param id string
---@param data MSKMenuData
---@param cb? MSKMenuCallback Läuft beim Bestätigen eines Eintrags mit Enter, alternativ data.onSelect.
---@return MSKMenuData|nil entry
function Menu.Register(id, data, cb) end

---Öffnet ein Menü, per ID oder als Inline-Definition. Ein offenes Menü wird
---vorher mit dem Schlüssel 'replace' geschlossen.
---Auf dem Server wird die Ziel-Spieler-ID vorangestellt, dort überleben
---Funktionen das Netzwerk nicht.
---@param idOrData string|MSKMenuData
---@param startIndex? number Eintrag, auf dem die Auswahl startet.
---@overload fun(playerId: number, idOrData: string|MSKMenuData, startIndex?: number)
function Menu.Show(idOrData, startIndex) end

---Ändert einen einzelnen Eintrag eines Menüs (teilweise). Nur Client.
---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function Menu.Update(menuId, dataId, updatedData) end

---Ersetzt alle Einträge, oder mit index nur diesen einen. Ein offenes Menü
---wird sofort aktualisiert und behält seine Auswahl, soweit möglich. Nur Client.
---@param menuId string
---@param options MSKMenuItem[]|MSKMenuItem Liste, oder ein einzelner Eintrag bei index.
---@param index? number
function Menu.SetOptions(menuId, options, index) end

---Schließt das Menü.
---@param key? string|false Wird an onClose übergeben, Standard 'forced'. false schließt ohne onClose.
---@overload fun(playerId: number)
function Menu.Hide(key) end

---Alias für Menu.Hide.
---@param key? string|false
---@overload fun(playerId: number)
function Menu.Close(key) end

---Liefert die ID des offenen Menüs. Nur Client.
---@return string|nil
function Menu.GetOpen() end

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

---@class MSKInput
---@overload fun(header: string, placeholder?: string, field?: boolean, cb?: fun(value: string|number|nil)): string|number|nil Veraltet, stattdessen Input.Dialog.
local Input = {}

---Öffnet das alte einzeilige Eingabefeld. Ohne cb blockiert der Aufruf und
---liefert den Wert, nil beim Abbrechen. Zahlen kommen als number zurück.
---Auf dem Server wartet der Aufruf ohne Zeitgrenze auf die Eingabe.
---@deprecated Stattdessen MSK.Input.Dialog.
---@param header string
---@param placeholder? string
---@param field? boolean true macht daraus ein Passwortfeld.
---@param cb? fun(value: string|number|nil) Erhält nil beim Abbrechen.
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function Input.Open(header, placeholder, field, cb) end

---Schließt das alte Eingabefeld. Wer darauf wartet, bekommt nil.
---@overload fun(playerId: number)
function Input.Close() end

---Ob gerade das alte Eingabefeld offen ist. Nur Client.
---@return boolean
function Input.Active() end

---Öffnet einen Dialog mit mehreren Feldern und wartet auf die Eingabe.
---Liefert nil beim Abbrechen, sonst die Werte nach Zeilennummer und
---zusätzlich nach id, wo eine Zeile eine hat. Leere optionale Felder sind nil,
---also nach Index lesen statt #values zu verwenden. Ein zweiter Dialog ersetzt
---den ersten, wer auf den ersten gewartet hat, bekommt nil.
---Auf dem Server prüft msk_core die Antwort des Clients noch einmal gegen
---dieselben Zeilen, ein manipulierter Client kommt an Pflichtfeldern, Grenzen
---und Auswahloptionen nicht vorbei.
---@param header string
---@param rows (MSKInputDialogRow|string)[] Ein String ist die Kurzform für ein Textfeld mit diesem Label.
---@param options? MSKInputDialogOptions
---@return table<number|string, any>|nil values
---@overload fun(playerId: number, header: string, rows: (MSKInputDialogRow|string)[], options?: MSKInputDialogOptions): table<number|string, any>|nil
function Input.Dialog(header, rows, options) end

---Schließt einen offenen Dialog. Wer darauf wartet, bekommt nil.
---@overload fun(playerId: number)
function Input.CloseDialog() end

---Ob gerade ein Dialog offen ist. Nur Client.
---@return boolean
function Input.DialogActive() end

--------------------------------------------------------------------------------
-- Numpad
--------------------------------------------------------------------------------

---@class MSKNumpad
---@overload fun(data: MSKNumpadOptions, cb?: fun(ok: boolean, reason?: MSKNumpadReason)): boolean|nil, MSKNumpadReason|nil Kurzform für Open.
local Numpad = {}

---Öffnet das Nummernfeld zur Code-Eingabe. Blockiert und liefert
---(ok, reason), oder ruft cb in jedem Fall auf, auch beim Abbrechen.
---Der Code erreicht nie die NUI, verglichen wird in Lua. Auf dem Client liegt
---er trotzdem im Speicher des Clients. Für alles mit echtem Wert die
---Server-Form Open(playerId, data) nehmen, dort verlässt der Code den Server nie.
---Die Form Open(pin, showPin, cb) ist veraltet, stattdessen die Tabelle.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: MSKNumpadReason)
---@return boolean|nil ok, MSKNumpadReason|nil reason
---@overload fun(pin: string|number, showPin?: boolean, cb?: fun(ok: boolean, reason?: MSKNumpadReason)): boolean|nil, MSKNumpadReason|nil
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, MSKNumpadReason|nil
---@overload fun(playerId: number, pin: string|number, showPin?: boolean): boolean, MSKNumpadReason|nil
function Numpad.Open(data, cb) end

---Fragt Ziffern ab, ohne sie mit einem Code zu vergleichen, etwa für eine
---eigene Prüfung auf dem Server. Liefert die Ziffern als String, nil beim
---Abbrechen. Auf dem Server kommen die Ziffern vom Client, also selbst prüfen.
---@param data? MSKNumpadInputOptions
---@param cb? fun(digits?: string, reason?: MSKNumpadReason)
---@return string|nil digits, MSKNumpadReason|nil reason
---@overload fun(playerId: number, data?: MSKNumpadInputOptions): string|nil, MSKNumpadReason|nil
function Numpad.Input(data, cb) end

---Schließt das Nummernfeld. Wer wartet, bekommt den Grund 'cancelled'.
---@overload fun(playerId: number)
function Numpad.Close() end

---Ob gerade ein Nummernfeld offen ist. Nur Client.
---@return boolean
function Numpad.Active() end

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgress
---@overload fun(data: MSKProgressData): boolean Kurzform für Start.
local Progress = {}

---Startet eine Progressbar und wartet auf ihr Ende. Liefert true, wenn sie
---durchgelaufen ist, false bei Abbruch, Unterbrechung oder wenn schon eine
---läuft (außer mit forceOverride).
---Die Form Start(duration, text, color) ist veraltet: sie wartet nicht und
---liefert nichts, stattdessen die Tabelle übergeben.
---Auf dem Server meldet der Client das Ergebnis, vor Belohnungen also selbst
---prüfen, ob die Aktion plausibel war.
---@param data MSKProgressData
---@return boolean finished
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function Progress.Start(data) end

---Wie Start, aber als Kreis dargestellt. Die Form mit Einzelwerten ist veraltet.
---@param data MSKProgressData
---@return boolean finished
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function Progress.Circle(data) end

---Bricht eine laufende Progressbar ab.
---@overload fun(playerId: number)
function Progress.Stop() end

---Ob gerade eine Progressbar läuft, plus deren Daten. Nur Client.
---@return boolean active, MSKProgressData|nil data
function Progress.Active() end

--------------------------------------------------------------------------------
-- TextUI
--------------------------------------------------------------------------------

---Die TextUI gehört der Resource, die sie eingeblendet hat, und verschwindet,
---wenn diese stoppt.
---@class MSKTextUI
---@overload fun(data: MSKTextUIData) Kurzform für Show.
local TextUI = {}

---Blendet die TextUI ein. Ist sie schon offen, wird sie aktualisiert, mit
---denselben Daten passiert nichts. Damit ist der Aufruf in einer Schleife
---unbedenklich.
---Die Form Show(key, text, color) ist veraltet, stattdessen die Tabelle.
---@param data MSKTextUIData
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.Show(data) end

---Für Aufrufe in jedem Frame: blendet sich etwa 100 ms nach dem letzten
---Aufruf selbst aus. Die Form mit Einzelwerten ist veraltet.
---@param data MSKTextUIData
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.ShowThread(data) end

---Blendet die TextUI aus.
---@overload fun(playerId: number)
function TextUI.Hide() end

---Ob die TextUI sichtbar ist, plus eine Kopie ihrer Daten. Nur Client.
---@return boolean open, MSKTextUIData|nil data
function TextUI.Active() end

--------------------------------------------------------------------------------
-- Coords
--------------------------------------------------------------------------------

---@class MSKCoords
local Coords = {}

---Blendet die Koordinatenanzeige ein. Auf dem Client schaltet ein zweiter
---Aufruf sie wieder aus.
---@overload fun(playerId: number)
function Coords.Show() end

---Blendet die Koordinatenanzeige aus.
---@overload fun(playerId: number)
function Coords.Hide() end

---Ob die Koordinatenanzeige aktiv ist. Auch als MSK.DoesShowCoords erreichbar.
---@return boolean
---@overload fun(playerId: number): boolean|nil
function Coords.Active() end

---Kopiert Koordinaten in die Zwischenablage, auf zwei Nachkommastellen gerundet.
---Auf dem Server die Position von targetId, sonst die von playerId.
---@param coords? vector3|vector4 Ohne Angabe die eigene Position.
---@overload fun(playerId: number, targetId?: number)
function Coords.Copy(coords) end

--------------------------------------------------------------------------------
-- Points (nur Client)
--------------------------------------------------------------------------------

---Alle 250 ms werden alle Points gemessen. Points mit nearby-Callback werden,
---solange der Spieler drin ist, zusätzlich in jedem Frame gemessen. Fehler in
---Callbacks beenden den Thread nicht mehr. Points einer gestoppten Resource
---werden ohne Callbacks entfernt.
---@class MSKPoints
local Points = {}

---Legt einen Point an, der onEnter und onExit im Radius auslöst.
---@param properties MSKPointProperties
---@return MSKPoint|nil
function Points.Add(properties) end

---Entfernt einen Point. War der Spieler drin, läuft vorher onExit.
---@param pointId number
---@return boolean
function Points.Remove(pointId) end

---Alle Points nach ID.
---@return table<number, MSKPoint>
function Points.GetAllPoints() end

---@return MSKPoint|nil
function Points.GetClosestPoint() end

---Alle Points, in denen der Spieler gerade steht, der nächste zuerst.
---@return MSKPoint[]
function Points.GetNearbyPoints() end

--------------------------------------------------------------------------------
-- Request (nur Client)
--------------------------------------------------------------------------------

---Alle Loader warten standardmäßig bis zu 30000 ms und werfen einen Fehler,
---wenn das Asset bis dahin nicht geladen ist.
---@class MSKRequest
---@overload fun(request: function, hasLoaded: function, assetType: string, asset: any, timeout?: number, ...: any): any Kurzform für Streaming.
local Request = {}

---Generischer Streaming-Loader. Basis der übrigen Request-Funktionen.
---@param request function Native, die das Laden anstößt.
---@param hasLoaded function Native, die den Ladezustand prüft.
---@param assetType string Bezeichnung für die Meldungen.
---@param asset any
---@param timeout? number Standard 30000 ms.
---@param ... any Weitere Argumente für request.
---@return any asset
function Request.Streaming(request, hasLoaded, assetType, asset, timeout, ...) end

---@param scaleformName string
---@param timeout? number Standard 30000 ms.
---@return number handle
function Request.ScaleformMovie(scaleformName, timeout) end

---@param animDict string
---@param timeout? number Standard 30000 ms.
---@return string animDict
function Request.AnimDict(animDict, timeout) end

---@param model string|number
---@param timeout? number Standard 30000 ms.
---@return number hash
function Request.Model(model, timeout) end

---@param animSet string
---@param timeout? number Standard 30000 ms.
---@return string
function Request.AnimSet(animSet, timeout) end

---@param ptFxName string
---@param timeout? number Standard 30000 ms.
---@return string
function Request.PtfxAsset(ptFxName, timeout) end

---@param textureDict string
---@param timeout? number Standard 30000 ms.
---@return string
function Request.TextureDict(textureDict, timeout) end

---Lädt eine Script-Audiobank. Fragt so lange nach, bis sie geladen ist.
---@param audioBank string
---@param timeout? number Standard 30000 ms.
---@return string
function Request.AudioBank(audioBank, timeout) end

---Lädt Modell und Animationen einer Waffe, etwa bevor ein Ped eine Waffe
---bekommt, die er noch nie hatte.
---@param weapon string|number
---@param flags? number Standard 31 (alles).
---@param extraComponents? number
---@param timeout? number Standard 30000 ms.
---@return number weaponHash
function Request.WeaponAsset(weapon, flags, extraComponents, timeout) end

---Linie vom Spieler aus nach vorn. Ein Fehlschuss ist auch ein Ergebnis und
---wirft keinen Fehler mehr.
---@param distance? number Standard 5.0.
---@param flag? number|MSKRaycastFlag Standard alles.
---@return number|false entityHit Getroffene Entity, oder false.
function Request.Raycast(distance, flag) end

---Strahl aus der Kamera in Blickrichtung, wartet höchstens eine Sekunde.
---@param flags? number Shape-Test-Flags, Standard 511 (alles).
---@param ignore? number Standard 4.
---@param distance? number Standard 10.0.
---@return boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.CameraRaycast(flags, ignore, distance) end

---Strahl zwischen zwei Punkten, wartet höchstens eine Sekunde.
---@param from vector3
---@param to vector3
---@param flags? number Shape-Test-Flags, Standard 511 (alles).
---@param ignore? number Standard 4.
---@param ignoreEntity? number Entity, durch die der Strahl geht, Standard der eigene Ped.
---@return boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.RaycastFromCoords(from, to, flags, ignore, ignoreEntity) end

---Startet einen Kamera-Raycast, ohne zu warten. Für Code, der jeden Frame
---läuft und nicht yielden darf. Ergebnis mit Request.ReadRaycast abholen.
---@param flags? number Standard 511.
---@param ignore? number Standard 4.
---@param distance? number Standard 10.0.
---@return number handle, vector3 destination
function Request.StartCameraRaycast(flags, ignore, distance) end

---Ergebnis eines mit StartCameraRaycast gestarteten Raycasts. done ist false,
---solange er noch läuft, dann fehlen die übrigen Werte.
---@param handle number
---@return boolean done, boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.ReadRaycast(handle) end

--------------------------------------------------------------------------------
-- Scaleform
--------------------------------------------------------------------------------

---@class MSKScaleform
local Scaleform = {}

---Zeigt ein beliebiges Scaleform bildschirmfüllend und gibt es danach frei. Nur Client.
---@param scaleform number Handle aus Request.ScaleformMovie.
---@param duration? number Standard 5000 ms.
function Scaleform.Show(scaleform, duration) end

---@param title string
---@param text string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, duration?: number)
function Scaleform.FreemodeMessage(title, text, duration) end

---@param title string
---@param text string
---@param footer? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, footer?: string, duration?: number)
function Scaleform.PopupWarning(title, text, footer, duration) end

---@param title string
---@param text string
---@param footer? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, footer?: string, duration?: number)
function Scaleform.BreakingNews(title, text, footer, duration) end

---@param duration? number
---@overload fun(playerId: number, duration?: number)
function Scaleform.TrafficMovie(duration) end

---Auch als MSK.ScaleformAnnounce erreichbar.
---@deprecated Stattdessen Scaleform.FreemodeMessage oder Scaleform.PopupWarning.
---@param title string
---@param text string
---@param typ? 1|2 1 = FreemodeMessage, 2 = PopupWarning.
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: 1|2, duration?: number)
function Scaleform.ScaleformAnnounce(title, text, typ, duration) end

---Lädt ein beliebiges Scaleform-Movie und liefert ein Objekt darauf.
---Das Movie lebt in der Resource, die es erzeugt hat. Nach Gebrauch Dispose
---aufrufen oder Render mit Dauer nutzen. Nur Client.
---@param name string Etwa 'MP_BIG_MESSAGE_FREEMODE'.
---@param options? number|MSKScaleformOptions Lade-Timeout in ms, oder eine Optionstabelle.
---@return MSKScaleformMovie
function Scaleform.New(name, options) end

--------------------------------------------------------------------------------
-- Cron (nur Server)
--------------------------------------------------------------------------------

---Jobs und Tasks einer Resource werden entfernt, wenn sie stoppt. Zeiten sind
---die lokale Zeit des Servers.
---@class MSKCron
local Cron = {}

---Legt einen Cron-Job an. Auch als MSK.CreateCron erreichbar.
---Mit m, h, d oder w läuft der Job wiederholt in diesem Abstand, mit atH und
---atM zu einer Uhrzeit, optional an einem Wochentag. Ein Zeitstempel läuft
---einmal. Für neue Scripts ist Cron.Schedule mit Cron-Ausdruck die flexiblere Wahl.
---@param date MSKCronDate|number Intervall, Uhrzeit oder Unix-Zeitstempel.
---@param data any Wird an cb übergeben.
---@param cb fun(uniqueId: number, data: any, info: MSKCronInfo)
---@return number|nil uniqueId ID für Cron.Delete, nil bei ungültigen Argumenten.
function Cron.Create(date, data, cb) end

---Löscht einen Job aus Cron.Create. Auch als MSK.DeleteCron erreichbar.
---@param id number
---@return boolean|nil found nil, wenn die ID unbekannt ist.
function Cron.Delete(id) end

---Führt cb aus, sobald ein Cron-Ausdruck passt. Fünf Felder: Minute (0-59),
---Stunde (0-23), Tag im Monat (1-31), Monat (1-12 oder jan-dec), Wochentag
---(0-7 oder sun-sat, 0 und 7 sind Sonntag). Jedes Feld kennt *, Werte,
---Bereiche (1-5), Listen (1,15,30) und Schritte (*/10, 8-18/2). Dazu die
---Makros @yearly, @annually, @monthly, @weekly, @daily, @midnight und @hourly.
---Sind Tag im Monat und Wochentag beide eingeschränkt, reicht einer davon.
---Gibt cb false zurück, wird der Task entfernt.
---Ein ungültiger Ausdruck wirft einen Fehler.
---@param expression string Etwa '*/15 * * * *' oder '0 20 * * fri'.
---@param cb fun(id: number, info: MSKCronTaskInfo): boolean?
---@return number id ID für Unschedule und GetNextRun.
function Cron.Schedule(expression, cb) end

---Entfernt einen Task aus Cron.Schedule.
---@param id number
---@return boolean removed
function Cron.Unschedule(id) end

---Zeitstempel des nächsten Laufs, für eine Task-ID oder einen Ausdruck.
---@param idOrExpression number|string
---@return number|nil timestamp nil bei unbekannter ID oder ungültigem Ausdruck.
function Cron.GetNextRun(idOrExpression) end

---Prüft einen Cron-Ausdruck, ohne etwas anzulegen.
---@param expression string
---@return boolean valid, string|nil reason
function Cron.IsValid(expression) end

--------------------------------------------------------------------------------
-- Check (nur Server)
--------------------------------------------------------------------------------

---@class MSKCheck
---@overload fun(repo: MSKCheckRepo) Kurzform für Version.
local Check = {}

---Vergleicht die Version der aufrufenden Resource mit dem neuesten
---GitHub-Release. Eine unerwartete Antwort von GitHub (Rate Limit, kein
---Release) führt zu einer Meldung statt einem Fehler.
---@param repo MSKCheckRepo
function Check.Version(repo) end

---Prüft, ob eine andere Resource die Mindestversion erfüllt. Eine Resource
---ohne lesbare Version (auch eine fehlende) erfüllt sie nicht. Fehlende
---Versionsteile zählen als 0.
---@param resource string
---@param minimumVersion string Etwa '4.1.0'.
---@param showMessage? boolean Schreibt die Fehlermeldung in die Konsole.
---@return boolean ok, string|nil errMsg
function Check.Dependency(resource, minimumVersion, showMessage) end

--------------------------------------------------------------------------------
-- Society (nur Server)
--------------------------------------------------------------------------------

---Firmenkonten folgen seit 4.0.0 der Banking-Resource, nicht dem Framework:
---Renewed-Banking, qb-banking, qb-management oder esx_addonaccount. Wird keine
---gefunden, merkt sich msk_core das seit 4.1.0 nicht mehr, eine später
---gestartete Banking-Resource wird also noch erkannt.
---@class MSKSociety
local Society = {}

---Welche Banking-Resource erkannt wurde, nil wenn keine läuft.
---@return string|nil
function Society.GetProvider() end

---@param society string Name des Firmenkontos ohne das Präfix society_.
---@return number
function Society.GetMoney(society) end

---@param society string
---@param amount number Wird abgerundet, muss größer 0 sein.
---@return boolean
function Society.AddMoney(society, amount) end

---@param society string
---@param amount number Wird abgerundet, muss größer 0 sein.
---@return boolean removed false, wenn das Konto nicht genug hat.
function Society.RemoveMoney(society, amount) end

--------------------------------------------------------------------------------
-- Offline (nur Server)
--------------------------------------------------------------------------------

---Ist der Spieler doch online, laufen die Bank-Funktionen seit 4.1.0 über das
---Framework. Direkt in die Datenbank geschrieben hätte der nächste Save des
---Frameworks die Änderung wieder überschrieben.
---@class MSKOffline
local Offline = {}

---Liest den Bankstand eines Spielers.
---@param identifier string
---@return number|nil bank nil, wenn es den Spieler nicht gibt.
function Offline.GetBank(identifier) end

---@param identifier string
---@param amount number Wird abgerundet, muss größer 0 sein.
---@return boolean
function Offline.AddBank(identifier, amount) end

---@param identifier string
---@param amount number Wird abgerundet, muss größer 0 sein.
---@return boolean removed false, wenn das Konto nicht genug hat.
function Offline.RemoveBank(identifier, amount) end

---Charaktertabelle des laufenden Frameworks plus Schlüsselspalte.
---ESX: users/identifier. QBCore und Qbox: players/citizenid.
---@return { table: string, identifier: string }|nil
function Offline.GetPlayerTable() end

--------------------------------------------------------------------------------
-- VehicleStore (nur Server)
--
-- Eine Form über der Fahrzeugtabelle des laufenden Frameworks. Die
-- Fahrzeugeigenschaften bleiben bewusst im Framework-Format, weil jede andere
-- Garage auf dem Server dieselbe Spalte liest.
--------------------------------------------------------------------------------

---@class MSKVehicleStore
local VehicleStore = {}

---Tabellen- und Spaltennamen des laufenden Frameworks, als Kopie.
---Außerhalb eines Threads aufrufen, sonst läuft die erste Query noch gegen
---den eigenen Fallback.
---@return MSKVehicleSchema|nil
function VehicleStore.GetSchema() end

---@param plate string
---@return MSKVehicleRow|nil
function VehicleStore.GetByPlate(plate) end

---@param plate string
---@return number
function VehicleStore.CountByPlate(plate) end

---Legt ein Fahrzeug an. Auf QBCore und Qbox ist model Pflicht, ohne model
---oder ohne ableitbaren Hash kommt false zurück, statt eine kaputte Zeile
---zu schreiben.
---@param data MSKVehicleInsert
---@return boolean
function VehicleStore.Insert(data) end

---Aktualisiert einzelne Felder. Die Schlüssel sind die vereinheitlichten
---Namen (owner, garage, type, job, stored, props), nicht die Spaltennamen.
---@param plate string
---@param fields table
---@return boolean
function VehicleStore.Update(plate, fields) end

---Schreibt ein echtes NULL in die Job-Spalte. Update überspringt nil-Werte.
---@param plate string
---@return boolean
function VehicleStore.ClearJob(plate) end

---@param plate string
---@return boolean true nur, wenn wirklich eine Zeile entfernt wurde.
function VehicleStore.Delete(plate) end

---Seitenweise und in SQL gefiltert.
---@param opts MSKVehicleBrowseOptions
---@return MSKVehicleBrowseResult
function VehicleStore.Browse(opts) end
