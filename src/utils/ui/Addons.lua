local addons, LayoutManager = {}, {};
LayoutManager.__index = LayoutManager;

function LayoutManager.new(tab)
	return setmetatable({ tab = tab, side = 1 }, LayoutManager);
end;

function LayoutManager:AddGroupbox(title, icon)
	
	local Groupbox;
	
	if self.side == 1 then Groupbox = self.tab:AddLeftGroupbox(title, icon or ""); else Groupbox = self.tab:AddRightGroupbox(title, icon or ""); end;
	self.side = self.side == 1 and 2 or 1;
	
	return Groupbox;
end;

local function createDeferredProxy()
	
	local queue = {};
	local sealed = false;

	local makeProxy = function(q)
		
		return setmetatable({}, {
			
			__index = function(_, method)
				
				if sealed then error("Groupbox cannot be used after CommitUI()", 2); end;
				return function(_, ...)
					
					local args  = { ... };
					local children = {};
					
					table.insert(q, { method = method, args = args, children = children });
					
					return setmetatable({}, {
						
						__index = function(self2, m2)
							return function(_, ...) table.insert(children, { method = m2, args = { ... }, children = {} }); end;
						end;
					});
				end;
			end;
		});
	end;
	
	local function replay(realObj, q)
		
		for _, entry in ipairs(q) do
			
			local fn = realObj[entry.method];
			if type(fn) ~= "function" then continue; end;
			
			local result = fn(realObj, table.unpack(entry.args));
			if type(result) == "table" and #entry.children > 0 then replay(result, entry.children); end;
		end;
	end;

	local proxy = makeProxy(queue);

	local function commit(realGroupbox)
		sealed = true; replay(realGroupbox, queue); queue = nil;
	end;

	local function discard()
		sealed = true queue  = nil;
	end;

	return proxy, commit, discard;
end;

local function createAddonEnv(layout, addonName)

	local env = {};
	local committed = false;

	local gbProxy, commitProxy, discardProxy = createDeferredProxy();

	local function validateAddonInfo(info)
		
		if type(info) ~= "table" then return false, ('Invalid AddonInfo table (table expected, got %s)'):format(typeof(info)); end;
		if type(info.Title) ~= "string" or info.Title == "" then return false, ('Invalid title argument (string expected, got %s)'):format(typeof(info.Title)); end;
		
		if not luna_xyz_env:IsValidGame(info.Game) then return false, ('Unsupported game (%s) by luna.xyz'):format(tostring(info.Game)); end;
		return true;
	end;

	setmetatable(env, {
		
		__newindex = function(_, key, value)
			
			rawset(env, key, value);

			if key == "AddonInfo" then
				
				local ok, err = validateAddonInfo(value);
				if not ok then discardProxy(); error(err, 2); end;

				local title = ("%s — %s"):format(value.Title, addonName);
				local gb    = layout:AddGroupbox(title, value.Icon or "");

				rawset(env, "_realGroupbox", gb); rawset(env, "Groupbox", gb);
				commitProxy(gb); committed = true;
			end;
		end,

		__index = function(_, key)
			return rawget(env, key) or luna_xyz_env[key] or getrenv()[key];
		end,
	});
	
	env.luna_xyz = env;
	env.luna_xyz_env = luna_xyz_env;

	function env:_discard()
		if not committed then discardProxy(); end;
	end;

	function env:_isCommitted()
		return committed;
	end;

	return env;
end;

local function showError(layout, groupbox, message)
	
	local Groupbox = groupbox or layout:AddGroupbox("⚠ Error");
	Groupbox:AddLabel(('<font color="rgb(255, 0, 0)">RUNTIME ERROR: %s</font>'):format(message), true);
end;

function addons:LoadAddons()

	local AddonsTab = luna_xyz_env.Window:AddTab("Addons", "boxes");
	local layout = LayoutManager.new(AddonsTab);

	if not luna_xyz_env._SupportsFileSystem then
		
		AddonsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nluna.xyz was unable to create addons folder (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
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

		local addon_name, ext = path:match("[/\\]([^/\\]+)$") or path, (path:match("%.(%w+)$") or ""):lower();
		local startTime2  = os.clock();

		Logger.debug('Loading addon ' .. addon_name .. '..');

		-- Extension check
		if not ({lua=true, luau=true, txt=true})[ext] then
			
			Logger.error(('Failed to load addon %s - (%s)'):format(addon_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: Invalid extension type must be ".lua", ".luau", ".txt"');

			showError(layout, nil, 'Invalid extension type must be ".lua", ".luau", ".txt"');
			continue;
		end;

		local fn = loadfile and loadfile(path) or loadstring(readfile(path));
		
		if not fn then
			
			Logger.error(('Failed to load addon %s - (%s)'):format(addon_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: Cannot load addon data');
			
			showError(layout, nil, "Cannot load addon data");
			continue;
		end;
		
		local env = createAddonEnv(layout, addon_name);
		setfenv(fn, env);

		local success, runtimeErr = pcall(fn);

		if not success then
			
			env:_discard();
			
			Logger.error(('Failed to load addon %s - (%s)'):format(addon_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: ' .. tostring(runtimeErr));
			
			showError(layout, rawget(env, "_realGroupbox"), tostring(runtimeErr));
			continue;
		end;
		
		if not env:_isCommitted() then
			
			env:_discard();
			
			Logger.error(('Failed to load addon %s - (%s)'):format(addon_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: "AddonInfo" table not found');
			
			showError(layout, nil, '"AddonInfo" table not found');
	
			continue;
		end;

		Logger.success(('The addon %s loaded successfully. - (%s)'):format(addon_name, string.format("%.2f", os.clock() - startTime2)));
	end;

	Logger.success(('Loaded luna.xyz addons. - (%s)'):format(string.format("%.2f", os.clock() - startTime)));
end;

return addons;
