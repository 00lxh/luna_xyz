local UserInputService = luna_xyz_env:GetService("UserInputService");

local Players = luna_xyz_env:GetService("Players");
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");

if PlayerScripts:FindFirstChild("PlayerModule") then
	return require(PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"));
end;

local ControlModule = { GamepadMoveVector = Vector3.zero; ThumbstickMoveVector = Vector3.zero; ThumbstickRadius = 15; TouchInput = nil; TouchStartPosition = nil };

function ControlModule:GetMoveVector(): Vector3
	
	local x, z = 0, 0;

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then z -= 1; end;
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then z += 1; end;
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then x -= 1; end;
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then x += 1; end;

	return Vector3.new(x, 0, z) + ControlModule.ThumbstickMoveVector + ControlModule.GamepadMoveVector;
end;

luna_xyz_env.Maid:GiveTask(UserInputService.InputChanged:Connect(function(input, gameProcessed)
	
	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 and not gameProcessed then
		ControlModule.GamepadMoveVector = Vector3.new(input.Position.X, 0, -input.Position.Y);
	end;
end));

luna_xyz_env.Maid:GiveTask(UserInputService.TouchStarted:Connect(function(input)
	ControlModule.TouchInput = input; ControlModule.TouchStartPosition = input.Position;
end));

luna_xyz_env.Maid:GiveTask(UserInputService.TouchMoved:Connect(function(input)
	
	if input ~= ControlModule.TouchInput then return; end;
	if not ControlModule.TouchStartPosition or not input.Position then return; end;
	
	local moveDirection = (input.Position - ControlModule.TouchStartPosition).Unit
	local distance = (input.Position - ControlModule.TouchStartPosition).Magnitude

	if distance > ControlModule.ThumbstickRadius then
		distance = ControlModule.ThumbstickRadius
	end

	local adjustedDistance = distance / ControlModule.ThumbstickRadius
	ControlModule.ThumbstickMoveVector = Vector3.new(moveDirection.X * adjustedDistance, 0, moveDirection.Y * adjustedDistance)
end));

luna_xyz_env.Maid:GiveTask(UserInputService.TouchEnded:Connect(function(input)
	if input ~= ControlModule.TouchInput then return; end;

	ControlModule.ThumbstickMoveVector = Vector3.new(0, 0, 0);
	ControlModule.TouchInput = nil;
end));

return ControlModule;
