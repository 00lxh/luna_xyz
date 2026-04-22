----- || LIBRARY || -----
local clonefunction = (clonefunction or function(fn: any) return fn end);
local cloneref = (cloneref or function(instance: any) return instance end);

local CoreGui = cloneref(game:GetService("CoreGui"));
local new_print = clonefunction(print);

local TextService = cloneref(game:GetService("TextService"));
local RunService = cloneref(game:GetService("RunService"));

getgenv().Logger = {
	
	["EVENT"] = {
		
		Icon = "info"; AltIcon = "rbxassetid://11422155687";
		Color = Color3.fromRGB(255, 255, 0);
	};
	
	["WARN"] = {

		Icon = "triangle-alert"; AltIcon = "rbxassetid://11419713314";
		Color = Color3.fromRGB(255, 170, 00);
	};
	
	["ERROR"] = {

		Icon = "circle-x"; AltIcon = "rbxassetid://11419709766";
		Color = Color3.fromRGB(255, 0, 0);
	};
	
	["SUCCESS"] = {

		Icon = "circle-check"; AltIcon = "rbxassetid://11419719540";
		Color = Color3.fromRGB(0, 255, 0);
	};
	
	["DEBUG"] = {

		Icon = "bug"; AltIcon = "rbxassetid://11419714821";
		Color = Color3.fromRGB(125, 125, 125);
	};
	
	["INFO"] = {

		Icon = "circle-question-mark"; AltIcon = "rbxassetid://11432859220";
		Color = Color3.fromRGB(255, 255, 255);
	};

	["WAITING"] = {

		Icon = "clock-fading"; AltIcon = "rbxassetid://11963371162";
		Color = Color3.fromRGB(255, 255, 127);
	};
	
	["READY"] = {

		Icon = "circle-check"; AltIcon = "rbxassetid://11419719540";
		Color = Color3.fromRGB(0, 170, 255);
	};
	
	["LOADING"] = {
		Icon = "loader"; AltIcon = "rbxassetid://11293978505";
	};
	
	ClassName = "Logger";
	IconsEnabled = true;
	
	ConsoleLogs = true;
	SaveLogs = false;
};

Logger.__index = Logger;

local current_date = os.date("*t");
current_date = string.format("%02d-%02d-%04d", current_date.month, current_date.day, current_date.year);

type IconModule = { Icons: { string }; GetAsset: (Name: string) -> Icon?; };

local __s, __d = pcall(function()
	return (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua")) :: () -> IconModule)();
end);

if not current_logs then getgenv().current_logs = {}; end;
if Logger.logger_conn then Logger.logger_conn:Disconnect(); Logger.logger_conn = nil; end;

----- || METHODS || -----

function GetCurrentDate()

	local date = os.date("*t");
	return string.format("%02d-%02d-%04d %02d:%02d:%02d", date.month, date.day, date.year, date.hour, date.min, date.sec);
end;

function CreateId()
	return string.format("0x%06x", math.random(0, 0xFFFFFF));
end;

function IsValidCustomIcon(Icon: string)
	return typeof(Icon) == "string" and (Icon:match("rbxasset") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="));
end;

function GetIcon(IconName: string)
	
	if not __s then return; end;
	local success, icon_data = pcall(__d.GetAsset, IconName);
	
	if not success then return; end;
	return icon_data;
end;

function GetCustomIcon(IconName: string)
	
	local CustomIcon = IsValidCustomIcon(IconName);
	
	if CustomIcon then
		return { Url = IconName; ImageRectOffset = Vector2.zero; ImageRectSize = Vector2.zero; Custom = true; };
	end;

	local LucideIcon = GetIcon(IconName);
	if LucideIcon then return LucideIcon; end;

	return { Url = tonumber(IconName) and string.format("rbxassetid://%s", tostring(IconName)) or IconName; ImageRectOffset = Vector2.zero; ImageRectSize = Vector2.zero; Custom = true; };
end;

local function CreateLog(_type: string, str: string)
	
	local log_id, log_date = CreateId(), GetCurrentDate();
	local icon = GetCustomIcon(Logger[_type].Icon or Logger[_type].AltIcon);
	
	local color = Logger[_type].Color or Color3.fromRGB(255, 255, 255);
	local text_color = string.format("%d, %d, %d", color.R * 255, color.G * 255, color.B * 255);

	current_logs[log_id] = {	
		Icon = icon; Color = color; str = '<font color="rgb(' .. text_color .. ')">' .. string.format("[%s]: [%s] %s (%s)", log_date, _type, tostring(str), log_id) .. '</font>'
	};
	if Logger.ConsoleLogs then new_print(log_id); end;
	
	if Logger.SaveLogs and isfile and readfile and writefile then

		local saveLocation = Logger.SaveLocation or "";

		local lastLog = isfile(saveLocation .. current_date .. '.log') and readfile(saveLocation .. current_date .. '.log') .. '\n' or "";
		writefile(saveLocation .. current_date .. '.log', lastLog .. string.format("[%s]: [%s] %s (%s)", log_date, _type, tostring(str), log_id));
	end;
end;

----- || CALLBACKS || -----

function Logger.event(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("EVENT", str);
end;

function Logger.warn(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("WARN", str);
end;

function Logger.error(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("ERROR", str);
end;

function Logger.success(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("SUCCESS", str);
end;

function Logger.debug(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("DEBUG", str);
end;

function Logger.info(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("INFO", str);
end;

function Logger.wait(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("WAITING", str);
end;

function Logger.ready(str: string)
	
	assert(typeof(str) == "string", "Invalid string.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string.");
	
	CreateLog("READY", str);
end;

function Logger:CreateLoading(options: table)
	
	local loader_obj = {}
	options = options or {};
	
	loader_obj.Color = options.Color or Color3.fromRGB(255, 255, 255);
	loader_obj.Subject = options.Subject or "N/A";
	
	loader_obj.Title = options.Title or "LOADING";
	loader_obj.Symbol = options.Symbol or "#";
	
	loader_obj.CurrentStep = options.CurrentStep or 0;
	loader_obj.TotalSteps = options.TotalSteps or 10;
	
	assert(typeof(loader_obj.Title) == "string", "Invalid string for the Title.");
	assert(loader_obj.Title:match("^%s*(.-)%s*$") ~= "", "Invalid string for the Title.");
	
	assert(typeof(loader_obj.Subject) == "string", "Invalid string for the Subject.");
	assert(loader_obj.Subject:match("^%s*(.-)%s*$") ~= "", "Invalid string for the Subject.");
	
	assert(typeof(loader_obj.Symbol) == "string", "Invalid string for the loading symbol.");
	assert(loader_obj.Symbol:match("^%s*(.-)%s*$") ~= "", "Invalid string for the loading symbol.");
	
	assert(typeof(loader_obj.CurrentStep) == "number" and loader_obj.CurrentStep == loader_obj.CurrentStep, "Invalid Step number.");
	assert(typeof(loader_obj.TotalSteps) == "number" and loader_obj.TotalSteps == loader_obj.TotalSteps, "Invalid Step number.");
	
	assert(typeof(loader_obj.Color) == "Color3", "Invalid color3 for the loader.");
	local log_id, log_date = CreateId(), GetCurrentDate();
	
	local function UpdateLoadingText(canSave: boolean)
		
		local filled = math.floor((loader_obj.CurrentStep / loader_obj.TotalSteps) * 40);
		local progress = string.rep(loader_obj.Symbol, filled) .. string.rep("-", 40 - filled);
		
		local icon = GetCustomIcon(Logger["LOADING"].Icon or Logger["LOADING"].AltIcon);
		local text_color = string.format("%d, %d, %d", loader_obj.Color.R * 255, loader_obj.Color.G * 255, loader_obj.Color.B * 255);
		
		local str = '[' .. progress .. '] - ' .. math.floor((loader_obj.CurrentStep / loader_obj.TotalSteps) * 100) .. '%';
		
		if Logger.SaveLogs and canSave and isfile and readfile and writefile then

			local saveLocation = Logger.SaveLocation or "";

			local lastLog = isfile(saveLocation .. current_date .. '.log') and readfile(saveLocation .. current_date .. '.log') .. '\n' or "";
			writefile(saveLocation .. current_date .. '.log', lastLog .. string.format("[%s]: [%s] %s (%s)", log_date, loader_obj.Title, loader_obj.CurrentStep < loader_obj.TotalSteps and 'Loading started! - (' .. loader_obj.Subject .. ')' or 'Loading finished! - (' .. loader_obj.Subject .. ')', log_id));
		end;

		return { Icon = icon; Color = loader_obj.Color; str = '<font color="rgb(' .. text_color .. ')">' .. string.format("[%s]: [%s] %s (%s)", log_date, loader_obj.Title, str, log_id) .. '</font>' };
	end;

	current_logs[log_id] = UpdateLoadingText(true);
	if Logger.ConsoleLogs then new_print(log_id); end;
	
	function loader_obj:SetTitle(str: string)
		
		assert(typeof(str) == "string", "Invalid string for the Title.");
		assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string for the Title.");
		
		loader_obj.Title = str;
		return loader_obj;
	end;
	
	function loader_obj:SetSubject(str: string)

		assert(typeof(str) == "string", "Invalid string for the Subject.");
		assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string for the Subject.");

		loader_obj.Subject = str;
		return loader_obj;
	end;
	
	function loader_obj:SetColor(color: Color3)

		assert(typeof(color) == "Color3", "Invalid color3 for the loader.");
		loader_obj.Color = color;

		return loader_obj;
	end;
	
	function loader_obj:SetTotalSteps(step: number)

		assert(typeof(step) == "number" and step == step, "Invalid Step number.");
		loader_obj.TotalSteps = step;
		
		current_logs[log_id] = UpdateLoadingText();
		return loader_obj;
	end;
	
	function loader_obj:SetCurrentStep(step: number)
		
		assert(typeof(step) == "number" and step == step, "Invalid Step number.");
		loader_obj.CurrentStep = math.clamp(step, 0, loader_obj.TotalSteps);
		
		current_logs[log_id] = UpdateLoadingText(loader_obj.CurrentStep >= loader_obj.TotalSteps);
		return loader_obj;
	end;
	
	return loader_obj;
end;

function Logger:SetSaveLocation(str: string)
	
	if str == nil then Logger.SaveLocation = nil; return; end;
	
	assert(typeof(str) == "string", "Invalid string location.");
	assert(str:match("^%s*(.-)%s*$") ~= "", "Invalid string location.");
	
	Logger.SaveLocation = str;
end;

function Logger:ToggleIcons(value: boolean)

	assert(typeof(value) == "boolean", 'Invalid argument #1 to "ToggleIcons" (boolean expected, got ' .. typeof(value) .. ')');
	Logger.IconsEnabled = value;
end;

function Logger:ToggleLogs(value: boolean)

	assert(typeof(value) == "boolean", 'Invalid argument #1 to "ToggleLogs" (boolean expected, got ' .. typeof(value) .. ')');
	Logger.SaveLogs = value;
end;

function Logger:ToggleConsoleLogs(value: boolean)

	assert(typeof(value) == "boolean", 'Invalid argument #1 to "ToggleConsoleLogs" (boolean expected, got ' .. typeof(value) .. ')');
	Logger.ConsoleLogs = value;
end;

function Logger:Destroy()
	
	if Logger.logger_conn then Logger.logger_conn:Disconnect(); Logger.logger_conn = nil; end;
	getgenv().Logger = nil;
end;

Logger.logger_conn = RunService.Heartbeat:Connect(function()

	if not CoreGui:FindFirstChild("DevConsoleMaster") then return; end;
	local DevConsoleUI = CoreGui.DevConsoleMaster.DevConsoleWindow.DevConsoleUI;

	for _, v in pairs(DevConsoleUI:GetDescendants()) do

		if not v:IsA("TextLabel") then continue; end;

		for log_id, log_data in pairs(current_logs) do

			if not v.Text or not v.Text:find(log_id, 1, true) then continue; end;
			
			v.RichText = true; v.Text = log_data.str;
			v.Parent.AutomaticSize = Enum.AutomaticSize.Y; v.AutomaticSize = Enum.AutomaticSize.Y;
			
			v.Parent.image.Image = Logger.IconsEnabled and log_data.Icon.Url or ""; v.Parent.image.ImageColor3 = log_data.Color;
			v.Parent.image.ImageRectOffset = log_data.Icon.ImageRectOffset; v.Parent.image.ImageRectSize = log_data.Icon.ImageRectSize;
			break;
		end;
	end;
end);

return Logger;
