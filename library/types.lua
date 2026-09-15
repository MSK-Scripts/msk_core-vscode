---@meta
--- Data structures and object types of the msk_core library (FiveM).
--- Source: bridge/ and modules/*/ in msk_core 4.1.0

--------------------------------------------------------------------------------
-- Player
--------------------------------------------------------------------------------

---The local player. On the client a 100ms thread keeps the fields up to date,
---in consumer resources it is a read-only view of the same values.
---@class MSKPlayer
---@field clientId number Local player index (PlayerId()).
---@field serverId number Server ID of the player.
---@field playerId number Same as serverId.
---@field ped number Handle of the current ped (PlayerPedId()).
---@field playerPed number Same as ped.
---@field coords vector3 Current position.
---@field heading number Current heading.
---@field state table Statebag of the player.
---@field vehicle number|false Vehicle handle, or false when not in a vehicle.
---@field seat number|false Seat index (-1 = driver), or false.
---@field weapon number|false Hash of the current weapon, or false.
---@field isDead boolean Takes visn_are and osp_ambulance into account if they are started.
---@field Notify fun(title: string, message: string, typ?: MSKNotifyType, duration?: number)
---@field [number] table Access another player by their server ID.
---@overload fun(key: string, val: any, update?: boolean): any Reads or sets a custom field. update propagates it to the core.
local MSKPlayer = {}

---Reads a value of ANOTHER player from the server (Callback, yielding).
---@param playerId number Server ID of the target player.
---@param key? string A single field, if omitted the whole table.
---@return any
function MSKPlayer.Get(playerId, key) end

---Calls cb as soon as a field changes, such as ped, vehicle, seat, weapon,
---isDead or a custom field. Also available as MSK.OnPlayer.
---Client: cb(value, oldValue) for the local player.
---Server: cb(playerId, value, oldValue) for every player.
---Pass the result to RemoveEventHandler to stop listening.
---@param key string
---@param cb fun(value: any, oldValue: any)
---@return table eventData
---@overload fun(key: string, cb: fun(playerId: number, value: any, oldValue: any)): table
function MSKPlayer.OnChange(key, cb) end

--------------------------------------------------------------------------------
-- Shared
--------------------------------------------------------------------------------

---Animations for FontAwesome icons in Context, Menu and TextUI.
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
-- Class
--------------------------------------------------------------------------------

---Methods that every class and every instance reaches at the end of its lookup chain.
---@class MSKClassBase
local MSKClassBase = {}

---Creates an instance. Equivalent to calling the class directly.
---Returns nil if init returns false.
---@param ... any Passed to init.
---@return MSKClassInstance|nil
function MSKClassBase:New(...) end

---Creates a child class that inherits all methods of this class.
---@param name string
---@return MSKClassObject
function MSKClassBase:Extend(name) end

---True if this instance or class is cls or inherits from it.
---@param cls MSKClassObject
---@return boolean
function MSKClassBase:IsA(cls) end

---A class from MSK.Class.New. Methods are defined directly on the table,
---for example function Vehicle:init(model) ... end.
---Always call the parent through the class name (Car.Parent.init), never through
---self.Parent, otherwise three levels deep ends in infinite recursion.
---@class MSKClassObject : MSKClassBase
---@field Name string Name of the class.
---@field Parent? MSKClassObject Parent class, if any.
---@field init? fun(self: MSKClassInstance, ...: any): boolean? Constructor. false rejects the instance.
---@field [string] any
---@overload fun(...: any): MSKClassInstance|nil Creates an instance.

---An instance of a class. Passed through an export it loses its metatable
---and with it its methods, so keep it in the resource that created it.
---@class MSKClassInstance : MSKClassBase
---@field [string] any

--------------------------------------------------------------------------------
-- Hook
--------------------------------------------------------------------------------

---@class MSKHookOptions
---@field priority? number Higher values run first, default 0.

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

---A countdown that can be paused, resumed, stopped and restarted.
---@class MSKTimerInstance
---@field duration number Total duration in milliseconds.
---@field remaining number Remaining time at the last start or pause.
---@field state MSKTimerState
---@field onEnd? fun(timer: MSKTimerInstance)
local MSKTimerInstance = {}

---Starts with the full duration. Does nothing while the timer is running.
---@return boolean started
function MSKTimerInstance:Start() end

---@return boolean paused
function MSKTimerInstance:Pause() end

---@return boolean resumed
function MSKTimerInstance:Resume() end

---Stops the timer. With runOnEnd, onEnd runs as if the time had expired.
---@param runOnEnd? boolean
---@return boolean stopped
function MSKTimerInstance:Stop(runOnEnd) end

---Starts over, optionally with a new duration.
---@param duration? number
function MSKTimerInstance:Restart(duration) end

---Remaining time in unit. Everything except milliseconds is rounded to two decimal places.
---@param unit? MSKTimerUnit Default "ms".
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
-- Print
--------------------------------------------------------------------------------

---@alias MSKPrintLevel
---| "error"
---| "warn"
---| "info"
---| "verbose"
---| "debug"

--------------------------------------------------------------------------------
-- Notify
--------------------------------------------------------------------------------

---The types come from Config.NotifyTypes, custom entries are possible.
---@alias MSKNotifyType string
---| "general"
---| "info"
---| "success"
---| "error"
---| "warning"

--------------------------------------------------------------------------------
-- Alert
--------------------------------------------------------------------------------

---@alias MSKAlertResult
---| "confirm" # Confirmed.
---| "cancel" # Cancelled, via button or Escape.
---| "timeout" # timeout has expired.

---@alias MSKAlertSize
---| "sm"
---| "md"
---| "lg"

---@class MSKAlertLabels
---@field confirm? string Label of the confirm button.
---@field cancel? string Label of the cancel button.

---@class MSKAlertData
---@field header? string Heading. Either header or content must be set.
---@field content? string Text. Line breaks and ~color~ codes work.
---@field size? MSKAlertSize Default "md".
---@field centered? boolean Centers the text.
---@field cancel? boolean false hides the cancel button.
---@field labels? MSKAlertLabels
---@field timeout? number Milliseconds, after which Show returns "timeout".

--------------------------------------------------------------------------------
-- Context (mouse menu with drilldown)
--------------------------------------------------------------------------------

---A line in the tooltip of an option.
---@class MSKContextMetadata
---@field label string
---@field value? any Displayed as text.
---@field progress? number 0 to 100.
---@field colorScheme? string

---@class MSKContextOption
---@field id? string With an options map, the key if not set.
---@field title? string
---@field description? string
---@field icon? string FontAwesome class.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field image? string
---@field arrow? boolean Automatically true when menu is set.
---@field disabled? boolean
---@field readOnly? boolean Entry is visible but cannot be selected.
---@field progress? number Progress bar in the entry, 0 to 100.
---@field colorScheme? string
---@field metadata? (string|MSKContextMetadata)[]|table<string, any> List of texts, list of lines, or a map of label = value.
---@field menu? string ID of the context menu to jump to.
---@field args? any Passed on to onSelect, event and serverEvent.
---@field onSelect? fun(args: any) Does not survive the network.
---@field event? string Client event fired on selection.
---@field serverEvent? string Server event fired on selection.

---@class MSKContextData
---@field id? string Required for Register, optional for Show (then inline).
---@field title? string
---@field options MSKContextOption[]|table<string, MSKContextOption> List, or map by ID (sorted by key).
---@field canClose? boolean Default true.
---@field position? string Default 'center'. Also left, right, top, bottom, top-left and so on.
---@field menu? string Parent menu, creates the back arrow.
---@field onBack? fun() Runs when jumping to the parent menu.
---@field onExit? fun() Runs when closed by the player or by Hide(true).

--------------------------------------------------------------------------------
-- Menu (keyboard, NativeUI style)
--------------------------------------------------------------------------------

---@class MSKMenuValue
---@field label string
---@field description? string

---Runs when an entry is confirmed with Enter.
---@alias MSKMenuCallback fun(selected: number, scrollIndex?: number, args?: any, checked?: boolean)

---@class MSKMenuItem
---@field id? string
---@field label? string
---@field description? string
---@field icon? string
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field disabled? boolean Skipped while navigating.
---@field checked? boolean Turns the entry into a checkbox, Enter toggles it and the menu stays open.
---@field progress? number 0 to 100.
---@field colorScheme? string
---@field values? (string|MSKMenuValue)[] Makes the entry horizontally scrollable.
---@field defaultIndex? number Starting value in values, default 1.
---@field close? boolean false keeps the menu open after confirming.
---@field args? any Passed on to the callbacks.
---@field onSelect? fun(args: any)
---@field event? string Client event on confirm.
---@field serverEvent? string Server event on confirm.

---@class MSKMenuData
---@field id? string Required for Register, optional for Show (then inline).
---@field title? string
---@field position? string Default 'top-left'.
---@field items MSKMenuItem[]
---@field options? MSKMenuItem[] Same as items.
---@field canClose? boolean Default true. false blocks Backspace and Escape.
---@field disableInput? boolean The menu does not react to keys.
---@field startIndex? number Entry the selection starts on.
---@field defaultSelected? number Same as startIndex.
---@field onSelect? MSKMenuCallback Alternative to the cb parameter of Register.
---@field onSelected? fun(selected: number, item: MSKMenuItem, args: any) Selection was moved.
---@field onSideScroll? fun(selected: number, scrollIndex: number, args: any)
---@field onCheck? fun(selected: number, checked: boolean, args: any)
---@field onClose? fun(key: string) key is 'cancel', 'select', 'replace', 'forced' or a custom key from Hide.

--------------------------------------------------------------------------------
-- Radial (client only)
--------------------------------------------------------------------------------

---@class MSKRadialItem
---@field id string Required. The same ID replaces an existing entry.
---@field label string Required.
---@field icon? string Font Awesome name ("car") or class ("fas fa-car").
---@field iconColor? string
---@field menu? string ID of a submenu from Radial.Register that opens on click.
---@field onSelect? fun(menuId: string|nil, index: number) menuId is nil on the top level.
---@field keepOpen? boolean Keeps the menu open after the click.

---@class MSKRadialMenu
---@field id string
---@field title? string
---@field items MSKRadialItem[]

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

---Field type of a dialog row and what it returns.
---@alias MSKInputFieldType string
---| "input" # string
---| "textarea" # string
---| "number" # number
---| "slider" # number, default min 0 and max 100
---| "checkbox" # boolean
---| "select" # value of the selected option
---| "multi-select" # list of option values
---| "color" # '#rrggbb' or '#rrggbbaa'
---| "date" # 'YYYY-MM-DD'
---| "date-range" # { 'YYYY-MM-DD', 'YYYY-MM-DD' }
---| "time" # 'HH:MM'

---@class MSKInputOption
---@field value any
---@field label? string Default tostring(value).

---A row in Input.Dialog.
---@class MSKInputDialogRow
---@field type? MSKInputFieldType Default 'input'.
---@field label? string
---@field id? string The value is also stored under this ID in the result.
---@field description? string
---@field placeholder? string
---@field icon? string
---@field required? boolean For checkbox it must be checked.
---@field disabled? boolean The result is always default, no matter what the client reports.
---@field default? any
---@field min? number|string Number for number and slider, 'YYYY-MM-DD' for date and date-range.
---@field max? number|string
---@field step? number
---@field maxLength? number Only input and textarea.
---@field password? boolean Only input.
---@field options? (MSKInputOption|any)[] Required for select and multi-select. A plain value is shorthand for { value = ... }.

---@class MSKInputDialogOptions
---@field allowCancel? boolean Default true.
---@field size? "sm"|"md"|"lg" Default 'md'.
---@field labels? { confirm?: string, cancel?: string }

--------------------------------------------------------------------------------
-- Numpad
--------------------------------------------------------------------------------

---Why a numpad was not successful.
---@alias MSKNumpadReason string
---| "wrong"
---| "maxAttempts" # Too many failed attempts.
---| "cancelled"
---| "busy" # A numpad was already open.
---| "invalid" # Server only: invalid player ID.
---| "error"

---@class MSKNumpadLabels
---@field enter? string Default 'Enter Code'.
---@field wrong? string Default 'Incorrect'.
---@field attempts? string Default 'Attempts left'.

---@class MSKNumpadOptions
---@field code string|number Digits only. Pass as a string so leading zeros are kept.
---@field masked? boolean Dots instead of digits, default true.
---@field maxAttempts? number Default unlimited.
---@field title? string
---@field labels? MSKNumpadLabels
---@field cb? fun(ok: boolean, reason?: MSKNumpadReason) Client only, alternative to the cb parameter.

---@class MSKNumpadInputOptions
---@field length? number Maximum number of digits, default 4.
---@field minLength? number Default 1.
---@field masked? boolean Default false.
---@field title? string
---@field labels? MSKNumpadLabels
---@field cb? fun(digits?: string, reason?: MSKNumpadReason) Client only, alternative to the cb parameter.

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgressAnimation
---@field dict? string Animation dictionary, loaded automatically.
---@field anim? string Name of the animation inside the dictionary.
---@field clip? string Same as anim.
---@field blendIn? number Default 3.0
---@field blendOut? number Default 1.0
---@field duration? number Default -1 (runs until stopped).
---@field flag? number Default 49
---@field playbackRate? number Default 0
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean
---@field scenario? string Alternative to dict/anim: a scenario instead of an animation.
---@field playEnter? boolean Only with scenario, default true.

---An object attached to the ped for the duration of the progress bar.
---@class MSKProgressProp
---@field model string|number
---@field bone? number Default 60309.
---@field pos? vector3|table Offset from the bone.
---@field rot? vector3|table Rotation relative to the bone.
---@field rotOrder? number Default 0.

---@class MSKProgressDisable
---@field mouse? boolean Blocks mouse movement.
---@field move? boolean Blocks movement.
---@field sprint? boolean Blocks sprinting only (has no effect together with move).
---@field vehicle? boolean Blocks vehicle controls.
---@field car? boolean Same as vehicle.
---@field combat? boolean Blocks attacking and aiming.

---@class MSKProgressData
---@field duration number Duration in milliseconds, default 1000.
---@field text? string Label of the bar.
---@field label? string Same as text.
---@field color? string Color, otherwise Config.ProgressColor.
---@field type? "bar"|"circle" Display style for Progress.Start, default bar.
---@field position? "middle"|"bottom" Default bottom for the bar, middle for the circle.
---@field canCancel? boolean Cancel with X, can be changed in the FiveM key bindings.
---@field forceOverride? boolean Cancels a running progress bar and starts over.
---@field useWhileDead? boolean Keeps running while dead, default false.
---@field useWhileRagdoll? boolean Keeps running while ragdolled, default false.
---@field useWhileCuffed? boolean Keeps running while cuffed, default false.
---@field useWhileFalling? boolean Keeps running while falling, default false.
---@field useWhileSwimming? boolean Keeps running while in water, default false.
---@field allowRagdoll? boolean Same as useWhileRagdoll.
---@field allowCuffed? boolean Same as useWhileCuffed.
---@field allowFalling? boolean Same as useWhileFalling.
---@field allowSwimming? boolean Same as useWhileSwimming.
---@field animation? MSKProgressAnimation
---@field anim? MSKProgressAnimation Same as animation.
---@field prop? MSKProgressProp|MSKProgressProp[] One object or a list of them.
---@field disable? MSKProgressDisable

--------------------------------------------------------------------------------
-- Skillcheck
--------------------------------------------------------------------------------

---@class MSKSkillcheckRound
---@field areaSize? number Size of the hit area in degrees (5 to 180), default 40.
---@field speedMultiplier? number Speed (0.1 to 10), default 1.0.

---@alias MSKSkillcheckPreset
---| "easy" # areaSize 50, speedMultiplier 1.0
---| "medium" # areaSize 40, speedMultiplier 1.5
---| "hard" # areaSize 25, speedMultiplier 1.75

---A preset, a custom round, or a list of them for several rounds in a row.
---@alias MSKSkillcheckDifficulty MSKSkillcheckPreset|MSKSkillcheckRound|(MSKSkillcheckPreset|MSKSkillcheckRound)[]

--------------------------------------------------------------------------------
-- TextUI
--------------------------------------------------------------------------------

---@alias MSKTextUIPosition string
---| "bottom-center"
---| "top-center"
---| "left-center"
---| "right-center"

---@class MSKTextUIData
---@field key? string|false Displayed key, default 'E'. false hides the key box.
---@field text? string Supports GTA color codes like ~g~.
---@field color? string Color of the key box, otherwise Config.TextUIColor.
---@field icon? string FontAwesome icon.
---@field iconColor? string
---@field iconAnimation? MSKIconAnimation
---@field position? MSKTextUIPosition Default 'bottom-center'.

--------------------------------------------------------------------------------
-- Settings (client only)
--------------------------------------------------------------------------------

---@alias MSKSettingKey
---| "locale" # "" = server language, otherwise e.g. "de". Used by MSK.Locale.
---| "notifyPosition" # "" = automatic, otherwise an MSKSettingNotifyPosition.
---| "notifySound" # true or false.

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
-- Keybind (client only)
--------------------------------------------------------------------------------

---@class MSKKeybindData
---@field name string Unique across all resources, no spaces. Becomes the commands +name / -name. Renaming discards the player's key choice.
---@field description string Text in the GTA settings (Key Bindings, FiveM).
---@field defaultKey? string Default key, e.g. "F5".
---@field defaultMapper? string Default "keyboard".
---@field secondaryKey? string Second key.
---@field secondaryMapper? string Defaults to defaultMapper.
---@field disabled? boolean Starts disabled.
---@field allowInPauseMenu? boolean Also triggers in the pause menu, default false.
---@field onPressed? fun(self: MSKKeybind)
---@field onReleased? fun(self: MSKKeybind)

---A registered key binding. Contains all fields that were passed in.
---@class MSKKeybind : MSKKeybindData
---@field defaultMapper string
---@field defaultKey string
---@field disabled boolean
---@field pressed boolean True while the key is held down.
local MSKKeybind = {}

---Disables (true, default) or enables (false) the binding.
---If the key is held down when disabling, onReleased runs.
---@param state? boolean
function MSKKeybind:Disable(state) end

---@return boolean
function MSKKeybind:IsDisabled() end

---True while the key is held down.
---@return boolean
function MSKKeybind:IsPressed() end

---The currently bound key as shown in the settings, e.g. "E" or "F5".
---@return string
function MSKKeybind:GetCurrentKey() end

--------------------------------------------------------------------------------
-- Points
--------------------------------------------------------------------------------

---@class MSKPointProperties
---@field coords vector3|vector4|table Center of the point, converted to vector3.
---@field distance number Radius at which onEnter is triggered.
---@field onEnter? fun(point: MSKPoint)
---@field onExit? fun(point: MSKPoint) Also runs when the point is removed while the player is inside.
---@field onRemove? fun(point: MSKPoint)
---@field nearby? fun(point: MSKPoint) Runs every frame while the player is within the radius.
---@field [string] any Custom fields are kept on the point.

---A registered point. Contains all passed properties plus the
---runtime fields maintained by the point thread.
---@class MSKPoint : MSKPointProperties
---@field id number Sequential ID, assigned by Points.Add.
---@field coords vector3
---@field inside boolean Whether the player is currently within the radius.
---@field currentDistance number|nil Distance to the player, only while inside.
---@field isClosest boolean Whether this is the closest point.
---@field owner string|nil Resource that created the point through the export.
---@field Remove fun() Removes this point, as point.Remove() and point:Remove().

--------------------------------------------------------------------------------
-- Zones (client only)
--------------------------------------------------------------------------------

---@alias MSKZoneShape
---| "sphere"
---| "box"
---| "poly"

---Shared fields of all zone shapes. The table you pass in becomes the
---zone itself, so your own fields are kept.
---@class MSKZoneBaseData
---@field onEnter? fun(zone: MSKZone) Once on entering.
---@field onExit? fun(zone: MSKZone) Once on leaving, also on Remove if the player is inside.
---@field inside? fun(zone: MSKZone) Every frame while the player is inside.
---@field onRemove? fun(zone: MSKZone) After removal.
---@field debug? boolean Draws the zone.
---@field name? string Shows up in error messages from the callbacks.
---@field [any] any

---@class MSKZoneSphereData : MSKZoneBaseData
---@field coords vector3|vector4|table
---@field radius number Must be greater than 0.

---@class MSKZoneBoxData : MSKZoneBaseData
---@field coords vector3|vector4|table Center point.
---@field size? vector3|table Default vec3(2.0, 2.0, 2.0).
---@field rotation? number Rotation in degrees, default 0.0.

---@class MSKZonePolyData : MSKZoneBaseData
---@field points (vector3|table)[] At least three points.
---@field thickness? number Height around the average Z of the points, default 4.0.
---@field minZ? number Overrides the bottom edge calculated from thickness.
---@field maxZ? number Overrides the top edge calculated from thickness.

---A registered zone. Contains all fields that were passed in, plus those
---MSK.Zones calculates on creation.
---@class MSKZone : MSKZoneBaseData
---@field id number Sequential ID, assigned by MSK.Zones.
---@field shape MSKZoneShape
---@field coords vector3 Center point, for poly the center of the bounding box.
---@field radius? number Sphere: radius. Box: half the diagonal.
---@field size? vector3 Box only.
---@field rotation? number Box only.
---@field corners? vector3[] Box only.
---@field points? vector3[] Poly only.
---@field thickness? number Poly only.
---@field minZ? number Poly only.
---@field maxZ? number Poly only.
---@field min? vector3 Poly only, bounding box.
---@field max? vector3 Poly only, bounding box.
local MSKZone = {}

---True if coords lies inside the zone.
---@param coords vector3|table
---@return boolean
function MSKZone:Contains(coords) end

---True while the player is inside the zone.
---@return boolean
function MSKZone:IsInside() end

---@param state boolean
function MSKZone:SetDebug(state) end

---Deletes the zone. If the player is inside, onExit runs first.
function MSKZone:Remove() end

--------------------------------------------------------------------------------
-- Grid
--------------------------------------------------------------------------------

---An entry in the grid. Needs either coords and radius, or min and max
---as an axis-aligned bounding box. Any table with these fields works.
---@class MSKGridEntry
---@field coords? vector3|vector2|table
---@field radius? number
---@field min? vector3|vector2|table
---@field max? vector3|vector2|table
---@field [any] any

---A spatial hash over the X/Y plane.
---@class MSKGridInstance
---@field cellSize number Edge length of a cell.
local MSKGridInstance = {}

---Adds an entry, or re-sorts it if it is already in the grid.
---@generic T : MSKGridEntry
---@param entry T
---@return T entry
function MSKGridInstance:Add(entry) end

---@param entry MSKGridEntry
---@return boolean removed
function MSKGridInstance:Remove(entry) end

---Entries in the cell that contains coords.
---@param coords vector3|vector2|table
---@return MSKGridEntry[]
function MSKGridInstance:GetNearby(coords) end

---Entries of all cells touched by the square around coords with radius.
---No entry appears twice.
---@param coords vector3|vector2|table
---@param radius number
---@return MSKGridEntry[]
function MSKGridInstance:GetInRange(coords, radius) end

---@param entry MSKGridEntry
---@return boolean
function MSKGridInstance:Has(entry) end

---Clears the grid.
function MSKGridInstance:Clear() end

--------------------------------------------------------------------------------
-- Marker (client only)
--------------------------------------------------------------------------------

---Color as named { r, g, b, a } or as a list { 255, 0, 0, 150 }.
---Missing values are 255, alpha 150.
---@alias MSKMarkerColor { r: number, g: number, b: number, a?: number }|number[]

---@class MSKMarkerData
---@field type? number Marker type, default 1.
---@field coords vector3|table
---@field width? number Default 1.0, applies to X and Y.
---@field height? number Default 1.0
---@field color? MSKMarkerColor Default MSK green with alpha 150.
---@field direction? vector3|table
---@field rotation? vector3|table
---@field bobUpAndDown? boolean
---@field faceCamera? boolean
---@field rotate? boolean
---@field textureDict? string
---@field textureName? string

---A marker with settings stored once.
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

---Draws the marker for this frame. Must be called every frame.
function MSKMarkerInstance:Draw() end

---@param coords vector3|table
function MSKMarkerInstance:SetCoords(coords) end

---@param color MSKMarkerColor
function MSKMarkerInstance:SetColor(color) end

---Distance from the marker to coords, or to the player if omitted.
---@param coords? vector3|table
---@return number
function MSKMarkerInstance:GetDistance(coords) end

--------------------------------------------------------------------------------
-- Selector
--------------------------------------------------------------------------------

---Weighted entry, as { value, weight } or { value = x, weight = n }.
---Weights of 0 or less are never picked.
---@alias MSKSelectorWeightedEntry { value: any, weight: number }|{ [1]: any, [2]: number }

---A pool of named sets, for scripts that keep picking from the same lists.
---@class MSKSelectorPool
---@field sets table<string, any[]>
local MSKSelectorPool = {}

---Creates or replaces the set name.
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

---Names of all sets, sorted alphabetically.
---@return string[]
function MSKSelectorPool:Names() end

---Like Selector.Pick on the set name. Errors if the set does not exist.
---@param name string
---@return any value, integer? index
function MSKSelectorPool:Pick(name) end

---@param name string
---@param amount integer
---@param unique? boolean Default true.
---@return any[]
function MSKSelectorPool:PickMany(name, amount, unique) end

---@param name string
---@return any value, integer? index
function MSKSelectorPool:Weighted(name) end

---@param name string
---@param amount integer
---@param unique? boolean Default true.
---@return any[]
function MSKSelectorPool:WeightedMany(name, amount, unique) end

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
-- Anim
--------------------------------------------------------------------------------

---@class MSKAnimOptions
---@field blendIn? number Default 8.0
---@field blendOut? number Default -8.0
---@field duration? number Default -1 (until the animation ends).
---@field flag? number Default 0
---@field rate? number Default 0.0
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean
---@field wait? boolean Blocks until the animation is over. Ignored for an endless loop without duration.

--------------------------------------------------------------------------------
-- Dui (client only)
--------------------------------------------------------------------------------

---@class MSKDuiData
---@field url string Address of the page, for your own files e.g. "nui://my_script/html/screen.html".
---@field width? number Default 1280.
---@field height? number Default 720.

---@alias MSKDuiMouseButton
---| "left"
---| "middle"
---| "right"

---A web page as a game texture. Removed when the resource stops.
---@class MSKDuiInstance
---@field id number
---@field url string
---@field width number
---@field height number
---@field duiObject? number nil after Remove.
---@field duiHandle string
---@field dictName string Name of the runtime TXD.
---@field textureName string Name of the runtime texture.
local MSKDuiInstance = {}

---True once the page has loaded far enough to receive messages.
---@return boolean
function MSKDuiInstance:IsAvailable() end

---@param url string
function MSKDuiInstance:SetUrl(url) end

---Sends a message to the page. It arrives there as a window event
---"message", with the table as event.data.
---@param data table
function MSKDuiInstance:SendMessage(data) end

---Shows the page in place of a game texture.
---@param originalDict string
---@param originalTexture string
function MSKDuiInstance:ReplaceTexture(originalDict, originalTexture) end

---Moves the mouse within the page, in pixels of the page size.
---@param x number
---@param y number
function MSKDuiInstance:MouseMove(x, y) end

---@param button? MSKDuiMouseButton Default "left".
function MSKDuiInstance:MouseDown(button) end

---@param button? MSKDuiMouseButton Default "left".
function MSKDuiInstance:MouseUp(button) end

---@param deltaY number
---@param deltaX? number
function MSKDuiInstance:MouseWheel(deltaY, deltaX) end

---Restores replaced textures and destroys the page.
function MSKDuiInstance:Remove() end

--------------------------------------------------------------------------------
-- Scaleform
--------------------------------------------------------------------------------

---@class MSKScaleformRenderTarget
---@field name string Name of the render target, such as 'tvscreen'.
---@field model? string|number Model that carries the render target, such as 'prop_tv_flat_01'.

---@class MSKScaleformOptions
---@field timeout? number Load timeout in ms, default 30000.
---@field renderTarget? MSKScaleformRenderTarget Draws on a screen in the world instead of your own.

---Argument for Movie:Call. Without a wrapper the Lua type decides: an integer becomes
---int, a decimal float, a boolean bool, a string text. A wrapper lets you
---force the type.
---@alias MSKScaleformArg integer|number|boolean|string|{ int: number }|{ float: number }|{ texture: string }

---@class MSKScaleformArea
---@field x number Center, 0 to 1.
---@field y number
---@field width number
---@field height number

---Object returned by Scaleform.New. After Dispose it can no longer be used, every
---call then throws an error.
---@class MSKScaleformMovie
---@field name string
---@field handle number|nil nil after Dispose.
---@field rendering boolean
local MSKScaleformMovie = {}

---Calls a method of the movie.
---@param method string
---@param ... MSKScaleformArg
function MSKScaleformMovie:Call(method, ...) end

---Calls a method and waits at most one second for its return value.
---@param method string
---@param returnType "int"|"bool"|"string"
---@param ... MSKScaleformArg
---@return integer|boolean|string|nil
function MSKScaleformMovie:CallWithReturn(method, returnType, ...) end

---Draws one frame. Without arguments fullscreen, otherwise at x/y with
---width/height (all 0 to 1).
---@param x? number
---@param y? number
---@param width? number
---@param height? number
function MSKScaleformMovie:Draw(x, y, width, height) end

---Draws the movie every frame in its own thread. With duration
---it stops afterwards and disposes itself, without it runs until Stop or Dispose.
---@param duration? number
---@param area? MSKScaleformArea Fullscreen if omitted.
function MSKScaleformMovie:Render(duration, area) end

---Stops Render. The movie stays loaded and can be rendered again.
function MSKScaleformMovie:Stop() end

---Stops Render and disposes the movie.
function MSKScaleformMovie:Dispose() end

---Draws on a named render target of a model in the world.
---Only a render target registered here is released here as well.
---@param name string
---@param model? string|number
function MSKScaleformMovie:SetRenderTarget(name, model) end

---Releases the render target, the movie draws on the screen again.
function MSKScaleformMovie:ReleaseRenderTarget() end

---Whether Render is currently drawing.
---@return boolean
function MSKScaleformMovie:IsRendering() end

--------------------------------------------------------------------------------
-- VehicleProperties
--------------------------------------------------------------------------------

---Color index or custom color as { r, g, b }.
---@alias MSKVehicleColor number|{ [1]: number, [2]: number, [3]: number }|{ r: number, g: number, b: number }

---Visual state and damage of a vehicle. The field names follow the
---format that ox_lib and QBCore/Qbox store in player_vehicles. When
---applying, the old QBCore names modKit17/19/21/47/49 are accepted as well.
---Fields that are nil are left unchanged by Set.
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
---@field wheels? number Wheel type, set before the wheel mods.
---@field wheelWidth? number
---@field wheelSize? number
---@field windowTint? number
---@field neonEnabled? (boolean|number)[] Four entries: left, right, front, back.
---@field neonColor? { [1]: number, [2]: number, [3]: number }
---@field tyreSmokeColor? { [1]: number, [2]: number, [3]: number }
---@field xenonColor? number|{ [1]: number, [2]: number, [3]: number } Index or custom color.
---@field modFrontWheels? number
---@field modBackWheels? number
---@field modCustomTiresF? boolean|number
---@field modCustomTiresR? boolean|number
---@field livery? number
---@field roofLivery? number
---@field bulletProofTyres? boolean|number Despite the name, the raw "tyres can burst" value, as ox_lib stores it.
---@field driftTyres? boolean Only from game build 2372, otherwise nil.
---@field extras? table<string, number|boolean> Extra ID as string: 0 = on, 1 = off. A boolean means on/off.
---@field windows? number[] IDs of the broken windows.
---@field doors? number[] IDs of the detached doors.
---@field tyres? table<string, number> Wheel index as string: 1 = flat, 2 = on the rim.
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
---@field modKit17? number Old QBCore name for modNitrous, only when applying.
---@field modKit19? number Old QBCore name for modSubwoofer, only when applying.
---@field modKit21? number Old QBCore name for modHydraulics, only when applying.
---@field modKit47? number Old QBCore name for modDoorR, only when applying.
---@field modKit49? number Old QBCore name for modLightbar, only when applying.

--------------------------------------------------------------------------------
-- Command
--------------------------------------------------------------------------------

---@alias MSKCommandParamType string
---| "number"
---| "string" # A single word that is not a number.
---| "longString" # The rest of the line, must be the last parameter.
---| "playerId" # Server ID or 'me'.
---| "player" # Like playerId, but returns the player data.
---| "any"

---@class MSKCommandParam
---@field name string Key under which the value ends up in args.
---@field type? MSKCommandParamType Determines how the argument is parsed.
---@field help? string
---@field optional? boolean No error if the argument is missing.
---@field action? MSKCommandParamType Deprecated, use type instead.
---@field val? boolean Deprecated, use optional instead (val = false means optional).

---@class MSKCommandHotkey
---@field key string Default key, such as 'F5'.
---@field text string Description in the FiveM key bindings.
---@field type? string Input device, default 'keyboard'.

---@class MSKCommandProperties
---@field help? string Description in the chat suggestion.
---@field params? MSKCommandParam[]
---@field restricted? string|string[]|false ACE group(s) allowed to use the command.
---@field showSuggestion? boolean Default true.
---@field allowConsole? boolean Server only, default true.
---@field returnPlayer? boolean Server only: passes the player object instead of the ID.
---@field hotkey? MSKCommandHotkey Client only, not together with params.

--------------------------------------------------------------------------------
-- Cron
--------------------------------------------------------------------------------

---Time specification for Cron.Create. Either an interval (m, h, d, w, can be
---combined) or a time of day (atH, optionally atM and atD).
---@class MSKCronDate
---@field m? number Interval in minutes.
---@field h? number Interval in hours.
---@field d? number Interval in days.
---@field w? number Interval in weeks.
---@field atH? number Hour of the time of day, 0 to 23.
---@field atM? number Minute of the time of day, 0 to 59. On the full hour if omitted.
---@field atD? number Day of the week, 1 = Sunday to 7 = Saturday. Daily if omitted.

---Second argument passed to the callback of Cron.Create.
---@class MSKCronInfo
---@field timestamp number
---@field d number Day of the month, for time-of-day jobs the day of the week (1 = Sunday).
---@field h number
---@field m number

---Second argument passed to the callback of Cron.Schedule.
---@class MSKCronTaskInfo
---@field timestamp number
---@field runs number How many times the task has run, including this run.

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
---@field author string GitHub user or organization.
---@field name string Name of the repository, also the expected resource name.
---@field checkName? boolean|{ notify?: boolean } Warns if the resource was renamed. notify repeats the warning every 5 seconds.
---@field print? boolean Also reports when the resource is up to date.
---@field download? string Link instead of the release page.

--------------------------------------------------------------------------------
-- Logger (server only)
--------------------------------------------------------------------------------

---Tags as key:value pairs: string "a:1,b:2", list { "a:1" } or table { a = 1 }.
---@alias MSKLoggerTags string|string[]|table<string, any>

--------------------------------------------------------------------------------
-- Bridge
--------------------------------------------------------------------------------

---@alias MSKFramework string
---| "ESX"
---| "QBCore"
---| "Qbox"
---| "STANDALONE"

---Detected framework and inventory. Since 4.0.0 a real table in the consumer
---resource as well, before that it turned into a function.
---@class MSKBridge
---@field Framework MSKBridgeFramework
---@field Inventory string Detected inventory system.
---@field PlayerData MSKPlayerData Client only, fetched fresh on every access.
---@field isPlayerLoaded boolean Client only: whether the player is loaded.

---@class MSKBridgeFramework
---@field Type MSKFramework
---@field Events table<string, string> Neutral event names.
---@field Core table Only inside msk_core, not across the export boundary.

---Looks up a player by exactly one of these fields.
---@class MSKPlayerQuery
---@field source? number Server ID.
---@field identifier? string License or identifier.
---@field citizenid? string Same as identifier on QBCore and Qbox.
---@field phone? string Not on ESX.
---@field userId? number Qbox only.

---Job or gang, structured the same way on every framework.
---@class MSKPlayerJob
---@field name string
---@field label string
---@field grade number
---@field gradeName string
---@field gradeLabel string
---@field salary number
---@field isBoss boolean
---@field onDuty boolean

---Player data, identical on ESX, QBCore and Qbox. Without methods, just as
---exports.msk_core:GetPlayerData returns it.
---@class MSKPlayerData
---@field source number|nil Server ID, nil if the player is offline.
---@field identifier string
---@field license string
---@field name string
---@field firstName string
---@field lastName string
---@field dob string
---@field sex "male"|"female"
---@field phone string|nil nil on ESX.
---@field group string
---@field job MSKPlayerJob
---@field jobs table<string, number> The real multijob map on Qbox.
---@field gang MSKPlayerJob|nil nil on ESX.
---@field gangs table<string, number>
---@field money table<string, number> cash, bank, black.
---@field metadata table
---@field position vector3|nil

---Player object: data plus methods. The methods are created in your own
---resource, because functions do not survive the export boundary.
---@class MSKPlayerObject : MSKPlayerData
---@field SetJob fun(name: string, grade?: number): boolean
---@field SetGang fun(name: string, grade?: number): boolean Always false on ESX.
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
---@field CanCarryItem fun(name: string, count?: number, metadata?: table): boolean|nil nil means the inventory cannot check it.
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

---A job or gang definition of the framework, not a player.
---@class MSKJobDefinition
---@field name string
---@field label string
---@field grades MSKJobGrade[] Sorted by grade.

---@class MSKJobGrade
---@field grade number
---@field name string
---@field label string
---@field salary number
---@field isBoss boolean

--------------------------------------------------------------------------------
-- VehicleStore (server only)
--------------------------------------------------------------------------------

---Table and column names of the running framework.
---@class MSKVehicleSchema
---@field table string owned_vehicles on ESX, otherwise player_vehicles.
---@field owner string owner on ESX, citizenid on QBCore and Qbox.
---@field plate string
---@field props string Column holding the vehicle properties.
---@field model string|nil Spawn name, nil on ESX (stored in the props JSON).
---@field hash string|nil QBCore and Qbox only.
---@field stored string stored on ESX, state on QBCore and Qbox.
---@field garage string
---@field type string
---@field job string
---@field storedIn number Value that means "in the garage".
---@field storedOut number

---A vehicle from the framework table, normalized.
---@class MSKVehicleRow
---@field plate string
---@field owner string
---@field model string|number Spawn name, usually a hash on ESX.
---@field props table In the format of the running framework, intentionally not normalized.
---@field stored boolean
---@field garage string|nil
---@field type string|nil
---@field job string|nil
---@field ownerName string|nil Only from Browse().
---@field raw table The unmodified database row.

---@class MSKVehicleInsert
---@field owner string Required.
---@field plate string Required.
---@field model? string|number Required on QBCore and Qbox (spawn name or hash).
---@field props? table
---@field stored? boolean Default true.
---@field garage? string
---@field type? string
---@field job? string
---@field license? string QBCore and Qbox only.

---@class MSKVehicleBrowseOptions
---@field page? number Default 1.
---@field perPage? number Default 25, maximum 100.
---@field query? string Searches plate, owner and character name.
---@field garage? string
---@field type? string
---@field model? string Spawn name.
---@field job? string
---@field owner? string

---@class MSKVehicleBrowseResult
---@field total number
---@field page number
---@field perPage number
---@field vehicles MSKVehicleRow[]
