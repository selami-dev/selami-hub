--ldstrng
--[[
	local Janitor = loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Util/Janitor.lua'))()
]]

--!optimize 2
--!strict

-- Compiled with L+ C Edition
-- Janitor
-- Original by Validark
-- Modifications by pobammer
-- roblox-ts support by OverHash and Validark
-- LinkToInstance fixed by Elttob.
-- Cleanup edge cases fixed by codesenseAye.

local LinkToInstanceIndex = setmetatable({}, {
	__tostring = function()
		return "LinkToInstanceIndex"
	end;
})

local INVALID_METHOD_NAME =
	"Object is a %* and as such expected `true?` for the method name and instead got %*. Traceback: %*"
local METHOD_NOT_FOUND_ERROR = "Object %* doesn't have method %*, are you sure you want to add it? Traceback: %*"
local NOT_A_PROMISE = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %* (%*)) Traceback: %*"

export type Janitor = typeof(setmetatable(
	{} :: {
		CurrentlyCleaning: boolean,
		SuppressInstanceReDestroy: boolean,

		Add: <T>(self: Janitor, object: T, methodName: BooleanOrString?, index: any?) -> T,
		AddObject: <T, A...>(
			self: Janitor,
			constructor: {new: (A...) -> T},
			methodName: BooleanOrString?,
			index: any?,
			A...
		) -> T,

		Remove: (self: Janitor, index: any) -> Janitor,
		RemoveNoClean: (self: Janitor, index: any) -> Janitor,

		RemoveList: (self: Janitor, ...any) -> Janitor,
		RemoveListNoClean: (self: Janitor, ...any) -> Janitor,

		Get: (self: Janitor, index: any) -> any?,
		GetAll: (self: Janitor) -> {[any]: any},

		Cleanup: (self: Janitor) -> (),
		Destroy: (self: Janitor) -> (),

		LinkToInstance: (self: Janitor, Object: Instance, allowMultiple: boolean?) -> RBXScriptConnection,
		LinkToInstances: (self: Janitor, ...Instance) -> Janitor,
	},
	{} :: {__call: (self: Janitor) -> ()}
))
type Private = typeof(setmetatable(
	{} :: {
		CurrentlyCleaning: boolean,
		SuppressInstanceReDestroy: boolean,

		-- Private
		[any]: BooleanOrString,

		Add: <T>(self: Private, object: T, methodName: BooleanOrString?, index: any?) -> T,
		AddObject: <T, A...>(
			self: Private,
			constructor: {new: (A...) -> T},
			methodName: BooleanOrString?,
			index: any?,
			A...
		) -> T,

		Remove: (self: Private, index: any) -> Private,
		RemoveNoClean: (self: Private, index: any) -> Private,

		RemoveList: (self: Private, ...any) -> Private,
		RemoveListNoClean: (self: Private, ...any) -> Private,

		Get: (self: Private, index: any) -> any?,
		GetAll: (self: Private) -> {[any]: any},

		Cleanup: (self: Private) -> (),
		Destroy: (self: Private) -> (),

		LinkToInstance: (self: Private, object: Instance, allowMultiple: boolean?) -> RBXScriptConnection,
		LinkToInstances: (self: Private, ...Instance) -> Private,
	},
	{} :: {__call: (self: Private) -> ()}
))
type Static = {
	ClassName: "Janitor",
	CurrentlyCleaning: boolean,
	SuppressInstanceReDestroy: boolean,

	new: () -> Janitor,
	Is: (object: any) -> boolean,
	instanceof: (object: any) -> boolean,
}
type PrivateStatic = Static & {
	__call: (self: Private) -> (),
	__tostring: (self: Private) -> string,
}

--[=[
	Janitor is a light-weight, flexible object for cleaning up connections, instances, or anything. This implementation covers all use cases,
	as it doesn't force you to rely on naive typechecking to guess how an instance should be cleaned up.
	Instead, the developer may specify any behavior for any object.

	@class Janitor
]=]
local Janitor = {} :: Janitor & Static
local Private = Janitor :: Private & PrivateStatic
Janitor.ClassName = "Janitor"
Janitor.CurrentlyCleaning = true
Janitor.SuppressInstanceReDestroy = false;
(Janitor :: any).__index = Janitor

local Janitors = setmetatable({} :: {[Private]: {[any]: any}}, {__mode = "k"})

--[=[
	Whether or not the Janitor is currently cleaning up.
	@readonly
	@prop CurrentlyCleaning boolean
	@within Janitor
]=]

--[=[
	Whether or not you want to suppress the re-destroying
	of instances. Default is false, which is the original
	behavior.

	@since 1.15.4
	@prop SuppressInstanceReDestroy boolean
	@within Janitor
]=]

local TYPE_DEFAULTS = {
	["function"] = true;
	thread = true;
	RBXScriptConnection = "Disconnect";
}

--[=[
	Instantiates a new Janitor object.
	@return Janitor
]=]
function Janitor.new(): Janitor
	return setmetatable({
		CurrentlyCleaning = false;
	}, Janitor)
end

--[=[
	Determines if the passed object is a Janitor. This checks the metatable
	directly.

	@param object unknown -- The object you are checking.
	@return boolean -- `true` if `object` is a Janitor.
]=]
function Janitor.Is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Janitor
end

--[=[
	An alias for [Janitor.Is]. This is intended for roblox-ts support.

	@function instanceof
	@within Janitor

	@param object unknown -- The object you are checking.
	@return boolean -- `true` if `object` is a Janitor.
]=]
Janitor.instanceof = Janitor.Is

-- very cheeky optimization
local function Remove(self: Private, index: any)
	local this = Janitors[self]

	if this then
		local object = this[index]
		if not object then
			return self
		end

		local methodName = self[object]
		if methodName then
			if methodName == true then
				if type(object) == "function" then
					object()
				else
					local wasCancelled: boolean = nil
					if coroutine.running() ~= object then
						wasCancelled = pcall(function()
							task.cancel(object)
						end)
					end

					if not wasCancelled then
						local toCleanup = object
						task.defer(function()
							task.cancel(toCleanup)
						end)
					end
				end
			else
				local objectMethod = object[methodName]
				if objectMethod then
					if self.SuppressInstanceReDestroy and methodName == "Destroy" and typeof(object) == "Instance" then
						pcall(objectMethod, object)
					else
						objectMethod(object)
					end
				end
			end

			self[object] = nil
		end

		this[index] = nil
	end

	return self
end

type BooleanOrString = boolean | string

local function Add<T>(self: Private, object: T, methodName: BooleanOrString?, index: any?): T
	if index then
		Remove(self, index)

		local this = Janitors[self]
		if not this then
			this = {}
			Janitors[self] = this
		end

		this[index] = object
	end

	local typeOf = typeof(object)
	local newMethodName = methodName or TYPE_DEFAULTS[typeOf] or "Destroy"

	if typeOf == "function" or typeOf == "thread" then
		if newMethodName ~= true then
			warn(string.format(INVALID_METHOD_NAME, typeOf, tostring(newMethodName), debug.traceback(nil, 2)))
		end
	else
		if not (object)[newMethodName] then
			warn(
				string.format(
					METHOD_NOT_FOUND_ERROR,
					tostring(object),
					tostring(newMethodName),
					debug.traceback(nil, 2)
				)
			)
		end
	end

	self[object] = newMethodName
	return object
end

--[=[
	Adds an `object` to Janitor for later cleanup, where `methodName` is the
	key of the method within `object` which should be called at cleanup time.
	If the `methodName` is `true` the `object` itself will be called if it's a
	function or have `task.cancel` called on it if it is a thread. If passed an
	index it will occupy a namespace which can be `Remove()`d or overwritten.
	Returns the `object`.

	:::info Note
	Objects not given an explicit `methodName` will be passed into the `typeof`
	function for a very naive typecheck. RBXConnections will be assigned to
	"Disconnect", functions and threads will be assigned to `true`, and
	everything else will default to "Destroy". Not recommended, but hey, you do
	you.
	:::

	### Luau:

	```lua
	local Workspace = game:GetService("Workspace")
	local TweenService = game:GetService("TweenService")

	local obliterator = Janitor.new()
	local part = Workspace:FindFirstChild("Part") :: Part

	-- Queue the Part to be Destroyed at Cleanup time
	obliterator:Add(part, "Destroy")

	-- Queue function to be called with `true` methodName
	obliterator:Add(print, true)

	-- Close a thread.
	obliterator:Add(task.defer(function()
		while true do
			print("Running!")
			task.wait(0.5)
		end
	end), true)

	-- This implementation allows you to specify behavior for any object
	obliterator:Add(TweenService:Create(part, TweenInfo.new(1), {Size = Vector3.one}), "Cancel")

	-- By passing an index, the object will occupy a namespace
	-- If "CurrentTween" already exists, it will call :Remove("CurrentTween") before writing
	obliterator:Add(TweenService:Create(part, TweenInfo.new(1), {Size = Vector3.one}), "Destroy", "CurrentTween")
	```

	### TypeScript:

	```ts
	import { Workspace, TweenService } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor<{ CurrentTween: Tween }>();
	const part = Workspace.FindFirstChild("Part") as Part;

	// Queue the part to be Destroyed at Cleanup time
	obliterator.Add(part, "Destroy");

	// Queue function to be called with `true` methodName
	obliterator.Add(print, true);

	// Close a thread.
	obliterator.Add(task.defer(() => {
		while (true) {
			print("Running!");
			task.wait(0.5);
		}
	}), true);

	// This implementation allows you to specify behavior for any object
	obliterator.Add(TweenService.Create(part, new TweenInfo(1), { Size: Vector3.one }), "Cancel");

	// By passing an index, the object will occupy a namespace
	// If "CurrentTween" already exists, it will call :Remove("CurrentTween") before writing
	obliterator.Add(TweenService.Create(part, new TweenInfo(1), { Size: Vector3.one }), "Destroy", "CurrentTween");
	```

	@method Add
	@within Janitor

	@param object T -- The object you want to clean up.
	@param methodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param index? unknown -- The index that can be used to clean up the object manually.
	@return T -- The object that was passed as the first argument.
]=]
Private.Add = Add

--[=[
	Constructs an object for you and adds it to the Janitor. It's really just
	shorthand for `Janitor:Add(object.new(), methodName, index)`.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	local subObliterator = obliterator:AddObject(Janitor, "Destroy")
	-- subObliterator is another Janitor!
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor();
	const subObliterator = obliterator.AddObject(Janitor, "Destroy");
	```

	@since v1.16.0
	@param constructor {new: (A...) -> T} -- The constructor for the object you want to add to the Janitor.
	@param methodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param index? unknown -- The index that can be used to clean up the object manually.
	@param ... A... -- The arguments that will be passed to the constructor.
	@return T -- The object that was passed as the first argument.
]=]
function Janitor:AddObject<T, A...>(constructor: {new: (A...) -> T}, methodName: BooleanOrString?, index: any?, ...: A...): T
	return Add(self, constructor.new(...), methodName, index)
end

--[=[
	Adds a [Promise](https://github.com/evaera/roblox-lua-promise) to the
	Janitor. If the Janitor is cleaned up and the Promise is not completed, the
	Promise will be cancelled.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:AddPromise(Promise.delay(3)):andThenCall(print, "Finished!"):catch(warn)
	task.wait(1)
	obliterator:Cleanup()
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor();
	obliterator.AddPromise(Promise.delay(3)).andThenCall(print, "Finished!").catch(warn);
	task.wait(1);
	obliterator.Cleanup();
	```

	@error NotAPromiseError -- Thrown if the promise is not a Promise.

	@param promiseObject Promise -- The promise you want to add to the Janitor.
	@return Promise
]=]

--[=[
	Cleans up whatever `Object` was set to this namespace by the 3rd parameter of [Janitor.Add](#Add).

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	obliterator:Remove("Baseplate")
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor<{ Baseplate: Part }>();
	obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	obliterator.Remove("Baseplate");
	```

	@method Remove
	@within Janitor

	@param index unknown -- The index you want to remove.
	@return Janitor
]=]
Private.Remove = Remove

--[=[
	Removes an object from the Janitor without running a cleanup.

	### Luau

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(function()
		print("Removed!")
	end, true, "Function")

	obliterator:RemoveNoClean("Function") -- Does not print.
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor<{ Function: () => void }>();
	obliterator.Add(() => print("Removed!"), true, "Function");

	obliterator.RemoveNoClean("Function"); // Does not print.
	```

	@method RemoveNoClean
	@within Janitor

	@since v1.15.0
	@param index unknown -- The index you are removing.
	@return Janitor
]=]
function Private:RemoveNoClean(index: any)
	local this = Janitors[self]

	if this then
		local object = this[index]
		if object then
			self[object] = nil
			this[index] = nil
		end
	end

	return self
end

--[=[
	Cleans up multiple objects at once.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(function()
		print("Removed One")
	end, true, "One")

	obliterator:Add(function()
		print("Removed Two")
	end, true, "Two")

	obliterator:Add(function()
		print("Removed Three")
	end, true, "Three")

	obliterator:RemoveList("One", "Two", "Three") -- Prints "Removed One", "Removed Two", and "Removed Three"
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	type NoOp = () => void

	const obliterator = new Janitor<{ One: NoOp, Two: NoOp, Three: NoOp }>();
	obliterator.Add(() => print("Removed One"), true, "One");
	obliterator.Add(() => print("Removed Two"), true, "Two");
	obliterator.Add(() => print("Removed Three"), true, "Three");

	obliterator.RemoveList("One", "Two", "Three"); // Prints "Removed One", "Removed Two", and "Removed Three"
	```

	@since v1.14.0
	@param ... unknown -- The indices you want to remove.
	@return Janitor
]=]
function Janitor:RemoveList(...: any)
	local this = Janitors[self]
	if this then
		local length = select("#", ...)
		if length == 1 then
			return Remove(self, ...)
		end
		if length == 2 then
			local indexA, indexB = ...
			Remove(self, indexA)
			Remove(self, indexB)
			return self
		end
		if length == 3 then
			local indexA, indexB, indexC = ...
			Remove(self, indexA)
			Remove(self, indexB)
			Remove(self, indexC)
			return self
		end

		for selectIndex = 1, length do
			local removeObject = select(selectIndex, ...)
			Remove(self, removeObject)
		end
	end

	return self
end

--[=[
	Cleans up multiple objects at once without running their cleanup.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(function()
		print("Removed One")
	end, true, "One")

	obliterator:Add(function()
		print("Removed Two")
	end, true, "Two")

	obliterator:Add(function()
		print("Removed Three")
	end, true, "Three")

	obliterator:RemoveListNoClean("One", "Two", "Three") -- Nothing is printed.
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	type NoOperation = () => void

	const obliterator = new Janitor<{ One: NoOperation, Two: NoOperation, Three: NoOperation }>();
	obliterator.Add(() => print("Removed One"), true, "One");
	obliterator.Add(() => print("Removed Two"), true, "Two");
	obliterator.Add(() => print("Removed Three"), true, "Three");

	obliterator.RemoveListNoClean("One", "Two", "Three"); // Nothing is printed.
	```

	@since v1.15.0
	@param ... unknown -- The indices you want to remove.
	@return Janitor
]=]
function Janitor:RemoveListNoClean(...: any)
	local this = Janitors[self]
	if this then
		local length = select("#", ...)
		if length == 1 then
			local indexA = ...
			local object = this[indexA]
			if object then
				self[object] = nil
				this[indexA] = nil
			end
			return self
		end
		if length == 2 then
			local indexA, indexB = ...
			local objectA = this[indexA]
			if objectA then
				self[objectA] = nil
				this[indexA] = nil
			end
			local objectB = this[indexB]
			if objectB then
				self[objectB] = nil
				this[indexB] = nil
			end
			return self
		end
		if length == 3 then
			local indexA, indexB, indexC = ...
			local objectA = this[indexA]
			if objectA then
				self[objectA] = nil
				this[indexA] = nil
			end
			local objectB = this[indexB]
			if objectB then
				self[objectB] = nil
				this[indexB] = nil
			end
			local objectC = this[indexC]
			if objectC then
				self[objectC] = nil
				this[indexC] = nil
			end
			return self
		end

		for selectIndex = 1, length do
			-- MACRO
			local index = select(selectIndex, ...)
			local object = this[index]
			if object then
				self[object] = nil
				this[index] = nil
			end
		end
	end

	return self
end

--[=[
	Gets whatever object is stored with the given index, if it exists. This was
	added since Maid allows getting the task using `__index`.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(Workspace.Baseplate, "Destroy", "Baseplate")
	print(obliterator:Get("Baseplate")) -- Returns Baseplate.
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor<{ Baseplate: Part }>();
	obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	print(obliterator.Get("Baseplate")); // Returns Baseplate.
	```

	@param index unknown -- The index that the object is stored under.
	@return unknown? -- This will return the object if it is found, but it won't return anything if it doesn't exist.
]=]
function Janitor:Get(index: any): any?
	local this = Janitors[self]
	return if this then this[index] else nil
end

--[=[
	Returns a frozen copy of the Janitor's indices.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	obliterator:Add(Workspace.Baseplate, "Destroy", "Baseplate")
	print(obliterator:GetAll().Baseplate) -- Prints Baseplate.
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor<{ Baseplate: Part }>();
	obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	print(obliterator.GetAll().Baseplate); // Prints Baseplate.
	```

	@since v1.15.1
	@return {[any]: any}
]=]
function Janitor:GetAll(): {[any]: any}
	local this = Janitors[self]
	return if this then table.freeze(table.clone(this)) else {}
end

local function GetFenv(self: Private): () -> (any, BooleanOrString)
	return function(): ()
		for object, methodName in next, self do
			if object ~= "SuppressInstanceReDestroy" then
				return object, methodName
			end
		end
	end
end

local function Cleanup(self: Private)
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil

		local get = GetFenv(self)
		local object, methodName = get()

		while object and methodName do -- changed to a while loop so that if you add to the janitor inside of a callback it doesn't get untracked (instead it will loop continuously which is a lot better than a hard to pindown edgecase)
			if methodName == true then
				if type(object) == "function" then
					object()
				elseif type(object) == "thread" then
					local wasCancelled: boolean = nil
					if coroutine.running() ~= object then
						wasCancelled = pcall(function()
							task.cancel(object)
						end)
					end

					if not wasCancelled then
						local toCleanup = object
						task.defer(function()
							task.cancel(toCleanup)
						end)
					end
				end
			else
				local objectMethod = (object)[methodName] :: (object: any) -> ()
				if objectMethod then
					if self.SuppressInstanceReDestroy and methodName == "Destroy" and typeof(object) == "Instance" then
						pcall(objectMethod, object)
					else
						objectMethod(object)
					end
				end
			end

			self[object] = nil
			object, methodName = get()
		end

		local this = Janitors[self]
		if this then
			table.clear(this)
			Janitors[self] = nil
		end

		self.CurrentlyCleaning = false
	end
end

--[=[
	Calls each object's `methodName` (or calls the object if
	`methodName == true`) and removes them from the Janitor. Also clears the
	namespace. This function is also called when you call a Janitor object (so
	it can be used as a destructor callback).

	### Luau:

	```lua
	obliterator:Cleanup() -- Valid.
	obliterator() -- Also valid.
	```

	### TypeScript:

	```ts
	obliterator.Cleanup()
	// TypeScript version doesn't support the __call method of cleaning.
	```

	@method Cleanup
	@within Janitor
]=]
Private.Cleanup = Cleanup

--[=[
	Calls [Janitor.Cleanup](#Cleanup) and renders the Janitor unusable.

	:::warning Metatable Removal
	Running this will make any further attempts to call a method of Janitor
	error.
	:::
]=]
function Janitor:Destroy()
	Cleanup(self)
	table.clear(self)
	setmetatable(self :: any, nil)
end

Private.__call = Cleanup

local function LinkToInstance(self: Private, object: Instance, allowMultiple: boolean?): RBXScriptConnection
	local indexToUse = if allowMultiple then newproxy(false) else LinkToInstanceIndex

	return Add(self, object.Destroying:Connect(function()
		Cleanup(self)
	end), "Disconnect", indexToUse)
end

--[=[
	"Links" this Janitor to an Instance, such that the Janitor will `Cleanup`
	when the Instance is `Destroy()`d and garbage collected. A Janitor may only
	be linked to one instance at a time, unless `allowMultiple` is true. When
	called with a truthy `allowMultiple` parameter, the Janitor will "link" the
	Instance without overwriting any previous links, and will also not be
	overwritable. When called with a falsy `allowMultiple` parameter, the
	Janitor will overwrite the previous link which was also called with a falsy
	`allowMultiple` parameter, if applicable.

	### Luau:

	```lua
	local obliterator = Janitor.new()

	obliterator:Add(function()
		print("Cleaning up!")
	end, true)

	do
		local folder = Instance.new("Folder")
		obliterator:LinkToInstance(folder)
		folder:Destroy()
	end
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const obliterator = new Janitor();
	obliterator.Add(() => print("Cleaning up!"), true);

	{
		const folder = new Instance("Folder");
		obliterator.LinkToInstance(folder, false);
		folder.Destroy();
	}
	```

	@method LinkToInstance
	@within Janitor

	@param object Instance -- The instance you want to link the Janitor to.
	@param allowMultiple? boolean -- Whether or not to allow multiple links on the same Janitor.
	@return RBXScriptConnection -- A RBXScriptConnection that can be disconnected to prevent the cleanup of LinkToInstance.
]=]
Private.LinkToInstance = LinkToInstance;

(Janitor).LegacyLinkToInstance = LinkToInstance

--[=[
	Links several instances to a new Janitor, which is then returned.

	@param ... Instance -- All the Instances you want linked.
	@return Janitor -- A new Janitor that can be used to manually disconnect all LinkToInstances.
]=]
function Janitor:LinkToInstances(...: Instance)
	local manualCleanup = Janitor.new()
	for index = 1, select("#", ...) do
		local object = select(index, ...)
		if typeof(object) ~= "Instance" then
			continue
		end

		manualCleanup:Add(LinkToInstance(self, object, true), "Disconnect")
	end

	return manualCleanup
end

function Private:__tostring()
	return "Janitor"
end

return Janitor :: Static