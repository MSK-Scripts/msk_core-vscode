---@meta
--- Gemeinsame Datenstrukturen der msk_core Library (FiveM).
--- Quelle: bridge/ und modules/*/ in msk_core 4.1.0

--------------------------------------------------------------------------------
-- Player
--------------------------------------------------------------------------------

---Der lokale Spieler. Auf dem Client hält ein 100ms-Thread die Felder aktuell,
---in Consumer-Resources ist es eine Read-Only-Sicht auf dieselben Werte.
---@class MSKPlayer
---@field clientId number Lokaler Player-Index (PlayerId()).
---@field serverId number Server-ID des Spielers.
---@field playerId number Identisch mit serverId.
---@field ped number Handle des aktuellen Peds (PlayerPedId()).
---@field playerPed number Identisch mit ped.
---@field coords vector3 Aktuelle Position.
---@field heading number Aktuelle Blickrichtung.
---@field state table Statebag des Spielers.
---@field vehicle number|false Fahrzeug-Handle, oder false außerhalb eines Fahrzeugs.
---@field seat number|false Sitzindex (-1 = Fahrer), oder false.
---@field weapon number|false Hash der aktuellen Waffe, oder false.
---@field isDead boolean Berücksichtigt visn_are und osp_ambulance, falls gestartet.
---@field Notify fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@field [number] table Zugriff auf einen anderen Spieler über dessen Server-ID.
---@overload fun(key: string, val: any, update?: boolean): any Liest oder setzt ein eigenes Feld. update propagiert es an den Core.
local MSKPlayer = {}

---Liest einen Wert eines ANDEREN Spielers vom Server (Callback, yielding).
---@param playerId number Server-ID des Zielspielers.
---@param key? string Einzelnes Feld, ohne Angabe die gesamte Tabelle.
---@return any
function MSKPlayer.Get(playerId, key) end

---Ruft cb auf, sobald sich ein Feld ändert, etwa ped, vehicle, seat, weapon,
---isDead oder ein eigenes Feld. Auch als MSK.OnPlayer erreichbar.
---Client: cb(value, oldValue) für den lokalen Spieler.
---Server: cb(playerId, value, oldValue) für jeden Spieler.
---Das Ergebnis an RemoveEventHandler übergeben, um nicht mehr zuzuhören.
---@param key string
---@param cb fun(value: any, oldValue: any)
---@return table eventData
---@overload fun(key: string, cb: fun(playerId: number, value: any, oldValue: any)): table
function MSKPlayer.OnChange(key, cb) end

--------------------------------------------------------------------------------
-- Notify
--------------------------------------------------------------------------------

---Die Typen kommen aus Config.NotifyTypes, eigene Einträge sind möglich.
---@alias MSKNotifyType string
---| "general"
---| "info"
---| "success"
---| "error"
---| "warning"

--------------------------------------------------------------------------------
-- Gemeinsam genutzt
--------------------------------------------------------------------------------

---Animationen für FontAwesome-Icons in Context, Menu und TextUI.
---@alias MSKIconAnimation string
---| "spin"
---| "spinPulse"
---| "spinReverse"
---| "beat"
---| "beatFade"
---| "bounce"
---| "fade"
---| "flip"
---| "shake"

--------------------------------------------------------------------------------
-- Points
--------------------------------------------------------------------------------

---@class MSKPointProperties
---@field coords vector3|vector4|table Mittelpunkt des Points, wird zu vector3.
---@field distance number Radius, ab dem onEnter ausgelöst wird.
---@field onEnter? fun(point: MSKPoint)
---@field onExit? fun(point: MSKPoint) Läuft auch, wenn der Point entfernt wird, während der Spieler drin ist.
---@field onRemove? fun(point: MSKPoint)
---@field nearby? fun(point: MSKPoint) Läuft in jedem Frame, solange der Spieler im Radius ist.
---@field [string] any Eigene Felder bleiben am Point erhalten.

---Ein registrierter Point. Enthält alle übergebenen Properties plus die
---Laufzeitfelder, die der Point-Thread pflegt.
---@class MSKPoint : MSKPointProperties
---@field id number Fortlaufende ID, von Points.Add vergeben.
---@field coords vector3
---@field inside boolean Ob der Spieler gerade im Radius ist.
---@field currentDistance number|nil Distanz zum Spieler, nur während inside.
---@field isClosest boolean Ob dies der nächstgelegene Point ist.
---@field owner string|nil Resource, die den Point über den Export angelegt hat.
---@field Remove fun() Entfernt diesen Point, als point.Remove() und point:Remove().

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgressAnimation
---@field dict? string Animations-Dictionary, wird automatisch geladen.
---@field anim? string Name der Animation innerhalb des Dictionaries.
---@field clip? string Gleichbedeutend mit anim.
---@field blendIn? number Standard 3.0
---@field blendOut? number Standard 1.0
---@field duration? number Standard -1 (läuft bis zum Stopp).
---@field flag? number Standard 49
---@field playbackRate? number Standard 0
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean
---@field scenario? string Alternative zu dict/anim: Szenario statt Animation.
---@field playEnter? boolean Nur bei scenario, Standard true.

---Ein Objekt, das für die Dauer der Progressbar an den Ped gehängt wird.
---@class MSKProgressProp
---@field model string|number
---@field bone? number Standard 60309.
---@field pos? vector3|table Versatz zum Knochen.
---@field rot? vector3|table Rotation zum Knochen.
---@field rotOrder? number Standard 0.

---@class MSKProgressDisable
---@field mouse? boolean Blockiert Mausbewegung.
---@field move? boolean Blockiert Bewegung.
---@field sprint? boolean Blockiert nur Sprinten (greift nicht zusammen mit move).
---@field vehicle? boolean Blockiert Fahrzeugsteuerung.
---@field car? boolean Gleichbedeutend mit vehicle.
---@field combat? boolean Blockiert Angriff und Zielen.

---@class MSKProgressData
---@field duration number Laufzeit in Millisekunden, Standard 1000.
---@field text? string Beschriftung der Leiste.
---@field label? string Gleichbedeutend mit text.
---@field color? string Farbe, sonst Config.ProgressColor.
---@field type? "bar"|"circle" Darstellung bei Progress.Start, Standard Leiste.
---@field position? "middle"|"bottom" Standard bottom bei der Leiste, middle beim Kreis.
---@field canCancel? boolean Abbrechen mit X, in den FiveM-Tastenbelegungen änderbar.
---@field forceOverride? boolean Bricht eine laufende Progressbar ab und startet neu.
---@field useWhileDead? boolean Läuft auch im Tod weiter, Standard false.
---@field useWhileRagdoll? boolean Läuft auch im Ragdoll weiter, Standard false.
---@field useWhileCuffed? boolean Läuft auch in Handschellen weiter, Standard false.
---@field useWhileFalling? boolean Läuft auch im Fallen weiter, Standard false.
---@field useWhileSwimming? boolean Läuft auch im Wasser weiter, Standard false.
---@field allowRagdoll? boolean Gleichbedeutend mit useWhileRagdoll.
---@field allowCuffed? boolean Gleichbedeutend mit useWhileCuffed.
---@field allowFalling? boolean Gleichbedeutend mit useWhileFalling.
---@field allowSwimming? boolean Gleichbedeutend mit useWhileSwimming.
---@field animation? MSKProgressAnimation
---@field anim? MSKProgressAnimation Gleichbedeutend mit animation.
---@field prop? MSKProgressProp|MSKProgressProp[] Ein Objekt oder eine Liste davon.
---@field disable? MSKProgressDisable

--------------------------------------------------------------------------------
-- Context (Maus-Menü mit Drilldown)
--------------------------------------------------------------------------------

---Eine Zeile im Tooltip einer Option.
---@class MSKContextMetadata
---@field label string
---@field value? any Wird als Text angezeigt.
---@field progress? number 0 bis 100.
---@field colorScheme? string

---@class MSKContextOption
---@field id? string Bei einer Options-Map der Schlüssel, wenn nicht gesetzt.
---@field title? string
---@field description? string
---@field icon? string FontAwesome-Klasse.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field image? string
---@field arrow? boolean Wird automatisch true, wenn menu gesetzt ist.
---@field disabled? boolean
---@field readOnly? boolean Eintrag ist sichtbar, aber nicht anwählbar.
---@field progress? number Fortschrittsbalken im Eintrag, 0 bis 100.
---@field colorScheme? string
---@field metadata? (string|MSKContextMetadata)[]|table<string, any> Liste von Texten, Liste von Zeilen oder Map label = value.
---@field menu? string ID des Kontextmenüs, in das gesprungen wird.
---@field args? any Wird an onSelect, event und serverEvent weitergereicht.
---@field onSelect? fun(args: any) Überlebt das Netzwerk nicht.
---@field event? string Client-Event, das beim Auswählen gefeuert wird.
---@field serverEvent? string Server-Event, das beim Auswählen gefeuert wird.

---@class MSKContextData
---@field id? string Pflicht bei Register, bei Show optional (dann inline).
---@field title? string
---@field options MSKContextOption[]|table<string, MSKContextOption> Liste, oder Map nach ID (sortiert nach Schlüssel).
---@field canClose? boolean Standard true.
---@field position? string Standard 'center'. Auch left, right, top, bottom, top-left und so weiter.
---@field menu? string Übergeordnetes Menü, erzeugt den Zurück-Pfeil.
---@field onBack? fun() Läuft beim Sprung zum übergeordneten Menü.
---@field onExit? fun() Läuft beim Schließen durch den Spieler oder Hide(true).

--------------------------------------------------------------------------------
-- Menu (Tastatur, NativeUI-Stil)
--------------------------------------------------------------------------------

---@class MSKMenuValue
---@field label string
---@field description? string

---Läuft, wenn ein Eintrag mit Enter bestätigt wird.
---@alias MSKMenuCallback fun(selected: number, scrollIndex?: number, args?: any, checked?: boolean)

---@class MSKMenuItem
---@field id? string
---@field label? string
---@field description? string
---@field icon? string
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field disabled? boolean Wird beim Navigieren übersprungen.
---@field checked? boolean Macht den Eintrag zur Checkbox, Enter schaltet um und das Menü bleibt offen.
---@field progress? number 0 bis 100.
---@field colorScheme? string
---@field values? (string|MSKMenuValue)[] Macht den Eintrag horizontal scrollbar.
---@field defaultIndex? number Startwert in values, Standard 1.
---@field close? boolean false lässt das Menü nach dem Bestätigen offen.
---@field args? any Wird an die Callbacks weitergereicht.
---@field onSelect? fun(args: any)
---@field event? string Client-Event beim Bestätigen.
---@field serverEvent? string Server-Event beim Bestätigen.

---@class MSKMenuData
---@field id? string Pflicht bei Register, bei Show optional (dann inline).
---@field title? string
---@field position? string Standard 'top-left'.
---@field items MSKMenuItem[]
---@field options? MSKMenuItem[] Gleichbedeutend mit items.
---@field canClose? boolean Standard true. false sperrt Backspace und Escape.
---@field disableInput? boolean Das Menü reagiert nicht auf Tasten.
---@field startIndex? number Eintrag, auf dem die Auswahl startet.
---@field defaultSelected? number Gleichbedeutend mit startIndex.
---@field onSelect? MSKMenuCallback Alternative zum cb-Parameter von Register.
---@field onSelected? fun(selected: number, item: MSKMenuItem, args: any) Auswahl wurde verschoben.
---@field onSideScroll? fun(selected: number, scrollIndex: number, args: any)
---@field onCheck? fun(selected: number, checked: boolean, args: any)
---@field onClose? fun(key: string) key ist 'cancel', 'select', 'replace', 'forced' oder ein eigener Schlüssel aus Hide.

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

---Feldtyp einer Dialogzeile und was er zurückgibt.
---@alias MSKInputFieldType string
---| "input" # string
---| "textarea" # string
---| "number" # number
---| "slider" # number, Standard min 0 und max 100
---| "checkbox" # boolean
---| "select" # Wert der gewählten Option
---| "multi-select" # Liste der Optionswerte
---| "color" # '#rrggbb' oder '#rrggbbaa'
---| "date" # 'YYYY-MM-DD'
---| "date-range" # { 'YYYY-MM-DD', 'YYYY-MM-DD' }
---| "time" # 'HH:MM'

---@class MSKInputOption
---@field value any
---@field label? string Standard tostring(value).

---Eine Zeile in Input.Dialog.
---@class MSKInputDialogRow
---@field type? MSKInputFieldType Standard 'input'.
---@field label? string
---@field id? string Der Wert steht zusätzlich unter dieser ID im Ergebnis.
---@field description? string
---@field placeholder? string
---@field icon? string
---@field required? boolean Bei checkbox muss sie angehakt sein.
---@field disabled? boolean Das Ergebnis ist immer default, egal was der Client meldet.
---@field default? any
---@field min? number|string Zahl bei number und slider, 'YYYY-MM-DD' bei date und date-range.
---@field max? number|string
---@field step? number
---@field maxLength? number Nur input und textarea.
---@field password? boolean Nur input.
---@field options? (MSKInputOption|any)[] Pflicht bei select und multi-select. Ein einfacher Wert ist die Kurzform für { value = ... }.

---@class MSKInputDialogOptions
---@field allowCancel? boolean Standard true.
---@field size? "sm"|"md"|"lg" Standard 'md'.
---@field labels? { confirm?: string, cancel?: string }

--------------------------------------------------------------------------------
-- Numpad
--------------------------------------------------------------------------------

---Warum ein Numpad nicht erfolgreich war.
---@alias MSKNumpadReason string
---| "wrong"
---| "maxAttempts" # Zu viele Fehlversuche.
---| "cancelled"
---| "busy" # Es war schon ein Numpad offen.
---| "invalid" # Nur Server: ungültige Spieler-ID.
---| "error"

---@class MSKNumpadLabels
---@field enter? string Standard 'Enter Code'.
---@field wrong? string Standard 'Incorrect'.
---@field attempts? string Standard 'Attempts left'.

---@class MSKNumpadOptions
---@field code string|number Nur Ziffern. Als String übergeben, damit führende Nullen erhalten bleiben.
---@field masked? boolean Punkte statt Ziffern, Standard true.
---@field maxAttempts? number Standard unbegrenzt.
---@field title? string
---@field labels? MSKNumpadLabels
---@field cb? fun(ok: boolean, reason?: MSKNumpadReason) Nur Client, Alternative zum cb-Parameter.

---@class MSKNumpadInputOptions
---@field length? number Höchstzahl der Ziffern, Standard 4.
---@field minLength? number Standard 1.
---@field masked? boolean Standard false.
---@field title? string
---@field labels? MSKNumpadLabels
---@field cb? fun(digits?: string, reason?: MSKNumpadReason) Nur Client, Alternative zum cb-Parameter.

--------------------------------------------------------------------------------
-- TextUI
--------------------------------------------------------------------------------

---@alias MSKTextUIPosition string
---| "bottom-center"
---| "top-center"
---| "left-center"
---| "right-center"

---@class MSKTextUIData
---@field key? string|false Angezeigte Taste, Standard 'E'. false blendet das Tastenfeld aus.
---@field text? string Unterstützt GTA-Farbcodes wie ~g~.
---@field color? string Farbe des Tastenfelds, sonst Config.TextUIColor.
---@field icon? string FontAwesome-Icon.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field position? MSKTextUIPosition Standard 'bottom-center'.

--------------------------------------------------------------------------------
-- Request
--------------------------------------------------------------------------------

---@alias MSKRaycastFlag string
---| "none"
---| "all"
---| "world"
---| "vehicle"
---| "ped"
---| "object"
---| "water"
---| "glass"
---| "river"
---| "foliage"

--------------------------------------------------------------------------------
-- Scaleform
--------------------------------------------------------------------------------

---@class MSKScaleformRenderTarget
---@field name string Name des Render Targets, etwa 'tvscreen'.
---@field model? string|number Modell, das das Render Target trägt, etwa 'prop_tv_flat_01'.

---@class MSKScaleformOptions
---@field timeout? number Lade-Timeout in ms, Standard 30000.
---@field renderTarget? MSKScaleformRenderTarget Zeichnet auf einen Bildschirm in der Welt statt auf den eigenen.

---Argument für Movie:Call. Ohne Hülle entscheidet der Lua-Typ: Ganzzahl wird
---int, Kommazahl float, boolean bool, string Text. Mit Hülle lässt sich der
---Typ erzwingen.
---@alias MSKScaleformArg integer|number|boolean|string|{ int: number }|{ float: number }|{ texture: string }

---@class MSKScaleformArea
---@field x number Mittelpunkt, 0 bis 1.
---@field y number
---@field width number
---@field height number

---Objekt aus Scaleform.New. Nach Dispose ist es nicht mehr nutzbar, jeder
---Aufruf wirft dann einen Fehler.
---@class MSKScaleformMovie
---@field name string
---@field handle number|nil Nach Dispose nil.
---@field rendering boolean
local MSKScaleformMovie = {}

---Ruft eine Methode des Movies auf.
---@param method string
---@param ... MSKScaleformArg
function MSKScaleformMovie:Call(method, ...) end

---Ruft eine Methode auf und wartet höchstens eine Sekunde auf ihren Rückgabewert.
---@param method string
---@param returnType "int"|"bool"|"string"
---@param ... MSKScaleformArg
---@return integer|boolean|string|nil
function MSKScaleformMovie:CallWithReturn(method, returnType, ...) end

---Zeichnet einen Frame. Ohne Argumente bildschirmfüllend, sonst an x/y mit
---width/height (alles 0 bis 1).
---@param x? number
---@param y? number
---@param width? number
---@param height? number
function MSKScaleformMovie:Draw(x, y, width, height) end

---Zeichnet das Movie in einem eigenen Thread in jedem Frame. Mit duration
---stoppt es danach und gibt sich selbst frei, ohne läuft es bis Stop oder Dispose.
---@param duration? number
---@param area? MSKScaleformArea Ohne Angabe bildschirmfüllend.
function MSKScaleformMovie:Render(duration, area) end

---Beendet Render. Das Movie bleibt geladen und kann wieder gerendert werden.
function MSKScaleformMovie:Stop() end

---Beendet Render und gibt das Movie frei.
function MSKScaleformMovie:Dispose() end

---Zeichnet auf ein benanntes Render Target eines Modells in der Welt.
---Nur ein hier registriertes Render Target wird hier auch wieder freigegeben.
---@param name string
---@param model? string|number
function MSKScaleformMovie:SetRenderTarget(name, model) end

---Löst das Render Target, das Movie zeichnet wieder auf den Bildschirm.
function MSKScaleformMovie:ReleaseRenderTarget() end

---Ob Render gerade zeichnet.
---@return boolean
function MSKScaleformMovie:IsRendering() end

--------------------------------------------------------------------------------
-- Command
--------------------------------------------------------------------------------

---@alias MSKCommandParamType string
---| "number"
---| "string" # Ein Wort, das keine Zahl ist.
---| "longString" # Der Rest der Zeile, muss der letzte Parameter sein.
---| "playerId" # Server-ID oder 'me'.
---| "player" # Wie playerId, liefert aber die Spielerdaten.
---| "any"

---@class MSKCommandParam
---@field name string Schlüssel, unter dem der Wert in args landet.
---@field type? MSKCommandParamType Bestimmt, wie das Argument geparst wird.
---@field help? string
---@field optional? boolean Fehlt das Argument, gibt es keinen Fehler.
---@field action? MSKCommandParamType Veraltet, stattdessen type.
---@field val? boolean Veraltet, stattdessen optional (val = false heißt optional).

---@class MSKCommandHotkey
---@field key string Standardtaste, etwa 'F5'.
---@field text string Beschreibung in den FiveM-Tastenbelegungen.
---@field type? string Eingabegerät, Standard 'keyboard'.

---@class MSKCommandProperties
---@field help? string Beschreibung im Chat-Vorschlag.
---@field params? MSKCommandParam[]
---@field restricted? string|string[]|false ACE-Gruppe(n), die den Befehl nutzen dürfen.
---@field showSuggestion? boolean Standard true.
---@field allowConsole? boolean Nur Server, Standard true.
---@field returnPlayer? boolean Nur Server: übergibt das Spielerobjekt statt der ID.
---@field hotkey? MSKCommandHotkey Nur Client, nicht zusammen mit params.

--------------------------------------------------------------------------------
-- Cron
--------------------------------------------------------------------------------

---Zeitangabe für Cron.Create. Entweder ein Intervall (m, h, d, w, lassen sich
---kombinieren) oder eine Uhrzeit (atH, optional atM und atD).
---@class MSKCronDate
---@field m? number Intervall in Minuten.
---@field h? number Intervall in Stunden.
---@field d? number Intervall in Tagen.
---@field w? number Intervall in Wochen.
---@field atH? number Stunde der Uhrzeit, 0 bis 23.
---@field atM? number Minute der Uhrzeit, 0 bis 59. Ohne Angabe zur vollen Stunde.
---@field atD? number Wochentag, 1 = Sonntag bis 7 = Samstag. Ohne Angabe täglich.

---Zweites Argument an den Callback von Cron.Create.
---@class MSKCronInfo
---@field timestamp number
---@field d number Tag im Monat, bei Uhrzeit-Jobs der Wochentag (1 = Sonntag).
---@field h number
---@field m number

---Zweites Argument an den Callback von Cron.Schedule.
---@class MSKCronTaskInfo
---@field timestamp number
---@field runs number Wie oft der Task schon gelaufen ist, dieser Lauf eingeschlossen.

---@class MSKCronJob
---@field uniqueId number
---@field timestamp? number
---@field date MSKCronDate|number
---@field data any
---@field cb fun(uniqueId: number, data: any, info: MSKCronInfo)
---@field owner? string

--------------------------------------------------------------------------------
-- Check
--------------------------------------------------------------------------------

---@class MSKCheckRepo
---@field author string GitHub-Benutzer oder Organisation.
---@field name string Name des Repositorys, zugleich der erwartete Resource-Name.
---@field checkName? boolean|{ notify?: boolean } Warnt, wenn die Resource umbenannt wurde. notify wiederholt die Warnung alle 5 Sekunden.
---@field print? boolean Meldet auch, wenn die Resource aktuell ist.
---@field download? string Link statt der Release-Seite.

--------------------------------------------------------------------------------
-- Bridge
--------------------------------------------------------------------------------

---@alias MSKFramework string
---| "ESX"
---| "QBCore"
---| "Qbox"
---| "STANDALONE"

---Erkanntes Framework und Inventory. Seit 4.0.0 auch in der Consumer-Resource
---eine echte Tabelle, vorher wurde daraus eine Funktion.
---@class MSKBridge
---@field Framework MSKBridgeFramework
---@field Inventory string Erkanntes Inventory-System.
---@field PlayerData MSKPlayerData Nur Client, wird bei jedem Zugriff neu geholt.
---@field isPlayerLoaded boolean Nur Client: ob der Spieler geladen ist.

---@class MSKBridgeFramework
---@field Type MSKFramework
---@field Events table<string, string> Neutrale Eventnamen.
---@field Core table Nur innerhalb von msk_core, nicht über die Exportgrenze.

---Sucht einen Spieler über genau eines dieser Felder.
---@class MSKPlayerQuery
---@field source? number Server-ID.
---@field identifier? string Lizenz oder Identifier.
---@field citizenid? string Auf QBCore und Qbox identisch mit identifier.
---@field phone? string Nicht auf ESX.
---@field userId? number Nur Qbox.

---Job oder Gang, auf jedem Framework gleich aufgebaut.
---@class MSKPlayerJob
---@field name string
---@field label string
---@field grade number
---@field gradeName string
---@field gradeLabel string
---@field salary number
---@field isBoss boolean
---@field onDuty boolean

---Spielerdaten, auf ESX, QBCore und Qbox identisch. Ohne Methoden, so wie sie
---exports.msk_core:GetPlayerData liefert.
---@class MSKPlayerData
---@field source number|nil Server-ID, nil wenn der Spieler offline ist.
---@field identifier string
---@field license string
---@field name string
---@field firstName string
---@field lastName string
---@field dob string
---@field sex "male"|"female"
---@field phone string|nil Auf ESX nil.
---@field group string
---@field job MSKPlayerJob
---@field jobs table<string, number> Auf Qbox die echte Multijob-Map.
---@field gang MSKPlayerJob|nil Auf ESX nil.
---@field gangs table<string, number>
---@field money table<string, number> cash, bank, black.
---@field metadata table
---@field position vector3|nil

---Spielerobjekt: Daten plus Methoden. Die Methoden entstehen in der eigenen
---Resource, weil Funktionen die Exportgrenze nicht überleben.
---@class MSKPlayerObject : MSKPlayerData
---@field SetJob fun(name: string, grade?: number): boolean
---@field SetGang fun(name: string, grade?: number): boolean Auf ESX immer false.
---@field SetDuty fun(onDuty: boolean): boolean
---@field AddJob fun(name: string, grade?: number): boolean
---@field RemoveJob fun(name: string): boolean
---@field AddGang fun(name: string, grade?: number): boolean
---@field RemoveGang fun(name: string): boolean
---@field HasJob fun(name: string, minGrade?: number): boolean
---@field HasGang fun(name: string, minGrade?: number): boolean
---@field IsBoss fun(): boolean
---@field IsOnDuty fun(): boolean
---@field GetMoney fun(account: string): number
---@field AddMoney fun(account: string, amount: number, reason?: string): boolean
---@field RemoveMoney fun(account: string, amount: number, reason?: string): boolean
---@field SetMoney fun(account: string, amount: number, reason?: string): boolean
---@field GetMeta fun(key: string): any
---@field SetMeta fun(key: string, value: any): boolean
---@field GetInventory fun(): table
---@field GetItem fun(name: string, metadata?: table): table|nil
---@field HasItem fun(name: string, count?: number, metadata?: table): boolean
---@field AddItem fun(name: string, count?: number, metadata?: table, slot?: number): boolean
---@field RemoveItem fun(name: string, count?: number, metadata?: table, slot?: number): boolean
---@field AddWeapon fun(name: string, count?: number, metadata?: table, slot?: number): boolean
---@field RemoveWeapon fun(name: string, count?: number, metadata?: table, slot?: number): boolean
---@field GetWeapon fun(name: string, metadata?: table): table|nil
---@field CanCarryItem fun(name: string, count?: number, metadata?: table): boolean|nil nil heißt, das Inventory kann es nicht prüfen.
---@field CanSwapItem fun(a: string, aCount: number, b: string, bCount: number): boolean|nil
---@field SetMaxWeight fun(kilograms: number): boolean|nil
---@field ClearInventory fun(): boolean|nil
---@field Notify fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@field Kick fun(reason?: string)
---@field Save fun(): boolean
---@field Refresh fun(): boolean
---@field IsOnline fun(): boolean
---@field GetCoords fun(): vector3|nil
---@field SetCoords fun(coords: vector3|table): boolean
---@field GetPed fun(): number|nil

---Eine Job- oder Gang-Definition des Frameworks, nicht ein Spieler.
---@class MSKJobDefinition
---@field name string
---@field label string
---@field grades MSKJobGrade[] Nach grade sortiert.

---@class MSKJobGrade
---@field grade number
---@field name string
---@field label string
---@field salary number
---@field isBoss boolean

--------------------------------------------------------------------------------
-- VehicleStore (nur Server)
--------------------------------------------------------------------------------

---Tabellen- und Spaltennamen des laufenden Frameworks.
---@class MSKVehicleSchema
---@field table string owned_vehicles auf ESX, sonst player_vehicles.
---@field owner string owner auf ESX, citizenid auf QBCore und Qbox.
---@field plate string
---@field props string Spalte mit den Fahrzeugeigenschaften.
---@field model string|nil Spawnname, auf ESX nil (steckt im props-JSON).
---@field hash string|nil Nur QBCore und Qbox.
---@field stored string stored auf ESX, state auf QBCore und Qbox.
---@field garage string
---@field type string
---@field job string
---@field storedIn number Wert, der "in der Garage" bedeutet.
---@field storedOut number

---Ein Fahrzeug aus der Framework-Tabelle, vereinheitlicht.
---@class MSKVehicleRow
---@field plate string
---@field owner string
---@field model string|number Spawnname, auf ESX meist ein Hash.
---@field props table Im Format des laufenden Frameworks, bewusst nicht vereinheitlicht.
---@field stored boolean
---@field garage string|nil
---@field type string|nil
---@field job string|nil
---@field ownerName string|nil Nur aus Browse().
---@field raw table Die unveränderte Datenbankzeile.

---@class MSKVehicleInsert
---@field owner string Pflicht.
---@field plate string Pflicht.
---@field model? string|number Auf QBCore und Qbox Pflicht (Spawnname oder Hash).
---@field props? table
---@field stored? boolean Standard true.
---@field garage? string
---@field type? string
---@field job? string
---@field license? string Nur QBCore und Qbox.

---@class MSKVehicleBrowseOptions
---@field page? number Standard 1.
---@field perPage? number Standard 25, maximal 100.
---@field query? string Sucht in Kennzeichen, Besitzer und Charaktername.
---@field garage? string
---@field type? string
---@field model? string Spawnname.
---@field job? string
---@field owner? string

---@class MSKVehicleBrowseResult
---@field total number
---@field page number
---@field perPage number
---@field vehicles MSKVehicleRow[]
