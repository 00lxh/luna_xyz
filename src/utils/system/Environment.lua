local CurrentCamera = workspace.CurrentCamera;
local floor = math.floor;

local cloneref = (cloneref or function(instance: any) return instance end);

local coreGui = cloneref(game:GetService("CoreGui"));
local gethui = (gethui or function() return coreGui; end);

local luna_cache = gethui():FindFirstChild("luna_cache") or Instance.new("Folder", gethui());
luna_cache.Name = "luna_cache";

local UserInputService = cloneref(game:GetService("UserInputService"));
local GuiService = cloneref(game:GetService("GuiService"));

function luna_xyz_env:ParseBoolean(raw: any, default: boolean)
	
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

function luna_xyz_env:IsValidGame(obj: any)

	assert(obj, "argument 1 missing or nil");

	if tostring(obj) == "*" then return true; end;
	if luna_xyz_env.supported_games[obj] then return true; end;

	for _, v in pairs(luna_xyz_env.supported_games) do
		if tostring(obj) == tostring(v.GameId) then return true; end;
	end;

	return false;
end;

function luna_xyz_env:GetService(serviceName: string)

	assert(serviceName, "Argument #1 missing or nil");
	assert(typeof(serviceName) == "string", ('Invalid argument #1 to "GetService" (string expected, got %s)'):format(typeof(serviceName)));

	if serviceName:lower() == "cache" then return luna_cache; end;
	if luna_xyz_env.loaded_libs[serviceName] then return luna_xyz_env.loaded_libs[serviceName]; end;

	local service = cloneref(game:GetService(serviceName));
	return service;
end;

function luna_xyz_env:GetMousePosition()

	if UserInputService.TouchEnabled then return Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2); end;
	return UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
end;

function luna_xyz_env:GetMouseLocation()

	local mouse_vector = luna_xyz_env:GetMousePosition();

	if UserInputService.TouchEnabled then return CurrentCamera:ViewportPointToRay(mouse_vector.X, mouse_vector.Y); end;
	return CurrentCamera:ScreenPointToRay(mouse_vector.X, mouse_vector.Y);
end;

function luna_xyz_env:IsString(str: string)
	return typeof(str) == "string" and str:match("^%s*(.-)%s*$") ~= "";
end;

function luna_xyz_env:IsNumber(num: number)
	return typeof(num) == "number" and num == num;
end;

function luna_xyz_env:FormatTime(t: number)
	return string.format("%02d:%02d:%02d:%02d", floor(t / 86400), floor(t / 3600 % 24), floor(t / 60 % 60), floor(t % 60));
end;

function luna_xyz_env:GetCharacter(player: Player)
	return player.Character or player.CharacterAdded:Wait();
end;

function luna_xyz_env:GetRoot(player: Player)
	
	local character = luna_xyz_env:GetCharacter(player);
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");
end;

return {};
