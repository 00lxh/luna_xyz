local Fly = { FlyBody = nil; FlyGyro = nil; Enabled = false; Speed = 50; Loaded = false };

local ControlModule = luna_xyz_env:GetService("ControlModule");
local CurrentCamera = workspace.CurrentCamera;

local UserInputService = luna_xyz_env:GetService("UserInputService");
local RunService = luna_xyz_env:GetService("RunService");

local Players = luna_xyz_env:GetService("Players");
local LP = Players.LocalPlayer;

function Fly:Setup()
	
	local flyBody = Instance.new("BodyVelocity");
	flyBody.Velocity, flyBody.MaxForce = Vector3.zero, Vector3.one * 9e9;

	local flyGyro = Instance.new("BodyGyro");
	
	flyGyro.MaxTorque, flyGyro.P = Vector3.one * 9e9, 9e4;
	Fly.FlyBody, Fly.FlyGyro = flyBody, flyGyro;

	luna_xyz_env.Maid.Fly = RunService.RenderStepped:Connect(function()
		
		if not Fly.Enabled or not luna_xyz_env then return; end;

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
	
	local Character = luna_xyz_env:GetCharacter(LP);
	local RootPart = luna_xyz_env:GetRoot(LP);
	
	local Humanoid = Character:FindFirstChildOfClass("Humanoid");
	if not Fly.Loaded then return warn('Use "Fly:Setup()" before using this function.'); end;

	if not RootPart then return warn("luna_xyz_env.RootPart is missing or nil."); end;
	if Humanoid then Humanoid.PlatformStand = value; end;
	
	Fly.Enabled = value;
	
	Fly.FlyBody.Parent = if value then RootPart else nil;
	Fly.FlyGyro.Parent = if value then RootPart else nil;
end;

function Fly:SetSpeed(speed: number)
	Fly.Speed = speed;
end;

return Fly;
