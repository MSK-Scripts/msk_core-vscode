---@meta
--- Modul-Namespaces der msk_core Library (FiveM).
--- Erreichbar als MSK.<Modul>, geladen per Lazy-Loading ueber import.lua.
---
--- Wo sich Client und Server unterscheiden, steht die Client-Signatur als
--- Hauptsignatur und die Server-Signatur als @overload. Auf dem Server nimmt
--- fast jede UI-Funktion die Ziel-Spieler-ID als erstes Argument.

--------------------------------------------------------------------------------
-- Math
--------------------------------------------------------------------------------

---@class MSKMath
local Math = {}

---Erzeugt eine Zufallszahl mit der angegebenen Stellenzahl.
---@param length number Anzahl der Stellen.
---@return number
function Math.Random(length) end

---Rundet auf die angegebene Nachkommastelle.
---@param num number
---@param decimal? number Nachkommastellen, Standard 0.
---@return number
function Math.Round(num, decimal) end

---Formatiert eine Zahl mit Tausendertrennzeichen.
---@param int number
---@param tag? string Trennzeichen, Standard Punkt.
---@return string
function Math.Comma(int, tag) end

--------------------------------------------------------------------------------
-- String
--------------------------------------------------------------------------------

---@class MSKString
local String = {}

---Erzeugt eine zufaellige Zeichenkette.
---@param length number
---@return string
function String.Random(length) end

---Prueft, ob str mit startStr beginnt.
---@param str string
---@param startStr string
---@return boolean
function String.StartsWith(str, startStr) end

---Entfernt Leerzeichen.
---@param str string
---@param bool? boolean true entfernt alle Leerzeichen, sonst nur aussen.
---@return string
function String.Trim(str, bool) end

---Wie Trim, aber mit der invertierten Bool-Semantik aus msk_core v2.
---Erreichbar als MSK.Trim, waehrend exports.msk_core:Trim auf String.Trim zeigt.
---@param str string
---@param bool? boolean
---@return string
function String.TrimLegacy(str, bool) end

---Zerlegt eine Zeichenkette an einem Trennzeichen.
---@param str string
---@param delimiter string
---@return string[]
function String.Split(str, delimiter) end

--------------------------------------------------------------------------------
-- Table
--------------------------------------------------------------------------------

---@class MSKTable
local Table = {}

---@param tbl table
---@param val any
---@return boolean
function Table.Contains(tbl, val) end

---Gibt die Tabelle formatiert in der Konsole aus.
---@param tbl table
function Table.Dump(tbl) end

---Wie Dump, liefert die Ausgabe aber als Zeichenkette zurueck.
---@param tbl table
---@param n? number Einrueckungstiefe.
---@return string
function Table.DumpString(tbl, n) end

---Zaehlt alle Eintraege, auch bei nicht fortlaufenden Schluesseln.
---@param tbl table
---@return number
function Table.Size(tbl) end

---@param tbl table
---@param val any
---@return any key Schluessel des ersten Treffers.
function Table.Index(tbl, val) end

---@param tbl table
---@param val any
---@return any key Schluessel des letzten Treffers.
function Table.LastIndex(tbl, val) end

---@param tbl table
---@param val any
---@return any value
function Table.Find(tbl, val) end

---@param tbl table
---@return table
function Table.Reverse(tbl) end

---Tiefe Kopie der Tabelle.
---@param tbl table
---@return table
function Table.Clone(tbl) end

---@param tbl table
---@param order? fun(a: any, b: any): boolean
---@return table
function Table.Sort(tbl, order) end

--------------------------------------------------------------------------------
-- Vector
--------------------------------------------------------------------------------

---@class MSKVector
local Vector = {}

---Formatiert Koordinaten als lesbare Zeichenkette.
---@param coords vector3|vector4|table
---@return string
function Vector.CoordsToString(coords) end

---@param vec vector2|vector3|vector4
---@return vector3
function Vector.VectorToVector(vec) end

---@param coords table
---@param toType? number Zielformat, 3 oder 4.
---@return vector3|vector4
function Vector.TableToVector(coords, toType) end

--------------------------------------------------------------------------------
-- Timeout
--------------------------------------------------------------------------------

---@class MSKTimeout
local Timeout = {}

---Fuehrt cb nach ms Millisekunden aus.
---@param ms number
---@param cb fun(data: any)
---@param data? any Wird an cb uebergeben.
---@return number requestId ID fuer Timeout.Clear.
function Timeout.Set(ms, cb, data) end

---Bricht einen laufenden Timeout ab.
---@param requestId number
function Timeout.Clear(requestId) end

---Wartet, bis cb einen Wert ungleich nil liefert, hoechstens aber timeout ms.
---@param timeout number
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
---Auf dem Server ist der erste Parameter von cb die Server-ID des Aufrufers.
---@param eventName string
---@param cb fun(...): any
function Callback.Register(eventName, cb) end

---Ruft einen Callback der Gegenseite auf und wartet auf das Ergebnis.
---Client: Trigger(eventName, ...). Server: Trigger(eventName, playerId, ...).
---@param eventName string
---@param ... any
---@return any
---@overload fun(eventName: string, playerId: number, ...: any): any
function Callback.Trigger(eventName, ...) end

---Wie Trigger, aber nicht blockierend: das Ergebnis kommt in den Callback.
---Nur auf dem Client vorhanden.
---@param eventName string
---@param ... any
function Callback.TriggerCallback(eventName, ...) end

--------------------------------------------------------------------------------
-- Context
--------------------------------------------------------------------------------

---@class MSKContext
---@overload fun(idOrData: string|MSKContextData) Kurzform fuer Show.
local Context = {}

---Registriert ein Kontextmenue unter einer ID. Nur Client.
---@param id string
---@param data MSKContextData
function Context.Register(id, data) end

---Oeffnet ein Kontextmenue, per ID oder als Inline-Definition.
---Auf dem Server wird die Ziel-Spieler-ID vorangestellt.
---@param idOrData string|MSKContextData
---@overload fun(playerId: number, idOrData: string|MSKContextData)
function Context.Show(idOrData) end

---Aendert einen einzelnen Eintrag eines offenen Menues. Nur Client.
---@param contextId string
---@param dataId string ID der Option.
---@param updatedData MSKContextOption
function Context.Update(contextId, dataId, updatedData) end

---Schliesst das Kontextmenue.
---@param fireExit? boolean Loest onExit aus.
---@overload fun(playerId: number)
function Context.Hide(fireExit) end

---Liefert die ID des offenen Kontextmenues. Nur Client.
---@return string|nil
function Context.GetOpen() end

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------

---@class MSKMenu
---@overload fun(idOrData: string|MSKMenuData) Kurzform fuer Show.
local Menu = {}

---Registriert ein Menue unter einer ID. Nur Client.
---@param id string
---@param data MSKMenuData
function Menu.Register(id, data) end

---Oeffnet ein Menue, per ID oder als Inline-Definition. Nur Client.
---@param idOrData string|MSKMenuData
function Menu.Show(idOrData) end

---Aendert einen einzelnen Eintrag eines offenen Menues. Nur Client.
---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function Menu.Update(menuId, dataId, updatedData) end

---Schliesst das Menue. Nur Client.
---@param key? string
function Menu.Hide(key) end

---Liefert die ID des offenen Menues. Nur Client.
---@return string|nil
function Menu.GetOpen() end

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

---@class MSKInput
---@overload fun(header: string, placeholder?: string, field?: boolean, cb?: fun(value: string|nil))
local Input = {}

---Oeffnet das Eingabefeld.
---@param header string
---@param placeholder? string
---@param field? boolean true macht daraus ein Passwortfeld.
---@param cb? fun(value: string|nil) Erhaelt nil beim Abbrechen.
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean)
function Input.Open(header, placeholder, field, cb) end

---Schliesst das Eingabefeld.
---@overload fun(playerId: number)
function Input.Close() end

---Ob gerade ein Eingabefeld offen ist. Nur Client.
---@return boolean
function Input.Active() end

--------------------------------------------------------------------------------
-- Numpad
--------------------------------------------------------------------------------

---@class MSKNumpad
---@overload fun(pin: string|number, showPin?: boolean, cb?: fun(success: boolean))
local Numpad = {}

---Oeffnet das Nummernfeld zur PIN-Eingabe.
---@param pin string|number Der erwartete Code.
---@param showPin? boolean Zeigt den Code im Feld an.
---@param cb? fun(success: boolean)
---@overload fun(playerId: number, pin: string|number, showPin?: boolean)
function Numpad.Open(pin, showPin, cb) end

---Schliesst das Nummernfeld.
---@overload fun(playerId: number)
function Numpad.Close() end

---Ob gerade ein Nummernfeld offen ist. Nur Client.
---@return boolean
function Numpad.Active() end

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgress
local Progress = {}

---Startet die Progressbar. Entweder mit einer Datentabelle, oder mit
---Dauer, Text und Farbe als Einzelwerte.
---@param data MSKProgressData|number Datentabelle oder Dauer in Millisekunden.
---@param text? string Nur bei Aufruf mit Einzelwerten.
---@param color? string Nur bei Aufruf mit Einzelwerten.
---@return boolean|nil cancelled true, wenn der Vorgang abgebrochen wurde.
---@overload fun(playerId: number, data: MSKProgressData|number, text?: string, color?: string)
function Progress.Start(data, text, color) end

---Bricht eine laufende Progressbar ab.
---@overload fun(playerId: number)
function Progress.Stop() end

---Ob gerade eine Progressbar laeuft. Nur Client.
---@return boolean
function Progress.Active() end

--------------------------------------------------------------------------------
-- TextUI
--------------------------------------------------------------------------------

---@class MSKTextUI
local TextUI = {}

---Blendet die TextUI ein.
---@param key string Angezeigte Taste, etwa "E".
---@param text string
---@param color? string
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.Show(key, text, color) end

---Wie Show, blendet sich aber automatisch aus, sobald der Thread endet.
---@param key string
---@param text string
---@param color? string
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.ShowThread(key, text, color) end

---Blendet die TextUI aus.
---@overload fun(playerId: number)
function TextUI.Hide() end

---Ob die TextUI sichtbar ist. Nur Client.
---@return boolean
function TextUI.Active() end

--------------------------------------------------------------------------------
-- Coords
--------------------------------------------------------------------------------

---@class MSKCoords
local Coords = {}

---Blendet die Koordinatenanzeige ein.
---@overload fun(playerId: number)
function Coords.Show() end

---Blendet die Koordinatenanzeige aus.
---@overload fun(playerId: number)
function Coords.Hide() end

---Ob die Koordinatenanzeige aktiv ist. Auch als MSK.DoesShowCoords erreichbar.
---@return boolean
---@overload fun(playerId: number): boolean
function Coords.Active() end

---Kopiert Koordinaten in die Zwischenablage.
---@param coords? vector3|vector4 Ohne Angabe die eigene Position.
---@overload fun(playerId: number, targetId?: number)
function Coords.Copy(coords) end

--------------------------------------------------------------------------------
-- Points (nur Client)
--------------------------------------------------------------------------------

---@class MSKPoints
local Points = {}

---Legt einen Point an, der onEnter und onExit im Radius ausloest.
---@param properties MSKPointProperties
---@return MSKPoint
function Points.Add(properties) end

---Entfernt einen Point.
---@param pointId number
---@return boolean
function Points.Remove(pointId) end

---@return MSKPoint[]
function Points.GetAllPoints() end

---@return MSKPoint|nil
function Points.GetClosestPoint() end

--------------------------------------------------------------------------------
-- Request (nur Client)
--------------------------------------------------------------------------------

---@class MSKRequest
---@overload fun(request: function, hasLoaded: function, assetType: string, asset: any, timeout?: number, ...: any): boolean
local Request = {}

---Generischer Streaming-Loader. Basis der uebrigen Request-Funktionen.
---@param request function Native, die das Laden anstoesst.
---@param hasLoaded function Native, die den Ladezustand prueft.
---@param assetType string Bezeichnung fuer die Fehlermeldung.
---@param asset any
---@param timeout? number Standard 1000 ms.
---@param ... any
---@return boolean
function Request.Streaming(request, hasLoaded, assetType, asset, timeout, ...) end

---@param scaleformName string
---@param timeout? number
---@return number handle
function Request.ScaleformMovie(scaleformName, timeout) end

---@param animDict string
---@return string animDict
function Request.AnimDict(animDict) end

---@param model string|number
---@return number hash
function Request.Model(model) end

---@param animSet string
---@return string
function Request.AnimSet(animSet) end

---@param ptFxName string
---@return string
function Request.PtfxAsset(ptFxName) end

---@param textureDict string
---@return string
function Request.TextureDict(textureDict) end

---Raycast aus der Kameramitte nach vorn.
---@param distance? number
---@param flag? number
---@return boolean hit, vector3 endCoords, number entityHit
function Request.Raycast(distance, flag) end

--------------------------------------------------------------------------------
-- Scaleform
--------------------------------------------------------------------------------

---@class MSKScaleform
local Scaleform = {}

---Zeigt ein beliebiges Scaleform. Nur Client.
---@param scaleform number Handle aus Request.ScaleformMovie.
---@param duration number
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

---@param title string
---@param text string
---@param typ? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: string, duration?: number)
function Scaleform.ScaleformAnnounce(title, text, typ, duration) end

--------------------------------------------------------------------------------
-- Cron (nur Server)
--------------------------------------------------------------------------------

---@class MSKCron
local Cron = {}

---Legt einen Cron-Job an. Auch als MSK.CreateCron erreichbar.
---@param date MSKCronDate Zeitpunkt, zu dem cb laeuft.
---@param data any Wird an cb uebergeben.
---@param cb fun(data: any)
---@return string uniqueId ID fuer Cron.Delete.
function Cron.Create(date, data, cb) end

---Loescht einen Cron-Job. Auch als MSK.DeleteCron erreichbar.
---@param id string
---@return boolean
function Cron.Delete(id) end

--------------------------------------------------------------------------------
-- Check (nur Server)
--------------------------------------------------------------------------------

---@class MSKCheck
---@overload fun(repo: MSKCheckRepo|string) Kurzform fuer Version.
local Check = {}

---Vergleicht die Resource-Version mit dem neuesten GitHub-Release.
---@param repo MSKCheckRepo|string
function Check.Version(repo) end

---Prueft, ob eine andere Resource laeuft und die Mindestversion erfuellt.
---@param resource string
---@param minimumVersion? string
---@param showMessage? boolean
---@return boolean ok, string currentVersion
function Check.Dependency(resource, minimumVersion, showMessage) end

--------------------------------------------------------------------------------
-- Society (nur Server)
--------------------------------------------------------------------------------

---@class MSKSociety
local Society = {}

---@param society string Name des Firmenkontos.
---@return number
function Society.GetMoney(society) end

---@param society string
---@param amount number
---@return boolean
function Society.AddMoney(society, amount) end

---@param society string
---@param amount number
---@return boolean
function Society.RemoveMoney(society, amount) end

--------------------------------------------------------------------------------
-- Offline (nur Server)
--------------------------------------------------------------------------------

---@class MSKOffline
local Offline = {}

---Liest den Bankstand eines Spielers, der nicht online ist.
---@param identifier string
---@return number
function Offline.GetBank(identifier) end

---@param identifier string
---@param amount number
---@return boolean
function Offline.AddBank(identifier, amount) end

---@param identifier string
---@param amount number
---@return boolean
function Offline.RemoveBank(identifier, amount) end
