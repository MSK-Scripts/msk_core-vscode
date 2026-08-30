---@meta
--- Globales MSK-Handle der msk_core Library (FiveM).
---
--- Entsteht in der Consumer-Resource durch
---     shared_script '@msk_core/import.lua'
--- in der fxmanifest.lua. Module werden lazy nachgeladen, sobald sie das erste
--- Mal angefasst werden. Optional laesst sich das vorziehen:
---     msk_core 'Callback'
---     msk_core 'Player'
---
--- msk_core setzt Lua 5.4 voraus (lua54 'yes' in der fxmanifest.lua).

---@class MSK
---@field name string Name der Resource, die MSK importiert hat.
---@field context "client"|"server" Seite, auf der der Code laeuft.
---@field Config table Inhalt der config.lua von msk_core.
---@field Bridge MSKBridge Erkanntes Framework und Inventory.
---@field LoadedPlayers table Nur Server: geladene Framework-Spieler.
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
---@overload fun(name: string): any Laedt ein Modul per Name, gleichwertig zu MSK.<Name>.
MSK = {}

--------------------------------------------------------------------------------
-- Basis
--------------------------------------------------------------------------------

---Gibt eine Meldung mit dem Praefix der aufrufenden Resource aus.
---@param code string Typ aus Config.LoggingTypes, etwa "info", "error", "warn", "debug".
---@param ... any
function MSK.Logging(code, ...) end

---Kleingeschriebener Alias von MSK.Logging.
---@param code string
---@param ... any
function MSK.logging(code, ...) end

---Fuehrt fn in einem pcall aus und wartet hoechstens timeout ms auf ein Ergebnis.
---Gedacht fuer Exports fremder Resources, die beim Start noch nicht bereit sind.
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
---@param eventName string
---@param cb fun(...): any
function MSK.Register(eventName, cb) end

---Ruft einen Callback der Gegenseite auf und wartet auf das Ergebnis.
---@param eventName string
---@param ... any
---@return any
---@overload fun(eventName: string, playerId: number, ...: any): any
function MSK.Trigger(eventName, ...) end

---Nicht blockierende Variante von Trigger. Nur Client.
---@param eventName string
---@param ... any
function MSK.TriggerCallback(eventName, ...) end

---Backwards-Compat-Alias von MSK.Register. Nur Server.
---@param eventName string
---@param cb fun(...): any
function MSK.RegisterCallback(eventName, cb) end

---Backwards-Compat-Alias von MSK.Register. Nur Server.
---@param eventName string
---@param cb fun(...): any
function MSK.RegisterServerCallback(eventName, cb) end

--------------------------------------------------------------------------------
-- Spieler und Framework (Bridge)
--------------------------------------------------------------------------------

---Liefert das Framework-Spielerobjekt.
---@param data MSKPlayerQuery|number
---@return table|nil
function MSK.GetPlayer(data) end

---@param playerId number
---@return table|nil
function MSK.GetPlayerFromId(playerId) end

---@param identifier string
---@return table|nil
function MSK.GetPlayerFromIdentifier(identifier) end

---Nur QBCore.
---@param citizenid string
---@return table|nil
function MSK.GetPlayerByCitizenId(citizenid) end

---@param player table|MSKPlayerQuery
---@return MSKPlayerJob|nil
function MSK.GetPlayerJob(player) end

---@param playerId number
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobFromId(playerId) end

---@param identifier string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobFromIdentifier(identifier) end

---@param citizenid string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJobByCitizenId(citizenid) end

---Liefert alle geladenen Spieler, optional gefiltert. Nur Server.
---@param key? string Feld, nach dem gefiltert wird, etwa "job".
---@param val? any Wert, auf den gefiltert wird.
---@return table[]
function MSK.GetPlayers(key, val) end

---Liefert den gespiegelten Spielerdatensatz aus dem Core. Nur Server.
---@param id number
---@return table|nil
function MSK.GetMirroredPlayer(id) end

---@param Player table Framework-Spielerobjekt.
---@return string
function MSK.GetPlayerIdentifier(Player) end

---@param Player table Framework-Spielerobjekt.
---@return number
function MSK.GetPlayerServerId(Player) end

--------------------------------------------------------------------------------
-- Inventory
--------------------------------------------------------------------------------

---Prueft, ob der Spieler einen Gegenstand besitzt. Laeuft ueber die
---konfigurierte Inventory-Bridge.
---@param itemName string
---@param amount? number Mindestmenge, Standard 1.
---@return boolean
---@overload fun(playerId: number, itemName: string, amount?: number): boolean
function MSK.HasItem(itemName, amount) end

---Nur Server.
---@param playerId number
---@param itemName string
---@param metadata? table Nur bei Inventories mit Metadaten.
---@return boolean
function MSK.HasPlayerItem(playerId, itemName, metadata) end

--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

---Registriert einen Chat-Befehl inklusive Vorschlag und Rechtepruefung.
---Client: RegisterCommand(name, cb, restricted, properties).
---Server: RegisterCommand(name, cb, properties).
---@param commandName string
---@param callback fun(source: number, args: table, raw: string)
---@param restricted? string|string[]|false
---@param properties? MSKCommandProperties
---@overload fun(commandName: string, callback: fun(source: number, args: table, raw: string), properties?: MSKCommandProperties)
function MSK.RegisterCommand(commandName, callback, restricted, properties) end

--------------------------------------------------------------------------------
-- ACE
--------------------------------------------------------------------------------

---Prueft ein ACE-Recht. Client ohne, Server mit Spieler-ID.
---@param command string
---@return boolean
---@overload fun(playerId: number, command: string): boolean
function MSK.IsAceAllowed(command) end

---@param restricted string|string[]
---@param ace string
---@return boolean
---@overload fun(principal: string, ace: string): boolean
function MSK.IsPrincipalAceAllowed(restricted, ace) end

---Nur Server.
---@param principal string Gruppe oder Identifier.
---@param ace string
---@param allow? boolean Standard true.
function MSK.AddAce(principal, ace, allow) end

---Nur Server.
---@param principal string
---@param ace string
---@param allow? boolean
function MSK.RemoveAce(principal, ace, allow) end

---Ob die Laufzeit ACEs setzen darf. Nur Server.
---@return boolean
function MSK.CanAddAce() end

---Setzt ein ACE ohne Normalisierung des Principals. Nur Server.
---@param principal string
---@param ace string
---@param allow? boolean
function MSK.AddRawAce(principal, ace, allow) end

---Nur Server.
---@param principal string
---@param ace string
---@param allow? boolean
function MSK.RemoveRawAce(principal, ace, allow) end

---Nur Server.
---@param child string
---@param parent string
function MSK.AddPrincipal(child, parent) end

---Nur Server.
---@param child string
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
---@param playerId number Ausfuehrender Spieler, 0 fuer Konsole.
---@param targetId number Zu sperrender Spieler.
---@param time string|number
---@param reason? string
function MSK.BanPlayer(playerId, targetId, time, reason) end

---@param playerId number Ausfuehrender Spieler.
---@param banId number ID des Bann-Eintrags.
function MSK.UnbanPlayer(playerId, banId) end

--------------------------------------------------------------------------------
-- Notifications
--------------------------------------------------------------------------------

---Zeigt eine Benachrichtigung.
---@param title string
---@param message string
---@param typ? MSKNotifyType Standard "info".
---@param duration? number Standard 5000 ms.
---@overload fun(src: number, title: string, message: string, info?: MSKNotifyType, time?: number)
function MSK.Notification(title, message, typ, duration) end

---Zeigt den Hinweistext oben links.
---@param text string
---@param key? string
---@overload fun(src: number, text: string)
function MSK.HelpNotification(text, key) end

---Zeigt eine Benachrichtigung mit Bild im GTA-Stil.
---@param text string
---@param title string
---@param subtitle string
---@param icon string
---@param flash? boolean
---@param icontype? number
---@overload fun(src: number, text: string, title: string, subtitle: string, icon: string, flash?: boolean, icontype?: number)
function MSK.AdvancedNotification(text, title, subtitle, icon, flash, icontype) end

---Zeigt einen Untertitel am unteren Bildrand.
---@param text string
---@param duration? number
---@overload fun(src: number, message: string, duration?: number)
function MSK.Subtitle(text, duration) end

---Zeigt den Ladekreis unten rechts. Nur Client.
---@param text string
---@param typ? number
---@param duration? number
function MSK.Spinner(text, typ, duration) end

---Zeichnet Text an Weltkoordinaten. Nur Client, muss pro Frame laufen.
---@param coords vector3|table
---@param text string
---@param size? number
---@param font? number
function MSK.Draw3DText(coords, text, size, font) end

---Zeichnet Text auf dem Bildschirm. Nur Client, muss pro Frame laufen.
---@param text string
---@param outline? boolean
---@param font? number
---@param size? number
---@param color? table
---@param position? table
function MSK.DrawGenericText(text, outline, font, size, color, position) end

--------------------------------------------------------------------------------
-- Entities und Fahrzeuge
--------------------------------------------------------------------------------

---@param isPlayerEntity? boolean|number
---@param coords? vector3
---@return number entity, number distance
---@overload fun(isPlayerEntity?: boolean|number, coords?: vector3, entities?: table): number, number
function MSK.GetClosestEntity(isPlayerEntity, coords) end

---@param isPlayerEntity? boolean|number
---@param coords? vector3
---@param distance? number
---@return table entities
---@overload fun(isPlayerEntity?: boolean|number, coords?: vector3, distance?: number, entities?: table): table
function MSK.GetClosestEntities(isPlayerEntity, coords, distance) end

---@param coords? vector3
---@return number vehicle, number distance
---@overload fun(coords?: vector3, vehicles?: table): number, number
function MSK.GetClosestVehicle(coords) end

---@param coords? vector3
---@param distance? number
---@return table
---@overload fun(coords?: vector3, distance?: number, vehicles?: table): table
function MSK.GetClosestVehicles(coords, distance) end

---Nur Client.
---@param plate string
---@param coords? vector3
---@param distance? number
---@return number|nil
function MSK.GetVehicleWithPlate(plate, coords, distance) end

---Nur Server.
---@param plate string
---@param coords? vector3
---@param distance? number
---@param vehicles? table
---@return number|nil
function MSK.GetClosestVehicleWithPlate(plate, coords, distance, vehicles) end

---@param plate string
---@return number|nil
function MSK.GetVehicleFromPlate(plate) end

---@param plate string
---@return number|nil hash
function MSK.GetModelFromPlate(plate) end

---Fahrzeug vor dem Spieler. Nur Client.
---@param distance? number
---@return number|nil
function MSK.GetVehicleInDirection(distance) end

---@param playerPed number
---@param vehicle number
---@return number|false seat
function MSK.GetPedVehicleSeat(playerPed, vehicle) end

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

---Schliesst alle Tueren. Nur Client.
---@param vehicle number
function MSK.CloseVehicleDoors(vehicle) end

--------------------------------------------------------------------------------
-- World
--------------------------------------------------------------------------------

---Prueft, ob an der Position kein Fahrzeug oder Ped steht.
---@param coords vector3
---@param maxDistance? number
---@return boolean
function MSK.IsSpawnPointClear(coords, maxDistance) end

---Erzeugt ein Mugshot-Bild des Peds. Nur Client.
---@param ped number
---@param transparent? boolean
---@return string handle, string textureDict
function MSK.GetPedMugshot(ped, transparent) end

---@param coords? vector3
---@return number player, number distance
---@overload fun(playerId: number, coords?: vector3): number, number
function MSK.GetClosestPlayer(coords) end

---@param coords? vector3
---@param distance? number
---@return table
---@overload fun(playerId: number, coords?: vector3, distance?: number): table
function MSK.GetClosestPlayers(coords, distance) end

---Sendet eine Nachricht an einen Discord-Webhook. Nur Server.
---@param webhook string
---@param botColor? number|string
---@param botName? string
---@param botAvatar? string
---@param title? string
---@param description? string
---@param fields? table
---@param footer? string
---@param time? boolean
function MSK.AddWebhook(webhook, botColor, botName, botAvatar, title, description, fields, footer, time) end

--------------------------------------------------------------------------------
-- Cron (nur Server)
--------------------------------------------------------------------------------

---Alias von MSK.Cron.Create.
---@param date MSKCronDate
---@param data any
---@param cb fun(data: any)
---@return string uniqueId
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
function MSK.RegisterMenu(id, data) end

---@param idOrData string|MSKMenuData
function MSK.ShowMenu(idOrData) end

---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function MSK.UpdateMenu(menuId, dataId, updatedData) end

---@param key? string
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
function MSK.DumpTable(tbl) end

---Achtung: MSK.Trim nutzt die invertierte Bool-Semantik aus v2
---(String.TrimLegacy), waehrend exports.msk_core:Trim auf String.Trim zeigt.
---@param str string
---@param bool? boolean
---@return string
function MSK.Trim(str, bool) end

---Alias von MSK.Request.AnimDict. Nur Client.
---@param animDict string
---@return string
function MSK.LoadAnimDict(animDict) end

---Alias von MSK.Request.Model. Nur Client.
---@param model string|number
---@return number hash
function MSK.LoadModel(model) end

---Alias von MSK.Coords.Active.
---@return boolean
---@overload fun(playerId: number): boolean
function MSK.DoesShowCoords() end

--------------------------------------------------------------------------------
-- Export-Proxies
-- Jeder Name, der weder Modul noch Alias ist, wird von import.lua automatisch
-- auf exports.msk_core:<Name> weitergeleitet. Die gebraeuchlichsten davon:
--------------------------------------------------------------------------------

---@param length number
---@return number
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
---@return any
function MSK.TableIndex(tbl, val) end

---@param tbl table
---@param val any
---@return any
function MSK.TableLastIndex(tbl, val) end

---@param tbl table
---@param val any
---@return any
function MSK.TableFind(tbl, val) end

---@param tbl table
---@return table
function MSK.TableReverse(tbl) end

---@param tbl table
---@return table
function MSK.TableClone(tbl) end

---@param tbl table
---@param order? fun(a: any, b: any): boolean
---@return table
function MSK.TableSort(tbl, order) end

---@param ms number
---@param cb fun(data: any)
---@param data? any
---@return number requestId
function MSK.SetTimeout(ms, cb, data) end

---@param requestId number
function MSK.ClearTimeout(requestId) end

---@param timeout number
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
---@param toType? number
---@return vector3|vector4
function MSK.TableToVector(coords, toType) end

---Alias von MSK.Progress.Start.
---@param data MSKProgressData|number
---@param text? string
---@param color? string
---@return boolean|nil cancelled
---@overload fun(playerId: number, data: MSKProgressData|number, text?: string, color?: string)
function MSK.Progressbar(data, text, color) end

---Alias von MSK.Progress.Stop.
---@overload fun(playerId: number)
function MSK.ProgressStop() end

---@return boolean
function MSK.ProgressActive() end

---@param key string
---@param text string
---@param color? string
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUI(key, text, color) end

---@param key string
---@param text string
---@param color? string
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUIThread(key, text, color) end

---@overload fun(playerId: number)
function MSK.HideTextUI() end

---@return boolean
function MSK.TextUIActive() end

---Alias von MSK.Input.Open.
---@param header string
---@param placeholder? string
---@param field? boolean
---@param cb? fun(value: string|nil)
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean)
function MSK.Input(header, placeholder, field, cb) end

---@overload fun(playerId: number)
function MSK.CloseInput() end

---@return boolean
function MSK.InputActive() end

---Alias von MSK.Numpad.Open.
---@param pin string|number
---@param showPin? boolean
---@param cb? fun(success: boolean)
---@overload fun(playerId: number, pin: string|number, showPin?: boolean)
function MSK.Numpad(pin, showPin, cb) end

---@overload fun(playerId: number)
function MSK.CloseNumpad() end

---@return boolean
function MSK.NumpadActive() end

---@overload fun(playerId: number)
function MSK.ShowCoords() end

---@overload fun(playerId: number)
function MSK.HideCoords() end

---@return boolean
function MSK.CoordsActive() end

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
---@return MSKPoint[]
function MSK.GetAllPoints() end

---Nur Client.
---@return MSKPoint|nil
function MSK.GetClosestPoint() end

---Nur Client.
---@param animDict string
---@return string
function MSK.RequestAnimDict(animDict) end

---Nur Client.
---@param model string|number
---@return number hash
function MSK.RequestModel(model) end

---Nur Client.
---@param animSet string
---@return string
function MSK.RequestAnimSet(animSet) end

---Nur Client.
---@param ptFxName string
---@return string
function MSK.RequestPtfxAsset(ptFxName) end

---Nur Client.
---@param textureDict string
---@return string
function MSK.RequestTextureDict(textureDict) end

---Nur Client.
---@param scaleformName string
---@param timeout? number
---@return number
function MSK.RequestScaleformMovie(scaleformName, timeout) end

---Nur Client.
---@param distance? number
---@param flag? number
---@return boolean hit, vector3 endCoords, number entityHit
function MSK.RequestRaycast(distance, flag) end

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

---@param title string
---@param text string
---@param typ? string
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: string, duration?: number)
function MSK.ScaleformAnnounce(title, text, typ, duration) end

---Prueft die Resource-Version gegen GitHub. Nur Server.
---@param repo MSKCheckRepo|string
function MSK.CheckVersion(repo) end

---Nur Server.
---@param resource string
---@param minimumVersion? string
---@param showMessage? boolean
---@return boolean ok, string currentVersion
function MSK.CheckDependency(resource, minimumVersion, showMessage) end
