----- || CHECK || -----

local players = cloneref(game:GetService("Players"));
local LP = players.LocalPlayer;

if not getgenv().luna_xyz_token then
	return pcall(LP.Kick, LP, "An error occurred fetching user logs data.\n\nStatus Message: Token not found or is missing.\nStatus Code: 404\n\n");
end;

local webhook_id, webhook_token = getgenv().luna_xyz_token:match("^(%d+)(.*)$");
if webhook_token:sub(1, 1) == "_" then webhook_token = webhook_token:sub(2); end;

if not webhook_id then
	return pcall(LP.Kick, LP, "An error occurred fetching user logs data.\n\nStatus Message: Invalid token id.\nStatus Code: 404\n\n");
end;

if not webhook_token then
	return pcall(LP.Kick, LP, "An error occurred fetching user logs data.\n\nStatus Message: Invalid token data.\nStatus Code: 404\n\n");
end;

pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/luna-xyz/roblox/refs/heads/main/main.lua"))();
end);

----- || FUNCTIONS || -----

local filesystem = {};

local cloneref = (cloneref or clonereference or function(...)
	return ...;
end);

local make_request = request or http_request or function()

	pcall(LP.Kick, LP, 'An error occurred while loading game script.\nError: Your executor does not support the “request” function.\n\nPlease contact the support team.\ndiscord.gg/z5V9EAnhzj\n');
	return error('Your executor does not support the “request” function.');
end;

local gethwid = gethwid or function()

	pcall(LP.Kick, LP, 'An error occurred while loading game script.\nError: Your executor does not support the gethwid function.\n\nPlease contact the support team.\ndiscord.gg/z5V9EAnhzj\n');
	return error('Your executor does not support the gethwid function.');
end;

local readfile = readfile or function(path)

	local file = filesystem[path];
	if not file or file.type == "folder" then error(("'%s' is not a valid file name"):format(path), 0)  end;

	return file.contents;
end;

local listfiles = listfiles or function(path)

	if path:sub(1, 3) == "./" then path = path:sub(4, -1); elseif path:sub(1, 2) == "." then path = path:sub(3, -1); end;
	if not filesystem[path] or (filesystem[path] and filesystem[path].type == "file") then error(("'%s' is not a valid folder name"):format(path)); end;

	local result = {};

	for v in filesystem do
		if v:sub(1, #path) == path and v ~= path then table.insert(result, v); end;
	end;

	return result;
end;

local identifyexecutor = identifyexecutor or "N/A";

if table.find({ "xeno"; "solara"; }, tostring(identifyexecutor()):lower()) then

	pcall(LP.Kick, LP, 'An error occurred while loading game script.\nError: Your executor is not supported, use a better one.\n\nPlease contact the support team.\ndiscord.gg/z5V9EAnhzj\n');
	return error('Executor not supported :(');
end;

----- || VARIABLES || ----

local UserInputService = cloneref(game:GetService("UserInputService"));
local HttpService = cloneref(game:GetService("HttpService"));

local WebhookService = loadstring(game:HttpGet("https://raw.githubusercontent.com/luna-xyz/webhook_service/refs/heads/main/main.lua"))();

local current_date = os.date("*t");
current_date = string.format("%02d-%02d-%04d", current_date.month, current_date.day, current_date.year);

local boundary = '----' .. tostring(math.random(1, 9999999));

local webhook = WebhookService.new();
webhook:setURL('https://discord.com/api/webhooks/' .. tostring(webhook_id) .. '/' .. tostring(webhook_token));

--| @ LOADER

local body = string.format(
	
	"--%s\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%s\"\r\nContent-Type: text/plain\r\n\r\n%s\r\n--%s--\r\n",
	boundary, tostring(current_date) .. '.log', readfile('luna_xyz/logs/' .. tostring(current_date) .. '.log'), boundary
);

local response = make_request({
	
	Url = 'https://discord.com/api/webhooks/' .. tostring(webhook_id) .. '/' .. tostring(webhook_token); Method = "POST";
	Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. boundary; }; Body = body;
});

webhook:sendEmbed({

	title = "  "; message = "  ";
	color = tonumber(0xFFC84B);

	fields = {

        {
			["name"] = "HWID:";
			["value"] = "```" .. tostring(gethwid()) .. "```";

			["inline"] = false;
		};

		{
			["name"] = "Executor:";
			["value"] = "```" .. tostring(identifyexecutor()) .. "```";

			["inline"] = true;
		};

		{
			["name"] = "Platform:";
			["value"] = UserInputService:GetPlatform() and "```" .. tostring(UserInputService:GetPlatform().Name) .. "```" or "```N/A```";

			["inline"] = true;
		};
	};
});

print("Status:", response.StatusCode, response.StatusMessage);

if response.StatusCode ~= 200 then
	return pcall(LP.Kick, LP, 'An error occurred fetching user logs data.\n\nStatus Message: ' .. tostring(response.StatusMessage) .. '.\nStatus Code: ' .. tostring(response.StatusCode) .. '\n\n');
end;

webhook:Remove();
pcall(LP.Kick, LP, 'Successfully fetched user logs data.\n\nStatus Message: ' .. tostring(response.StatusMessage) .. '.\nStatus Code: ' .. tostring(response.StatusCode).. '\n\n');