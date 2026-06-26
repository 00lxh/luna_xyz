local addons, LayoutManager, Registry = {}, {}, { Loaded  = {}; Errored = {}; };
LayoutManager.__index = LayoutManager;

----- || LAYOUT MANAGER || ----

function LayoutManager.new(tab)
	return setmetatable({ tab = tab, side = 1 }, LayoutManager);
end;

function LayoutManager:AddGroupbox(title, icon)
	
	local groupbox = self.side == 1 and self.tab:AddLeftGroupbox(title, icon or "") or self.tab:AddRightGroupbox(title, icon or "");
	self.side = self.side == 1 and 2 or 1;
	
	return groupbox;
end;

----- || METHODS || ----

local function showError(layout, groupbox, message)
	
	local gb = groupbox or layout:AddGroupbox("⚠ Error");
	gb:AddLabel(('<font color="rgb(255,0,0)">ERROR: %s</font>'):format(message), true);
end;

local function validateAddonInfo(info)
	
	if type(info) ~= "table" then return false, ("AddonInfo must be a table, got %s"):format(type(info)); end;
	if type(info.Title) ~= "string" or info.Title == "" then return false, ("AddonInfo.Title must be a non-empty string, got %s"):format(type(info.Title)); end;
	
	if info.Game ~= nil then
		
		local isValidGame = false;
		
		if type(info.Game) == "table" then
			
			for _, id in ipairs(info.Game) do 
				if luna_xyz_env:IsValidGame(tostring(id)) then isValidGame = true break; end;
			end;
			
		else
			
			isValidGame = info.Game == "*" or luna_xyz_env:IsValidGame(tostring(info.Game));
		end;
		
		if not isValidGame then
			return false, ("Unsupported game (%s) for luna.xyz"):format(tostring(info.Game));
		end;
	end;

	return true;
end;

local function addonErrored(addonName, filePath, err, layout, groupbox)
	
	for i, addon in ipairs(Registry.Loaded) do
		
		if addon.Name == addonName then
			
			for _, cb in ipairs(addon.UnloadCallbacks) do
				task.spawn(pcall, cb);
			end;
			
			table.remove(Registry.Loaded, i);
			break;
		end;
	end;

	table.insert(Registry.Errored, {
		Name = addonName; FilePath = filePath; Error = tostring(err);
	});

	Logger.error(("Failed to load addon %s"):format(addonName));
	Logger.error("    RUNTIME ERROR: " .. tostring(err));
	
	showError(layout, groupbox, tostring(err));
end;

local function createAddonEnv(layout, addonName, filePath, addonThread)
	
	local registered, currentData = false, nil;
	local AddonAPI, env = {}, {};
	
	setmetatable(env, {
		
		__newindex = function(t, key, value)
			
			rawset(t, key, value);

			if key == "AddonInfo" then
				
				local ok, err = validateAddonInfo(value);
				
				if not ok then
	
					if coroutine.status(addonThread) ~= "dead" then pcall(task.cancel, addonThread); end;
					error(err, 2);
				end;
				
				local title = ("%s — %s"):format(value.Title, addonName);
				local groupbox = layout:AddGroupbox(title, value.Icon or "");
				
				rawset(t, "Groupbox", groupbox);
				registered, currentData = true, value;

				table.insert(Registry.Loaded, {
					Name = addonName; FilePath = filePath; Data = currentData; Thread = addonThread; Environment = env; UnloadCallbacks = {};
				});
			end;
		end;
		
		__index = function(_, key)
			
			local renv, genv  = getrenv(), getgenv();
			return (renv and renv[key]) or (genv and genv[key]) or (AddonAPI and AddonAPI[key]) or (luna_xyz_env and luna_xyz_env[key]);
		end;
	});
	
	function env:_isRegistered() return registered; end;
	function env:_groupbox() return rawget(self, "Groupbox"); end;
	
	function AddonAPI:BindToUnload(callback)

		if type(callback) ~= "function" then return; end;

		for _, addon in ipairs(Registry.Loaded) do

			if addon.Data == currentData then

				if addon.Unloaded then return Logger.error(("BindToUnload called after addon %s was already unloaded"):format(addonName)); end;
				return table.insert(addon.UnloadCallbacks, callback);
			end;
		end;
	end;
	
	env.AddonAPI = AddonAPI;
	env.luna_xyz_env, env.luna_xyz = luna_xyz_env, env;
	
	return env;
end;

----- || LAYOUT MANAGER || ----

function addons:LoadAddons()
	
	local AddonsTab = luna_xyz_env.Window:AddTab("Addons", "boxes");
	local layout = LayoutManager.new(AddonsTab);
	
	if not luna_xyz_env._SupportsFileSystem then

		AddonsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nluna.xyz could not access the addons folder (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
		});		
		return;
	end;
	
	local files = listfiles("luna_xyz/addons");

	if #files == 0 then

		AddonsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nYour addons FOLDER is empty! (luna_xyz/addons)."
		});
		return;
	end;
	
	repeat task.wait() until getgenv().luna_xyz_loaded;

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - WARNING</font>', Visible = true;
		Text = "\nThis tab is for UN-OFFICIAL addons made for luna.xyz, We are not responsible for what addons you will use. You are putting yourself <b>AT RISK</b> since you are executing third-party scripts.";
	});
	
	local startTime = os.clock();
	Logger.debug("Loading addons..");
	
	for _, path in ipairs(files) do
		
		local addonName = path:match("[/\\]([^/\\]+)$") or path;
		local ext, startTime2 = (path:match("%.(%w+)$") or ""):lower(), os.clock();
		
		Logger.debug(('Loading addon %s..'):format(addonName));
		
		if not ({ lua = true, luau = true, txt = true })[ext] then
			
			local err = 'Invalid extension — must be ".lua", ".luau", or ".txt"';
			addonErrored(addonName, path, err, layout, nil);
			
			continue;
		end;
		
		local fn, compileErr = (loadfile or function(p)
			return loadstring(readfile(p));
		end)(path);

		if not fn then
			
			addonErrored(addonName, path, compileErr or "Addon Compilation Error", layout, nil);
			continue;
		end;
		
		local addonThread; addonThread = task.spawn(function()
			
			coroutine.yield();
			local ok, runtimeErr = pcall(fn);

			if not ok then
				
				--local groupbox = addonThread and rawget(setfenv(fn, {}), "Groupbox") or nil;
				addonErrored(addonName, path, runtimeErr, layout, nil);
				
				return;
			end;
			
			if not getfenv(fn):_isRegistered() then
				
				addonErrored(addonName, path, '"AddonInfo" was never assigned', layout, nil);
				return;
			end;

			Logger.success(("The addon %s loaded successfully. - (%.2f)"):format(addonName, os.clock() - startTime2));
		end);
		
		local env = createAddonEnv(layout, addonName, path, addonThread);
		setfenv(fn, env); coroutine.resume(addonThread);
	end;

	Logger.success(("Loaded luna.xyz addons successfully. - (%.2fs)"):format(os.clock() - startTime));
	
	luna_xyz_env.Library:OnUnload(function()
		addons:UnloadAll();
	end);
end;

function addons:UnloadAll()

	if #Registry.Loaded == 0 then
		return Logger.debug("No addons to unload.");
	end;
	
	local startTime = os.clock();
	Logger.debug(("Unloading %d addon(s).."):format(#Registry.Loaded));

	for _, addon in ipairs(Registry.Loaded) do
		
		if addon.Unloaded then continue; end;
		addon.Unloaded = true;
		
		local startTime2 = os.clock();
		Logger.debug(("Unloading addon %s.."):format(addon.Name));
		
		if addon.Thread and coroutine.status(addon.Thread) ~= "dead" then
			
			local ok, cancelErr = pcall(task.cancel, addon.Thread);
			
			if not ok then
				Logger.error(("Could not cancel thread for %s: %s"):format(addon.Name, tostring(cancelErr)));
			end;
		end;
		
		for _, callback in ipairs(addon.UnloadCallbacks) do
			
			local ok, cbErr = pcall(callback)
			
			if not ok then
				Logger.error(("UnloadCallback error in %s: %s"):format(addon.Name, tostring(cbErr)));
			end;
		end;

		Logger.success(("Addon %s unloaded successfully. - (%.2fs)"):format(addon.Name, os.clock() - startTime2))
	end;
	
	table.clear(Registry.Loaded); table.clear(Registry.Errored);
	Logger.success(("All addons unloaded successfully. - (%.2fs)"):format(os.clock() - startTime));
end;

addons.Registry = Registry;
return addons;
