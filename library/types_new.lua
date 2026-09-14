---@meta
--- Datenstrukturen und Objekttypen der Module, die mit msk_core 4.1.0 neu
--- dazugekommen sind. Quelle: modules/<Name>/ in msk_core 4.1.0

--------------------------------------------------------------------------------
-- Alert
--------------------------------------------------------------------------------

---@alias MSKAlertResult
---| "confirm" # Bestätigt.
---| "cancel" # Abgebrochen, per Button oder Escape.
---| "timeout" # timeout ist abgelaufen.

---@alias MSKAlertSize
---| "sm"
---| "md"
---| "lg"

---@class MSKAlertLabels
---@field confirm? string Beschriftung des Bestätigen-Buttons.
---@field cancel? string Beschriftung des Abbrechen-Buttons.

---@class MSKAlertData
---@field header? string Überschrift. header oder content muss gesetzt sein.
---@field content? string Text. Zeilenumbrüche und ~farb~-Codes funktionieren.
---@field size? MSKAlertSize Standard "md".
---@field centered? boolean Zentriert den Text.
---@field cancel? boolean false blendet den Abbrechen-Button aus.
---@field labels? MSKAlertLabels
---@field timeout? number Millisekunden, danach liefert Show "timeout".

--------------------------------------------------------------------------------
-- Anim
--------------------------------------------------------------------------------

---@class MSKAnimOptions
---@field blendIn? number Standard 8.0
---@field blendOut? number Standard -8.0
---@field duration? number Standard -1 (bis die Animation endet).
---@field flag? number Standard 0
---@field rate? number Standard 0.0
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean
---@field wait? boolean Blockiert, bis die Animation vorbei ist. Wird bei einer Endlosschleife ohne duration ignoriert.

--------------------------------------------------------------------------------
-- Class
--------------------------------------------------------------------------------

---Methoden, die jede Klasse und jede Instanz am Ende ihrer Lookup-Kette erreicht.
---@class MSKClassBase
local MSKClassBase = {}

---Erzeugt eine Instanz. Gleichwertig zum direkten Aufruf der Klasse.
---Liefert nil, wenn init false zurückgibt.
---@param ... any Wird an init übergeben.
---@return MSKClassInstance|nil
function MSKClassBase:New(...) end

---Erzeugt eine Kindklasse, die alle Methoden dieser Klasse erbt.
---@param name string
---@return MSKClassObject
function MSKClassBase:Extend(name) end

---True, wenn diese Instanz oder Klasse cls ist oder davon erbt.
---@param cls MSKClassObject
---@return boolean
function MSKClassBase:IsA(cls) end

---Eine Klasse aus MSK.Class.New. Methoden werden direkt auf der Tabelle
---definiert, etwa function Vehicle:init(model) ... end.
---Den Parent immer über den Klassennamen aufrufen (Car.Parent.init), nie über
---self.Parent, sonst endet das bei drei Ebenen in einer Endlosrekursion.
---@class MSKClassObject : MSKClassBase
---@field Name string Name der Klasse.
---@field Parent? MSKClassObject Elternklasse, falls vorhanden.
---@field init? fun(self: MSKClassInstance, ...: any): boolean? Konstruktor. false verweigert die Instanz.
---@field [string] any
---@overload fun(...: any): MSKClassInstance|nil Erzeugt eine Instanz.

---Eine Instanz einer Klasse. Über einen Export verliert sie ihre Metatable
---und damit ihre Methoden, also in der erzeugenden Resource behalten.
---@class MSKClassInstance : MSKClassBase
---@field [string] any

--------------------------------------------------------------------------------
-- Dui (nur Client)
--------------------------------------------------------------------------------

---@class MSKDuiData
---@field url string Adresse der Seite, für eigene Dateien etwa "nui://my_script/html/screen.html".
---@field width? number Standard 1280.
---@field height? number Standard 720.

---@alias MSKDuiMouseButton
---| "left"
---| "middle"
---| "right"

---Eine Webseite als Spieltextur. Wird beim Stoppen der Resource entfernt.
---@class MSKDuiInstance
---@field id number
---@field url string
---@field width number
---@field height number
---@field duiObject? number nil nach Remove.
---@field duiHandle string
---@field dictName string Name des Runtime-TXD.
---@field textureName string Name der Runtime-Textur.
local MSKDuiInstance = {}

---True, sobald die Seite weit genug geladen ist, um Nachrichten zu empfangen.
---@return boolean
function MSKDuiInstance:IsAvailable() end

---@param url string
function MSKDuiInstance:SetUrl(url) end

---Schickt eine Nachricht an die Seite. Sie kommt dort als window-Event
---"message" an, mit der Tabelle als event.data.
---@param data table
function MSKDuiInstance:SendMessage(data) end

---Zeigt die Seite anstelle einer Spieltextur.
---@param originalDict string
---@param originalTexture string
function MSKDuiInstance:ReplaceTexture(originalDict, originalTexture) end

---Bewegt die Maus innerhalb der Seite, in Pixeln der Seitengröße.
---@param x number
---@param y number
function MSKDuiInstance:MouseMove(x, y) end

---@param button? MSKDuiMouseButton Standard "left".
function MSKDuiInstance:MouseDown(button) end

---@param button? MSKDuiMouseButton Standard "left".
function MSKDuiInstance:MouseUp(button) end

---@param deltaY number
---@param deltaX? number
function MSKDuiInstance:MouseWheel(deltaY, deltaX) end

---Stellt ersetzte Texturen wieder her und zerstört die Seite.
function MSKDuiInstance:Remove() end

--------------------------------------------------------------------------------
-- Grid
--------------------------------------------------------------------------------

---Ein Eintrag im Grid. Braucht entweder coords und radius oder min und max
---als achsenparallele Bounding Box. Jede Tabelle mit diesen Feldern passt.
---@class MSKGridEntry
---@field coords? vector3|vector2|table
---@field radius? number
---@field min? vector3|vector2|table
---@field max? vector3|vector2|table
---@field [any] any

---Ein Spatial Hash über die X/Y-Ebene.
---@class MSKGridInstance
---@field cellSize number Kantenlänge einer Zelle.
local MSKGridInstance = {}

---Fügt einen Eintrag hinzu oder sortiert ihn neu ein, wenn er schon drin ist.
---@generic T : MSKGridEntry
---@param entry T
---@return T entry
function MSKGridInstance:Add(entry) end

---@param entry MSKGridEntry
---@return boolean removed
function MSKGridInstance:Remove(entry) end

---Einträge in der Zelle, die coords enthält.
---@param coords vector3|vector2|table
---@return MSKGridEntry[]
function MSKGridInstance:GetNearby(coords) end

---Einträge aller Zellen, die das Quadrat um coords mit radius berührt.
---Kein Eintrag kommt doppelt vor.
---@param coords vector3|vector2|table
---@param radius number
---@return MSKGridEntry[]
function MSKGridInstance:GetInRange(coords, radius) end

---@param entry MSKGridEntry
---@return boolean
function MSKGridInstance:Has(entry) end

---Leert das Grid.
function MSKGridInstance:Clear() end

--------------------------------------------------------------------------------
-- Hook
--------------------------------------------------------------------------------

---@class MSKHookOptions
---@field priority? number Höhere Werte laufen zuerst, Standard 0.

--------------------------------------------------------------------------------
-- Keybind (nur Client)
--------------------------------------------------------------------------------

---@class MSKKeybindData
---@field name string Eindeutig über alle Resources, ohne Leerzeichen. Wird zu den Commands +name / -name. Umbenennen verwirft die Tastenwahl des Spielers.
---@field description string Text in den GTA-Einstellungen (Tastenbelegung, FiveM).
---@field defaultKey? string Standardtaste, etwa "F5".
---@field defaultMapper? string Standard "keyboard".
---@field secondaryKey? string Zweite Taste.
---@field secondaryMapper? string Standard wie defaultMapper.
---@field disabled? boolean Startet deaktiviert.
---@field allowInPauseMenu? boolean Löst auch im Pausemenü aus, Standard false.
---@field onPressed? fun(self: MSKKeybind)
---@field onReleased? fun(self: MSKKeybind)

---Eine registrierte Tastenbelegung. Enthält alle übergebenen Felder.
---@class MSKKeybind : MSKKeybindData
---@field defaultMapper string
---@field defaultKey string
---@field disabled boolean
---@field pressed boolean True, solange die Taste gedrückt ist.
local MSKKeybind = {}

---Deaktiviert (true, Standard) oder aktiviert (false) die Belegung.
---Ist die Taste beim Deaktivieren gedrückt, läuft onReleased.
---@param state? boolean
function MSKKeybind:Disable(state) end

---@return boolean
function MSKKeybind:IsDisabled() end

---True, solange die Taste gedrückt ist.
---@return boolean
function MSKKeybind:IsPressed() end

---Die aktuell belegte Taste wie in den Einstellungen, etwa "E" oder "F5".
---@return string
function MSKKeybind:GetCurrentKey() end

--------------------------------------------------------------------------------
-- Logger (nur Server)
--------------------------------------------------------------------------------

---Tags als key:value-Paare: String "a:1,b:2", Liste { "a:1" } oder Tabelle { a = 1 }.
---@alias MSKLoggerTags string|string[]|table<string, any>

--------------------------------------------------------------------------------
-- Marker (nur Client)
--------------------------------------------------------------------------------

---Farbe als { r, g, b, a } mit Namen oder als Liste { 255, 0, 0, 150 }.
---Fehlende Werte sind 255, Alpha 150.
---@alias MSKMarkerColor { r: number, g: number, b: number, a?: number }|number[]

---@class MSKMarkerData
---@field type? number Markertyp, Standard 1.
---@field coords vector3|table
---@field width? number Standard 1.0, gilt für X und Y.
---@field height? number Standard 1.0
---@field color? MSKMarkerColor Standard MSK-Grün mit Alpha 150.
---@field direction? vector3|table
---@field rotation? vector3|table
---@field bobUpAndDown? boolean
---@field faceCamera? boolean
---@field rotate? boolean
---@field textureDict? string
---@field textureName? string

---Ein Marker mit einmal abgelegten Einstellungen.
---@class MSKMarkerInstance
---@field type number
---@field coords vector3
---@field direction vector3
---@field rotation vector3
---@field width number
---@field height number
---@field color { r: number, g: number, b: number, a: number }
---@field bobUpAndDown boolean
---@field faceCamera boolean
---@field rotate boolean
---@field textureDict? string
---@field textureName? string
local MSKMarkerInstance = {}

---Zeichnet den Marker für diesen Frame. Muss jeden Frame aufgerufen werden.
function MSKMarkerInstance:Draw() end

---@param coords vector3|table
function MSKMarkerInstance:SetCoords(coords) end

---@param color MSKMarkerColor
function MSKMarkerInstance:SetColor(color) end

---Abstand vom Marker zu coords, ohne Angabe zum Spieler.
---@param coords? vector3|table
---@return number
function MSKMarkerInstance:GetDistance(coords) end

--------------------------------------------------------------------------------
-- Print
--------------------------------------------------------------------------------

---@alias MSKPrintLevel
---| "error"
---| "warn"
---| "info"
---| "verbose"
---| "debug"

--------------------------------------------------------------------------------
-- Radial (nur Client)
--------------------------------------------------------------------------------

---@class MSKRadialItem
---@field id string Pflicht. Gleiche ID ersetzt einen vorhandenen Eintrag.
---@field label string Pflicht.
---@field icon? string Font-Awesome-Name ("car") oder Klasse ("fas fa-car").
---@field iconColor? string
---@field menu? string ID eines Untermenüs aus Radial.Register, das beim Klick geöffnet wird.
---@field onSelect? fun(menuId: string|nil, index: number) menuId ist nil auf der ersten Ebene.
---@field keepOpen? boolean Lässt das Menü nach dem Klick offen.

---@class MSKRadialMenu
---@field id string
---@field title? string
---@field items MSKRadialItem[]

--------------------------------------------------------------------------------
-- Selector
--------------------------------------------------------------------------------

---Gewichteter Eintrag, als { value, weight } oder { value = x, weight = n }.
---Gewichte von 0 oder weniger werden nie gezogen.
---@alias MSKSelectorWeightedEntry { value: any, weight: number }|{ [1]: any, [2]: number }

---Ein Pool benannter Sets, für Scripts, die immer wieder aus denselben Listen ziehen.
---@class MSKSelectorPool
---@field sets table<string, any[]>
local MSKSelectorPool = {}

---Legt das Set name an oder ersetzt es.
---@param name string
---@param entries any[]
---@return any[] entries
function MSKSelectorPool:Add(name, entries) end

---@param name string
---@return boolean removed
function MSKSelectorPool:Remove(name) end

---@param name string
---@return any[]|nil
function MSKSelectorPool:Get(name) end

---Namen aller Sets, alphabetisch sortiert.
---@return string[]
function MSKSelectorPool:Names() end

---Wie Selector.Pick auf dem Set name. Fehler, wenn es das Set nicht gibt.
---@param name string
---@return any value, integer? index
function MSKSelectorPool:Pick(name) end

---@param name string
---@param amount integer
---@param unique? boolean Standard true.
---@return any[]
function MSKSelectorPool:PickMany(name, amount, unique) end

---@param name string
---@return any value, integer? index
function MSKSelectorPool:Weighted(name) end

---@param name string
---@param amount integer
---@param unique? boolean Standard true.
---@return any[]
function MSKSelectorPool:WeightedMany(name, amount, unique) end

--------------------------------------------------------------------------------
-- Settings (nur Client)
--------------------------------------------------------------------------------

---@alias MSKSettingKey
---| "locale" # "" = Serversprache, sonst etwa "de". Wird von MSK.Locale genutzt.
---| "notifyPosition" # "" = automatisch, sonst eine MSKSettingNotifyPosition.
---| "notifySound" # true oder false.

---@alias MSKSettingNotifyPosition
---| ""
---| "top-left"
---| "top"
---| "top-right"
---| "center-left"
---| "center-right"
---| "bottom-left"
---| "bottom"
---| "bottom-right"

---@class MSKSettingsValues
---@field locale string
---@field notifyPosition MSKSettingNotifyPosition
---@field notifySound boolean

--------------------------------------------------------------------------------
-- Skillcheck
--------------------------------------------------------------------------------

---@class MSKSkillcheckRound
---@field areaSize? number Größe des Trefferbereichs in Grad (5 bis 180), Standard 40.
---@field speedMultiplier? number Geschwindigkeit (0.1 bis 10), Standard 1.0.

---@alias MSKSkillcheckPreset
---| "easy" # areaSize 50, speedMultiplier 1.0
---| "medium" # areaSize 40, speedMultiplier 1.5
---| "hard" # areaSize 25, speedMultiplier 1.75

---Eine Stufe, eine eigene Runde oder eine Liste davon für mehrere Runden hintereinander.
---@alias MSKSkillcheckDifficulty MSKSkillcheckPreset|MSKSkillcheckRound|(MSKSkillcheckPreset|MSKSkillcheckRound)[]

--------------------------------------------------------------------------------
-- Timer
--------------------------------------------------------------------------------

---@alias MSKTimerState
---| "idle"
---| "running"
---| "paused"
---| "stopped"
---| "finished"

---@alias MSKTimerUnit
---| "ms"
---| "s"
---| "m"
---| "h"

---Ein Countdown, der pausiert, fortgesetzt, gestoppt und neu gestartet werden kann.
---@class MSKTimerInstance
---@field duration number Gesamtdauer in Millisekunden.
---@field remaining number Restzeit beim letzten Start oder Pausieren.
---@field state MSKTimerState
---@field onEnd? fun(timer: MSKTimerInstance)
local MSKTimerInstance = {}

---Startet mit der vollen Dauer. Tut nichts, solange der Timer läuft.
---@return boolean started
function MSKTimerInstance:Start() end

---@return boolean paused
function MSKTimerInstance:Pause() end

---@return boolean resumed
function MSKTimerInstance:Resume() end

---Stoppt den Timer. Mit runOnEnd läuft onEnd, als wäre die Zeit abgelaufen.
---@param runOnEnd? boolean
---@return boolean stopped
function MSKTimerInstance:Stop(runOnEnd) end

---Startet von vorn, optional mit neuer Dauer.
---@param duration? number
function MSKTimerInstance:Restart(duration) end

---Restzeit in unit. Alles außer Millisekunden ist auf zwei Nachkommastellen gerundet.
---@param unit? MSKTimerUnit Standard "ms".
---@return number
function MSKTimerInstance:GetTimeLeft(unit) end

---@return boolean
function MSKTimerInstance:IsRunning() end

---@return boolean
function MSKTimerInstance:IsPaused() end

---@return boolean
function MSKTimerInstance:IsFinished() end

---@param onEnd? fun(timer: MSKTimerInstance)
function MSKTimerInstance:SetOnEnd(onEnd) end

--------------------------------------------------------------------------------
-- VehicleProperties
--------------------------------------------------------------------------------

---Farbindex oder eigene Farbe als { r, g, b }.
---@alias MSKVehicleColor number|{ [1]: number, [2]: number, [3]: number }|{ r: number, g: number, b: number }

---Optischer Zustand und Schaden eines Fahrzeugs. Die Feldnamen folgen dem
---Format, das ox_lib und QBCore/Qbox in player_vehicles speichern. Beim
---Anwenden werden auch die alten QBCore-Namen modKit17/19/21/47/49 akzeptiert.
---Felder, die nil sind, lässt Set unverändert.
---@class MSKVehicleProperties
---@field model? number
---@field plate? string
---@field plateIndex? number
---@field bodyHealth? number
---@field engineHealth? number
---@field tankHealth? number
---@field fuelLevel? number
---@field oilLevel? number
---@field dirtLevel? number
---@field paintType1? number
---@field paintType2? number
---@field color1? MSKVehicleColor
---@field color2? MSKVehicleColor
---@field pearlescentColor? number
---@field wheelColor? number
---@field interiorColor? number
---@field dashboardColor? number
---@field wheels? number Felgentyp, wird vor den Rad-Mods gesetzt.
---@field wheelWidth? number
---@field wheelSize? number
---@field windowTint? number
---@field neonEnabled? (boolean|number)[] Vier Einträge: links, rechts, vorn, hinten.
---@field neonColor? { [1]: number, [2]: number, [3]: number }
---@field tyreSmokeColor? { [1]: number, [2]: number, [3]: number }
---@field xenonColor? number|{ [1]: number, [2]: number, [3]: number } Index oder eigene Farbe.
---@field modFrontWheels? number
---@field modBackWheels? number
---@field modCustomTiresF? boolean|number
---@field modCustomTiresR? boolean|number
---@field livery? number
---@field roofLivery? number
---@field bulletProofTyres? boolean|number Trotz des Namens roh "Reifen können platzen", wie ox_lib es speichert.
---@field driftTyres? boolean Erst ab Game Build 2372, sonst nil.
---@field extras? table<string, number|boolean> Extra-ID als String: 0 = an, 1 = aus. Ein Boolean bedeutet an/aus.
---@field windows? number[] IDs der zerbrochenen Scheiben.
---@field doors? number[] IDs der abgerissenen Türen.
---@field tyres? table<string, number> Rad-Index als String: 1 = platt, 2 = auf der Felge.
---@field modSpoilers? number
---@field modFrontBumper? number
---@field modRearBumper? number
---@field modSideSkirt? number
---@field modExhaust? number
---@field modFrame? number
---@field modGrille? number
---@field modHood? number
---@field modFender? number
---@field modRightFender? number
---@field modRoof? number
---@field modEngine? number
---@field modBrakes? number
---@field modTransmission? number
---@field modHorns? number
---@field modSuspension? number
---@field modArmor? number
---@field modNitrous? number
---@field modSubwoofer? number
---@field modHydraulics? number
---@field modPlateHolder? number
---@field modVanityPlate? number
---@field modTrimA? number
---@field modOrnaments? number
---@field modDashboard? number
---@field modDial? number
---@field modDoorSpeaker? number
---@field modSeats? number
---@field modSteeringWheel? number
---@field modShifterLeavers? number
---@field modAPlate? number
---@field modSpeakers? number
---@field modTrunk? number
---@field modHydrolic? number
---@field modEngineBlock? number
---@field modAirFilter? number
---@field modStruts? number
---@field modArchCover? number
---@field modAerials? number
---@field modTrimB? number
---@field modTank? number
---@field modWindows? number
---@field modDoorR? number
---@field modLivery? number
---@field modLightbar? number
---@field modTurbo? boolean|number
---@field modSmokeEnabled? boolean|number
---@field modXenon? boolean|number
---@field modKit17? number Alter QBCore-Name für modNitrous, nur beim Anwenden.
---@field modKit19? number Alter QBCore-Name für modSubwoofer, nur beim Anwenden.
---@field modKit21? number Alter QBCore-Name für modHydraulics, nur beim Anwenden.
---@field modKit47? number Alter QBCore-Name für modDoorR, nur beim Anwenden.
---@field modKit49? number Alter QBCore-Name für modLightbar, nur beim Anwenden.

--------------------------------------------------------------------------------
-- Zones (nur Client)
--------------------------------------------------------------------------------

---@alias MSKZoneShape
---| "sphere"
---| "box"
---| "poly"

---Gemeinsame Felder aller Zonenformen. Die übergebene Tabelle wird selbst zur
---Zone, eigene Felder bleiben also erhalten.
---@class MSKZoneBaseData
---@field onEnter? fun(zone: MSKZone) Einmal beim Betreten.
---@field onExit? fun(zone: MSKZone) Einmal beim Verlassen, auch bei Remove, wenn der Spieler drin ist.
---@field inside? fun(zone: MSKZone) Jeden Frame, solange der Spieler drin ist.
---@field onRemove? fun(zone: MSKZone) Nach dem Entfernen.
---@field debug? boolean Zeichnet die Zone.
---@field name? string Taucht in Fehlermeldungen der Callbacks auf.
---@field [any] any

---@class MSKZoneSphereData : MSKZoneBaseData
---@field coords vector3|vector4|table
---@field radius number Muss größer als 0 sein.

---@class MSKZoneBoxData : MSKZoneBaseData
---@field coords vector3|vector4|table Mittelpunkt.
---@field size? vector3|table Standard vec3(2.0, 2.0, 2.0).
---@field rotation? number Drehung in Grad, Standard 0.0.

---@class MSKZonePolyData : MSKZoneBaseData
---@field points (vector3|table)[] Mindestens drei Punkte.
---@field thickness? number Höhe um den Z-Mittelwert der Punkte, Standard 4.0.
---@field minZ? number Überschreibt die aus thickness berechnete Unterkante.
---@field maxZ? number Überschreibt die aus thickness berechnete Oberkante.

---Eine registrierte Zone. Enthält alle übergebenen Felder plus die, die
---MSK.Zones beim Anlegen berechnet.
---@class MSKZone : MSKZoneBaseData
---@field id number Fortlaufende ID, von MSK.Zones vergeben.
---@field shape MSKZoneShape
---@field coords vector3 Mittelpunkt, bei Poly die Mitte der Bounding Box.
---@field radius? number Sphere: Radius. Box: halbe Diagonale.
---@field size? vector3 Nur Box.
---@field rotation? number Nur Box.
---@field corners? vector3[] Nur Box.
---@field points? vector3[] Nur Poly.
---@field thickness? number Nur Poly.
---@field minZ? number Nur Poly.
---@field maxZ? number Nur Poly.
---@field min? vector3 Nur Poly, Bounding Box.
---@field max? vector3 Nur Poly, Bounding Box.
local MSKZone = {}

---True, wenn coords in der Zone liegt.
---@param coords vector3|table
---@return boolean
function MSKZone:Contains(coords) end

---True, solange der Spieler in der Zone ist.
---@return boolean
function MSKZone:IsInside() end

---@param state boolean
function MSKZone:SetDebug(state) end

---Löscht die Zone. Ist der Spieler drin, läuft vorher onExit.
function MSKZone:Remove() end
