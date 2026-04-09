local floor = math.floor;

function luna_xyz_env:GetMousePosition()

	if luna_xyz_env.UserInputService.TouchEnabled then
		return Vector2.new(luna_xyz_env.Camera.ViewportSize.X / 2, luna_xyz_env.Camera.ViewportSize.Y / 2);
	end;

	return luna_xyz_env.UserInputService:GetMouseLocation() - luna_xyz_env.GuiService:GetGuiInset();
end;

function luna_xyz_env:GetMouseLocation()

	local mouse_vector = luna_xyz_env:GetMousePosition();

	if luna_xyz_env.UserInputService.TouchEnabled then
		return luna_xyz_env.Camera:ViewportPointToRay(mouse_vector.X, mouse_vector.Y);
	end;

	return luna_xyz_env.Camera:ScreenPointToRay(mouse_vector.X, mouse_vector.Y);
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

function luna_xyz_env:IsString(str: string)
	return typeof(str) == "string" and str:match("^%s*(.-)%s*$") ~= "";
end;

function luna_xyz_env:IsNumber(num: number)
	return typeof(num) == "number" and num == num;
end;

function luna_xyz_env:formatTime(t: number)
	return string.format("%02d:%02d:%02d:%02d", floor(t / 86400), floor(t / 3600 % 24), floor(t / 60 % 60), floor(t % 60));
end;

function  luna_xyz_env:GetCharacter(player: Player)
	return player.Character or player.CharacterAdded:Wait();
end;

function luna_xyz_env:GetRoot(player: Player)
	
	local character = luna_xyz_env:GetCharacter(player);
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");
end;

return {};