---@meta
--- Global MSK handle of the msk_core library (FiveM).
---
--- Created in the consumer resource by
---     shared_script '@msk_core/import.lua'
--- in fxmanifest.lua. Modules are lazy-loaded the first time they are
--- accessed. Optionally you can load them up front:
---     msk_core 'Callback'
---     msk_core 'Player'
---
--- msk_core requires Lua 5.4 (lua54 'yes' in fxmanifest.lua).
--- As of: msk_core 4.1.0

---@class MSK
---@field name string Name of the resource that imported MSK.
---@field context "client"|"server" Side the code runs on.
---@field Config table Contents of msk_core's config.lua.
---@field Bridge MSKBridge Detected framework and inventory.
---@field LoadedPlayers table<number, MSKPlayerData> Server only: loaded players, only inside msk_core.
---@field Player MSKPlayer Local player. On the server the mirrored table, indexed by server ID.
---@field Math MSKMath
---@field String MSKString
---@field Table MSKTable
---@field Array MSKArray
---@field Vector MSKVector
---@field Timeout MSKTimeout
---@field Timer MSKTimer
---@field Cache MSKCache
---@field Class MSKClass
---@field Hook MSKHook
---@field Require MSKRequire
---@field Locale MSKLocale
---@field Print MSKPrint
---@field Callback MSKCallback
---@field Events MSKEvents Server only.
---@field Alert MSKAlert
---@field Context MSKContext
---@field Menu MSKMenu
---@field Radial MSKRadial Client only.
---@field Input MSKInput
---@field Numpad MSKNumpad
---@field Progress MSKProgress
---@field Skillcheck MSKSkillcheck
---@field TextUI MSKTextUI
---@field Clipboard MSKClipboard Client only.
---@field Controls MSKControls Client only.
---@field Keybind MSKKeybindModule Client only.
---@field Settings MSKSettings Client only.
---@field Coords MSKCoords
---@field Points MSKPoints Client only.
---@field Zones MSKZones Client only.
---@field Grid MSKGrid
---@field Marker MSKMarker Client only.
---@field Selector MSKSelector
---@field Request MSKRequest Client only.
---@field Anim MSKAnim Client only.
---@field Dui MSKDui Client only.
---@field Scaleform MSKScaleform
---@field VehicleProperties MSKVehiclePropertiesModule Get is client only, Set works on both sides.
---@field Cron MSKCron Server only.
---@field Check MSKCheck Server only.
---@field Files MSKFiles Server only.
---@field Logger MSKLogger Server only.
---@field Society MSKSociety Server only.
---@field Offline MSKOffline Server only.
---@field VehicleStore MSKVehicleStore Server only.
---@overload fun(name: string): any Loads a module by name, equivalent to MSK.<Name>.
MSK = {}

--------------------------------------------------------------------------------
-- Base
--------------------------------------------------------------------------------

---Prints a message with the prefix of the calling resource.
---@param code string Type from Config.LoggingTypes, e.g. "info", "error", "warn", "debug".
---@param ... any
function MSK.Logging(code, ...) end

---Lowercase alias of MSK.Logging.
---@param code string
---@param ... any
function MSK.logging(code, ...) end

---Runs fn in a pcall and waits at most timeout ms for a result.
---Meant for exports of other resources that are not ready yet at startup.
---Returns nil if nothing arrives in time, and does not throw an error.
---@param fn fun(): any
---@param timeout? number Default 1000 ms.
---@return any
function MSK.Call(fn, timeout) end

---Returns the config table of msk_core.
---@return table
function MSK.GetConfig() end

--------------------------------------------------------------------------------
-- Callback (flat, from the Callback module)
--------------------------------------------------------------------------------

---Registers a callback. Equivalent to MSK.Callback.Register.
---The callback belongs to the calling resource: another resource cannot
---overwrite it, and it is removed as soon as the resource stops.
---On the server, cb receives the caller's server ID as its first parameter.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered false if the name already belongs to another resource.
function MSK.Register(eventName, cb) end

---Calls a callback on the other side and waits for the result.
---Times out after msk:callbackTimeout (default 5000 ms) and then returns nil.
---Client: Trigger(eventName, ...). Server: Trigger(eventName, playerId, ...).
---Must be called from within a thread.
---@param eventName string
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, ...: any): ...
function MSK.Trigger(eventName, ...) end

---Like Trigger, but instead of returning a value the server callback receives a
---cb function that it calls. Still blocks until the response. Client only.
---@param eventName string
---@param ... any
---@return any ...
function MSK.TriggerCallback(eventName, ...) end

---Like Trigger, with a custom time limit in ms. nil or false waits without a limit.
---Meant for callbacks that wait for the player (dialogs, skill checks) or
---take longer than msk:callbackTimeout. On the server, waiting also ends
---as soon as the player leaves the server.
---Client: TriggerAwait(eventName, timeout, ...).
---Server: TriggerAwait(eventName, playerId, timeout, ...).
---@param eventName string
---@param timeout? number|false
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, timeout?: number|false, ...: any): ...
function MSK.TriggerAwait(eventName, timeout, ...) end

---Backwards-compat alias of MSK.Register. Server only.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered
function MSK.RegisterCallback(eventName, cb) end

---Backwards-compat alias of MSK.Register. Server only.
---@param eventName string
---@param cb fun(playerId: number, ...: any): ...
---@return boolean registered
function MSK.RegisterServerCallback(eventName, cb) end

--------------------------------------------------------------------------------
-- Player and framework (Bridge)
--------------------------------------------------------------------------------

---Returns the player object: unified data plus methods. Server only.
---Accepts a server ID, an identifier or a query table.
---@param data MSKPlayerQuery|number|string
---@return MSKPlayerObject|nil
function MSK.GetPlayer(data) end

---@param playerId number
---@return MSKPlayerObject|nil
function MSK.GetPlayerFromId(playerId) end

---@param identifier string
---@return MSKPlayerObject|nil
function MSK.GetPlayerFromIdentifier(identifier) end

---On QBCore and Qbox the citizenid is the identifier.
---@param citizenid string
---@return MSKPlayerObject|nil
function MSK.GetPlayerByCitizenId(citizenid) end

---Always nil on ESX, no phone number is attached to the player there.
---@param phone string
---@return MSKPlayerObject|nil
function MSK.GetPlayerByPhone(phone) end

---Qbox only, nil on every other framework.
---@param userId number
---@return MSKPlayerObject|nil
function MSK.GetPlayerByUserId(userId) end

---Calls cb whenever a field of the player changes, e.g. ped, vehicle,
---seat, weapon, isDead or a custom field. Alias of MSK.Player.OnChange.
---Client: cb(value, oldValue) for the local player.
---Server: cb(playerId, value, oldValue) for every mirrored player.
---Returns the event handler, which can be removed again with RemoveEventHandler.
---@param key string
---@param cb fun(value: any, oldValue: any)
---@return table eventData
---@overload fun(key: string, cb: fun(playerId: number, value: any, oldValue: any)): table
function MSK.OnPlayer(key, cb) end

---On the client without parameters, returns your own job there.
---@param player? table|MSKPlayerQuery|number|string
---@return MSKPlayerJob|nil
function MSK.GetPlayerJob(player) end

---Always nil on ESX, there are no gangs there.
---@param player? table|MSKPlayerQuery|number|string
---@return MSKPlayerJob|nil
function MSK.GetPlayerGang(player) end

---All jobs of the player as name -> grade. On Qbox the real multijob map.
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

---All job definitions of the framework, not players. Client and server.
---On the client this is a callback roundtrip, so only call it from a thread.
---@return table<string, MSKJobDefinition>
function MSK.GetJobs() end

---Like GetJobs, for gangs. Empty on ESX.
---@return table<string, MSKJobDefinition>
function MSK.GetGangs() end

---Returns all loaded players as data without methods, optionally filtered.
---Server only.
---@param key? "job"|"gang"|"group"
---@param val? any Value to filter by.
---@return MSKPlayerData[]
function MSK.GetPlayers(key, val) end

---Unified data of the local player, nil as long as no character
---is loaded. Client only.
---@return MSKPlayerData|nil
function MSK.GetPlayerData() end

---Client only.
---@return boolean
function MSK.IsPlayerLoaded() end

---Takes visn_are and osp_ambulance into account if they are started. Client only.
---@return boolean
function MSK.IsPlayerDead() end

---Returns the mirrored player record from the core. Server only.
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

---Checks whether the player owns an item. Goes through the
---configured inventory bridge. On the server the first parameter is the
---server ID. If the third argument is a table, it is read as metadata
---and count is skipped.
---@param itemName string
---@param count? number Minimum amount, default 1.
---@param metadata? table Only for inventories with metadata.
---@return table|false
---@overload fun(playerId: number, itemName: string|string[], count?: number, metadata?: table): table|false
function MSK.HasItem(itemName, count, metadata) end

---Accepts the same ID forms as MSK.GetPlayer. Server only.
---@param id number|string|MSKPlayerQuery
---@param itemName string|string[]
---@param count? number Minimum amount, default 1.
---@param metadata? table Only for inventories with metadata.
---@return table|false
function MSK.HasPlayerItem(id, itemName, count, metadata) end

--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

---Registers a chat command including suggestion and permission check.
---commandName can also be a list of names, each one gets its own
---copy of the properties.
---Client: RegisterCommand(name, cb, restricted, properties).
---Server: RegisterCommand(name, cb, properties), there restricted goes into properties.
---Parameters of type "longString" take the rest of the line and must
---therefore be the last parameter.
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

---Checks an ACE permission, "command." is prepended if needed.
---Client without, server with player ID. On the client a callback roundtrip.
---@param command string
---@return boolean
---@overload fun(playerId: number, command: string): boolean
function MSK.IsAceAllowed(command) end

---Checks whether a principal has an ACE permission. A number counts as a server ID,
---text without a prefix as a group or, with a colon, as an identifier.
---On the client the server only answers for groups and your own principals
---(own server ID, own identifiers). For other players it always returns false.
---@param principal string|number
---@param ace string
---@return boolean
function MSK.IsPrincipalAceAllowed(principal, ace) end

---Server only.
---@param principal string|number Group, identifier or server ID.
---@param ace string
---@param allow? boolean Default true.
function MSK.AddAce(principal, ace, allow) end

---Server only.
---@param principal string|number
---@param ace string
---@param allow? boolean
function MSK.RemoveAce(principal, ace, allow) end

---Whether msk_core is allowed to set ACEs (add_ace resource.msk_core command.add_ace allow).
---Server only.
---@return boolean
function MSK.CanAddAce() end

---Sets an ACE without normalizing the principal and without the "command." prefix.
---Always goes through msk_core. Server only.
---@param principal string
---@param ace string
---@param allow? boolean
---@return boolean ok false if msk_core is not allowed to set ACEs.
function MSK.AddRawAce(principal, ace, allow) end

---Server only.
---@param principal string
---@param ace string
---@param allow? boolean
---@return boolean ok
function MSK.RemoveRawAce(principal, ace, allow) end

---Server only.
---@param child string|number Principal or server ID.
---@param parent string
function MSK.AddPrincipal(child, parent) end

---Server only.
---@param child string|number
---@param parent string
function MSK.RemovePrincipal(child, parent) end

--------------------------------------------------------------------------------
-- Ban (server only)
--------------------------------------------------------------------------------

---@param playerId number
---@return table|false
function MSK.IsPlayerBanned(playerId) end

---Bans a player. The duration supports the suffixes M, H, D and W,
---e.g. "30M", "12H", "7D", "2W". Without a suffix the ban is permanent.
---@param playerId? number Executing player. 0 stands for the console, nil for the system.
---@param targetId number Player to ban.
---@param time string|number
---@param reason? string
function MSK.BanPlayer(playerId, targetId, time, reason) end

---@param playerId? number Executing player. 0 stands for the console, nil for the system.
---@param banId number ID of the ban entry.
function MSK.UnbanPlayer(playerId, banId) end

--------------------------------------------------------------------------------
-- Notifications
--------------------------------------------------------------------------------

---Shows a notification. A visible notification with the same
---id is updated instead of stacked.
---Client: Notification(data). Server: Notification(playerId, data), -1 for everyone.
---The form (title, message, type, duration) still works but is
---deprecated, pass a table instead.
---@param data MSKNotifyData
---@overload fun(playerId: number, data: MSKNotifyData)
---@overload fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@overload fun(playerId: number, title: string, message: string, typ?: MSKNotifyType, duration?: number)
function MSK.Notification(data) end

---Alias of MSK.Notification.
---@param data MSKNotifyData
---@overload fun(playerId: number, data: MSKNotifyData)
---@overload fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@overload fun(playerId: number, title: string, message: string, typ?: MSKNotifyType, duration?: number)
function MSK.Notify(data) end

---Shows a help text. Depending on the config natively at the top left or as TextUI.
---@param text string
---@param key? string Key shown in the TextUI, client only.
---@overload fun(playerId: number, text: string)
function MSK.HelpNotification(text, key) end

---Alias of MSK.HelpNotification.
---@param text string
---@param key? string
---@overload fun(playerId: number, text: string)
function MSK.HelpNotify(text, key) end

---Shows a GTA-style notification with a picture.
---@param text string
---@param title string
---@param subtitle string
---@param icon? string Default "CHAR_HUMANDEFAULT".
---@param flash? boolean Default true, false disables flashing.
---@param icontype? number Default 1.
---@overload fun(playerId: number, text: string, title: string, subtitle: string, icon?: string, flash?: boolean, icontype?: number)
function MSK.AdvancedNotification(text, title, subtitle, icon, flash, icontype) end

---Alias of MSK.AdvancedNotification.
---@param text string
---@param title string
---@param subtitle string
---@param icon? string
---@param flash? boolean
---@param icontype? number
---@overload fun(playerId: number, text: string, title: string, subtitle: string, icon?: string, flash?: boolean, icontype?: number)
function MSK.AdvancedNotify(text, title, subtitle, icon, flash, icontype) end

---Shows a subtitle at the bottom of the screen.
---@param text string
---@param duration? number Default 8000 ms.
---@overload fun(playerId: number, message: string, duration?: number)
function MSK.Subtitle(text, duration) end

---Shows the loading spinner at the bottom right.
---@param text string
---@param typ? number Default 4 (orange), 5 is white.
---@param duration? number Default 5000 ms.
---@overload fun(playerId: number, text: string, typ?: number, duration?: number)
function MSK.Spinner(text, typ, duration) end

---Draws text at world coordinates. Must run every frame.
---@param coords vector3|table
---@param text string
---@param size? number
---@param font? number
---@overload fun(playerId: number, coords: vector3|table, text: string, size?: number, font?: number)
function MSK.Draw3DText(coords, text, size, font) end

---Draws text on the screen. Must run every frame.
---@param text string
---@param outline? boolean
---@param font? number
---@param size? number
---@param color? table
---@param position? table
---@overload fun(playerId: number, text: string, outline?: boolean, font?: number, size?: number, color?: table, position?: table)
function MSK.DrawGenericText(text, outline, font, size, color, position) end

--------------------------------------------------------------------------------
-- Entities and vehicles
--------------------------------------------------------------------------------

---Closest player or closest vehicle. With maxDistance only entities
---within that range count. Without a match it returns -1, -1.
---Client: GetClosestEntity(isPlayerEntity, coords, maxDistance).
---Server: GetClosestEntity(isPlayerEntity, coords, entities, maxDistance). There
---isPlayerEntity is false for vehicles or the server ID to search
---around. Without coords this player serves as the origin and is never returned itself.
---@param isPlayerEntity? boolean
---@param coords? vector3 Defaults to your own position.
---@param maxDistance? number
---@return number entity, number distance
---@overload fun(isPlayerEntity: number|false, coords?: vector3, entities?: table, maxDistance?: number): number, number
function MSK.GetClosestEntity(isPlayerEntity, coords, maxDistance) end

---All players or vehicles within range. Without distance every entity counts.
---@param isPlayerEntity? boolean
---@param coords? vector3
---@param distance? number
---@return table entities
---@overload fun(isPlayerEntity: number|false, coords?: vector3, distance?: number, entities?: table): table
function MSK.GetClosestEntities(isPlayerEntity, coords, distance) end

---Closest vehicle, -1, -1 without a match.
---Client: GetClosestVehicle(coords, maxDistance).
---Server: GetClosestVehicle(coords, vehicles, maxDistance), coords are required there.
---@param coords? vector3 Defaults to your own position.
---@param maxDistance? number Only vehicles within this range count.
---@return number vehicle, number distance
---@overload fun(coords: vector3, vehicles?: number[], maxDistance?: number): number, number
function MSK.GetClosestVehicle(coords, maxDistance) end

---@param coords? vector3
---@param distance? number If omitted, every vehicle counts.
---@return table
---@overload fun(coords: vector3, distance?: number, vehicles?: table): table
function MSK.GetClosestVehicles(coords, distance) end

---Peds within range, closest first. Player peds only with
---includePlayers, never your own ped. Client only.
---@param coords? vector3 Defaults to your own position.
---@param maxDistance? number Default 2.0
---@param includePlayers? boolean
---@return MSKNearbyEntity[]
function MSK.GetNearbyPeds(coords, maxDistance, includePlayers) end

---Objects within range, closest first. Client only.
---@param coords? vector3
---@param maxDistance? number Default 2.0
---@return MSKNearbyEntity[]
function MSK.GetNearbyObjects(coords, maxDistance) end

---Vehicles within range, closest first. Your own vehicle only with
---includeOwn. Client only.
---@param coords? vector3
---@param maxDistance? number Default 2.0
---@param includeOwn? boolean
---@return MSKNearbyEntity[]
function MSK.GetNearbyVehicles(coords, maxDistance, includeOwn) end

---Other players within range, closest first. Your own player only
---with includeSelf. Client only.
---@param coords? vector3
---@param maxDistance? number Default 2.0
---@param includeSelf? boolean
---@return MSKNearbyPlayer[]
function MSK.GetNearbyPlayers(coords, maxDistance, includeSelf) end

---Closest ped within range including its position, nil without a match. Client only.
---@param coords? vector3
---@param maxDistance? number Default 2.0
---@param includePlayers? boolean
---@return number|nil ped, vector3|nil coords
function MSK.GetClosestPed(coords, maxDistance, includePlayers) end

---Closest object within range including its position, nil without a match. Client only.
---@param coords? vector3
---@param maxDistance? number Default 2.0
---@return number|nil object, vector3|nil coords
function MSK.GetClosestObject(coords, maxDistance) end

---Vehicle with this plate nearby, false without a match. Client only.
---Case and leading or trailing whitespace do not matter.
---@param plate string
---@param coords? vector3
---@param distance? number
---@return number|false
function MSK.GetVehicleWithPlate(plate, coords, distance) end

---Vehicle with this plate near coords, false without a match.
---Without coords every vehicle is searched. Server only.
---@param plate string
---@param coords? vector3
---@param distance? number
---@param vehicles? table
---@return number|false
function MSK.GetClosestVehicleWithPlate(plate, coords, distance, vehicles) end

---Finds the vehicle with this plate without a radius. The search always runs
---on the server, on the client it is a callback roundtrip (blocking).
---On the client vehicle is false if the vehicle exists but is not
---streamed here. netId is still set in that case.
---@param plate string
---@return number|false vehicle, number|nil netId
function MSK.GetVehicleFromPlate(plate) end

---Reads the model from the framework's vehicle table, so it also works
---for parked vehicles. Blocking, on the client a callback.
---@param plate string
---@return number|nil model Hash, nil without a match or on STANDALONE.
---@return string|nil name Spawn name, only if the framework stores it.
function MSK.GetModelFromPlate(plate) end

---Vehicle in front of the player. Client only.
---@param distance? number Default 5.0
---@return number|false vehicle, vector3|nil coords, string|nil distance
function MSK.GetVehicleInDirection(distance) end

---Alias of MSK.GetVehicleInDirection. Client only.
---@param distance? number
---@return number|false vehicle, vector3|nil coords, string|nil distance
function MSK.GetVehicleInFront(distance) end

---Seat index of the ped in the vehicle (-1 is the driver), false if it is not
---sitting in it. Since 4.1.0 also false instead of -1 on the server.
---Client: without parameters your own ped and your own vehicle.
---Server: ped is required, without vehicle the vehicle it is sitting in.
---@param ped? number
---@param vehicle? number
---@return number|false seat
function MSK.GetPedVehicleSeat(ped, vehicle) end

---Client only.
---@param vehicle number
---@return boolean
function MSK.IsVehicleEmpty(vehicle) end

---Display name of the vehicle. Client only.
---@param vehicle? number
---@param model? string|number
---@return string
function MSK.GetVehicleLabel(vehicle, model) end

---Client only.
---@param model string|number
---@return string
function MSK.GetVehicleLabelFromModel(model) end

---Closes all doors. Client only.
---@param vehicle number
function MSK.CloseVehicleDoors(vehicle) end

---Creates a networked vehicle on the server and waits until it exists.
---Without options.type msk_core asks a client for the vehicle type once per
---model. Trailers cannot be detected that way, set type = "trailer"
---for them. Blocking. Server only.
---@param model string|number
---@param coords vector3|vector4|table
---@param options? MSKSpawnVehicleOptions
---@return number|nil vehicle, number|nil netId nil if the vehicle could not be created.
function MSK.SpawnVehicle(model, coords, options) end

--------------------------------------------------------------------------------
-- World
--------------------------------------------------------------------------------

---Checks whether no vehicle is within range.
---@param coords? vector3 On the client defaults to your own position, required on the server.
---@param maxDistance? number Default 5.0
---@return boolean
function MSK.IsSpawnPointClear(coords, maxDistance) end

---Creates a mugshot image of the ped. If it is not ready in time,
---nil is returned. Client only.
---@param ped number
---@param transparent? boolean
---@param timeout? number Default 5000 ms.
---@return number|nil handle, string|nil textureDict
function MSK.GetPedMugshot(ped, transparent, timeout) end

---Closest player, -1, -1 without a match.
---Client: GetClosestPlayer(coords, maxDistance), returns the player index.
---Server: GetClosestPlayer(playerId, coords, maxDistance). The search is around
---playerId, who is never returned. Without playerId coords are required.
---@param coords? vector3 Defaults to your own position.
---@param maxDistance? number Only players within this range count.
---@return number player, number distance
---@overload fun(playerId?: number, coords?: vector3, maxDistance?: number): string|number, number
function MSK.GetClosestPlayer(coords, maxDistance) end

---@param coords? vector3
---@param distance? number
---@return table
---@overload fun(playerId?: number, coords?: vector3, distance?: number): table
function MSK.GetClosestPlayers(coords, distance) end

---Sends a message to a Discord webhook. Without a valid https URL
---nothing is sent and false is returned. Server only.
---@param webhook string
---@param botColor? number|string
---@param botName? string
---@param botAvatar? string
---@param title? string
---@param description? string
---@param fields? table
---@param footer? { text: string, link?: string }
---@param time? string os.date format, appended to the footer.
---@return false|nil
function MSK.AddWebhook(webhook, botColor, botName, botAvatar, title, description, fields, footer, time) end

--------------------------------------------------------------------------------
-- Cron (server only)
--------------------------------------------------------------------------------

---Alias of MSK.Cron.Create.
---@param date MSKCronDate|number Interval, time of day or Unix timestamp.
---@param data any
---@param cb fun(uniqueId: number, data: any, info: MSKCronInfo)
---@return number|nil uniqueId ID for MSK.DeleteCron, nil on invalid arguments.
function MSK.CreateCron(date, data, cb) end

---Alias of MSK.Cron.Delete.
---@param id string
---@return boolean
function MSK.DeleteCron(id) end

--------------------------------------------------------------------------------
-- Flat aliases for Context and Menu
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
---@param startIndex? number Entry the selection starts on.
---@overload fun(playerId: number, idOrData: string|MSKMenuData, startIndex?: number)
function MSK.ShowMenu(idOrData, startIndex) end

---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function MSK.UpdateMenu(menuId, dataId, updatedData) end

---Replaces all entries, or with index only that one. An open menu
---updates immediately. Client only.
---@param menuId string
---@param options MSKMenuItem[]|MSKMenuItem
---@param index? number
function MSK.SetMenuOptions(menuId, options, index) end

---Closes the open menu. key is passed to onClose, false closes without onClose.
---@param key? string|false
---@overload fun(playerId: number)
function MSK.HideMenu(key) end

---@return string|nil
function MSK.GetOpenMenu() end

--------------------------------------------------------------------------------
-- Backwards-compat aliases from aliases.lua
--------------------------------------------------------------------------------

---Alias of MSK.Timeout.Set.
---@param ms number
---@param cb fun(data: any)
---@param data? any
---@return number requestId
function MSK.AddTimeout(ms, cb, data) end

---Alias of MSK.Timeout.Clear.
---@param requestId number
function MSK.DelTimeout(requestId) end

---Alias of MSK.Table.Contains.
---@param tbl table
---@param val any
---@return boolean
function MSK.Table_Contains(tbl, val) end

---Alias of MSK.Table.Dump.
---@param tbl table
---@return string
function MSK.DumpTable(tbl) end

---Note: MSK.Trim uses the inverted bool semantics from v2
---(String.TrimLegacy), while exports.msk_core:Trim points to String.Trim.
---@param str string
---@param bool? boolean
---@return string
function MSK.Trim(str, bool) end

---Alias of MSK.Request.AnimDict. Client only.
---@param animDict string
---@param timeout? number Default 30000 ms.
---@return string
function MSK.LoadAnimDict(animDict, timeout) end

---Alias of MSK.Request.Model. Client only.
---@param model string|number
---@param timeout? number Default 30000 ms.
---@return number hash
function MSK.LoadModel(model, timeout) end

---Alias of MSK.Coords.Active.
---@return boolean
---@overload fun(playerId: number): boolean
function MSK.DoesShowCoords() end

--------------------------------------------------------------------------------
-- Export-Proxies
-- Any name that is neither a module nor an alias is automatically forwarded
-- by import.lua to exports.msk_core:<Name>. The most common ones:
--------------------------------------------------------------------------------

---Random sequence of digits.
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

---Returns an iterator that traverses the table in sorted order.
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

---Waits until cb returns a value other than nil. false waits without a limit.
---@param timeout? number|false Default 1000 ms.
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

---Alias of MSK.Progress.Start. The table form waits and returns true if
---the bar completed, otherwise false. The form (duration, text, color)
---does not wait and is deprecated, pass a table instead.
---@param data MSKProgressData
---@return boolean|nil finished
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function MSK.Progressbar(data) end

---Like MSK.Progressbar, displayed as a circle.
---@param data MSKProgressData
---@return boolean|nil finished
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function MSK.ProgressCircle(data) end

---Alias of MSK.Progress.Stop.
---@overload fun(playerId: number)
function MSK.ProgressStop() end

---Client only.
---@return boolean active, MSKProgressData|nil data
function MSK.ProgressActive() end

---Shows the TextUI. Calling it again updates it, with identical data
---nothing happens. The form (key, text, color) is deprecated, pass a
---table instead.
---@param data MSKTextUIData
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUI(data) end

---For calls in every frame: hides itself about 100 ms after the last call.
---The form (key, text, color) is deprecated.
---@param data MSKTextUIData
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function MSK.ShowTextUIThread(data) end

---@overload fun(playerId: number)
function MSK.HideTextUI() end

---Client only.
---@return boolean open, MSKTextUIData|nil data
function MSK.TextUIActive() end

---Simple input field. Alias of MSK.Input.Open.
---@deprecated Use MSK.InputDialog or MSK.Input.Dialog instead.
---@param header string
---@param placeholder? string
---@param field? boolean
---@param cb? fun(value: string|number|nil)
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function MSK.Input(header, placeholder, field, cb) end

---@deprecated Use MSK.InputDialog or MSK.Input.Dialog instead.
---@param header string
---@param placeholder? string
---@param field? boolean
---@param cb? fun(value: string|number|nil)
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function MSK.OpenInput(header, placeholder, field, cb) end

---@overload fun(playerId: number)
function MSK.CloseInput() end

---Client only.
---@return boolean
function MSK.InputActive() end

---Opens an input dialog with multiple fields and waits for the values.
---Returns nil on cancel, otherwise the values by row number and additionally
---by id where one is set. Empty optional fields are nil.
---On the server the client's values are validated against the rows
---once more. Alias of MSK.Input.Dialog.
---@param header string
---@param rows (MSKInputDialogRow|string)[] A string is shorthand for a text field with that label.
---@param options? MSKInputDialogOptions
---@return table|nil values
---@overload fun(playerId: number, header: string, rows: (MSKInputDialogRow|string)[], options?: MSKInputDialogOptions): table|nil
function MSK.InputDialog(header, rows, options) end

---Closes an open dialog, anyone waiting on it gets nil.
---@overload fun(playerId: number)
function MSK.CloseInputDialog() end

---Client only.
---@return boolean
function MSK.InputDialogActive() end

---Numpad with a code. Alias of MSK.Numpad.Open. Blocks, or calls cb in every
---case, even on cancel. reason is "wrong", "maxAttempts", "cancelled",
---"busy" or on the server "invalid". In the server form the code never leaves
---the server. The form (pin, showPin, cb) is deprecated, pass a
---table instead.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: string)
---@return boolean|nil ok, string|nil reason
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, string|nil
---@overload fun(pin: string|number, showPin?: boolean, cb?: fun(ok: boolean, reason?: string))
---@overload fun(playerId: number, pin: string|number, showPin?: boolean): boolean, string|nil
function MSK.Numpad(data, cb) end

---Alias of MSK.Numpad.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: string)
---@return boolean|nil ok, string|nil reason
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, string|nil
function MSK.OpenNumpad(data, cb) end

---Asks for digits without comparing them to a code. Returns the digits
---as text or nil on cancel. On the server the digits come from the client,
---so validate them yourself. Alias of MSK.Numpad.Input.
---@param data? MSKNumpadInputOptions
---@param cb? fun(digits?: string, reason?: string)
---@return string|nil digits, string|nil reason
---@overload fun(playerId: number, data?: MSKNumpadInputOptions): string|nil, string|nil
function MSK.NumpadInput(data, cb) end

---@overload fun(playerId: number)
function MSK.CloseNumpad() end

---Client only.
---@return boolean
function MSK.NumpadActive() end

---Modal dialog that waits for the player's answer. Returns "confirm",
---"cancel", "timeout" or nil if the dialog was closed by code.
---Alias of MSK.Alert.Show. Client only.
---@param data MSKAlertData
---@return "confirm"|"cancel"|"timeout"|nil
function MSK.AlertDialog(data) end

---Client only.
function MSK.CloseAlertDialog() end

---Client only.
---@return boolean
function MSK.AlertActive() end

---Starts a skill check and returns true if every round was passed.
---The result comes from the client, so do not use it as the only check for anything
---valuable. Alias of MSK.Skillcheck.Start. Client only.
---@param difficulty? "easy"|"medium"|"hard"|{ areaSize?: number, speedMultiplier?: number }|("easy"|"medium"|"hard"|{ areaSize?: number, speedMultiplier?: number })[] A list stands for multiple rounds.
---@param inputs? string[] Keys to pick from per round, default { "e" }.
---@return boolean passed
function MSK.Skillcheck(difficulty, inputs) end

---Ends a running skill check as failed. Client only.
function MSK.CancelSkillcheck() end

---Client only.
---@return boolean
function MSK.SkillcheckActive() end

---Copies text to the player's clipboard. Alias of MSK.Clipboard.Set.
---Client only.
---@param text string|number
function MSK.SetClipboard(text) end

---A player setting, without key a copy of all settings.
---Alias of MSK.Settings.Get. Client only.
---@param key? "locale"|"notifyPosition"|"notifySound"
---@return any
function MSK.GetSetting(key) end

---Client only.
---@return table
function MSK.GetSettings() end

---Changes a player setting. false if the value is not valid.
---Alias of MSK.Settings.Set. Client only.
---@param key "locale"|"notifyPosition"|"notifySound"
---@param value any
---@return boolean changed
function MSK.SetSetting(key, value) end

---Opens the settings menu. Client only.
function MSK.OpenSettings() end

---Adds one or more entries to the first level of the radial menu.
---An entry with an existing id replaces the old one. Alias of MSK.Radial.Add.
---Client only.
---@param items MSKRadialItem|MSKRadialItem[]
function MSK.AddRadialItem(items) end

---Client only.
---@param id string
---@return boolean removed
function MSK.RemoveRadialItem(id) end

---Removes all entries of the calling resource. Client only.
function MSK.ClearRadialItems() end

---Registers a submenu that entries open via their menu field. Client only.
---@param menu MSKRadialMenu
function MSK.RegisterRadial(menu) end

---Client only.
---@param id string
function MSK.UnregisterRadial(id) end

---Client only.
function MSK.ShowRadial() end

---Client only.
function MSK.HideRadial() end

---Locks the radial menu (true, default) or unlocks it again (false).
---Client only.
---@param state? boolean
function MSK.DisableRadial(state) end

---Client only.
---@return boolean
function MSK.IsRadialOpen() end

---Id of the open submenu, nil on the first level or when closed. Client only.
---@return string|nil
function MSK.GetRadialId() end

---Registers a hook that can reject an action by returning false. Higher
---priority runs first. Alias of MSK.Hook.Register.
---@param event string
---@param cb fun(payload: any): boolean|nil
---@param options? { priority?: number }
---@return integer id
function MSK.RegisterHook(event, cb, options) end

---Removes a hook, only the registering resource may do that.
---@param id integer
---@return boolean removed
function MSK.RemoveHook(id) end

---Runs all hooks of an event. Returns false plus the rejecting resource
---as soon as a hook returns false, otherwise true.
---@param event string
---@param payload? any
---@return boolean allowed, string|nil refusedBy
function MSK.TriggerHook(event, payload) end

---@param event string
---@return boolean
function MSK.HasHook(event) end

---Alias of MSK.Cron.Schedule. Runs cb whenever the cron expression matches,
---e.g. "*/15 * * * *" or "@daily". If cb returns false, the task is
---removed. Server only.
---@param expression string
---@param cb fun(id: number, info: { timestamp: number, runs: number }): boolean|nil
---@return number id
function MSK.ScheduleCron(expression, cb) end

---Server only.
---@param id number
---@return boolean removed
function MSK.UnscheduleCron(id) end

---Timestamp of the next run of a task or an expression. Server only.
---@param idOrExpression number|string
---@return number|nil timestamp
function MSK.CronNextRun(idOrExpression) end

---Validates a cron expression without scheduling anything. Server only.
---@param expression string
---@return boolean valid, string|nil reason
function MSK.IsCronValid(expression) end

---Reads the vehicle properties, nil if the vehicle does not exist.
---Alias of MSK.VehicleProperties.Get. Client only.
---@param vehicle number
---@return table|nil props
function MSK.GetVehicleProperties(vehicle) end

---Applies vehicle properties, fields that are nil stay untouched. Only takes effect
---on the client that owns the vehicle. With fixVehicle it is repaired first
---and the stored damage is skipped. Alias of MSK.VehicleProperties.Set.
---Client only.
---@param vehicle number
---@param props table
---@param fixVehicle? boolean
---@return boolean applied
function MSK.SetVehicleProperties(vehicle, props, fixVehicle) end

---Queues a log entry for the configured log service (Loki, Datadog,
---Fivemanage). Alias of MSK.Logger.Log. Server only.
---@param source? number Player ID, 0 or nil for the server.
---@param event string Short name, e.g. "shop:purchase".
---@param message string
---@param extra? table Additional JSON-serializable data.
---@param tags? string|table key:value pairs as "a:1,b:2", a list or a table.
---@return boolean queued false if no log service is configured.
function MSK.LoggerLog(source, event, message, extra, tags) end

---Whether a log service is configured. Server only.
---@return boolean
function MSK.LoggerEnabled() end

---Toggles the coordinate display (a second call hides it).
---@overload fun(playerId: number)
function MSK.ShowCoords() end

---@overload fun(playerId: number)
function MSK.HideCoords() end

---@return boolean
function MSK.CoordsActive() end

---Client: copies coords or your own position to the clipboard.
---Server: copies the position of targetId (default playerId) for playerId.
---@param coords? vector3|vector4
---@overload fun(playerId: number, targetId?: number)
function MSK.CopyCoords(coords) end

---Alias of MSK.Points.Add. Client only.
---@param properties MSKPointProperties
---@return MSKPoint
function MSK.AddPoint(properties) end

---Client only.
---@param pointId number
---@return boolean
function MSK.RemovePoint(pointId) end

---Client only.
---@return table<number, MSKPoint>
function MSK.GetAllPoints() end

---Client only.
---@return MSKPoint|nil
function MSK.GetClosestPoint() end

---All points the player is currently standing in, closest first.
---Client only.
---@return MSKPoint[]
function MSK.GetNearbyPoints() end

---Client only.
---@param animDict string
---@param timeout? number Default 30000 ms.
---@return string
function MSK.RequestAnimDict(animDict, timeout) end

---Client only.
---@param model string|number
---@param timeout? number Default 30000 ms.
---@return number hash
function MSK.RequestModel(model, timeout) end

---Client only.
---@param animSet string
---@param timeout? number Default 30000 ms.
---@return string
function MSK.RequestAnimSet(animSet, timeout) end

---Client only.
---@param ptFxName string
---@param timeout? number Default 30000 ms.
---@return string
function MSK.RequestPtfxAsset(ptFxName, timeout) end

---Client only.
---@param textureDict string
---@param timeout? number Default 30000 ms.
---@return string
function MSK.RequestTextureDict(textureDict, timeout) end

---Client only.
---@param scaleformName string
---@param timeout? number Default 30000 ms.
---@return number
function MSK.RequestScaleformMovie(scaleformName, timeout) end

---Generic streaming request: calls request(asset, ...) and waits until
---hasLoaded(asset) returns true. Client only.
---@param request fun(asset: any, ...: any)
---@param hasLoaded fun(asset: any): boolean
---@param assetType string Only used for the log message.
---@param asset any
---@param timeout? number Default 30000 ms.
---@param ... any
---@return any asset
function MSK.RequestStreaming(request, hasLoaded, assetType, asset, timeout, ...) end

---Casts a ray forward from the player. Returns the hit entity or false,
---including when nothing was hit. Client only.
---@param distance? number Default 5.0
---@param flag? number|"none"|"all"|"world"|"vehicle"|"ped"|"object"|"water"|"glass"|"river"|"foliage"
---@return number|false entityHit
function MSK.RequestRaycast(distance, flag) end

---Casts a ray between two points, waits at most one second. Client only.
---@param from vector3
---@param to vector3
---@param flags? number Shape test flags, default 511.
---@param ignore? number Default 4.
---@param ignoreEntity? number Entity the ray passes through, defaults to your own ped.
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

---@deprecated Use MSK.FreemodeMessage or MSK.PopupWarning instead.
---@param title string
---@param text string
---@param typ? number 1 = FreemodeMessage, 2 = PopupWarning.
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: number, duration?: number)
function MSK.ScaleformAnnounce(title, text, typ, duration) end

---Checks the resource version against GitHub. Server only.
---@param repo MSKCheckRepo
function MSK.CheckVersion(repo) end

---Server only.
---@param resource string
---@param minimumVersion? string
---@param showMessage? boolean
---@return boolean ok, string currentVersion
function MSK.CheckDependency(resource, minimumVersion, showMessage) end

--------------------------------------------------------------------------------
-- Types for flat functions
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

---GTA sound instead of the NUI sound.
---@class MSKNotifySound
---@field name string
---@field set string
---@field bank? string Audio bank, loaded if needed.

---Everything beyond title, message, type and duration only applies to the MSK UI.
---External adapters (okok, qb-core, bulletin, native, custom) get whatever they understand.
---@class MSKNotifyData
---@field id? string|number A visible notification with the same id is updated.
---@field title? string Without a title the notification is compact.
---@field message string
---@field description? string Replacement for message.
---@field type? MSKNotifyType Default "info".
---@field duration? number Default 5000 ms.
---@field icon? string Overrides the icon of the type.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field position? MSKNotifyPosition Only applies as long as the player has set "Automatic".
---@field showDuration? boolean false hides the progress bar.
---@field sound? boolean|MSKNotifySound false is silent.

-- TextUI, Numpad, Alert, input dialog types and MSKIconAnimation live in
-- types.lua.

---@class MSKNearbyEntity
---@field entity number
---@field coords vector3
---@field distance number

---@class MSKNearbyPlayer
---@field playerId number Local player index.
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
---@field heading? number If coords do not contain a heading.
---@field type? MSKVehicleType If omitted, a client is asked.
---@field plate? string
---@field props? table Vehicle properties, applied by the owning client.
---@field bucket? number Routing bucket.
---@field warp? number Server ID of a player who is put into the driver's seat.
---@field playerId? number Player who is asked for the vehicle type.
