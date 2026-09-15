---@meta
--- Module namespaces of the msk_core library (FiveM).
--- Accessible as MSK.<Module>, lazy-loaded through import.lua.
---
--- Where client and server differ, the client signature is the main
--- signature and the server signature is an @overload. On the server, almost
--- every UI function takes the target player ID as its first argument.
---
--- TxAdmin and the Zone Creator have no public API. TxAdmin is toggled via
--- Config.TxAdmin, the Zone Creator via the command from
--- Config.ZoneCreator.

--------------------------------------------------------------------------------
-- Math
--------------------------------------------------------------------------------

---@class MSKMath
local Math = {}

---Generates a random string of digits with the given number of digits.
---Also accessible as Math.Number.
---@param length number Number of digits.
---@return string
function Math.Random(length) end

---Alias for Math.Random.
---@param length number
---@return string
function Math.Number(length) end

---Rounds to the given decimal place. Halves round away from zero
---(2.5 becomes 3, -2.5 becomes -3). Negative places round to tens, hundreds
---and so on, Math.Round(1234, -2) returns 1200.
---@param num number
---@param decimal? number Decimal places, default 0. May be negative.
---@return number
function Math.Round(num, decimal) end

---Formats a number with thousands separators.
---@param int number
---@param tag? string Separator, default is a dot.
---@return string
function Math.Comma(int, tag) end

---Limits a value to the range between min and max. Swapped
---bounds are corrected automatically.
---@param value number
---@param min number
---@param max number
---@return number
function Math.Clamp(value, min, max) end

---Linear interpolation: t = 0 returns from, t = 1 returns to. Works
---with numbers and vectors.
---@generic T : number|vector2|vector3|vector4
---@param from T
---@param to T
---@param t number
---@return T
function Math.Lerp(from, to, t) end

---Counterpart to Lerp: where value lies between from and to, as a factor
---(0 at from, 1 at to). If from and to are equal, 0 is returned.
---@param from number
---@param to number
---@param value number
---@return number
function Math.InverseLerp(from, to, value) end

---Maps a value from one range to another, e.g. 0 to 100
---health to 0 to 1000.
---@param value number
---@param inMin number
---@param inMax number
---@param outMin number
---@param outMax number
---@param clamp? boolean Keeps the result within the target range.
---@return number
function Math.Remap(value, inMin, inMax, outMin, outMax, clamp) end

---Converts '#rgb', '#rgba', '#rrggbb' or '#rrggbbaa' (with or without '#') into
---channels from 0 to 255. Alpha is nil if the input has none.
---@param hex string
---@return integer r, integer g, integer b, integer? a
function Math.HexToRgb(hex) end

---Converts color channels from 0 to 255 into '#rrggbb', with a into '#rrggbbaa'.
---Out-of-range values are clamped.
---@param r number
---@param g number
---@param b number
---@param a? number
---@return string
function Math.RgbToHex(r, g, b, a) end

---Reads numbers from a vector, a table ({ x =, y =, z =, w = } or
---{ 1, 2, 3 }) or a string ('1.0, 2, 3' or 'vector3(1.0, 2, 3)').
---@param input any
---@return number ...
function Math.ToScalars(input) end

---A vector2, vector3 or vector4, depending on how many numbers input contains.
---Accepts anything Math.ToScalars understands. With only one number, it is
---returned unchanged.
---@param input any
---@return vector2|vector3|vector4|number
function Math.ToVector(input) end

---Rotation in degrees that tilts an object's up axis onto a surface normal,
---e.g. one from a raycast. The heading stays 0.
---@param normal vector3
---@return vector3
function Math.NormalToRotation(normal) end

---Integer as a hex string with 0x prefix, e.g. 255 to '0xff'.
---@param value number
---@param upper? boolean Uppercase letters ('0xFF').
---@return string
function Math.ToHex(value, upper) end

---Color as vector4(r, g, b, a), red, green and blue from 0 to 255, alpha from
---0 to 1 (default 1). Understands hex ('#rgb', '#rrggbb', '#rrggbbaa'),
---'rgb(255, 0, 0)', 'rgba(255, 0, 0, 0.5)', '255, 0, 0', { r =, g =, b =, a = },
---{ 255, 0, 0 } and vectors. Out-of-range values throw an error.
---@param input string|table|vector3|vector4
---@return vector4
function Math.ToRgba(input) end

--------------------------------------------------------------------------------
-- String
--------------------------------------------------------------------------------

---@class MSKString
local String = {}

---Generates a random string of letters.
---@param length number
---@return string
function String.Random(length) end

---Random string following a pattern, e.g. for license plates or
---phone numbers. 1 = digit, A = uppercase letter, a = lowercase letter,
---. = letter or digit. All other characters stay as they are, ^ makes the
---next character literal ('^1' yields an actual 1).
---With length, the result has exactly that many characters: a shorter pattern is
---repeated, a longer result is cut off.
---@param pattern string E.g. '11AAA111'.
---@param length? number
---@return string
function String.RandomPattern(pattern, length) end

---Checks whether str starts with startStr.
---@param str string
---@param startStr string
---@return boolean
function String.StartsWith(str, startStr) end

---Removes whitespace.
---@param str string
---@param bool? boolean true removes all whitespace, otherwise only leading and trailing.
---@return string
function String.Trim(str, bool) end

---Like Trim, but with the inverted bool semantics from msk_core v2.
---Accessible as MSK.Trim, while exports.msk_core:Trim points to String.Trim.
---@param str string
---@param bool? boolean
---@return string
function String.TrimLegacy(str, bool) end

---Splits a string at the whole delimiter (no pattern matching).
---Empty parts are dropped.
---@param str string
---@param delimiter string Must not be empty.
---@return string[]
function String.Split(str, delimiter) end

--------------------------------------------------------------------------------
-- Table
--------------------------------------------------------------------------------

---@class MSKTable
local Table = {}

---Whether val is contained in tbl. If val is itself a table, one
---shared value is enough.
---@param tbl table
---@param val any May be false, but not nil.
---@return boolean
function Table.Contains(tbl, val) end

---The table as indented JSON. Other values via tostring.
---@param tbl any
---@return string
function Table.Dump(tbl) end

---Recursive output in the style of Lua source code.
---@param tbl any
---@param n? number Indentation depth.
---@return string
function Table.DumpString(tbl, n) end

---Counts all entries, even with non-sequential keys.
---@param tbl table
---@return number
function Table.Size(tbl) end

---First index of val in a list.
---@param tbl table
---@param val any
---@return number index -1 if not found.
function Table.Index(tbl, val) end

---Last index of val in a list.
---@param tbl table
---@param val any
---@return number index -1 if not found.
function Table.LastIndex(tbl, val) end

---First index and value of val in a list.
---@param tbl table
---@param val any
---@return number|nil index, any value
function Table.Find(tbl, val) end

---New list in reverse order.
---@param tbl table
---@return table
function Table.Reverse(tbl) end

---Deep copy of the table, including its metatable.
---@param tbl table
---@return table
function Table.Clone(tbl) end

---Iterator over tbl, sorted by keys.
---@param tbl table
---@param order? fun(tbl: table, a: any, b: any): boolean Custom sort order.
---@return fun(): any, any
function Table.Sort(tbl, order) end

---Read-only view of tbl. Writing throws an error, reading, pairs,
---ipairs and # work as usual. The original table stays
---writable, and the view reflects its changes.
---@param tbl table
---@param deep? boolean Nested tables are returned frozen as well.
---@return table
function Table.Freeze(tbl, deep) end

---Whether tbl is a view created by Table.Freeze.
---@param tbl any
---@return boolean
function Table.IsFrozen(tbl) end

---New table from base, overwritten with the entries from override.
---Neither input is modified.
---@param base table
---@param override table
---@param deep? boolean Nested tables are merged instead of replaced.
---@return table
function Table.Merge(base, override, deep) end

---Deep comparison: same keys and same values, nested
---tables compared by content instead of identity.
---@param a any
---@param b any
---@return boolean
function Table.Matches(a, b) end

---List of all keys.
---@param tbl table
---@return any[]
function Table.Keys(tbl) end

---List of all values.
---@param tbl table
---@return any[]
function Table.Values(tbl) end

---Empties tbl in place and returns it. Unlike assigning a new
---table, every reference sees the empty table.
---@param tbl table
---@return table
function Table.Wipe(tbl) end

--------------------------------------------------------------------------------
-- Array
--------------------------------------------------------------------------------

---Functional helpers for sequences (keys 1..n). No function modifies the
---input, results are plain tables and also survive an export.
---@class MSKArray
local Array = {}

---New list with fn(value, index) applied to every element.
---@param list any[]
---@param fn fun(value: any, index: integer): any
---@return any[]
function Array.Map(list, fn) end

---New list with all elements for which fn returns truthy.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return any[]
function Array.Filter(list, fn) end

---Folds the list into a single value. Without initial, the first element is the
---start value and folding begins at the second.
---@param list any[]
---@param fn fun(accumulator: any, value: any, index: integer): any
---@param initial? any
---@return any
function Array.Reduce(list, fn, initial) end

---First element for which fn is truthy, plus its index.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return any value, integer? index
function Array.Find(list, fn) end

---Index of the first matching element, otherwise nil.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return integer?
function Array.FindIndex(list, fn) end

---True if fn is truthy for at least one element.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return boolean
function Array.Some(list, fn) end

---True if fn is truthy for every element, also for an empty list.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean
---@return boolean
function Array.Every(list, fn) end

---Calls fn for every element. If fn returns false, the loop ends.
---@param list any[]
---@param fn fun(value: any, index: integer): boolean?
function Array.ForEach(list, fn) end

---True if value is an element of the list (plain comparison).
---@param list any[]
---@param value any
---@return boolean
function Array.Includes(list, value) end

---Joins any number of lists into a new one.
---@param ... any[]
---@return any[]
function Array.Concat(...) end

---Slice from from to to, both inclusive. Negative values count from the end,
---the last element is then -1.
---@param list any[]
---@param from? integer
---@param to? integer
---@return any[]
function Array.Slice(list, from, to) end

---List without duplicates, the first occurrence is kept. keyFn defines what counts
---as equal, by default the value itself.
---@param list any[]
---@param keyFn? fun(value: any): any
---@return any[]
function Array.Unique(list, keyFn) end

---Flattens nested lists depth levels deep (default 1, math.huge for all).
---@param list any[]
---@param depth? number
---@return any[]
function Array.Flatten(list, depth) end

---Groups by the key that fn returns: { [key] = { elements } }.
---@param list any[]
---@param fn fun(value: any, index: integer): any
---@return table<any, any[]>
function Array.GroupBy(list, fn) end

---New list in random order (Fisher-Yates).
---@param list any[]
---@return any[]
function Array.Shuffle(list) end

---Splits the list into lists of size elements each. The last one may be shorter.
---@param list any[]
---@param size integer At least 1.
---@return any[][]
function Array.Chunk(list, size) end

---List of numbers from from to to in steps of step.
---@param from number
---@param to number
---@param step? number Default 1, or -1 if from is greater than to. Must not be 0.
---@return number[]
function Array.Range(from, to, step) end

--------------------------------------------------------------------------------
-- Vector
--------------------------------------------------------------------------------

---@class MSKVector
local Vector = {}

---Formats coordinates as 'vector3(...)' or 'vector4(...)'.
---@param coords vector3|vector4|table
---@return string
function Vector.CoordsToString(coords) end

---Turns a vector4 into a vector3, everything else stays unchanged.
---@param vec any
---@return any
function Vector.VectorToVector(vec) end

---Converts a coordinate table into a vector. The heading comes
---from h, w or heading.
---@param coords table
---@param toType "vector3"|"vector4"
---@return vector3|vector4|nil
function Vector.TableToVector(coords, toType) end

---World position of an offset relative to position and heading, e.g.
---a point two meters in front of a vehicle. The offset is (right, forward, up).
---@param coords vector3|vector4|table
---@param rotation number|vector3 Heading in degrees, or a rotation whose z is used.
---@param offset vector3|table
---@return vector3
function Vector.GetRelativeCoords(coords, rotation, offset) end

--------------------------------------------------------------------------------
-- Timeout
--------------------------------------------------------------------------------

---@class MSKTimeout
---@overload fun(ms: number, cb: fun(data: any), data?: any): number Shorthand for Set.
local Timeout = {}

---Runs cb after ms milliseconds.
---@param ms number
---@param cb fun(data: any)
---@param data? any Passed to cb.
---@return number requestId ID for Timeout.Clear.
function Timeout.Set(ms, cb, data) end

---Cancels a pending timeout. Called after it has fired, nothing happens.
---@param requestId number
function Timeout.Clear(requestId) end

---Waits until cb returns a non-nil value. If the time runs out, the
---function throws an error.
---@param timeout number|false|nil Milliseconds, nil means 1000, false waits without limit.
---@param cb fun(): any
---@param errMessage? string Message on timeout.
---@return any
function Timeout.Await(timeout, cb, errMessage) end

--------------------------------------------------------------------------------
-- Timer
--------------------------------------------------------------------------------

---@class MSKTimer
local Timer = {}

---Creates a countdown over duration milliseconds. It starts immediately,
---unless autoStart is false.
---@param duration number At least 0.
---@param onEnd? fun(timer: MSKTimerInstance)
---@param autoStart? boolean
---@return MSKTimerInstance
function Timer.New(duration, onEnd, autoStart) end

--------------------------------------------------------------------------------
-- Cache
--------------------------------------------------------------------------------

---Remembers results under a key. The cache belongs to the resource
---that uses it, other resources cannot see it.
---@class MSKCache
---@overload fun(key: any, fn?: function|any, ttl?: number): any Shorthand for Get.
local Cache = {}

---Returns the cached value. If it is missing or expired, fn runs and
---the result is stored. fn may also be a plain value.
---A nil result is not stored.
---@param key any
---@param fn? function|any
---@param ttl? number Milliseconds. If omitted, the value stays until Clear.
---@return any
function Cache.Get(key, fn, ttl) end

---Stores value under key and replaces the old value.
---@param key any
---@param value any
---@param ttl? number Milliseconds.
function Cache.Set(key, value, ttl) end

---@param key any
---@return boolean
function Cache.Has(key) end

---Removes key, without an argument the entire cache.
---@param key? any
function Cache.Clear(key) end

--------------------------------------------------------------------------------
-- Class
--------------------------------------------------------------------------------

---Small class system. A class is also the metatable of its instances.
---@class MSKClass
---@overload fun(name: string, parent?: MSKClassObject): MSKClassObject Shorthand for New.
local Class = {}

---Creates a new class, optionally as a child of parent.
---@param name string Not empty.
---@param parent? MSKClassObject
---@return MSKClassObject
function Class.New(name, parent) end

---True if value is a class (not an instance).
---@param value any
---@return boolean
function Class.IsClass(value) end

---True if value is an instance of cls or of one of its child classes.
---@param value any
---@param cls MSKClassObject
---@return boolean
function Class.IsInstance(value, cls) end

--------------------------------------------------------------------------------
-- Hook
--------------------------------------------------------------------------------

---Lets other resources step into an action and prevent it. The
---registry lives in msk_core, one per side. Hooks of a resource are removed
---when the resource stops.
---@class MSKHook
local Hook = {}

---Registers a hook. A hook only prevents the action if it returns exactly
---false. If it throws an error, the error is logged and the hook is skipped.
---@param event string Not empty.
---@param cb fun(payload: any): boolean?
---@param options? MSKHookOptions
---@return integer id
function Hook.Register(event, cb, options) end

---Removes a hook. Only the resource that registered it may do this.
---@param id integer
---@return boolean removed
function Hook.Remove(id) end

---Runs all hooks of event by priority. Returns false plus the name
---of the refusing resource as soon as a hook returns false, otherwise true.
---@param event string
---@param payload? any
---@return boolean allowed, string? refusedBy
function Hook.Trigger(event, payload) end

---@param event string
---@return boolean
function Hook.Has(event) end

--------------------------------------------------------------------------------
-- Require
--------------------------------------------------------------------------------

---Loads Lua and JSON files at runtime, from this or another
---resource. Paths: "shared.utils" or "@my_lib/client/helpers.lua". Without a
---slash, dots separate the folders. On the client the file must be listed under files in the
---fxmanifest of the owning resource.
---@class MSKRequire
---@overload fun(path: string): any Shorthand for Load.
local Require = {}

---Runs a Lua file once and caches its return value, like require().
---Without a return value, true is cached. Circular dependencies throw an error.
---@param path string
---@return any
function Require.Load(path) end

---Reads and decodes a JSON file. Not cached.
---@param path string
---@return any
function Require.Json(path) end

---Raw content of a file. The path is used as is, without adding an extension and
---without converting dots into folders.
---@param path string
---@return string
function Require.File(path) end

---Discards a cached Lua module so that Load runs the file again.
---@param path string
---@return boolean dropped
function Require.Unload(path) end

--------------------------------------------------------------------------------
-- Locale
--------------------------------------------------------------------------------

---Translations from locales/<language>.json of the using resource. Nested
---objects become dot keys. Language: SetLanguage, then the
---player setting (client only), then the convar msk:locale, then "en".
---Missing keys fall back to en.json. On the client the
---JSON files must be listed under files in the fxmanifest.
---@class MSKLocale
---@overload fun(key: string, ...: any): string Shorthand for T.
local Locale = {}

---(Re)loads the translations. Without lang, the language is determined again.
---@param lang? string
---@return boolean found Whether a file exists for the language.
function Locale.Load(lang) end

---The translation for key. A table as the only additional argument fills
---${name} placeholders, other arguments go through string.format. ${other.key}
---without a matching table field pulls in another translation. A
---missing key returns the key itself.
---@param key string
---@param ... any
---@return string
function Locale.T(key, ...) end

---A translation from the locales folder of another resource, in the
---language this resource uses. Arguments as with T.
---@param resource string
---@param key string
---@param ... any
---@return string
function Locale.GetFrom(resource, key, ...) end

---Forces a language for this resource. nil returns to automatic selection.
---@param lang? string
function Locale.SetLanguage(lang) end

---@return string
function Locale.GetLanguage() end

---@param key string
---@return boolean
function Locale.Has(key) end

---Copy of all translations of the active language, by dot key.
---@return table<string, string>
function Locale.GetAll() end

--------------------------------------------------------------------------------
-- Print
--------------------------------------------------------------------------------

---Console output with levels, switchable per resource at runtime:
---setr msk:printlevel "warn" or setr msk:printlevel:<resource> "debug".
---Order from quiet to loud: error, warn, info (default), verbose, debug.
---@class MSKPrint
---@overload fun(...: any) Shorthand for Info.
local Print = {}

---@param ... any Tables are printed as JSON.
function Print.Error(...) end

---@param ... any
function Print.Warn(...) end

---@param ... any
function Print.Info(...) end

---@param ... any
function Print.Verbose(...) end

---@param ... any
function Print.Debug(...) end

---Overrides the level for this resource until the next restart.
---nil returns to the convars.
---@param level? MSKPrintLevel
function Print.SetLevel(level) end

---Name of the active level of this resource.
---@return MSKPrintLevel
function Print.GetLevel() end

---True if a message of this level would be printed. Handy to avoid building
---expensive debug strings in the first place.
---@param level MSKPrintLevel
---@return boolean
function Print.IsEnabled(level) end

--------------------------------------------------------------------------------
-- Callback
--------------------------------------------------------------------------------

---@class MSKCallback
local Callback = {}

---Registers a Callback that the other side can call via Trigger.
---The first parameter of cb is the server ID (on the server, that of the
---caller). A Callback belongs to the Resource that registered it: another
---Resource cannot overwrite it, and it disappears when
---its Resource stops. Errors in the handler are answered immediately instead of
---leaving the other side waiting.
---@param eventName string
---@param cb fun(playerId: number, ...): ...
---@return boolean registered false if the name already belongs to another Resource.
function Callback.Register(eventName, cb) end

---Calls a Callback on the other side and waits for the result.
---The wait time is controlled by the convar msk:callbackTimeout (default 5000 ms),
---after which nil is returned and a message is printed to the console. Multiple
---return values with nil in between also arrive intact.
---On the server, returns nil without waiting if the player does not exist.
---@param eventName string
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, ...: any): ...
function Callback.Trigger(eventName, ...) end

---Like Trigger, but the server handler receives a response function instead of
---returning a value: Register(name, function(playerId, cb, ...) end).
---Only the first response counts. Also blocks while waiting. Client only.
---@param eventName string
---@param ... any
---@return any ...
function Callback.TriggerCallback(eventName, ...) end

---Like Trigger, but with its own time limit, for Callbacks that take longer than
---msk:callbackTimeout (database, external requests, dialogs).
---On the server, waiting also ends when the player leaves, then nil is returned.
---Client: TriggerAwait(eventName, timeout, ...).
---Server: TriggerAwait(eventName, playerId, timeout, ...).
---@param eventName string
---@param timeout? number|false Milliseconds, nil or false waits without limit.
---@param ... any
---@return any ...
---@overload fun(eventName: string, playerId: number, timeout?: number|false, ...: any): ...
function Callback.TriggerAwait(eventName, timeout, ...) end

--------------------------------------------------------------------------------
-- Events (server only)
--------------------------------------------------------------------------------

---Serializes the arguments once and sends the same payload to all targets.
---@class MSKEvents
local Events = {}

---Sends eventName to one player, several players or -1 for everyone.
---@param eventName string
---@param targets number|number[]
---@param ... any
function Events.TriggerClients(eventName, targets, ...) end

---IDs of all players whose ped is at most radius away from coords.
---@param coords vector3|table
---@param radius number
---@return number[]
function Events.GetPlayersInRange(coords, radius) end

---Sends eventName to all players within the radius.
---@param eventName string
---@param coords vector3|table
---@param radius number
---@param ... any
---@return number[] targets The players that received the event.
function Events.TriggerClientsInRange(eventName, coords, radius, ...) end

--------------------------------------------------------------------------------
-- Alert
--------------------------------------------------------------------------------

---@class MSKAlert
---@overload fun(data: MSKAlertData): MSKAlertResult|nil Shorthand for Show.
---@overload fun(playerId: number, data: MSKAlertData): MSKAlertResult|nil Shorthand for Show on the server.
local Alert = {}

---Shows a modal dialog and waits for the answer (yielding).
---Returns nil if the dialog was closed by code or replaced by a new
---one. On the server the answer comes from the client, so treat it like any
---other client input.
---@param data MSKAlertData
---@return MSKAlertResult|nil
---@overload fun(playerId: number, data: MSKAlertData): MSKAlertResult|nil
function Alert.Show(data) end

---Closes the open dialog. Client only.
function Alert.Close() end

---Whether a dialog is currently open. Client only.
---@return boolean
function Alert.Active() end

--------------------------------------------------------------------------------
-- Context
--------------------------------------------------------------------------------

---A context menu belongs to the Resource that registered it. When that Resource stops,
---the menu is removed and, if open, closed.
---@class MSKContext
---@overload fun(idOrData: string|MSKContextData) Shorthand for Show.
local Context = {}

---Registers a context menu under an ID. If exactly this menu is open,
---it shows the new version immediately. Client only.
---@param id string
---@param data MSKContextData
---@return MSKContextData|nil entry
function Context.Register(id, data) end

---Opens a context menu, by ID or as an inline definition.
---On the server, the target player ID is prepended. Functions do not survive
---the network, so use event, serverEvent and args there
---or register the menu on the client beforehand.
---@param idOrData string|MSKContextData
---@overload fun(playerId: number, idOrData: string|MSKContextData)
function Context.Show(idOrData) end

---Changes a single entry of a menu (partially). If the menu is open, it is
---updated immediately. Client only.
---@param contextId string
---@param dataId string ID of the option.
---@param updatedData MSKContextOption
function Context.Update(contextId, dataId, updatedData) end

---Closes the context menu.
---@param fireExit? boolean Triggers onExit.
---@overload fun(playerId: number)
function Context.Hide(fireExit) end

---Returns the ID of the open context menu. Client only.
---@return string|nil
function Context.GetOpen() end

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------

---Keyboard menu without NUI focus, the player can keep walking or driving.
---A menu belongs to the Resource that registered it.
---@class MSKMenu
---@overload fun(idOrData: string|MSKMenuData, startIndex?: number) Shorthand for Show.
local Menu = {}

---Registers a menu under an ID. Client only.
---@param id string
---@param data MSKMenuData
---@param cb? MSKMenuCallback Runs when an entry is confirmed with Enter, alternatively data.onSelect.
---@return MSKMenuData|nil entry
function Menu.Register(id, data, cb) end

---Opens a menu, by ID or as an inline definition. An open menu is
---closed first with the key 'replace'.
---On the server, the target player ID is prepended, and functions do not
---survive the network there.
---@param idOrData string|MSKMenuData
---@param startIndex? number Entry the selection starts on.
---@overload fun(playerId: number, idOrData: string|MSKMenuData, startIndex?: number)
function Menu.Show(idOrData, startIndex) end

---Changes a single entry of a menu (partially). Client only.
---@param menuId string
---@param dataId string
---@param updatedData MSKMenuItem
function Menu.Update(menuId, dataId, updatedData) end

---Replaces all entries, or with index only that one. An open menu
---is updated immediately and keeps its selection where possible. Client only.
---@param menuId string
---@param options MSKMenuItem[]|MSKMenuItem List, or a single entry with index.
---@param index? number
function Menu.SetOptions(menuId, options, index) end

---Closes the menu.
---@param key? string|false Passed to onClose, default 'forced'. false closes without onClose.
---@overload fun(playerId: number)
function Menu.Hide(key) end

---Alias for Menu.Hide.
---@param key? string|false
---@overload fun(playerId: number)
function Menu.Close(key) end

---Returns the ID of the open menu. Client only.
---@return string|nil
function Menu.GetOpen() end

--------------------------------------------------------------------------------
-- Radial (client only)
--------------------------------------------------------------------------------

---Radial menu that scripts fill with their own items. Opened via the key from
---Config.Radial. Items and submenus disappear when their resource stops.
---@class MSKRadial
local Radial = {}

---Adds an item or a list of items to the top level.
---An item with an already existing ID replaces the old one.
---@param items MSKRadialItem|MSKRadialItem[]
function Radial.Add(items) end

---Removes a top level item by ID.
---@param id string
---@return boolean removed
function Radial.Remove(id) end

---Removes all top level items that the calling resource created.
function Radial.Clear() end

---Registers a submenu that items open through their menu field.
---@param menu MSKRadialMenu
function Radial.Register(menu) end

---@param id string
function Radial.Unregister(id) end

---Opens the menu. Does nothing if it is disabled or has no items.
function Radial.Show() end

function Radial.Hide() end

---Disables (true, default) or enables (false) the radial menu.
---@param state? boolean
function Radial.Disable(state) end

---@return boolean
function Radial.IsOpen() end

---ID of the open submenu, nil on the top level or when closed.
---@return string|nil
function Radial.GetCurrentId() end

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

---@class MSKInput
---@overload fun(header: string, placeholder?: string, field?: boolean, cb?: fun(value: string|number|nil)): string|number|nil Deprecated, use Input.Dialog instead.
local Input = {}

---Opens the old single-line input field. Without cb the call blocks and
---returns the value, nil on cancel. Numbers are returned as number.
---On the server, the call waits for the input without a time limit.
---@deprecated Use MSK.Input.Dialog instead.
---@param header string
---@param placeholder? string
---@param field? boolean true turns it into a password field.
---@param cb? fun(value: string|number|nil) Receives nil on cancel.
---@return string|number|nil
---@overload fun(playerId: number, header: string, placeholder?: string, field?: boolean): string|number|nil
function Input.Open(header, placeholder, field, cb) end

---Closes the old input field. Anyone waiting on it gets nil.
---@overload fun(playerId: number)
function Input.Close() end

---Whether the old input field is currently open. Client only.
---@return boolean
function Input.Active() end

---Opens a dialog with multiple fields and waits for the input.
---Returns nil on cancel, otherwise the values by row number and
---additionally by id where a row has one. Empty optional fields are nil,
---so read by index instead of using #values. A second dialog replaces
---the first, and anyone waiting on the first gets nil.
---On the server, msk_core validates the client's response again against
---the same rows, so a tampered client cannot get past required fields, limits
---and select options.
---@param header string
---@param rows (MSKInputDialogRow|string)[] A string is shorthand for a text field with that label.
---@param options? MSKInputDialogOptions
---@return table<number|string, any>|nil values
---@overload fun(playerId: number, header: string, rows: (MSKInputDialogRow|string)[], options?: MSKInputDialogOptions): table<number|string, any>|nil
function Input.Dialog(header, rows, options) end

---Closes an open dialog. Anyone waiting on it gets nil.
---@overload fun(playerId: number)
function Input.CloseDialog() end

---Whether a dialog is currently open. Client only.
---@return boolean
function Input.DialogActive() end

--------------------------------------------------------------------------------
-- Numpad
--------------------------------------------------------------------------------

---@class MSKNumpad
---@overload fun(data: MSKNumpadOptions, cb?: fun(ok: boolean, reason?: MSKNumpadReason)): boolean|nil, MSKNumpadReason|nil Shorthand for Open.
local Numpad = {}

---Opens the numpad for code entry. Blocks and returns
---(ok, reason), or calls cb in every case, including on cancel.
---The code never reaches the NUI, the comparison happens in Lua. On the client it still
---sits in the client's memory. For anything of real value, use the
---server form Open(playerId, data), where the code never leaves the server.
---The form Open(pin, showPin, cb) is deprecated, use the table instead.
---@param data MSKNumpadOptions
---@param cb? fun(ok: boolean, reason?: MSKNumpadReason)
---@return boolean|nil ok, MSKNumpadReason|nil reason
---@overload fun(pin: string|number, showPin?: boolean, cb?: fun(ok: boolean, reason?: MSKNumpadReason)): boolean|nil, MSKNumpadReason|nil
---@overload fun(playerId: number, data: MSKNumpadOptions): boolean, MSKNumpadReason|nil
---@overload fun(playerId: number, pin: string|number, showPin?: boolean): boolean, MSKNumpadReason|nil
function Numpad.Open(data, cb) end

---Asks for digits without comparing them to a code, e.g. for your
---own check on the server. Returns the digits as a string, nil on
---cancel. On the server the digits come from the client, so validate them yourself.
---@param data? MSKNumpadInputOptions
---@param cb? fun(digits?: string, reason?: MSKNumpadReason)
---@return string|nil digits, MSKNumpadReason|nil reason
---@overload fun(playerId: number, data?: MSKNumpadInputOptions): string|nil, MSKNumpadReason|nil
function Numpad.Input(data, cb) end

---Closes the numpad. Anyone waiting gets the reason 'cancelled'.
---@overload fun(playerId: number)
function Numpad.Close() end

---Whether a numpad is currently open. Client only.
---@return boolean
function Numpad.Active() end

--------------------------------------------------------------------------------
-- Progress
--------------------------------------------------------------------------------

---@class MSKProgress
---@overload fun(data: MSKProgressData): boolean Shorthand for Start.
local Progress = {}

---Starts a progress bar and waits for it to end. Returns true if it
---completed, false on cancel, interruption, or if one is already
---running (unless forceOverride is set).
---The form Start(duration, text, color) is deprecated: it does not wait and
---returns nothing, pass the table instead.
---On the server the client reports the result, so before granting rewards
---check yourself whether the action was plausible.
---@param data MSKProgressData
---@return boolean finished
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function Progress.Start(data) end

---Like Start, but displayed as a circle. The form with individual values is deprecated.
---@param data MSKProgressData
---@return boolean finished
---@overload fun(duration: number, text?: string, color?: string)
---@overload fun(playerId: number, data: MSKProgressData): boolean|nil
---@overload fun(playerId: number, duration: number, text?: string, color?: string)
function Progress.Circle(data) end

---Cancels a running progress bar.
---@overload fun(playerId: number)
function Progress.Stop() end

---Whether a progress bar is currently running, plus its data. Client only.
---@return boolean active, MSKProgressData|nil data
function Progress.Active() end

--------------------------------------------------------------------------------
-- Skillcheck
--------------------------------------------------------------------------------

---@class MSKSkillcheck
---@overload fun(difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean Shorthand for Start.
---@overload fun(playerId: number, difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean Shorthand for Start on the server.
local Skillcheck = {}

---Starts a skill check and waits for the result (yielding). true only
---if every round was passed. If one is already running, false is returned immediately.
---The result is reported by the client, so do not let it decide alone about money or items.
---@param difficulty? MSKSkillcheckDifficulty Default "easy".
---@param inputs? string[] Keys to pick from each round, default { "e" }.
---@return boolean passed
---@overload fun(playerId: number, difficulty?: MSKSkillcheckDifficulty, inputs?: string[]): boolean
function Skillcheck.Start(difficulty, inputs) end

---Ends a running skill check as failed. Client only.
function Skillcheck.Cancel() end

---Whether a skill check is currently running. Client only.
---@return boolean
function Skillcheck.Active() end

--------------------------------------------------------------------------------
-- TextUI
--------------------------------------------------------------------------------

---The TextUI belongs to the Resource that showed it, and disappears
---when that Resource stops.
---@class MSKTextUI
---@overload fun(data: MSKTextUIData) Shorthand for Show.
local TextUI = {}

---Shows the TextUI. If it is already open, it is updated, and with
---the same data nothing happens. This makes calling it in a loop
---safe.
---The form Show(key, text, color) is deprecated, use the table instead.
---@param data MSKTextUIData
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.Show(data) end

---For calls every frame: hides itself about 100 ms after the last
---call. The form with individual values is deprecated.
---@param data MSKTextUIData
---@overload fun(key: string, text: string, color?: string)
---@overload fun(playerId: number, data: MSKTextUIData)
---@overload fun(playerId: number, key: string, text: string, color?: string)
function TextUI.ShowThread(data) end

---Hides the TextUI.
---@overload fun(playerId: number)
function TextUI.Hide() end

---Whether the TextUI is visible, plus a copy of its data. Client only.
---@return boolean open, MSKTextUIData|nil data
function TextUI.Active() end

--------------------------------------------------------------------------------
-- Clipboard (client only)
--------------------------------------------------------------------------------

---@class MSKClipboard
local Clipboard = {}

---Copies text to the player's clipboard.
---@param text string|number
function Clipboard.Set(text) end

--------------------------------------------------------------------------------
-- Controls (client only)
--------------------------------------------------------------------------------

---Disables controls without your own Wait(0) loop. Disabling is
---counted: two places that lock the same control must both
---release it again.
---@class MSKControls
local Controls = {}

---Disables the given controls (numbers or lists of numbers).
---@param ... number|number[]
function Controls.Disable(...) end

---Reverts one Disable per given control.
---@param ... number|number[]
function Controls.Enable(...) end

---Releases the controls regardless of the counter. Without arguments, all controls
---of this resource.
---@param ... number|number[]
function Controls.Clear(...) end

---@param control number
---@return boolean
function Controls.IsDisabled(control) end

---All controls this resource is currently locking, sorted.
---@return number[]
function Controls.GetDisabled() end

--------------------------------------------------------------------------------
-- Keybind (client only)
--------------------------------------------------------------------------------

---@class MSKKeybindModule
local Keybind = {}

---Creates a key binding that the player can change in the GTA settings.
---Errors if the name already exists.
---@param data MSKKeybindData
---@return MSKKeybind
function Keybind.Add(data) end

---@param name string
---@return MSKKeybind|nil
function Keybind.Get(name) end

---All bindings of this resource, by name.
---@return table<string, MSKKeybind>
function Keybind.GetAll() end

--------------------------------------------------------------------------------
-- Settings (client only)
--------------------------------------------------------------------------------

---Per-player settings, stored locally via resource KVP. Changes
---trigger the event msk_core:settingChanged (key, value).
---@class MSKSettings
local Settings = {}

---One setting, without key a copy of all of them.
---@param key? MSKSettingKey
---@return any
---@overload fun(): MSKSettingsValues
function Settings.Get(key) end

---Copy of all settings.
---@return MSKSettingsValues
function Settings.GetAll() end

---Changes a setting. false if the value is not valid for it.
---Errors on an unknown key.
---@param key MSKSettingKey
---@param value any
---@return boolean changed
function Settings.Set(key, value) end

---Opens the settings menu.
function Settings.Open() end

--------------------------------------------------------------------------------
-- Coords
--------------------------------------------------------------------------------

---@class MSKCoords
local Coords = {}

---Shows the coordinates display. On the client, a second
---call turns it off again.
---@overload fun(playerId: number)
function Coords.Show() end

---Hides the coordinates display.
---@overload fun(playerId: number)
function Coords.Hide() end

---Whether the coordinates display is active. Also accessible as MSK.DoesShowCoords.
---@return boolean
---@overload fun(playerId: number): boolean|nil
function Coords.Active() end

---Copies coordinates to the clipboard, rounded to two decimal places.
---On the server, the position of targetId, otherwise that of playerId.
---@param coords? vector3|vector4 If omitted, your own position.
---@overload fun(playerId: number, targetId?: number)
function Coords.Copy(coords) end

--------------------------------------------------------------------------------
-- Points (client only)
--------------------------------------------------------------------------------

---All Points are measured every 250 ms. Points with a nearby Callback are
---additionally measured every frame while the player is inside. Errors in
---Callbacks no longer end the thread. Points of a stopped Resource
---are removed without running Callbacks.
---@class MSKPoints
local Points = {}

---Creates a Point that triggers onEnter and onExit within its radius.
---@param properties MSKPointProperties
---@return MSKPoint|nil
function Points.Add(properties) end

---Removes a Point. If the player was inside, onExit runs first.
---@param pointId number
---@return boolean
function Points.Remove(pointId) end

---All Points by ID.
---@return table<number, MSKPoint>
function Points.GetAllPoints() end

---@return MSKPoint|nil
function Points.GetClosestPoint() end

---All Points the player is currently inside, closest first.
---@return MSKPoint[]
function Points.GetNearbyPoints() end

--------------------------------------------------------------------------------
-- Zones (client only)
--------------------------------------------------------------------------------

---Areas that react on enter and exit. Checked four times
---per second against the player's grid cell. Zones belong to the resource
---that created them.
---@class MSKZones
local Zones = {}

---@param data MSKZoneSphereData
---@return MSKZone
function Zones.Sphere(data) end

---@param data MSKZoneBoxData
---@return MSKZone
function Zones.Box(data) end

---@param data MSKZonePolyData
---@return MSKZone
function Zones.Poly(data) end

---All zones of this resource, by ID.
---@return table<number, MSKZone>
function Zones.GetAll() end

---The zones the player is currently inside.
---@return MSKZone[]
function Zones.GetInside() end

---@param id number
---@return boolean removed
function Zones.Remove(id) end

--------------------------------------------------------------------------------
-- Grid
--------------------------------------------------------------------------------

---Spatial hash over the X/Y plane. Foundation of MSK.Zones.
---@class MSKGrid
local Grid = {}

---Creates a grid with cells of edge length cellSize.
---@param cellSize? number Greater than 0, default 250.
---@return MSKGridInstance
function Grid.New(cellSize) end

--------------------------------------------------------------------------------
-- Marker (client only)
--------------------------------------------------------------------------------

---@class MSKMarker
local Marker = {}

---Creates a marker with fixed settings. Draw it with marker:Draw() every frame.
---@param data MSKMarkerData
---@return MSKMarkerInstance
function Marker.New(data) end

---Draws a marker for this frame only, without keeping an object.
---@param data MSKMarkerData
function Marker.Draw(data) end

--------------------------------------------------------------------------------
-- Selector
--------------------------------------------------------------------------------

---Random selection from lists, with or without weighting.
---@class MSKSelector
local Selector = {}

---A random element plus its index. nil for an empty list.
---@param list any[]
---@return any value, integer? index
function Selector.Pick(list) end

---amount random elements. With unique (default true) no element is
---drawn twice, so the result is at most as long as the list.
---@param list any[]
---@param amount integer
---@param unique? boolean
---@return any[]
function Selector.PickMany(list, amount, unique) end

---A random value where each entry is drawn according to its share of the total weight.
---@param entries MSKSelectorWeightedEntry[]
---@return any value, integer? index
function Selector.Weighted(entries) end

---amount weighted draws. With unique (default true) an entry leaves
---the pool once it is drawn.
---@param entries MSKSelectorWeightedEntry[]
---@param amount integer
---@param unique? boolean
---@return any[]
function Selector.WeightedMany(entries, amount, unique) end

---Creates a pool of named sets, optionally prefilled with { [name] = entries }.
---@param sets? table<string, any[]>
---@return MSKSelectorPool
function Selector.New(sets) end

--------------------------------------------------------------------------------
-- Request (client only)
--------------------------------------------------------------------------------

---All loaders wait up to 30000 ms by default and throw an error
---if the asset has not loaded by then.
---@class MSKRequest
---@overload fun(request: function, hasLoaded: function, assetType: string, asset: any, timeout?: number, ...: any): any Shorthand for Streaming.
local Request = {}

---Generic streaming loader. Base of the other Request functions.
---@param request function Native that starts loading.
---@param hasLoaded function Native that checks the loading state.
---@param assetType string Label used in messages.
---@param asset any
---@param timeout? number Default 30000 ms.
---@param ... any Additional arguments for request.
---@return any asset
function Request.Streaming(request, hasLoaded, assetType, asset, timeout, ...) end

---@param scaleformName string
---@param timeout? number Default 30000 ms.
---@return number handle
function Request.ScaleformMovie(scaleformName, timeout) end

---@param animDict string
---@param timeout? number Default 30000 ms.
---@return string animDict
function Request.AnimDict(animDict, timeout) end

---@param model string|number
---@param timeout? number Default 30000 ms.
---@return number hash
function Request.Model(model, timeout) end

---@param animSet string
---@param timeout? number Default 30000 ms.
---@return string
function Request.AnimSet(animSet, timeout) end

---@param ptFxName string
---@param timeout? number Default 30000 ms.
---@return string
function Request.PtfxAsset(ptFxName, timeout) end

---@param textureDict string
---@param timeout? number Default 30000 ms.
---@return string
function Request.TextureDict(textureDict, timeout) end

---Loads a script audio bank. Keeps requesting until it is loaded.
---@param audioBank string
---@param timeout? number Default 30000 ms.
---@return string
function Request.AudioBank(audioBank, timeout) end

---Loads the model and animations of a weapon, e.g. before a ped gets a weapon
---it has never had.
---@param weapon string|number
---@param flags? number Default 31 (everything).
---@param extraComponents? number
---@param timeout? number Default 30000 ms.
---@return number weaponHash
function Request.WeaponAsset(weapon, flags, extraComponents, timeout) end

---Line from the player forward. A miss is also a result and
---no longer throws an error.
---@param distance? number Default 5.0.
---@param flag? number|MSKRaycastFlag Default everything.
---@return number|false entityHit Hit entity, or false.
function Request.Raycast(distance, flag) end

---Ray from the camera in the view direction, waits at most one second.
---@param flags? number Shape test flags, default 511 (everything).
---@param ignore? number Default 4.
---@param distance? number Default 10.0.
---@return boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.CameraRaycast(flags, ignore, distance) end

---Ray between two points, waits at most one second.
---@param from vector3
---@param to vector3
---@param flags? number Shape test flags, default 511 (everything).
---@param ignore? number Default 4.
---@param ignoreEntity? number Entity the ray passes through, default is your own ped.
---@return boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.RaycastFromCoords(from, to, flags, ignore, ignoreEntity) end

---Starts a camera raycast without waiting. For code that runs every frame
---and must not yield. Fetch the result with Request.ReadRaycast.
---@param flags? number Default 511.
---@param ignore? number Default 4.
---@param distance? number Default 10.0.
---@return number handle, vector3 destination
function Request.StartCameraRaycast(flags, ignore, distance) end

---Result of a raycast started with StartCameraRaycast. done is false
---while it is still running, and then the other values are missing.
---@param handle number
---@return boolean done, boolean hit, number entityHit, vector3 endCoords, vector3 surfaceNormal, number materialHash
function Request.ReadRaycast(handle) end

--------------------------------------------------------------------------------
-- Anim (client only)
--------------------------------------------------------------------------------

---@class MSKAnim
---@overload fun(ped: number|nil, dict: string, clip: string, options?: MSKAnimOptions) Shorthand for Play.
local Anim = {}

---Plays an animation and takes care of loading and releasing the dictionary.
---@param ped? number nil is your own ped.
---@param dict string
---@param clip string
---@param options? MSKAnimOptions
function Anim.Play(ped, dict, clip, options) end

---@param ped? number nil is your own ped.
---@param dict string
---@param clip string
---@param blendOut? number Default 1.0
function Anim.Stop(ped, dict, clip, blendOut) end

---@param ped? number nil is your own ped.
---@param dict string
---@param clip string
---@return boolean
function Anim.IsPlaying(ped, dict, clip) end

---Starts a scenario in place, e.g. "WORLD_HUMAN_SMOKING".
---@param ped? number nil is your own ped.
---@param scenario string
---@param playEnter? boolean Default true.
function Anim.Scenario(ped, scenario, playEnter) end

---Stops everything the ped is currently doing, including animations and scenarios.
---@param ped? number nil is your own ped.
---@param immediately? boolean Instantly instead of with a transition.
function Anim.Clear(ped, immediately) end

--------------------------------------------------------------------------------
-- Dui (client only)
--------------------------------------------------------------------------------

---@class MSKDui
local Dui = {}

---Renders a web page into a game texture. Every DUI of a resource is removed
---when the resource stops.
---@param data MSKDuiData
---@return MSKDuiInstance
function Dui.New(data) end

--------------------------------------------------------------------------------
-- Scaleform
--------------------------------------------------------------------------------

---@class MSKScaleform
local Scaleform = {}

---Shows any Scaleform fullscreen and releases it afterwards. Client only.
---@param scaleform number Handle from Request.ScaleformMovie.
---@param duration? number Default 5000 ms.
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

---Also accessible as MSK.ScaleformAnnounce.
---@deprecated Use Scaleform.FreemodeMessage or Scaleform.PopupWarning instead.
---@param title string
---@param text string
---@param typ? 1|2 1 = FreemodeMessage, 2 = PopupWarning.
---@param duration? number
---@overload fun(playerId: number, title: string, text: string, typ?: 1|2, duration?: number)
function Scaleform.ScaleformAnnounce(title, text, typ, duration) end

---Loads any Scaleform movie and returns an object for it.
---The movie lives in the Resource that created it. Call Dispose when done
---or use Render with a duration. Client only.
---@param name string E.g. 'MP_BIG_MESSAGE_FREEMODE'.
---@param options? number|MSKScaleformOptions Load timeout in ms, or an options table.
---@return MSKScaleformMovie
function Scaleform.New(name, options) end

--------------------------------------------------------------------------------
-- VehicleProperties
--------------------------------------------------------------------------------

---@class MSKVehiclePropertiesModule
local VehicleProperties = {}

---The properties of a vehicle, nil if it does not exist. Client only.
---@param vehicle number
---@return MSKVehicleProperties|nil
function VehicleProperties.Get(vehicle) end

---Applies properties. Fields that are nil stay unchanged. With
---fixVehicle the vehicle is repaired first and the stored damage is skipped.
---On the client it only takes effect for the owner of the vehicle. On the server
---the properties go into a state bag and the owning client applies them.
---@param vehicle number Client: entity handle. Server: server entity handle.
---@param props MSKVehicleProperties
---@param fixVehicle? boolean
---@return boolean applied On the server: written to the state bag.
function VehicleProperties.Set(vehicle, props, fixVehicle) end

--------------------------------------------------------------------------------
-- Cron (server only)
--------------------------------------------------------------------------------

---Jobs and tasks of a Resource are removed when it stops. Times are
---the server's local time.
---@class MSKCron
local Cron = {}

---Creates a cron job. Also accessible as MSK.CreateCron.
---With m, h, d or w the job repeats at that interval, with atH and
---atM at a time of day, optionally on a weekday. A timestamp runs
---once. For new scripts, Cron.Schedule with a cron expression is the more flexible choice.
---@param date MSKCronDate|number Interval, time of day or Unix timestamp.
---@param data any Passed to cb.
---@param cb fun(uniqueId: number, data: any, info: MSKCronInfo)
---@return number|nil uniqueId ID for Cron.Delete, nil on invalid arguments.
function Cron.Create(date, data, cb) end

---Deletes a job from Cron.Create. Also accessible as MSK.DeleteCron.
---@param id number
---@return boolean|nil found nil if the ID is unknown.
function Cron.Delete(id) end

---Runs cb whenever a cron expression matches. Five fields: minute (0-59),
---hour (0-23), day of month (1-31), month (1-12 or jan-dec), weekday
---(0-7 or sun-sat, 0 and 7 are Sunday). Each field supports *, values,
---ranges (1-5), lists (1,15,30) and steps (*/10, 8-18/2). Plus the
---macros @yearly, @annually, @monthly, @weekly, @daily, @midnight and @hourly.
---If day of month and weekday are both restricted, matching either one is enough.
---If cb returns false, the task is removed.
---An invalid expression throws an error.
---@param expression string E.g. '*/15 * * * *' or '0 20 * * fri'.
---@param cb fun(id: number, info: MSKCronTaskInfo): boolean?
---@return number id ID for Unschedule and GetNextRun.
function Cron.Schedule(expression, cb) end

---Removes a task from Cron.Schedule.
---@param id number
---@return boolean removed
function Cron.Unschedule(id) end

---Timestamp of the next run, for a task ID or an expression.
---@param idOrExpression number|string
---@return number|nil timestamp nil for an unknown ID or invalid expression.
function Cron.GetNextRun(idOrExpression) end

---Validates a cron expression without creating anything.
---@param expression string
---@return boolean valid, string|nil reason
function Cron.IsValid(expression) end

--------------------------------------------------------------------------------
-- Check (server only)
--------------------------------------------------------------------------------

---@class MSKCheck
---@overload fun(repo: MSKCheckRepo) Shorthand for Version.
local Check = {}

---Compares the version of the calling Resource with the latest
---GitHub release. An unexpected response from GitHub (rate limit, no
---release) results in a message instead of an error.
---@param repo MSKCheckRepo
function Check.Version(repo) end

---Checks whether another Resource meets the minimum version. A Resource
---without a readable version (including a missing one) does not meet it. Missing
---version parts count as 0.
---@param resource string
---@param minimumVersion string E.g. '4.1.0'.
---@param showMessage? boolean Prints the error message to the console.
---@return boolean ok, string|nil errMsg
function Check.Dependency(resource, minimumVersion, showMessage) end

--------------------------------------------------------------------------------
-- Files (server only)
--------------------------------------------------------------------------------

---@class MSKFiles
local Files = {}

---Names of the files (no folders) directly in path of the resource, sorted
---alphabetically. Paths containing quotes, $, backticks or .. are rejected.
---@param resource? string Defaults to the calling resource.
---@param path string Folder relative to the resource root.
---@param pattern? string Lua pattern the name must match.
---@return string[]
function Files.List(resource, path, pattern) end

--------------------------------------------------------------------------------
-- Logger (server only)
--------------------------------------------------------------------------------

---Sends log entries in batches to Grafana Loki, Datadog or Fivemanage.
---Configured via convars (set msk:logger "loki" etc.), always with set, never with
---setr, otherwise the API key ends up on every client.
---@class MSKLogger
local Logger = {}

---Queues an entry. For a player, the name and
---all identifiers except the IP are added.
---@param source? number Player ID, 0 or nil for the server.
---@param event string Short, machine-readable name, e.g. "shop:purchase".
---@param message string
---@param extra? table Additional, JSON-serializable data.
---@param tags? MSKLoggerTags
---@return boolean queued false if no log service is configured.
function Logger.Log(source, event, message, extra, tags) end

---True if a log service is configured and entries are being sent.
---@return boolean
function Logger.IsEnabled() end

--------------------------------------------------------------------------------
-- Society (server only)
--------------------------------------------------------------------------------

---Since 4.0.0, society accounts follow the banking Resource, not the framework:
---Renewed-Banking, qb-banking, qb-management or esx_addonaccount. If none is
---found, msk_core no longer remembers that since 4.1.0, so a banking Resource
---started later is still detected.
---@class MSKSociety
local Society = {}

---Which banking Resource was detected, nil if none is running.
---@return string|nil
function Society.GetProvider() end

---@param society string Name of the society account without the society_ prefix.
---@return number
function Society.GetMoney(society) end

---@param society string
---@param amount number Rounded down, must be greater than 0.
---@return boolean
function Society.AddMoney(society, amount) end

---@param society string
---@param amount number Rounded down, must be greater than 0.
---@return boolean removed false if the account does not have enough.
function Society.RemoveMoney(society, amount) end

--------------------------------------------------------------------------------
-- Offline (server only)
--------------------------------------------------------------------------------

---If the player is online after all, the bank functions go through the
---framework since 4.1.0. Writing directly to the database would have let the framework's
---next save overwrite the change.
---@class MSKOffline
local Offline = {}

---Reads a player's bank balance.
---@param identifier string
---@return number|nil bank nil if the player does not exist.
function Offline.GetBank(identifier) end

---@param identifier string
---@param amount number Rounded down, must be greater than 0.
---@return boolean
function Offline.AddBank(identifier, amount) end

---@param identifier string
---@param amount number Rounded down, must be greater than 0.
---@return boolean removed false if the account does not have enough.
function Offline.RemoveBank(identifier, amount) end

---Character table of the running framework plus key column.
---ESX: users/identifier. QBCore and Qbox: players/citizenid.
---@return { table: string, identifier: string }|nil
function Offline.GetPlayerTable() end

--------------------------------------------------------------------------------
-- VehicleStore (server only)
--
-- A layer over the vehicle table of the running framework. The
-- vehicle properties deliberately stay in the framework format, because every other
-- garage on the server reads the same column.
--------------------------------------------------------------------------------

---@class MSKVehicleStore
local VehicleStore = {}

---Table and column names of the running framework, as a copy.
---Call outside of a thread, otherwise the first query still runs against
---the built-in fallback.
---@return MSKVehicleSchema|nil
function VehicleStore.GetSchema() end

---@param plate string
---@return MSKVehicleRow|nil
function VehicleStore.GetByPlate(plate) end

---@param plate string
---@return number
function VehicleStore.CountByPlate(plate) end

---Creates a vehicle. On QBCore and Qbox, model is required, without model
---or without a derivable hash false is returned instead of writing
---a broken row.
---@param data MSKVehicleInsert
---@return boolean
function VehicleStore.Insert(data) end

---Updates individual fields. The keys are the unified
---names (owner, garage, type, job, stored, props), not the column names.
---@param plate string
---@param fields table
---@return boolean
function VehicleStore.Update(plate, fields) end

---Writes an actual NULL into the job column. Update skips nil values.
---@param plate string
---@return boolean
function VehicleStore.ClearJob(plate) end

---@param plate string
---@return boolean true only if a row was actually removed.
function VehicleStore.Delete(plate) end

---Paginated and filtered in SQL.
---@param opts MSKVehicleBrowseOptions
---@return MSKVehicleBrowseResult
function VehicleStore.Browse(opts) end
