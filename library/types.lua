---@meta
--- Gemeinsame Datenstrukturen der msk_core Library (FiveM).
--- Quelle: modules/*/ in msk_core 3.3.1

--------------------------------------------------------------------------------
-- Player
--------------------------------------------------------------------------------

---Der lokale Spieler. Auf dem Client haelt ein 100ms-Thread die Felder aktuell,
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
---@field vehicle number|false Fahrzeug-Handle, oder false ausserhalb eines Fahrzeugs.
---@field seat number|false Sitzindex (-1 = Fahrer), oder false.
---@field weapon number|false Hash der aktuellen Waffe, oder false.
---@field isDead boolean Beruecksichtigt visn_are und osp_ambulance, falls gestartet.
---@field Notify fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@field [number] table Zugriff auf einen anderen Spieler ueber dessen Server-ID.
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
---@field distance number Radius, ab dem onEnter ausgeloest wird.
---@field onEnter? fun(point: MSKPoint)
---@field onExit? fun(point: MSKPoint)
---@field onRemove? fun(point: MSKPoint)

---Ein registrierter Point. Enthaelt alle uebergebenen Properties plus die
---Laufzeitfelder, die der Point-Thread pflegt.
---@class MSKPoint : MSKPointProperties
---@field id number Fortlaufende ID, von Points.Add vergeben.
---@field inside boolean Ob der Spieler gerade im Radius ist.
---@field currentDistance number|nil Distanz zum Spieler, nur waehrend inside.
---@field isClosest boolean Ob dies der naechstgelegene Point ist.
---@field Remove fun() Entfernt diesen Point.

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgressAnimation
---@field dict? string Animations-Dictionary, wird automatisch geladen.
---@field anim? string Name der Animation innerhalb des Dictionaries.
---@field clip? string Clip, der beim Stoppen abgeraeumt wird.
---@field blendIn? number Standard 3.0
---@field blendOut? number Standard 1.0
---@field duration? number Standard -1 (laeuft bis zum Stopp).
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
-- Context (Maus-Menue mit Drilldown)
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
---@field readOnly? boolean Eintrag ist sichtbar, aber nicht anwaehlbar.
---@field progress? number Fortschrittsbalken im Eintrag, 0 bis 100.
---@field colorScheme? string
---@field metadata? table Zusatzinfos, die als Tooltip erscheinen.
---@field menu? string ID des Kontextmenues, in das gesprungen wird.
---@field args? any Wird an onSelect, event und serverEvent weitergereicht.
---@field onSelect? fun(args: any) Laeuft nur bei registrierten Menues.
---@field event? string Client-Event, das beim Auswaehlen gefeuert wird.
---@field serverEvent? string Server-Event, das beim Auswaehlen gefeuert wird.

---@class MSKContextData
---@field id? string Pflicht bei Register, bei Show optional (dann inline).
---@field title? string
---@field options MSKContextOption[]
---@field canClose? boolean Standard true.
---@field position? string Standard 'center'.
---@field menu? string Uebergeordnetes Menue, erzeugt den Zurueck-Pfeil.
---@field onBack? fun() Laeuft beim Sprung zum uebergeordneten Menue.
---@field onExit? fun() Laeuft beim Schliessen, wenn Hide(true) aufgerufen wird.

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
---@field restricted? string|string[]|false ACE-Gruppe(n), die den Befehl nutzen duerfen.
---@field showSuggestion? boolean Standard true.
---@field allowConsole? boolean Nur Server, Standard true.
---@field returnPlayer? boolean Nur Server: uebergibt das Framework-Objekt statt der ID.
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
---| "OXCORE"
---| "STANDALONE"

---@class MSKBridge
---@field Framework table Framework-Objekt inklusive Type.
---@field Inventory string Erkanntes Inventory-System.
---@field isPlayerLoaded boolean Nur Client: ob der Spieler geladen ist.

---Sucht einen Spieler ueber genau eines dieser Felder.
---@class MSKPlayerQuery
---@field source? number Server-ID.
---@field identifier? string Lizenz oder Identifier.
---@field citizenid? string Nur QBCore.

---@class MSKPlayerJob
---@field name string
---@field label? string
---@field grade number
---@field grade_name? string
---@field grade_label? string
---@field onDuty? boolean
