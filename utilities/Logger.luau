----- || LIBRARY || -----

local CoreGui = cloneref(game:GetService("CoreGui"));

local Logger = {};
Logger.ClassName = "Logger"

----- || METHODS || -----

local function GetCurrentDate()

	local date = os.date("*t");
	return string.format("%02d-%02d-%04d %02d:%02d:%02d", date.month, date.day, date.year, date.hour, date.min, date.sec);
end;

local function CreateLog(t, c)
	
	if not CoreGui:FindFirstChild("DevConsoleMaster") then return; end;
	local devConsoleMaster = CoreGui:FindFirstChild("DevConsoleMaster");

	local text, text_log, color = tostring(math.random(-20000, 20000));
	print(text);

	if tostring(t) == "EVENT" then color = Color3.fromRGB(255, 255, 0);
	elseif tostring(t) == "WARN" then color = Color3.fromRGB(255, 170, 0);
	elseif tostring(t) == "ERROR" then color = Color3.fromRGB(170, 0, 0);
	elseif tostring(t) == "DEBUG" then color = Color3.fromRGB(125, 125, 125);
	elseif tostring(t) == "READY" then color = Color3.fromRGB(0, 170, 255); end;
	
	task.spawn(function()
		
		repeat task.wait(.1)
			
			for _, v in pairs(devConsoleMaster:GetDescendants()) do		
				if v:IsA("TextLabel") and string.find(v.Text:lower(), text:lower()) then text_log = v; break; end;
			end;
			
		until text_log;

		text_log.TextColor3 = color; text_log.TextSize = 15;
		text_log.Text = string.format("[%s]: [%s] %s", GetCurrentDate(), tostring(t), tostring(c));
	end);
end;

----- || CALLBACKS || -----

function Logger.event(content) CreateLog("EVENT", content); end;
function Logger.warn(content) CreateLog("WARN", content); end;

function Logger.error(content) CreateLog("ERROR", content); end;
function Logger.debug(content) CreateLog("DEBUG", content); end;

function Logger.ready(content) CreateLog("READY", content); end;

local logger_table = setmetatable({}, {

	__index = Logger;

	__newindex = function(_, key, value)
		error('You cannot modify this table: attempt to set "' .. tostring(key) .. '" to "' .. tostring(value) .. '"');
	end;

	__metatable = "🔒 This is a read-only table.";
});

getgenv().Logger = logger_table;
return logger_table;