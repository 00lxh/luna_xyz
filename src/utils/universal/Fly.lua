local Fly = { FlyBody = nil; FlyGyro = nil; Enabled = false; Speed = 50; Loaded = false };

local ControlModule = luna_xyz_env:GetService("ControlModule");
local CurrentCamera = workspace.CurrentCamera;

local UserInputService = luna_xyz_env:GetService("UserInputService");
local RunService = luna_xyz_env:GetService("RunService");

local Players = luna_xyz_env:GetService("Players");
local LP = Players.LocalPlayer;

function Fly:Setup()
	
	if luna_xyz_env.Maid.FlyConnection then luna_xyz_env.Maid.FlyConnection = nil; end;
	if luna_xyz_env.Maid.FlyCharacterAdded then luna_xyz_env.Maid.FlyCharacterAdded = nil; end;
	
	if not luna_xyz_env then return; end;
	
	local flyBody = Instance.new("BodyVelocity");
	flyBody.Velocity, flyBody.MaxForce = Vector3.zero, Vector3.one * 9e9;

	local flyGyro = Instance.new("BodyGyro");
	
	flyGyro.MaxTorque, flyGyro.P = Vector3.one * 9e9, 9e4;
	Fly.FlyBody, Fly.FlyGyro = flyBody, flyGyro;

	luna_xyz_env.Maid.FlyConnection = RunService.RenderStepped:Connect(function()
		
		if not Fly.Enabled or not luna_xyz_env or not (Fly.FlyBody.Parent or Fly.FlyGyro.Parent) then return; end;

		local velocity = Vector3.zero;
		local moveVector = ControlModule:GetMoveVector();
		
		velocity = -((CurrentCamera.CFrame.LookVector * moveVector.Z) - (CurrentCamera.CFrame.RightVector * moveVector.X));

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity += CurrentCamera.CFrame.UpVector; end;
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity -= CurrentCamera.CFrame.UpVector; end;

		Fly.FlyBody.Velocity = velocity * Fly.Speed;
		Fly.FlyGyro.CFrame = CurrentCamera.CFrame;
	end);
	
	Fly.Loaded = true;
end;

function Fly:Toggle(value: boolean)
	
	if luna_xyz_env.Maid.FlyCharacterAdded then luna_xyz_env.Maid.FlyCharacterAdded = nil; end;
	if not Fly.Loaded then return warn('[FLY]: Use "Fly:Setup()" before using this function.'); end;
	
	local rootPart = luna_xyz_env:GetRoot(LP);
	if not rootPart then return warn("[FLY]: HumanoidRootPart is missing or nil."); end;
	
	local humanoid = rootPart and rootPart.Parent:FindFirstChildOfClass("Humanoid");
	if humanoid then humanoid.PlatformStand = value; end;
	
	Fly.Enabled = value;
	
	pcall(function()
		Fly.FlyBody.Parent = if value then rootPart else nil;
		Fly.FlyGyro.Parent = if value then rootPart else nil;
	end);
	
	luna_xyz_env.Maid.FlyCharacterAdded = LP.CharacterAdded:Connect(function(character)
		
		task.wait(.3);
		if not Fly.Enabled or not luna_xyz_env then return; end;
		
		if Fly.FlyBody then Fly.FlyBody:Destroy(); end;
		if Fly.FlyGyro then Fly.FlyGyro:Destroy(); end;
		
		Fly:Setup(); Fly:Toggle(true);
	end);
end;

function Fly:SetSpeed(speed: number)
	Fly.Speed = speed;
end;

return Fly;
