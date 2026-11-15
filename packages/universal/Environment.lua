---- || LOADING CHECK || -----

local identifyexecutor = (identifyexecutor or function() return "Roblox Studio", "v1.0.0"; end);
local getgenv = (getgenv or function() return _G; end);

local cloneref = (cloneref or function(instance: any) return instance end);
local coreGui = cloneref(game:GetService("CoreGui"));

local gethui = (gethui or function() return coreGui; end);
local luna_xyz_env, package_cache, hidden_ui = getgenv().luna_xyz_env or {}, {}, gethui();

local luna_cache = hidden_ui:FindFirstChild("luna_cache") or Instance.new("Folder", hidden_ui);
luna_cache.Name = "luna_cache";

local luna_metadata = loadstring(game:HttpGet("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/metadata.lua"))();
local status_metadata, games_metadata = luna_metadata:GetStatusMetadata(), luna_metadata:GetGamesMetadata();

----- || SERVICES || -----

local UserInputService = cloneref(game:GetService("UserInputService"));
local GuiService = cloneref(game:GetService("GuiService"));

local Players = cloneref(game:GetService("Players"));
local LP = Players.LocalPlayer;

local current_camera = workspace.CurrentCamera;
local floor = math.floor;

----- || METHODS || -----

function luna_xyz_env:LoadPackage(url, ...)

	local args = table.pack(...);

	local success, result = pcall(function()

		assert(type(url) == "string" and #url > 0, "Invalid package URL.");
		local source = package_cache[url] or game:HttpGet(url);

		assert(type(source) == "string" and #source > 0, "400 Bad Request.");
		package_cache[url] = source;

		local chunk, compileError = loadstring(source);
		assert(chunk, compileError or "Failed to compile source.");

		return chunk(table.unpack(args, 1, args.n));
	end);

	return (success or nil) and result or nil, success, (not success or nil) and result or nil;
end;

function luna_xyz_env:IsValidGame(obj)

	assert(obj, "argument 1 missing or nil");
	if tostring(obj) == "*" then return true, nil; end;

	for name, data in games_metadata do

		local place_id, game_id = tostring(game.PlaceId), tostring(game.GameId);
		local data_game_id, data_lobby_id = tostring(data.GameId), tostring(data.LobbyGameId);

		if data.GameId and (place_id == data_game_id or game_id == data_game_id) then
			return true, data;
		end

		if data.LobbyGameId and (place_id == data_lobby_id or game_id == data_lobby_id) then

			data.IsGameLobby = true;
			return true, data;
		end
	end

	return false, nil;
end;

function luna_xyz_env:GetService(serviceName)

	assert(serviceName, "Argument #1 missing or nil");
	assert(typeof(serviceName) == "string", ('Invalid argument #1 to "GetService" (string expected, got %s)'):format(typeof(serviceName)));

	if serviceName:lower() == "cache" then return luna_cache; end;
	return cloneref(game:GetService(serviceName));
end;

----- || UTILS || -----

function luna_xyz_env:IsString(str)
	return typeof(str) == "string" and str:match("^%s*(.-)%s*$") ~= "";
end;

function luna_xyz_env:IsNumber(num)
	return typeof(num) == "number" and num == num;
end;

function luna_xyz_env:FormatTime(t)
	return string.format("%02d:%02d:%02d:%02d", floor(t / 86400), floor(t / 3600 % 24), floor(t / 60 % 60), floor(t % 60));
end;

function luna_xyz_env:GetCharacter(player)
	return player.Character or player.CharacterAdded:Wait();
end;

function luna_xyz_env:GetRoot(player)

	local character = luna_xyz_env:GetCharacter(player);
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");
end;

function luna_xyz_env:GetMousePosition()

	if UserInputService.TouchEnabled then return Vector2.new(current_camera.ViewportSize.X / 2, current_camera.ViewportSize.Y / 2); end;
	return UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
end;

function luna_xyz_env:GetMouseLocation()

	local mouse_vector = luna_xyz_env:GetMousePosition();

	if UserInputService.TouchEnabled then return current_camera:ViewportPointToRay(mouse_vector.X, mouse_vector.Y); end;
	return current_camera:ScreenPointToRay(mouse_vector.X, mouse_vector.Y);
end;

function luna_xyz_env:ParseBoolean(raw, default)

	if raw == nil then return default or false; end;
	local str = tostring(raw):lower();

	local trueValues = {
		["true"] = true; ["t"] = true; ["1"] = true; ["yes"] = true; ["y"] = true; ["on"] = true; ["enable"] = true; ["enabled"] = true;
	};

	local falseValues = {
		["false"] = true; ["f"] = true; ["0"] = true; ["no"] = true; ["n"] = true; ["off"] = true; ["disable"] = true; ["disabled"] = true;
	};

	if trueValues[str] then return true; elseif falseValues[str] then return false; end;
	return default or false;
end;

function luna_xyz_env:GetClosestPlayer(filters)

	local rootPart = luna_xyz_env:GetRoot(LP);
	if not rootPart then return nil; end;

	local closest, shortestDist = nil, math.huge;

	for _, v in Players:GetChildren() do

		if not v.Character or v == LP then continue; end;

		local targetRoot = luna_xyz_env:GetRoot(v);
		if not targetRoot or not luna_xyz_env:MatchesFilters(v, filters) then continue; end;

		local dist = (rootPart.Position - targetRoot.Position);
		if dist:Dot(dist) > (shortestDist ^ 2) then continue; end;

		closest, shortestDist = v.Character, dist.Magnitude;
	end;

	return closest;
end;

function luna_xyz_env:MatchesFilters(player, filters)

	filters = filters or {};

	if filters.Team and player.Team and player.Team.Name ~= filters.Team then return false; end;
	local character = player.Character;

	for attribute, expected in filters.Attributes or {} do

		local value = character:GetAttribute(attribute);

		if type(expected) == "function" then if not expected(value) then return false; end;
		elseif expected == false then value = value == true; if value then return false; end;
		elseif value ~= expected then return false; end;
	end;

	return true;
end;

----- || FINALIZE || -----

return luna_xyz_env;
