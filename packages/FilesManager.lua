----- || ENV INIT || ------

local identifyexecutor = (identifyexecutor or function() return "Roblox Studio", "v1.0.0"; end);
local getgenv = (getgenv or function() return _G; end);

----- || SERVICES || -----

local luna_xyz_env = getgenv().luna_xyz_env;
local httpService = luna_xyz_env:GetService("HttpService");

local players = luna_xyz_env:GetService("Players");
local LP = players.LocalPlayer;

local SettingsPath, ServersPath = "luna_xyz/saves/settings.json", "luna_xyz/analytics/visited_servers.json";
local SaveManager = luna_xyz_env:LoadPackage("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua");

----- || TABLES || -----

local default_settings = {

	General = {

		IncognitoMode = false; DiscordRichPresence = false;
		ExecuteOnTeleport = false; ConsoleLogs = false; CreateLogs = true;
	};

	Menu = {

		WindowAlwaysOnTop = false; WindowHideOnLoad = false;
		WatermarkVisibility = true; KeybindMenuOpen = false;

		KeybindMenuSettings = true; ShowCustomCursor = false;
		ForceCheckbox = false; MenuKeybind = "LeftAlt"; MenuDPI = "100%"; 
	};

	Notifications  = {

		NotificationSide = "Right"; NotificationStyle = "luna.xyz";
		NotificationSound = true; NotificationVolume = 2; NotificationSoundId = "rbxassetid://82845990304289";
	};

	Animations = {

		WindowAnimations = { ToggleWindow = true; TabSwitch = true; Groupbox = true; Dropdown = true; KeyPicker = true; };
		WindowSwipeDirection = "bottom"; TransitionDuration = 0.22; TransitionOffset = 26;
	};
};

local luna_files = {

	["custom"] = {}; ["analytics"] = {}; ["saves"] = {};

	["assets"] = {
		
		["luna_v1.png"] = { type = "file"; content = game:HttpGet("https://github.com/00lxh/luna_xyz/blob/main/src/assets/luna_v1.png?raw=true"); };
		["luna_v2.png"] = { type = "file"; content = game:HttpGet("https://github.com/00lxh/luna_xyz/blob/main/src/assets/luna_v2.png?raw=true"); };
		["luna_v3.png"] = { type = "file"; content = game:HttpGet("https://github.com/00lxh/luna_xyz/blob/main/src/assets/luna_v3.png?raw=true"); };
	};
	
	["logs"] = {
		["NOTICE.txt"] = { type = "file"; content = "WARNING:\nDo NOT share these logs with anyone other than the developers.\n\nThey may contain sensitive information such as but not limited to: Username, HWID, and Security Tokens.\nThese logs are crash reports and are only helpful to the developers. You may delete these if needed. Logs older than 10 days are automatically deleted.\n\n- Thank you <3!"; };
	};
};

local analytics_data_template = {

	["executor"] = identifyexecutor();
	["TotalExecutions"] = 0; ["t"] = { [LP.UserId] = 0; };
};

local luna_settings, servers_available = {}, {};

----- || METHODS || -----

local function DeepCopy(tbl)

	local copy = {};

	for key, value in tbl do copy[key] = type(value) == "table" and DeepCopy(value) or value;end;
	return copy;
end;

local function MergeTables(defaults, loaded)

	local merged = DeepCopy(defaults);

	for key, value in loaded do

		if type(value) == "table" and type(defaults[key]) == "table" then merged[key] = MergeTables(defaults[key], value); continue; end;
		merged[key] = type(value) == "table" and DeepCopy(value) or value;
	end;
	
	return merged;
end;

local function GetPath(tbl, path)

	local current = tbl;

	for key in string.gmatch(path, "[^%.]+") do

		if type(current) ~= "table" then return nil; end;
		current = current[key];
	end;

	return current;
end;

----- || FILES LOADER || -----

function SaveManager:SaveSettings()

	local success, result = pcall(function()
		writefile(SettingsPath, httpService:JSONEncode(luna_settings));
	end);

	return success, result;
end;

function SaveManager:SaveVisitedServers()

	local success, result = pcall(function()
		writefile(ServersPath, httpService:JSONEncode(servers_available));
	end);

	return success, result;
end;

function SaveManager:LoadSettings()

	local function loadFile(path)

		if not isfile(path) then return nil; end;

		local success, result = pcall(function()
			return httpService:JSONDecode(readfile(path));
		end);

		return success and type(result) == "table" and result or nil;
	end;

	servers_available = loadFile(ServersPath) or {};
	luna_settings = MergeTables(default_settings, loadFile(SettingsPath) or DeepCopy(default_settings));

	return self:SaveSettings();
end;

function SaveManager:SetSetting(name, value)

	local keys = {};

	for key in string.gmatch(name, "[^%.]+") do table.insert(keys, key); end;
	local current = luna_settings;

	for i = 1, #keys - 1 do

		if type(current[keys[i]]) ~= "table" then return false; end;
		current = current[keys[i]];
	end;

	current[keys[#keys]] = value;
	self:SaveSettings();

	return value;
end;

function SaveManager:SetSettingValue(Name, Value)

	for _, setting_group in { luna_xyz_env.Toggles; luna_xyz_env.Options; luna_xyz_env.Labels; } do

		local ui_element = setting_group[Name];

		if ui_element and ui_element.SetValue then
			if ui_element.Type == "KeyPicker" then ui_element:SetValue({ Value, ui_element.Mode, ui_element.Modifiers }); else ui_element:SetValue(Value); end; return true;
		end;
	end;
	return false;
end;

function SaveManager:ApplySettings(_settings, prefix)

	for name, value in pairs(_settings or luna_settings) do

		local path = prefix and (prefix .. "." .. name) or name;
		if type(value) == "table" then self:ApplySettings(value, path); else self:SetSettingValue(name, value); end;
	end;
end;

function SaveManager:ResetSetting(name)

	local keys = {};
	for key in string.gmatch(name, "[^%.]+") do table.insert(keys, key); end;

	local default = GetPath(default_settings, name);
	if default == nil then return false; end;

	local current = luna_settings;

	for i = 1, #keys - 1 do

		current = current[keys[i]];
		if type(current) ~= "table" then return false; end;
	end;

	current[keys[#keys]] = DeepCopy(default);
	self:SaveSettings();

	return true;
end;

function SaveManager:ResetSettings()

	luna_settings = DeepCopy(default_settings);
	self:SaveSettings();

	return luna_settings;
end;

function SaveManager:GetSetting(name)

	local value = GetPath(luna_settings, name);

	if value ~= nil then return value; end;
	return GetPath(default_settings, name);
end;

function SaveManager:GetDefaultSettings()
	return default_settings;
end;

----- || FINALIZE || -----

if isfolder("luna_xyz") and isfile("luna_xyz/hash_cache.json") then delfolder("luna_xyz"); end;
if not isfolder("luna_xyz") then makefolder("luna_xyz"); end;

for folder_name, folder_data in luna_files do

	if not isfolder(('luna_xyz/%s'):format(folder_name)) then makefolder(('luna_xyz/%s'):format(folder_name)); end;
	if not next(folder_data) then continue; end;

	for file_name, file_data in folder_data do

		if file_data.type == "folder" and not isfolder(('luna_xyz/%s/%s'):format(folder_name, file_name)) then

			makefolder(('luna_xyz/%s/%s'):format(folder_name, file_name));
			if #file_data.content == 0 then continue; end;

			for a, b in file_data.content do

				if isfile(('luna_xyz/%s/%s/%s'):format(folder_name, file_name, a)) then continue; end;
				writefile(('luna_xyz/%s/%s/%s'):format(folder_name, file_name, a), b);
			end;

		elseif file_data.type == "file" and not isfile(('luna_xyz/%s/%s'):format(folder_name, file_name)) then

			if isfile(('luna_xyz/%s/%s'):format(folder_name, file_name)) then continue; end;
			writefile(('luna_xyz/%s/%s'):format(folder_name, file_name), file_data.content);
		end;
	end;
end;

if not isfile("luna_xyz/analytics/stats.json") then writefile("luna_xyz/analytics/stats.json", httpService:JSONEncode(analytics_data_template)); end;
local analytics_data = httpService:JSONDecode(readfile("luna_xyz/analytics/stats.json")); MergeTables(analytics_data_template, analytics_data);

analytics_data.TotalExecutions += 1; luna_xyz_env.analytics_data = analytics_data;
writefile("luna_xyz/analytics/stats.json", httpService:JSONEncode(analytics_data));

task.spawn(function()
	while task.wait(10) and luna_xyz_env do writefile("luna_xyz/analytics/stats.json", httpService:JSONEncode(analytics_data)); end;
end);

SaveManager.FilesLoaded = true;
return SaveManager;
