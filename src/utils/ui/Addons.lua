local addons = {};
local lastPosition = 1;

local function CreateGroupboxProxy(AddonGroupbox)
	
	local actions = {};

	local proxy = setmetatable({}, {
		__index = function(_, method) return function(_, ...) table.insert(actions, { method, {...} }); end; end;
	});

	local function CommitUI()
		for _, action in ipairs(actions) do
			
			local method, args = action[1], action[2];
			if AddonGroupbox[method] then AddonGroupbox[method](AddonGroupbox, unpack(args)); end;
		end;
	end;

	local function ClearUI() table.clear(actions); end;
	return proxy, CommitUI, ClearUI;
end;

local function CreateAddonGroupbox(AddonsTab, title, icon)

	local Groupbox = lastPosition == 1 and AddonsTab:AddLeftGroupbox(title, icon or "") or AddonsTab:AddRightGroupbox(title, icon or "");
	if lastPosition == 1 then lastPosition = 2; else lastPosition = 1; end;

	return Groupbox;
end;

local function CreateAddonEnv(AddonsTab, addon_name)

	local exec_env, real_env, addon_env = getrenv(), {}, {};
	
	setmetatable(addon_env, {

		__newindex = function(_, key, value)

			if key ~= "AddonInfo" then

				rawset(real_env, key, value); rawset(addon_env, key, value);
				return;
			end;

			rawset(real_env, key, value); rawset(addon_env, key, value);

			local realGroupbox = CreateAddonGroupbox(AddonsTab, value.Title .. ' - ' .. addon_name, value.Icon or "")
			local proxy, CommitUI, ClearUI = CreateGroupboxProxy(realGroupbox);

			rawset(real_env, "Groupbox", proxy); rawset(addon_env, "Groupbox", proxy);
			rawset(addon_env, "CurrentGroupbox", realGroupbox); rawset(addon_env, "CommitUI", CommitUI); rawset(addon_env, "ClearUI", ClearUI);
		end;

		__index = function(_, key)
			return rawget(addon_env, key) or AddonsTab[key] or luna_xyz_env[key] or exec_env[key];
		end;
	});

	addon_env.luna_xyz = addon_env;
	addon_env.luna_xyz_env = luna_xyz_env;

	return addon_env;
end;

function addons:LoadAddons()
	
	local AddonsTab = luna_xyz_env.Window:AddTab("Addons", "boxes");
	local lastPosition = 1;

	if not luna_xyz_env._SupportsFileSystem then

		AddonsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nluna.xyz was unable to create addons folder (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
		});

		return {};
	end;

	if #listfiles("luna_xyz/addons") <= 0 then

		AddonsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nYour addons FOLDER is empty! (luna_xyz/addons)."
		});

		return {};
	end;

	repeat task.wait() until luna_xyz_loaded;

	local startTime = os.time();
	Logger.debug("Loading addons..");

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - WARNING</font>', Visible = true;
		Text = "\nThis tab is for UN-OFFICIAL addons made for luna.xyz, We are not responsible for what addons you will use. You are putting yourself <b>AT RISK</b> since you are executing third-party scripts.";
	});
	
	for i, v in pairs(listfiles("luna_xyz/addons")) do
		
		local startTime2 = os.time(); local addon_name = v:match(".+\\(.+)") or v;
		Logger.debug('Loading addon ' .. addon_name .. '..');
		
		if not ({lua=true, luau=true, txt=true})[(v:match("%.([%w]+)$") or ""):lower()] then
			
			Logger.error('Failed to load addon ' .. addon_name .. ' - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
			Logger.error('    RUNTIME ERROR: Invalid extension type must be ".lua", ".luau", ".txt"');

			local Groupbox = CreateAddonGroupbox(AddonsTab, addon_name);
			Groupbox:AddLabel('<font color="rgb(255, 0, 0)">RUNTIME ERROR: Invalid extension type must be ".lua", ".luau", ".txt"</font>', true);

			continue;
		end;

		local fn = loadfile and loadfile(v) or loadstring(readfile(v));
		local addon_env = CreateAddonEnv(AddonsTab, addon_name);
		
		setfenv(fn, addon_env);
		local success, runtimeErr = pcall(fn);

		if not addon_env.AddonInfo then
			
			if addon_env.ClearUI then addon_env.ClearUI(); end;

			Logger.error('Failed to load addon ' .. addon_name .. ' - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
			Logger.error('    RUNTIME ERROR: "AddonInfo" table not found');

			local Groupbox = addon_env.CurrentGroupbox or CreateAddonGroupbox(AddonsTab, addon_name);
			Groupbox:AddLabel('<font color="rgb(255, 0, 0)">RUNTIME ERROR: "AddonInfo" table not found</font>', true);

			continue;
		end;

		if not addon_env.AddonInfo.Title then
			
			if addon_env.ClearUI then addon_env.ClearUI(); end;

			Logger.error('Failed to load addon ' .. addon_name .. ' - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
			Logger.error('    RUNTIME ERROR: Invalid title argument (string expected, got ' .. typeof(addon_env.AddonInfo.Title) .. ')');

			local Groupbox = addon_env.CurrentGroupbox or CreateAddonGroupbox(AddonsTab, addon_name);
			Groupbox:AddLabel('<font color="rgb(255, 0, 0)">RUNTIME ERROR: Invalid title argument (string expected, got ' .. typeof(addon_env.AddonInfo.Title) .. ')</font>', true);

			continue;
		end;
		
		if not addon_env.AddonInfo.Game or not luna_xyz_env:IsValidGame(addon_env.AddonInfo.Game) then

			if addon_env.ClearUI then addon_env.ClearUI(); end;

			Logger.error('Failed to load addon ' .. addon_name .. ' - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
			Logger.error('    RUNTIME ERROR: Unsupported game (' .. tostring(addon_env.AddonInfo.Game) .. ') by luna.xyz');

			local Groupbox = addon_env.CurrentGroupbox or CreateAddonGroupbox(AddonsTab, addon_name);
			Groupbox:AddLabel('<font color="rgb(255, 0, 0)">RUNTIME ERROR: Unsupported game (' .. tostring(addon_env.AddonInfo.Game) .. ') by luna.xyz</font>', true);

			continue;
		end;
		
		if not success then
			
			if addon_env.ClearUI then addon_env.ClearUI(); end;

			Logger.error('Failed to load addon ' .. addon_name .. ' - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
			Logger.error('    RUNTIME ERROR: ' .. tostring(runtimeErr));

			local Groupbox = addon_env.CurrentGroupbox or CreateAddonGroupbox(AddonsTab, addon_name);
			Groupbox:AddLabel('<font color="rgb(255, 0, 0)">RUNTIME ERROR: ' .. tostring(runtimeErr) .. '</font>', true);

			continue;
		end;
		
		addon_env.CommitUI();
		Logger.success('The addon ' .. addon_name .. ' loaded successfully. - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
	end;
	
	Logger.success('Loaded luna.xyz addons. - (' .. string.format("%.2f", os.time() - startTime) .. ')');
end;

return addons;
