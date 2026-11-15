---- || LOADING CHECK || -----

local getgenv = (getgenv or function() return _G; end);
local luna_xyz_env = getgenv().luna_xyz_env;

----- || LIBRARIES || -----

local AddonsManager, LayoutManager, Registry = {}, {}, { Loaded = {}; Errored = {}; };
LayoutManager.__index = LayoutManager;

----- || METHODS || -----

local function addonErrored(addonName, filePath, err, layout)

	local errorGroupbox;

	for i, addon in Registry.Loaded do

		if addon.Name ~= addonName then continue; end;

		for _, cb in addon.UnloadCallbacks do task.spawn(pcall, cb); end;
		errorGroupbox = addon.Groupbox; table.remove(Registry.Loaded, i); break;
	end;

	table.insert(Registry.Errored, {
		Name = addonName; FilePath = filePath; Error = tostring(err);
	});

	Logger.error(("Failed to load addon %s"):format(addonName));
	Logger.error("    RUNTIME ERROR: " .. tostring(err));

	if not errorGroupbox then errorGroupbox = layout:AddGroupbox(('%s — Error'):format(addonName), "triangle-alert"); end;
	errorGroupbox:AddLabel(('<font color="rgb(255,0,0)">ERROR: %s</font>'):format(tostring(err)), true);
end;

local function validateAddon(info)

	if typeof(info) ~= "table" then return false, ('Invalid argument #1 to "AddonInfo" (table expected, got %s)'):format(typeof(info)); end;
	if typeof(info.Title) ~= "string" or not luna_xyz_env:IsString(info.Title) then return false, ('Invalid argument to "AddonInfo.Title" must be a non-empty string, got "%s"'):format(tostring(info.Title)); end;

	local isValidGame = false;

	if info.GameId and typeof(info.GameId) == "table" then
		for _, id in info.GameId do if luna_xyz_env:IsValidGame(id) then isValidGame = true; break; end; end;
	end;

	isValidGame = info.GameId == "*" or luna_xyz_env:IsValidGame(info.GameId);
	if not isValidGame then return false, ('Invalid argument to "AddonInfo.GameId" (unsupported game, got "%s")'):format(tostring(info.GameId)); end;

	return true;
end;

local function createAddonEnv(layout, addonName, filePath, fn, addonThread)

	local registered, currentData = false, nil;
	local baseEnv, AddonAPI, env = getfenv(fn), {}, {};

	setmetatable(env, {

		__index = baseEnv; __newindex = function(t, key, value)

			rawset(t, key, value);
			if key ~= "AddonInfo" then return; end;

			local success, err = validateAddon(value);
			if not success then error(err, 2); end;

			local groupbox = layout:AddGroupbox(('%s — %s'):format(value.Title, addonName), value.Icon or "");
			rawset(t, "Groupbox", groupbox); registered, currentData = true, value;

			table.insert(Registry.Loaded, { Name = addonName; FilePath = filePath; Data = currentData; Thread = addonThread; Environment = env; Groupbox = groupbox; UnloadCallbacks = {}; });
		end;
	});

	local AddonEnvProxy = setmetatable({}, {

		__index = function(_, key)

			if key == "Maid" then return luna_xyz_env.AddonsMaid; end;
			return luna_xyz_env[key];
		end;

		__newindex = function(_, key, value)
			luna_xyz_env[key] = value;
		end;
	});

	function AddonAPI:BindToUnload(callback)

		assert(typeof(callback) == "function", ('Invalid argument #1 to "BindToUnload" (function expected, got %s)"'):format(typeof(callback)));
		for _, addon in Registry.Loaded do if addon.Data == currentData then table.insert(addon.UnloadCallbacks, callback); end; end;
	end;

	function env:_isRegistered() return registered; end;
	function env:_groupbox() return rawget(self, "Groupbox"); end;

	env.AddonAPI = AddonAPI;
	env.luna_xyz_env, env.luna_xyz = AddonEnvProxy, env;

	return env;
end;

----- || LAYOUT || -----

function LayoutManager.new(tab)
	return setmetatable({ tab = tab; side = 1; }, LayoutManager);
end;

function LayoutManager:AddGroupbox(title, icon)

	local groupbox = self.side == 1 and self.tab:AddLeftGroupbox(title, icon or "") or self.tab:AddRightGroupbox(title, icon or "");
	self.side = self.side == 1 and 2 or 1;

	return groupbox;
end;

----- || ADDONS || -----

function AddonsManager:Initialize()
	
	local AddonsTab = luna_xyz_env.Window:AddTab("Addons", "boxes", "Community Addons of luna.xyz");
	local Layout, SupportsFileSystem = LayoutManager.new(AddonsTab), luna_xyz_env.SupportsFileSystem;

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>'; Visible = not SupportsFileSystem;
		Text = "\nluna.xyz was unable to load addons (<b>ERROR: FileSystem API</b>)\n<i>Please switch to an executor with FileSystem API support.</i>";
	});

	if not SupportsFileSystem then return; end;

	local supported_formats = { lua = true; luau = true; addon = true; plugin = true; laddon = true; };
	local addons = isfolder("luna_xyz/custom") and listfiles("luna_xyz/custom") or {};

	local formats_text = {};
	for format in supported_formats do table.insert(formats_text, ('".%s"'):format(format)); end;

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>'; Visible = #addons == 0;
		Text = "\nluna.xyz was unable to load addons (<b>ERROR: FileSystem API</b>)\n<i>Your addons FOLDER is empty! (luna_xyz/addons).</i>";
	});

	if #addons == 0 then return; end;

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">WARNING</font>'; Visible = true;
		Text = "\nThis tab is for <b>UN-OFFICIAL</b> addons made for luna.xyz, We are not responsible for what addons you use. You are putting yourself <b>AT RISK</b> since you are executing <b>third-party</b> scripts.";
	});

	for _, path in addons do

		local addonName = path:match("[/\\]([^/\\]+)$") or path;
		local ext = (path:match("%.(%w+)$") or ""):lower();

		if not supported_formats[ext] then

			local err = ('Invalid extension type must be %s'):format(table.concat(formats_text, ", "));
			addonErrored(addonName, path, err, Layout); continue;
		end;

		local compile_func = loadfile or function(p)
			return loadstring(readfile(p));
		end;

		local fn, compileErr = compile_func(path);
		Logger.debug(('Initializing Addon: %s..'):format(addonName));

		if not fn then

			Logger.error(('Failed to initialize Addon %s.'):format(addonName));
			Logger.error(('    RUNTIME ERROR: %s'):format(compileErr or "Addon Compilation Error"));

			addonErrored(addonName, path, compileErr or "Addon Compilation Error", Layout);
			continue;
		end;

		local env, addonThread; addonThread = coroutine.create(function()

			local ok, runtimeErr = pcall(fn);

			if not ok then

				Logger.error(('Failed to initialize Addon %s.'):format(addonName));
				Logger.error(('    RUNTIME ERROR: %s'):format(runtimeErr));

				return addonErrored(addonName, path, runtimeErr, Layout);
			end;

			if not env:_isRegistered() then

				Logger.error(('Failed to initialize Addon %s.'):format(addonName));
				Logger.error(('    RUNTIME ERROR: %s'):format('"AddonInfo" was never assigned'));

				return addonErrored(addonName, path, '"AddonInfo" was never assigned', Layout);
			end;

			return Logger.debug(('Addon "%s" initialized successfully.'):format(addonName));
		end);

		env = createAddonEnv(Layout, addonName, path, fn, addonThread);
		setfenv(fn, env); task.spawn(addonThread);
	end;
end;

function AddonsManager:UnloadAll()

	if #Registry.Loaded == 0 then return; end;
	local loaded_addons, failed_addons = 0, 0;

	for _, addon in Registry.Loaded do

		if addon.Unloaded then continue; end;
		loaded_addons += 1;

		local addonError = false; addon.Unloaded = true;
		Logger.debug(('Unloading addon: %s..'):format(addon.Name));

		if addon.Thread and coroutine.status(addon.Thread) ~= "dead" then

			local success, cancelErr = pcall(task.cancel, addon.Thread);

			if not success then

				Logger.error(('Failed to unload Addon %s.'):format(addon.Name)); Logger.error(('    RUNTIME ERROR: %s'):format(cancelErr));
				addonError = true; failed_addons += 1;
			end;
		end;

		for _, callback in addon.UnloadCallbacks do

			local success, callbackErr = pcall(callback);

			if not success then
				Logger.error(('Failed to call "UnloadCallback" in %s.'):format(addon.Name)); Logger.error(('    RUNTIME ERROR: %s'):format(callbackErr));
				addonError = true; failed_addons += 1;
			end;
		end;

		if not addonError then Logger.debug(('Addon "%s" unloaded successfully.'):format(addon.Name)); end;
	end;

	table.clear(Registry.Loaded); table.clear(Registry.Errored);
	return Logger.debug(('Successfully unloaded %d of %d addons.'):format(loaded_addons - failed_addons, loaded_addons));
end;

----- || FINALIZE || -----

luna_xyz_env.Library:OnUnload(function()
	AddonsManager:UnloadAll();
end);

AddonsManager.Registry = Registry;
return AddonsManager;
