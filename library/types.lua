---@meta
--- Gemeinsame Datenstrukturen der msk_core Library (FiveM).
--- Quelle: bridge/ und modules/*/ in msk_core 4.0.0

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

--------------------------------------------------------------------------------
-- Notify
--------------------------------------------------------------------------------

---@alias MSKNotifyType string
---| "info"
---| "success"
---| "error"
---| "warning"

--------------------------------------------------------------------------------
-- Points
--------------------------------------------------------------------------------

---@class MSKPointProperties
---@field coords vector3|table Mittelpunkt des Points.
---@field distance number Radius, ab dem onEnter ausgelöst wird.
---@field onEnter? fun(point: MSKPoint)
---@field onExit? fun(point: MSKPoint)
---@field onRemove? fun(point: MSKPoint)

---Ein registrierter Point. Enthält alle übergebenen Properties plus die
---Laufzeitfelder, die der Point-Thread pflegt.
---@class MSKPoint : MSKPointProperties
---@field id number Fortlaufende ID, von Points.Add vergeben.
---@field inside boolean Ob der Spieler gerade im Radius ist.
---@field currentDistance number|nil Distanz zum Spieler, nur während inside.
---@field isClosest boolean Ob dies der nächstgelegene Point ist.
---@field Remove fun() Entfernt diesen Point.

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgressAnimation
---@field dict? string Animations-Dictionary, wird automatisch geladen.
---@field anim? string Name der Animation innerhalb des Dictionaries.
---@field clip? string Clip, der beim Stoppen abgeräumt wird.
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

---@class MSKProgressDisable
---@field mouse? boolean Blockiert Mausbewegung.
---@field move? boolean Blockiert Bewegung.
---@field sprint? boolean Blockiert nur Sprinten (greift nicht zusammen mit move).
---@field vehicle? boolean Blockiert Fahrzeugsteuerung.
---@field combat? boolean Blockiert Angriff und Zielen.

---@class MSKProgressData
---@field duration number Laufzeit in Millisekunden.
---@field text? string Beschriftung der Leiste.
---@field color? string Farbe, sonst Config.ProgressColor.
---@field forceOverride? boolean Bricht eine laufende Progressbar ab und startet neu.
---@field useWhileDead? boolean Erlaubt den Start im Tod, Standard false.
---@field useWhileRagdoll? boolean Erlaubt den Start im Ragdoll, Standard false.
---@field useWhileCuffed? boolean Erlaubt den Start in Handschellen, Standard false.
---@field useWhileFalling? boolean Erlaubt den Start im Fallen, Standard false.
---@field useWhileSwimming? boolean Erlaubt den Start im Wasser, Standard false.
---@field animation? MSKProgressAnimation
---@field disable? MSKProgressDisable

--------------------------------------------------------------------------------
-- Context (Maus-Menü mit Drilldown)
--------------------------------------------------------------------------------

---@class MSKContextOption
---@field id? string
---@field title? string
---@field description? string
---@field icon? string FontAwesome-Klasse.
---@field iconColor? string
---@field image? string
---@field arrow? boolean Wird automatisch true, wenn menu gesetzt ist.
---@field disabled? boolean
---@field readOnly? boolean Eintrag ist sichtbar, aber nicht anwählbar.
---@field progress? number Fortschrittsbalken im Eintrag, 0 bis 100.
---@field colorScheme? string
---@field metadata? table Zusatzinfos, die als Tooltip erscheinen.
---@field menu? string ID des Kontextmenüs, in das gesprungen wird.
---@field args? any Wird an onSelect, event und serverEvent weitergereicht.
---@field onSelect? fun(args: any) Läuft nur bei registrierten Menüs.
---@field event? string Client-Event, das beim Auswählen gefeuert wird.
---@field serverEvent? string Server-Event, das beim Auswählen gefeuert wird.

---@class MSKContextData
---@field id? string Pflicht bei Register, bei Show optional (dann inline).
---@field title? string
---@field options MSKContextOption[]
---@field canClose? boolean Standard true.
---@field position? string Standard 'center'.
---@field menu? string Übergeordnetes Menü, erzeugt den Zurück-Pfeil.
---@field onBack? fun() Läuft beim Sprung zum übergeordneten Menü.
---@field onExit? fun() Läuft beim Schließen, wenn Hide(true) aufgerufen wird.

--------------------------------------------------------------------------------
-- Menu (Tastatur, NativeUI-Stil)
--------------------------------------------------------------------------------

---@class MSKMenuValue
---@field label string
---@field description? string

---@class MSKMenuItem
---@field id? string
---@field label? string
---@field description? string
---@field icon? string
---@field iconColor? string
---@field disabled? boolean
---@field checked? boolean Macht den Eintrag zur Checkbox.
---@field progress? number 0 bis 100.
---@field colorScheme? string
---@field values? (string|MSKMenuValue)[] Macht den Eintrag horizontal scrollbar.
---@field args? any Wird an die Callbacks weitergereicht.
---@field onSelect? fun(args: any)

---@class MSKMenuData
---@field id? string Pflicht bei Register, bei Show optional (dann inline).
---@field title? string
---@field position? string Standard 'top-left'.
---@field items MSKMenuItem[]
---@field onSelected? fun(selected: number, item: MSKMenuItem, args: any)
---@field onSideScroll? fun(selected: number, valueIndex: number, args: any)
---@field onCheck? fun(selected: number, checked: boolean, args: any)

--------------------------------------------------------------------------------
-- Command
--------------------------------------------------------------------------------

---@alias MSKCommandParamType string
---| "number"
---| "string"
---| "playerId"
---| "player"
---| "any"

---@class MSKCommandParam
---@field name string
---@field type? MSKCommandParamType Bestimmt, wie das Argument geparst wird.
---@field help? string

---@class MSKCommandProperties
---@field help? string Beschreibung im Chat-Vorschlag.
---@field params? MSKCommandParam[]
---@field restricted? string|string[]|false ACE-Gruppe(n), die den Befehl nutzen dürfen.
---@field showSuggestion? boolean Standard true.
---@field allowConsole? boolean Nur Server, Standard true.
---@field returnPlayer? boolean Nur Server: übergibt das Spielerobjekt statt der ID.
---@field hotkey? string Nur Client: Taste, auf die der Befehl gelegt wird.

--------------------------------------------------------------------------------
-- Cron
--------------------------------------------------------------------------------

---@class MSKCronDate
---@field min? number Minute, 0 bis 59.
---@field hour? number Stunde, 0 bis 23.
---@field day? number Tag des Monats.
---@field month? number
---@field year? number

---@class MSKCronJob
---@field uniqueId string
---@field timestamp? number
---@field date MSKCronDate
---@field data any
---@field cb fun(data: any)

--------------------------------------------------------------------------------
-- Check
--------------------------------------------------------------------------------

---@class MSKCheckRepo
---@field resource? string Name der Resource, sonst die aufrufende.
---@field repository? string GitHub-Repository im Format user/repo.
---@field checkName? table

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
---@field model? string|number
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
