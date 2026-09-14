---@meta
--- Globales MSK-Handle der msk_core Library (FiveM).
---
--- Entsteht in der Consumer-Resource durch
---     shared_script '@msk_core/import.lua'
--- in der fxmanifest.lua. Module werden lazy nachgeladen, sobald sie das erste
--- Mal angefasst werden. Optional lässt sich das vorziehen:
---     msk_core 'Callback'
---     msk_core 'Player'
---
--- msk_core setzt Lua 5.4 voraus (lua54 'yes' in der fxmanifest.lua).
--- Stand: msk_core 4.1.0

---@class MSK
---@field name string Name der Resource, die MSK importiert hat.
---@field context "client"|"server" Seite, auf der der Code läuft.
---@field Config table Inhalt der config.lua von msk_core.
---@field Bridge MSKBridge Erkanntes Framework und Inventory.
---@field LoadedPlayers table<number, MSKPlayerData> Nur Server: geladene Spieler, nur innerhalb von msk_core.
---@field Player MSKPlayer Lokaler Spieler. Auf dem Server die gespiegelte Tabelle, indiziert per Server-ID.
---@field Math MSKMath
---@field String MSKString
---@field Table MSKTable
---@field Vector MSKVector
---@field Timeout MSKTimeout
---@field Callback MSKCallback
---@field Context MSKContext
---@field Menu MSKMenu
---@field Input MSKInput
---@field Numpad MSKNumpad
---@field Progress MSKProgress
---@field TextUI MSKTextUI
---@field Coords MSKCoords
---@field Points MSKPoints Nur Client.
---@field Request MSKRequest Nur Client.
---@field Scaleform MSKScaleform
---@field Cron MSKCron Nur Server.
---@field Check MSKCheck Nur Server.
---@field Society MSKSociety Nur Server.
---@field Offline MSKOffline Nur Server.
---@field VehicleStore MSKVehicleStore Nur Server.
---@overload fun(name: string): any Lädt ein Modul per Name, gleichwertig zu MSK.<Name>.
MSK = {}

--------------------------------------------------------------------------------
-- Basis
--------------------------------------------------------------------------------

---Gibt eine Meldung mit dem Präfix der aufrufenden Resource aus.
---@param code string Typ aus Config.LoggingTypes, etwa "info", "error", "warn", "debug".
---@param ... any
function MSK.Logging(code, ...) end

---Kleingeschriebener Alias von MSK.Logging.
---@param code string
---@param ... any
function MSK.logging(code, ...) end

---Führt fn in einem pcall aus und wartet höchstens timeout ms auf ein Ergebnis.
---Gedacht für Exports fremder Resources, die beim Start noch nicht bereit sind.
---Liefert nil, wenn in der Zeit nichts kommt, und wirft keinen Fehler.
---@param fn fun(): any
---@param timeout? number Standard 1000 ms.
---@return any
function MSK.Call(fn, timeout) end

---Liefert die Config-Tabelle von msk_core.
---@return table
function MSK.GetConfig() end

--------------------------------------------------------------------------------
-- Callback (flach, aus dem Callback-Modul)
--------------------------------------------------------------------------------

---Registriert einen Callback. Gleichwertig zu MSK.Callback.Register.
---Der Callback gehört der aufrufenden Resource: eine andere Resource kann ihn
---nicht überschreiben, und er verschwindet, sobald die Resource stoppt.
---Auf dem Server bekommt cb als ersten Parameter die Server-ID des Aufrufers.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered false, wenn der Name schon einer anderen Resource gehört.
function MSK.Register(eventName, cb) end

---Ruft einen Callback der Gegenseite auf und wartet auf das Ergebnis.
---Läuft nach msk:callbackTimeout (Standard 5000 ms) ab und liefert dann nil.
---Client: Trigger(eventName, ...). Server: Trigger(eventName, playerId, ...).
---Muss aus einem Thread heraus aufgerufen werden.
---@param eventName string
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, ...: any): ...
function MSK.Trigger(eventName, ...) end

---Wie Trigger, aber der Server-Callback bekommt statt eines Rückgabewerts eine
---cb-Funktion, die er aufruft. Blockiert trotzdem bis zur Antwort. Nur Client.
---@param eventName string
---@param ... any
---@return any ...
function MSK.TriggerCallback(eventName, ...) end

---Wie Trigger, mit eigenem Zeitlimit in ms. nil oder false wartet ohne Limit.
---Gedacht für Callbacks, die auf den Spieler warten (Dialoge, Skillchecks) oder
---länger als msk:callbackTimeout brauchen. Auf dem Server endet das Warten
---auch, sobald der Spieler den Server verlässt.
---Client: TriggerAwait(eventName, timeout, ...).
---Server: TriggerAwait(eventName, playerId, timeout, ...).
---@param eventName string
---@param timeout? number|false
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, timeout?: number|false, ...: any): ...
function MSK.TriggerAwait(eventName, timeout, ...) end

---Backwards-Compat-Alias von MSK.Register. Nur Server.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered
function MSK.RegisterCallback(eventName, cb) end

---Backwards-Compat-Alias von MSK.Register. Nur Server.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered
function MSK.RegisterServerCallback(eventName, cb) end

--------------------------------------------------------------------------------
-- Spieler und Framework (Bridge)
--------------------------------------------------------------------------------

---Liefert das Spielerobjekt: vereinheitlichte Daten plus Methoden. Nur Server.
---Nimmt eine Server-ID, einen Identifier oder eine Query-Tabelle.
---@param data MSKPlayerQuery|number|string
---@return MSKPlayerObject|nil
function MSK.GetPlayer(data) end

---@param playerId number
---@return MSKPlayerObject|nil
function MSK.GetPlayerFromId(playerId) end

---@param identifier string
---@return MSKPlayerObject|nil
function MSK.GetPlayerFromIdentifier(identifier) end

---Auf QBCore und Qbox ist die citizenid der Identifier.
---@param citizenid string
---@return MSKPlayerObject|nil
function MSK.GetPlayerByCitizenId(citizenid) end

---Auf ESX immer nil, dort hängt keine Telefonnummer am Spieler.
---@param phone string
---@return MSKPlayerObject|nil
function MSK.GetPlayerByPhone(phone) end

---Nur Qbox, auf jedem anderen Framework nil.
---@param userId number
---@return MSKPlayerObject|nil
function MSK.GetPlayerByUserId(userId) end

---Ruft cb auf, sobald sich ein Feld des Spielers ändert, etwa ped, vehicle,
---seat, weapon, isDead oder ein eigenes Feld. Alias von MSK.Player.OnChange.
---Client: cb(value, oldValue) für den lokalen Spieler.
---Server: cb(playerId, value, oldValue) für jeden gespiegelten Spieler.
---Liefert den Event-Handler, mit RemoveEventHandler lässt er sich wieder lösen.
---@param key string
---@param cb fun(value: any, oldValue: any)
---@return table eventData
---@overload fun(key: string, cb: fun(playerId: number, value: any, oldValue: any)): table
function MSK.OnPlayer(key, cb) end

---Auf dem Client ohne Parameter, dort der eigene Job.
---@param player? table|MSKPlayerQuery|number|string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJob(player) end

---Auf ESX immer nil, dort gibt es keine Gangs.
---@param player? table|MSKPlayerQuery|number|string
---@return MSKPlayerJob|nil
function MSK.GetPlayerGang(player) end

---Alle Jobs des Spielers als name -> grade. Auf Qbox die echte Multijob-Map.
---@param player? table|MSKPlayerQuery|number|string
---@return table<string, number>
function MSK.GetPlayerJobs(player) end

---@param playerId number
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobFromId(playerId) end

---@param identifier string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobFromIdentifier(identifier) end

---@param citizenid string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobByCitizenId(citizenid) end

---Alle Job-Definitionen des Frameworks, keine Spieler. Client und Server.
---Auf dem Client ein Callback-Roundtrip, also nur aus einem Thread heraus.
---@return table<string, MSKJobDefinition>
function MSK.GetJobs() end

---Wie GetJobs, für Gangs. Auf ESX leer.
---@return table<string, MSKJobDefinition>
function MSK.GetGangs() end

---Liefert alle geladenen Spieler als Daten ohne Methoden, optional gefiltert.
---Nur Server.
---@param key? "job"|"gang"|"group"
---@param val? any Wert, auf den gefiltert wird.
---@return MSKPlayerData[]
function MSK.GetPlayers(key, val) end

---Vereinheitlichte Daten des lokalen Spielers, nil solange kein Charakter
---geladen ist. Nur Client.
---@return MSKPlayerData|nil
function MSK.GetPlayerData() end

---Nur Client.
---@return boolean
function MSK.IsPlayerLoaded() end

---Berücksichtigt visn_are und osp_ambulance, falls gestartet. Nur Client.
---@return boolean
function MSK.IsPlayerDead() end

---Liefert den gespiegelten Spielerdatensatz aus dem Core. Nur Server.
---@param id number
---@return table|nil
function MSK.GetMirroredPlayer(id) end

---@param id number|string|MSKPlayerQuery
---@return string|nil
function MSK.GetPlayerIdentifier(id) end

---@param id number|string|MSKPlayerQuery
---@return number|nil
function MSK.GetPlayerServerId(id) end

--------------------------------------------------------------------------------
-- Inventory
--------------------------------------------------------------------------------

---Prüft, ob der Spieler einen Gegenstand besitzt. Läuft über die
---konfigurierte Inventory-Bridge. Auf dem Server ist der erste Parameter die
---Server-ID. Steht an dritter Stelle eine Tabelle, wird sie als metadata
---gelesen und count übersprungen.
---@param itemName string
---@param count? number Mindestmenge, Standard 1.
---@param metadata? table Nur bei Inventories mit Metadaten.
---@return table|false
---@overload fun(playerId: number, itemName: string|string[], count?: number, metadata?: table): table|false
function MSK.HasItem(itemName, count, metadata) end

---Nimmt dieselben ID-Formen wie MSK.GetPlayer. Nur Server.
---@param id number|string|MSKPlayerQuery
---@param itemName string|string[]
---@param count? number Mindestmenge, Standard 1.
---@param metadata? table Nur bei Inventories mit Metadaten.
---@return table|false
function MSK.HasPlayerItem(id, itemName, count, metadata) end

--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

---Registriert einen Chat-Befehl inklusive Vorschlag und Rechteprüfung.
---commandName darf auch eine Liste von Namen sein, jeder bekommt eine eigene
---Kopie der properties.
---Client: RegisterCommand(name, cb, restricted, properties).
---Server: RegisterCommand(name, cb, properties), restricted steht dort in properties.
---Parameter vom Typ "longString" nehmen den Rest der Zeile auf und müssen
---deshalb der letzte Parameter sein.
---@param commandName string|string[]
---@param callback fun(source: number, args: table, raw: string)
---@param restricted? string|string[]|false
---@param properties? MSKCommandProperties
---@return table|nil command
---@overload fun(commandName: string|string[], callback: fun(source: number|MSKPlayerObject, args: table, raw: string), properties?: MSKCommandProperties): table|nil
function MSK.RegisterCommand(commandName, callback, restricted, properties) end

--------------------------------------------------------------------------------
-- ACE
--------------------------------------------------------------------------------

---Prüft ein ACE-Recht, "command." wird bei Bedarf vorangestellt.
---Client ohne, Server mit Spieler-ID. Auf dem Client ein Callback-Roundtrip.
---@param command string
---@return boolean
---@overload fun(playerId: number, command: string): boolean
function MSK.IsAceAllowed(command) end

---Prüft, ob ein Principal ein ACE-Recht hat. Eine Zahl gilt als Server-ID,
---ein Text ohne Präfix als Gruppe oder, mit Doppelpunkt, als Identifier.
---Auf dem Client beantwortet der Server nur Gruppen und die eigenen Principals
---(eigene Server-ID, eigene Identifier). Für andere Spieler kommt immer false.
---@param principal string|number
---@param ace string
---@return boolean
function MSK.IsPrincipalAceAllowed(principal, ace) end

---Nur Server.
---@param principal string|number Gruppe, Identifier oder Server-ID.
---@param ace string
---@param allow? boolean Standard true.
function MSK.AddAce(principal, ace, allow) end

---Nur Server.
---@param principal string|number
---@param ace string
---@param allow? boolean
function MSK.RemoveAce(principal, ace, allow) end

---Ob msk_core ACEs setzen darf (add_ace resource.msk_core command.add_ace allow).
---Nur Server.
---@return boolean
function MSK.CanAddAce() end

---Setzt ein ACE ohne Normalisierung des Principals und ohne "command."-Präfix.
---Läuft immer über msk_core. Nur Server.
---@param principal string
---@param ace string
---@param allow? boolean
---@return boolean ok false, wenn msk_core keine ACEs setzen darf.
function MSK.AddRawAce(principal, ace, allow) end

---Nur Server.
---@param principal string
---@param ace string
---@param allow? boolean
---@return boolean ok
function MSK.RemoveRawAce(principal, ace, allow) end

---Nur Server.
---@param child string|number Principal oder Server-ID.
---@param parent string
function MSK.AddPrincipal(child, parent) end

---Nur Server.
---@param child string|number
---@param parent string
function MSK.RemovePrincipal(child, parent) end

--------------------------------------------------------------------------------
-- Ban (nur Server)
--------------------------------------------------------------------------------

---@param playerId number
---@return table|false
function MSK.IsPlayerBanned(playerId) end

---Sperrt einen Spieler. Die Zeitangabe kennt die Suffixe M, H, D und W,
---etwa "30M", "12H", "7D", "2W". Ohne Suffix gilt der Bann als permanent.
---@param playerId? number Ausführender Spieler. 0 steht für die Konsole, nil für das System.
---@param targetId number Zu sperrender Spieler.
---@param time string|number
---@param reason? string
function MSK.BanPlayer(playerId, targetId, time, reason) end

---@param playerId? number Ausführender Spieler. 0 steht für die Konsole, nil für das System.
---@param banId number ID des Bann-Eintrags.
function MSK.UnbanPlayer(playerId, banId) end

--------------------------------------------------------------------------------
-- Notifications
--------------------------------------------------------------------------------

---Zeigt eine Benachrichtigung. Eine sichtbare Benachrichtigung mit derselben
---id wird aktualisiert statt gestapelt.
---Client: Notification(data). Server: Notification(playerId, data), -1 für alle.
---Die Form (title, message, type, duration) funktioniert noch, ist aber
---veraltet, stattdessen eine Tabelle übergeben.
---@param data MSKNotifyData
---@overload fun(playerId: number, data: MSKNotifyData)
---@overload fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@overload fun(playerId: number, title: string, message: string, typ?: MSKNotifyType, duration?: number)
function MSK.Notification(data) end

---Alias von MSK.Notification.
---@param data MSKNotifyData
---@overload fun(playerId: number, data: MSKNotifyData)
---@overload fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@overload fun(playerId: number, title: string, message: string, typ?: MSKNotifyType, duration?: number)
function MSK.Notify(data) end

---Zeigt einen Hinweistext. Je nach Config nativ oben links oder als TextUI.
---@param text string
---@param key? string Taste in der TextUI, nur Client.
---@overload fun(playerId: number, text: string)
function MSK.HelpNotification(text, key) end

---Alias von MSK.HelpNotification.
---@param text string
---@param key? string
---@overload fun(playerId: number, text: string)
function MSK.HelpNotify(text, key) end

---Zeigt eine Benachrichtigung mit Bild im GTA-Stil.
---@param text string
---@param title string
---@param subtitle string
---@param icon? string Standard "CHAR_HUMANDEFAULT".
---@param flash? boolean Standard true, false schaltet das Blinken ab.
---@param icontype? number Standard 1.
---@overload fun(playerId: number, text: string, title: string, subtitle: string, icon?: string, flash?: boolean, icontype?: number)
function MSK.AdvancedNotification(text, title, subtitle, icon, flash, icontype) end

---Alias von MSK.AdvancedNotification.
---@param text string
---@param title string
---@param subtitle string
---@param icon? string
---@param flash? boolean
---@param icontype? number
---@overload fun(playerId: number, text: string, title: string, subtitle: string, icon?: string, flash?: boolean, icontype?: number)
function MSK.AdvancedNotify(text, title, subtitle, icon, flash, icontype) end

---Zeigt einen Untertitel am unteren Bildrand.
---@param text string
---@param duration? number Standard 8000 ms.
---@overload fun(playerId: number, message: string, duration?: number)
function MSK.Subtitle(text, duration) end

---Zeigt den Ladekreis unten rechts.
---@param text string
---@param typ? number Standard 4 (orange), 5 ist weiß.
---@param duration? number Standard 5000 ms.
---@overload fun(playerId: number, text: string, typ?: number, duration?: number)
function MSK.Spinner(text, typ, duration) end

---Zeichnet Text an Weltkoordinaten. Muss pro Frame laufen.
---@param coords vector3|table
---@param text string
---@param size? number
---@param font? number
---@overload fun(playerId: number, coords: vector3|table, text: string, size?: number, font?: number)
function MSK.Draw3DText(coords, text, size, font) end

---Zeichnet Text auf dem Bildschirm. Muss pro Frame laufen.
---@param text string
---@param outline? boolean
---@param font? number
---@param size? number
---@param color? table
---@param position? table
---@overload fun(playerId: number, text: string, outline?: boolean, font?: number, size?: number, color?: table, position?: table)
function MSK.DrawGenericText(text, outline, font, size, color, position) end

--------------------------------------------------------------------------------
-- Entities und Fahrzeuge
--------------------------------------------------------------------------------

---Nächster Spieler oder nächstes Fahrzeug. Mit maxDistance zählen nur
---Entities in dieser Reichweite. Ohne Treffer kommt -1, -1.
---Client: GetClosestEntity(isPlayerEntity, coords, maxDistance).
---Server: GetClosestEntity(isPlayerEntity, coords, entities, maxDistance). Dort
---ist isPlayerEntity false für Fahrzeuge oder die Server-ID, um die gesucht
---wird. Dieser Spieler dient ohne coords als Ursprung und wird nie selbst geliefert.
---@param isPlayerEntity? boolean
---@param coords? vector3 Standard die eigene Position.
---@param maxDistance? number
---@return number entity, number distance
---@overload fun(isPlayerEntity: number|false, coords?: vector3, entities?: table, maxDistance?: number): number, number
function MSK.GetClosestEntity(isPlayerEntity, coords, maxDistance) end

---Alle Spieler oder Fahrzeuge in der Reichweite. Ohne distance zählt jede Entity.
---@param isPlayerEntity? boolean
---@param coords? vector3
---@param distance? number
---@return table entities
---@overload fun(isPlayerEntity: number|false, coords?: vector3, distance?: number, entities?: table): table
function MSK.GetClosestEntities(isPlayerEntity, coords, distance) end

---Nächstes Fahrzeug, -1, -1 ohne Treffer.
---Client: GetClosestVehicle(coords, maxDistance).
---Server: GetClosestVehicle(coords, vehicles, maxDistance), coords sind dort Pflicht.
---@param coords? vector3 Standard die eigene Position.
---@param maxDistance? number Nur Fahrzeuge in dieser Reichweite zählen.
---@return number vehicle, number distance
---@overload fun(coords: vector3, vehicles?: number[], maxDistance?: number): number, number
function MSK.GetClosestVehicle(coords, maxDistance) end

---@param coords? vector3
---@param distance? number Ohne Angabe zählt jedes Fahrzeug.
---@return table
---@overload fun(coords: vector3, distance?: number, vehicles?: table): table
function MSK.GetClosestVehicles(coords, distance) end

---Peds in der Reichweite, das nächste zuerst. Spieler-Peds nur mit
---includePlayers, der eigene Ped nie. Nur Client.
---@param coords? vector3 Standard die eigene Position.
---@param maxDistance? number Standard 2.0
---@param includePlayers? boolean
---@return MSKNearbyEntity[]
function MSK.GetNearbyPeds(coords, maxDistance, includePlayers) end

---Objekte in der Reichweite, das nächste zuerst. Nur Client.
---@param coords? vector3
---@param maxDistance? number Standard 2.0
---@return MSKNearbyEntity[]
function MSK.GetNearbyObjects(coords, maxDistance) end

---Fahrzeuge in der Reichweite, das nächste zuerst. Das eigene Fahrzeug nur mit
---includeOwn. Nur Client.
---@param coords? vector3
---@param maxDistance? number Standard 2.0
---@param includeOwn? boolean
---@return MSKNearbyEntity[]
function MSK.GetNearbyVehicles(coords, maxDistance, includeOwn) end

---Andere Spieler in der Reichweite, der nächste zuerst. Der eigene Spieler nur
---mit includeSelf. Nur Client.
---@param coords? vector3
---@param maxDistance? number Standard 2.0
---@param includeSelf? boolean
---@return MSKNearbyPlayer[]
function MSK.GetNearbyPlayers(coords, maxDistance, includeSelf) end

---Nächster Ped in der Reichweite samt Position, nil ohne Treffer. Nur Client.
---@param coords? vector3
---@param maxDistance? number Standard 2.0
---@param includePlayers? boolean
---@return number|nil ped, vector3|nil coords
function MSK.GetClosestPed(coords, maxDistance, includePlayers) end

---Nächstes Objekt in der Reichweite samt Position, nil ohne Treffer. Nur Client.
---@param coords? vector3
---@param maxDistance? number Standard 2.0
---@return number|nil object, vector3|nil coords
function MSK.GetClosestObject(coords, maxDistance) end

---Fahrzeug mit diesem Kennzeichen in der Nähe, false ohne Treffer. Nur Client.
---Groß- und Kleinschreibung und Leerzeichen am Rand spielen keine Rolle.
---@param plate string
---@param coords? vector3
---@param distance? number
---@return number|false
function MSK.GetVehicleWithPlate(plate, coords, distance) end

---Fahrzeug mit diesem Kennzeichen in der Nähe von coords, false ohne Treffer.
---Ohne coords wird jedes Fahrzeug durchsucht. Nur Server.
---@param plate string
---@param coords? vector3
---@param distance? number
---@param vehicles? table
---@return number|false
function MSK.GetClosestVehicleWithPlate(plate, coords, distance, vehicles) end

---Sucht das Fahrzeug mit diesem Kennzeichen ohne Radius. Die Suche läuft immer
---auf dem Server, auf dem Client ist es ein Callback-Roundtrip (blockierend).
---Auf dem Client ist vehicle false, wenn das Fahrzeug existiert, aber hier
---nicht gestreamt ist. netId ist dann trotzdem gesetzt.
---@param plate string
---@return number|false vehicle, number|nil netId
function MSK.GetVehicleFromPlate(plate) end

---Liest das Modell aus der Fahrzeugtabelle des Frameworks, funktioniert also
---auch für eingeparkte Fahrzeuge. Blockierend, auf dem Client ein Callback.
---@param plate string
---@return number|nil model Hash, nil ohne Treffer oder auf STANDALONE.
---@return string|nil name Spawnname, nur wenn das Framework ihn speichert.
function MSK.GetModelFromPlate(plate) end

---Fahrzeug vor dem Spieler. Nur Client.
---@param distance? number Standard 5.0
---@return number|false vehicle, vector3|nil coords, string|nil distance
function MSK.GetVehicleInDirection(distance) end

---Alias von MSK.GetVehicleInDirection. Nur Client.
---@param distance? number
---@return number|false vehicle, vector3|nil coords, string|nil distance
function MSK.GetVehicleInFront(distance) end

---Sitzindex des Peds im Fahrzeug (-1 ist der Fahrer), false wenn er nicht
---darin sitzt. Auf dem Server seit 4.1.0 ebenfalls false statt -1.
---Client: ohne Parameter der eigene Ped und das eigene Fahrzeug.
---Server: ped ist Pflicht, ohne vehicle das Fahrzeug, in dem er sitzt.
---@param ped? number
---@param vehicle? number
---@return number|false seat
function MSK.GetPedVehicleSeat(ped, vehicle) end

---Nur Client.
---@param vehicle number
---@return boolean
function MSK.IsVehicleEmpty(vehicle) end

---Anzeigename des Fahrzeugs. Nur Client.
---@param vehicle? number
---@param model? string|number
---@return string
function MSK.GetVehicleLabel(vehicle, model) end

---Nur Client.
---@param model string|number
---@return string
function MSK.GetVehicleLabelFromModel(model) end

---Schließt alle Türen. Nur Client.
---@param vehicle number
function MSK.CloseVehicleDoors(vehicle) end

---Erzeugt ein vernetztes Fahrzeug auf dem Server und wartet, bis es existiert.
---Ohne options.type fragt msk_core einmal pro Modell einen Client nach dem
---Fahrzeugtyp. Anhänger lassen sich so nicht erkennen, dafür type = "trailer"
---setzen. Blockierend. Nur Server.
---@param model string|number
---@param coords vector3|vector4|table
---@param options? MSKSpawnVehicleOptions
---@return number|nil vehicle, number|nil netId nil, wenn das Fahrzeug nicht erstellt werden konnte.
function MSK.SpawnVehicle(model, coords, options) end

--------------------------------------------------------------------------------
-- World
--------------------------------------------------------------------------------

---Prüft, ob in der Reichweite kein Fahrzeug steht.
---@param coords? vector3 Auf dem Client Standard die eigene Position, auf dem Server Pflicht.
---@param maxDistance? number Standard 5.0
---@return boolean
function MSK.IsSpawnPointClear(coords, maxDistance) end

---Erzeugt ein Mugshot-Bild des Peds. Wird es nicht rechtzeitig fertig, kommt
---nil. Nur Client.
---@param ped number
---@param transparent? boolean
---@param timeout? number Standard 5000 ms.
---@return number|nil handle, string|nil textureDict
function MSK.GetPedMugshot(ped, transparent, timeout) end

---Nächster Spieler, -1, -1 ohne Treffer.
---Client: GetClosestPlayer(coords, maxDistance), liefert den Player-Index.
---Server: GetClosestPlayer(playerId, coords, maxDistance). Um playerId wird
---gesucht, er selbst wird nie geliefert. Ohne playerId sind coords Pflicht.
---@param coords? vector3 Standard die eigene Position.
---@param maxDistance? number Nur Spieler in dieser Reichweite zählen.
---@return number player, number distance
---@overload fun(playerId?: number, coords?: vector3, maxDistance?: number): string|number, number
function MSK.GetClosestPlayer(coords, maxDistance) end

---@param coords? vector3
---@param distance? number
---@return table
---@overload fun(playerId?: number, coords?: vector3, distance?: number): table
function MSK.GetClosestPlayers(coords, distance) end

---Sendet eine Nachricht an einen Discord-Webhook. Ohne gültige https-URL wird
---nichts gesendet und false geliefert. Nur Server.
---@param webhook string
---@param botColor? number|string
---@param botName? string
---@param botAvatar? string
---@param title? string
---@param description? string
---@param fields? table
---@param footer? { text: string, link?: string }
---@param time? string os.date-Format, wird an den Footer angehängt.
---@return false|nil
function MSK.AddWebhook(webhook, botColor, botName, botAvatar, title, description, fields, footer, time) end

--------------------------------------------------------------------------------
-- Cron (nur Server)
--------------------------------------------------------------------------------

---Alias von MSK.Cron.Create.
---@param date MSKCronDate|number Intervall, Uhrzeit oder Unix-Zeitstempel.
---@param data any
---@param cb fun(uniqueId: number, data: any, info: MSKCronInfo)
---@return number|nil uniqueId ID für MSK.DeleteCron, nil bei ungültigen Argumenten.
function MSK.CreateCron(date, data, cb) end

---Alias von MSK.Cron.Delete.
---@param id string
---@return boolean
function MSK.DeleteCron(id) end

--------------------------------------------------------------------------------
-- Flache Aliase auf Context und Menu
--------------------------------------------------------------------------------

---@param id string
---@param data MSKContextData
function MSK.RegisterContext(id, data) end

---@param idOrData string|MSKContextData
---@overload fun(playerId: number, idOrData: string|MSKContextData)
function MSK.ShowContext(idOrData) end

---@param contextId string
---@param dataId string
---@param updatedData MSKContextOption
function MSK.UpdateContext(contextId, dataId, updatedData) end

---@param fireExit? boolean
---@overload fun(playerId: number)
function MSK.HideContext(fireExit) end

---@return string|nil
function MSK.GetOpenContext() end

---@param id string
---@param data MSKMenuData
---@param cb? fun(selected: number, scrollIndex?: number, args?: any, checked?: boolean)
function MSK.RegisterMenu(id, data, cb) end

---@param idOrData string|MSKMenuData
---@param startIndex? number Eintrag, auf dem die Auswahl startet.
---@overload fun(playerId: number, idOrData: string|MSKMenuData, startIndex?: number)
function MSK.ShowMenu(idOrData, startIndex) end

---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function MSK.UpdateMenu(menuId, dataId, updatedData) end

---Ersetzt alle Einträge oder mit index nur diesen einen. Ein offenes Menü
---aktualisiert sich sofort. Nur Client.
---@param menuId string
---@param options MSKMenuItem[]|MSKMenuItem
---@param index? number
function MSK.SetMenuOptions(menuId, options, index) end

---Schließt das offene Menü. key geht an onClose, false schließt ohne onClose.
---@param key? string|false
---@overload fun(playerId: number)
function MSK.HideMenu(key) end

---@return string|nil
function MSK.GetOpenMenu() end

--------------------------------------------------------------------------------
-- Backwards-Compat-Aliase aus aliases.lua
--------------------------------------------------------------------------------

---Alias von MSK.Timeout.Set.
---@param ms number
---@param cb fun(data: any)
---@param data? any
---@return number requestId
function MSK.AddTimeout(ms, cb, data) end

---Alias von MSK.Timeout.Clear.
---@param requestId number
function MSK.DelTimeout(requestId) end

---Alias von MSK.Table.Contains.
---@param tbl table
---@param val any
---@return boolean
function MSK.Table_Contains(tbl, val) end

---Alias von MSK.Table.Dump.
---@param tbl table
---@return string
function MSK.DumpTable(tbl) end

---Achtung: MSK.Trim nutzt die invertierte Bool-Semantik aus v2
---(String.TrimLegacy), während exports.msk_core:Trim auf String.Trim zeigt.
---@param str string
---@param bool? boolean
---@return string
function MSK.Trim(str, bool) end

---Alias von MSK.Request.AnimDict. Nur Client.
---@param animDict string
---@param timeout? number Standard 30000 ms.
---@return string
function MSK.LoadAnimDict(animDict, timeout) end

---Alias von MSK.Request.Model. Nur Client.
---@param model string|number
---@param timeout? number Standard 30000 ms.
---@return number hash
function MSK.LoadModel(model, timeout) end

---Alias von MSK.Coords.Active.
---@return boolean
---@overload fun(playerId: number): boolean
function MSK.DoesShowCoords() end

--------------------------------------------------------------------------------
-- Export-Proxies
-- Jeder Name, der weder Modul noch Alias ist, wird von import.lua automatisch
-- auf exports.msk_core:<Name> weitergeleitet. Die gebräuchlichsten davon:
--------------------------------------------------------------------------------

---Zufällige Ziffernfolge.
---@param length number
---@return string
function MSK.GetRandomNumber(length) end

---@param num number
---@param decimal? number
---@return number
function MSK.Round(num, decimal) end

---@param int number
---@param tag? string
---@return string
function MSK.Comma(int, tag) end

---@param length number
---@return string
function MSK.GetRandomString(length) end

---@param str string
---@param startStr string
---@return boolean
function MSK.StartsWith(str, startStr) end

---@param str string
---@param delimiter string
---@return string[]
function MSK.Split(str, delimiter) end

---@param tbl table
---@param val any
---@return boolean
function MSK.TableContains(tbl, val) end

---@param tbl table
---@return string
function MSK.TableDump(tbl) end

---@param tbl table
---@param n? number
---@return string
function MSK.TableDumpString(tbl, n) end

---@param tbl table
---@return number
function MSK.TableSize(tbl) end

---@param tbl table
---@param val any
---@return number
function MSK.TableIndex(tbl, val) end

---@param tbl table
---@param val any
---@return number
function MSK.TableLastIndex(tbl, val) end

---@param tbl table
---@param val any
---@return number|nil, any
function MSK.TableFind(tbl, val) end

---@param tbl table
---@return table
function MSK.TableReverse(tbl) end

---@param tbl table
---@return table
function MSK.TableClone(tbl) end

---Liefert einen Iterator, der die Tabelle sortiert durchläuft.
---@param tbl table
---@param order? fun(tbl: table, a: any, b: any): boolean
---@return fun(): any, any
function MSK.TableSort(tbl, order) end

---@param ms number
---@param cb fun(data: any)
---@param data? any
---@return number requestId
function MSK.SetTimeout(ms, cb, data) end

---@param requestId number
function MSK.ClearTimeout(requestId) end

---Wartet, bis cb einen Wert ungleich nil liefert. false wartet ohne Limit.
---@param timeout? number|false Standard 1000 ms.
---@param cb fun(): any
---@param errMessage? string
---@return any
function MSK.AwaitTimeout(timeout, cb, errMessage) end

---@param coords vector3|vector4|table
---@return string
function MSK.CoordsToString(coords) end

---@param vec vector2|vector3|vector4
---@return vector3
function MSK.VectorToVector(vec) end

---@param coords table
---@param toType "vector3"|"vector4"
---@return vector3|vector4|nil
function MSK.TableToVector(coords, toType) end

---Alias von MSK.Progress.Start. Die Tabellenform wartet und liefert true, wenn
---die Leiste durchgelaufen ist, sonst false. Die Form (duration, text, color)
---wartet nicht und ist veraltet, stattdessen eine Tabelle übergeben.
---@param data MSKProgressData
---@return boolean|nil finished
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function MSK.Progressbar(data) end

---Wie MSK.Progressbar, als Kreis dargestellt.
---@param data MSKProgressData
---@return boolean|nil finished
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function MSK.ProgressCircle(data) end

---Alias von MSK.Progress.Stop.
---@overload fun(playerId: number)
function MSK.ProgressStop() end

---Nur Client.
---@return boolean active, MSKProgressData|nil data
function MSK.ProgressActive() end

---Zeigt die TextUI. Ein erneuter Aufruf aktualisiert sie, mit gleichen Daten
---passiert nichts. Die Form (key, text, color) ist veraltet, stattdessen eine
---Tabelle übergeben.
---@param data MSKTextUIData
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUI(data) end

---Für Aufrufe in jedem Frame: blendet sich etwa 100 ms nach dem letzten Aufruf
---selbst aus. Die Form (key, text, color) ist veraltet.
---@param data MSKTextUIData
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUIThread(data) end

---@overload fun(playerId: number)
function MSK.HideTextUI() end

---Nur Client.
---@return boolean open, MSKTextUIData|nil data
function MSK.TextUIActive() end

---Einfaches Eingabefeld. Alias von MSK.Input.Open.
---@deprecated Stattdessen MSK.InputDialog bzw. MSK.Input.Dialog nutzen.
---@param header string
---@param placeholder? string
---@param field? boolean
---@param cb? fun(value: string|number|nil)
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function MSK.Input(header, placeholder, field, cb) end

---@deprecated Stattdessen MSK.InputDialog bzw. MSK.Input.Dialog nutzen.
---@param header string
---@param placeholder? string
---@param field? boolean
---@param cb? fun(value: string|number|nil)
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function MSK.OpenInput(header, placeholder, field, cb) end

---@overload fun(playerId: number)
function MSK.CloseInput() end

---Nur Client.
---@return boolean
function MSK.InputActive() end

---Öffnet einen Eingabedialog mit mehreren Feldern und wartet auf die Werte.
---Liefert nil bei Abbruch, sonst die Werte nach Zeilennummer und zusätzlich
---nach id, wo eine gesetzt ist. Leere optionale Felder sind nil.
---Auf dem Server werden die Werte des Clients noch einmal gegen die Zeilen
---geprüft. Alias von MSK.Input.Dialog.
---@param header string
---@param rows (MSKInputDialogRow|string)[] Ein Text ist die Kurzform für ein Textfeld mit diesem Label.
---@param options? MSKInputDialogOptions
---@return table|nil values
---@overload fun(playerId: number, header: string, rows: (MSKInputDialogRow|string)[], options?: MSKInputDialogOptions): table|nil
function MSK.InputDialog(header, rows, options) end

---Schließt einen offenen Dialog, wer darauf wartet, bekommt nil.
---@overload fun(playerId: number)
function MSK.CloseInputDialog() end

---Nur Client.
---@return boolean
function MSK.InputDialogActive() end

---Numpad mit Code. Alias von MSK.Numpad.Open. Blockiert, oder ruft cb in jedem
---Fall auf, auch bei Abbruch. reason ist "wrong", "maxAttempts", "cancelled",
---"busy" oder auf dem Server "invalid". In der Server-Form verlässt der Code
---den Server nie. Die Form (pin, showPin, cb) ist veraltet, stattdessen eine
---Tabelle übergeben.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: string)
---@return boolean|nil ok, string|nil reason
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, string|nil
---@overload fun(pin: string|number, showPin?: boolean, cb?: fun(ok: boolean, reason?: string))
---@overload fun(playerId: number, pin: string|number, showPin?: boolean): boolean, string|nil
function MSK.Numpad(data, cb) end

---Alias von MSK.Numpad.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: string)
---@return boolean|nil ok, string|nil reason
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, string|nil
function MSK.OpenNumpad(data, cb) end

---Fragt Ziffern ab, ohne sie mit einem Code zu vergleichen. Liefert die Ziffern
---als Text oder nil bei Abbruch. Auf dem Server kommen die Ziffern vom Client,
---also selbst prüfen. Alias von MSK.Numpad.Input.
---@param data? MSKNumpadInputOptions
---@param cb? fun(digits?: string, reason?: string)
---@return string|nil digits, string|nil reason
---@overload fun(playerId: number, data?: MSKNumpadInputOptions): string|nil, string|nil
function MSK.NumpadInput(data, cb) end

---@overload fun(playerId: number)
function MSK.CloseNumpad() end

---Nur Client.
---@return boolean
function MSK.NumpadActive() end

---Modaler Dialog, der auf die Antwort des Spielers wartet. Liefert "confirm",
---"cancel", "timeout" oder nil, wenn der Dialog per Code geschlossen wurde.
---Alias von MSK.Alert.Show. Nur Client.
---@param data MSKAlertData
---@return "confirm"|"cancel"|"timeout"|nil
function MSK.AlertDialog(data) end

---Nur Client.
function MSK.CloseAlertDialog() end

---Nur Client.
---@return boolean
function MSK.AlertActive() end

---Startet einen Skillcheck und liefert true, wenn jede Runde bestanden wurde.
---Das Ergebnis kommt vom Client, also nicht als einzige Prüfung für Wertvolles
---nutzen. Alias von MSK.Skillcheck.Start. Nur Client.
---@param difficulty? "easy"|"medium"|"hard"|{ areaSize?: number, speedMultiplier?: number }|("easy"|"medium"|"hard"|{ areaSize?: number, speedMultiplier?: number })[] Eine Liste steht für mehrere Runden.
---@param inputs? string[] Tasten, aus denen pro Runde gewählt wird, Standard { "e" }.
---@return boolean passed
function MSK.Skillcheck(difficulty, inputs) end

---Beendet einen laufenden Skillcheck als nicht bestanden. Nur Client.
function MSK.CancelSkillcheck() end

---Nur Client.
---@return boolean
function MSK.SkillcheckActive() end

---Kopiert Text in die Zwischenablage des Spielers. Alias von MSK.Clipboard.Set.
---Nur Client.
---@param text string|number
function MSK.SetClipboard(text) end

---Eine Spielereinstellung, ohne key eine Kopie aller Einstellungen.
---Alias von MSK.Settings.Get. Nur Client.
---@param key? "locale"|"notifyPosition"|"notifySound"
---@return any
function MSK.GetSetting(key) end

---Nur Client.
---@return table
function MSK.GetSettings() end

---Ändert eine Spielereinstellung. false, wenn der Wert nicht passt.
---Alias von MSK.Settings.Set. Nur Client.
---@param key "locale"|"notifyPosition"|"notifySound"
---@param value any
---@return boolean changed
function MSK.SetSetting(key, value) end

---Öffnet das Einstellungsmenü. Nur Client.
function MSK.OpenSettings() end

---Fügt der ersten Ebene des Radialmenüs einen oder mehrere Einträge hinzu.
---Ein Eintrag mit vorhandener id ersetzt den alten. Alias von MSK.Radial.Add.
---Nur Client.
---@param items MSKRadialItem|MSKRadialItem[]
function MSK.AddRadialItem(items) end

---Nur Client.
---@param id string
---@return boolean removed
function MSK.RemoveRadialItem(id) end

---Entfernt alle Einträge der aufrufenden Resource. Nur Client.
function MSK.ClearRadialItems() end

---Registriert ein Untermenü, das Einträge über ihr Feld menu öffnen. Nur Client.
---@param menu MSKRadialMenu
function MSK.RegisterRadial(menu) end

---Nur Client.
---@param id string
function MSK.UnregisterRadial(id) end

---Nur Client.
function MSK.ShowRadial() end

---Nur Client.
function MSK.HideRadial() end

---Sperrt das Radialmenü (true, Standard) oder gibt es wieder frei (false).
---Nur Client.
---@param state? boolean
function MSK.DisableRadial(state) end

---Nur Client.
---@return boolean
function MSK.IsRadialOpen() end

---Id des offenen Untermenüs, nil auf der ersten Ebene oder wenn zu. Nur Client.
---@return string|nil
function MSK.GetRadialId() end

---Registriert einen Hook, der eine Aktion mit false ablehnen kann. Höhere
---Priorität läuft zuerst. Alias von MSK.Hook.Register.
---@param event string
---@param cb fun(payload: any): boolean|nil
---@param options? { priority?: number }
---@return integer id
function MSK.RegisterHook(event, cb, options) end

---Entfernt einen Hook, nur die registrierende Resource darf das.
---@param id integer
---@return boolean removed
function MSK.RemoveHook(id) end

---Führt alle Hooks eines Events aus. false plus die ablehnende Resource,
---sobald ein Hook false liefert, sonst true.
---@param event string
---@param payload? any
---@return boolean allowed, string|nil refusedBy
function MSK.TriggerHook(event, payload) end

---@param event string
---@return boolean
function MSK.HasHook(event) end

---Alias von MSK.Cron.Schedule. Führt cb aus, sobald der Cron-Ausdruck passt,
---etwa "*/15 * * * *" oder "@daily". Liefert cb false, wird die Aufgabe
---entfernt. Nur Server.
---@param expression string
---@param cb fun(id: number, info: { timestamp: number, runs: number }): boolean|nil
---@return number id
function MSK.ScheduleCron(expression, cb) end

---Nur Server.
---@param id number
---@return boolean removed
function MSK.UnscheduleCron(id) end

---Zeitstempel des nächsten Laufs einer Aufgabe oder eines Ausdrucks. Nur Server.
---@param idOrExpression number|string
---@return number|nil timestamp
function MSK.CronNextRun(idOrExpression) end

---Prüft einen Cron-Ausdruck, ohne etwas zu planen. Nur Server.
---@param expression string
---@return boolean valid, string|nil reason
function MSK.IsCronValid(expression) end

---Liest die Fahrzeugeigenschaften, nil wenn das Fahrzeug nicht existiert.
---Alias von MSK.VehicleProperties.Get. Nur Client.
---@param vehicle number
---@return table|nil props
function MSK.GetVehicleProperties(vehicle) end

---Wendet Fahrzeugeigenschaften an, Felder mit nil bleiben unberührt. Greift nur
---auf dem Client, dem das Fahrzeug gehört. Mit fixVehicle wird vorher repariert
---und der gespeicherte Schaden übersprungen. Alias von MSK.VehicleProperties.Set.
---Nur Client.
---@param vehicle number
---@param props table
---@param fixVehicle? boolean
---@return boolean applied
function MSK.SetVehicleProperties(vehicle, props, fixVehicle) end

---Reiht einen Log-Eintrag für den konfigurierten Log-Dienst ein (Loki, Datadog,
---Fivemanage). Alias von MSK.Logger.Log. Nur Server.
---@param source? number Spieler-ID, 0 oder nil für den Server.
---@param event string Kurzer Name, etwa "shop:purchase".
---@param message string
---@param extra? table Zusätzliche, JSON-fähige Daten.
---@param tags? string|table key:value-Paare als "a:1,b:2", Liste oder Tabelle.
---@return boolean queued false, wenn kein Log-Dienst konfiguriert ist.
function MSK.LoggerLog(source, event, message, extra, tags) end

---Ob ein Log-Dienst konfiguriert ist. Nur Server.
---@return boolean
function MSK.LoggerEnabled() end

---Schaltet die Koordinatenanzeige um (zweiter Aufruf blendet sie aus).
---@overload fun(playerId: number)
function MSK.ShowCoords() end

---@overload fun(playerId: number)
function MSK.HideCoords() end

---@return boolean
function MSK.CoordsActive() end

---Client: kopiert coords oder die eigene Position in die Zwischenablage.
---Server: kopiert die Position von targetId (Standard playerId) bei playerId.
---@param coords? vector3|vector4
---@overload fun(playerId: number, targetId?: number)
function MSK.CopyCoords(coords) end

---Alias von MSK.Points.Add. Nur Client.
---@param properties MSKPointProperties
---@return MSKPoint
function MSK.AddPoint(properties) end

---Nur Client.
---@param pointId number
---@return boolean
function MSK.RemovePoint(pointId) end

---Nur Client.
---@return table<number, MSKPoint>
function MSK.GetAllPoints() end

---Nur Client.
---@return MSKPoint|nil
function MSK.GetClosestPoint() end

---Alle Points, in denen der Spieler gerade steht, der nächste zuerst.
---Nur Client.
---@return MSKPoint[]
function MSK.GetNearbyPoints() end

---Nur Client.
---@param animDict string
---@param timeout? number Standard 30000 ms.
---@return string
function MSK.RequestAnimDict(animDict, timeout) end

---Nur Client.
---@param model string|number
---@param timeout? number Standard 30000 ms.
---@return number hash
function MSK.RequestModel(model, timeout) end

---Nur Client.
---@param animSet string
---@param timeout? number Standard 30000 ms.
---@return string
function MSK.RequestAnimSet(animSet, timeout) end

---Nur Client.
---@param ptFxName string
---@param timeout? number Standard 30000 ms.
---@return string
function MSK.RequestPtfxAsset(ptFxName, timeout) end

---Nur Client.
---@param textureDict string
---@param timeout? number Standard 30000 ms.
---@return string
function MSK.RequestTextureDict(textureDict, timeout) end

---Nur Client.
---@param scaleformName string
---@param timeout? number Standard 30000 ms.
---@return number
function MSK.RequestScaleformMovie(scaleformName, timeout) end

---Allgemeiner Streaming-Request: ruft request(asset, ...) auf und wartet, bis
---hasLoaded(asset) true liefert. Nur Client.
---@param request fun(asset: any, ...: any)
---@param hasLoaded fun(asset: any): boolean
---@param assetType string Nur für die Log-Meldung.
---@param asset any
---@param timeout? number Standard 30000 ms.
---@param ... any
---@return any asset
function MSK.RequestStreaming(request, hasLoaded, assetType, asset, timeout, ...) end

---Strahl vom Spieler nach vorne. Liefert die getroffene Entity oder false,
---auch wenn nichts getroffen wurde. Nur Client.
---@param distance? number Standard 5.0
---@param flag? number|"none"|"all"|"world"|"vehicle"|"ped"|"object"|"water"|"glass"|"river"|"foliage"
---@return number|false entityHit
function MSK.RequestRaycast(distance, flag) end

---Strahl zwischen zwei Punkten, wartet höchstens eine Sekunde. Nur Client.
---@param from vector3
---@param to vector3
---@param flags? number Shape-Test-Flags, Standard 511.
---@param ignore? number Standard 4.
---@param ignoreEntity? number Entity, durch die der Strahl geht, Standard der eigene Ped.
---@return boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function MSK.RequestRaycastFromCoords(from, to, flags, ignore, ignoreEntity) end

---@param title string
---@param text string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, duration?: number)
function MSK.FreemodeMessage(title, text, duration) end

---@param title string
---@param text string
---@param footer? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, footer?: string, duration?: number)
function MSK.PopupWarning(title, text, footer, duration) end

---@param title string
---@param text string
---@param footer? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, footer?: string, duration?: number)
function MSK.BreakingNews(title, text, footer, duration) end

---@param duration? number
---@overload fun(playerId: number, duration?: number)
function MSK.TrafficMovie(duration) end

---@deprecated Stattdessen MSK.FreemodeMessage oder MSK.PopupWarning nutzen.
---@param title string
---@param text string
---@param typ? number 1 = FreemodeMessage, 2 = PopupWarning.
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: number, duration?: number)
function MSK.ScaleformAnnounce(title, text, typ, duration) end

---Prüft die Resource-Version gegen GitHub. Nur Server.
---@param repo MSKCheckRepo
function MSK.CheckVersion(repo) end

---Nur Server.
---@param resource string
---@param minimumVersion? string
---@param showMessage? boolean
---@return boolean ok, string currentVersion
function MSK.CheckDependency(resource, minimumVersion, showMessage) end

--------------------------------------------------------------------------------
-- Typen für flache Funktionen
--------------------------------------------------------------------------------

---@alias MSKNotifyPosition
---| "top-left"
---| "top"
---| "top-right"
---| "center-left"
---| "center-right"
---| "bottom-left"
---| "bottom"
---| "bottom-right"

---GTA-Sound statt des NUI-Sounds.
---@class MSKNotifySound
---@field name string
---@field set string
---@field bank? string Audio-Bank, wird bei Bedarf geladen.

---Alles über title, message, type und duration hinaus gilt nur für die MSK-UI.
---Externe Adapter (okok, qb-core, bulletin, native, custom) bekommen, was sie verstehen.
---@class MSKNotifyData
---@field id? string|number Eine sichtbare Benachrichtigung mit derselben id wird aktualisiert.
---@field title? string Ohne Titel wird die Benachrichtigung kompakt.
---@field message string
---@field description? string Ersatz für message.
---@field type? MSKNotifyType Standard "info".
---@field duration? number Standard 5000 ms.
---@field icon? string Überschreibt das Icon des Typs.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field position? MSKNotifyPosition Greift nur, solange der Spieler "Automatisch" eingestellt hat.
---@field showDuration? boolean false blendet den Fortschrittsbalken aus.
---@field sound? boolean|MSKNotifySound false ist stumm.

-- TextUI-, Numpad-, Alert- und Input-Dialog-Typen stehen in types.lua und
-- types_new.lua, MSKIconAnimation in types.lua.

---@class MSKNearbyEntity
---@field entity number
---@field coords vector3
---@field distance number

---@class MSKNearbyPlayer
---@field playerId number Lokaler Player-Index.
---@field serverId number
---@field ped number
---@field coords vector3
---@field distance number

---@alias MSKVehicleType
---| "automobile"
---| "bike"
---| "boat"
---| "heli"
---| "plane"
---| "submarine"
---| "trailer"
---| "train"

---@class MSKSpawnVehicleOptions
---@field heading? number Wenn coords keinen Heading enthalten.
---@field type? MSKVehicleType Ohne Angabe wird ein Client gefragt.
---@field plate? string
---@field props? table Fahrzeugeigenschaften, der besitzende Client wendet sie an.
---@field bucket? number Routing-Bucket.
---@field warp? number Server-ID eines Spielers, der auf den Fahrersitz gesetzt wird.
---@field playerId? number Spieler, der nach dem Fahrzeugtyp gefragt wird.
