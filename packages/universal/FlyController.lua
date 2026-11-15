----- || ENV INIT || ------

local getgenv = (getgenv or function() return _G; end);

local luna_xyz_env = getgenv().luna_xyz_env;
local Fly = { FlyBody = nil; FlyGyro = nil; Enabled = false; Speed = 50; Loaded = false; };

----- || SERVICES || -----

local ControlModule = luna_xyz_env:LoadPackage("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/packages/universal/ControlModule.lua");
local UserInputService = luna_xyz_env:GetService("UserInputService");

local RunService = luna_xyz_env:GetService("RunService");
local Players = luna_xyz_env:GetService("Players");

local LP = Players.LocalPlayer;
local current_camera = workspace.CurrentCamera;

----- || INITIALIZE || -----

if luna_xyz_env.Maid.FlyConnection then luna_xyz_env.Maid.FlyConnection = nil; end;
if luna_xyz_env.Maid.FlyCharacterAdded then luna_xyz_env.Maid.FlyCharacterAdded = nil; end;

local flyBody = Instance.new("BodyVelocity");
flyBody.Velocity, flyBody.MaxForce = Vector3.zero, Vector3.one * 9e9;

local flyGyro = Instance.new("BodyGyro");

flyGyro.MaxTorque, flyGyro.P = Vector3.one * 9e9, 9e4;
Fly.FlyBody, Fly.FlyGyro = flyBody, flyGyro;

luna_xyz_env.Maid.FlyConnection = RunService.RenderStepped:Connect(function()

	if not Fly.Enabled or not luna_xyz_env or not (Fly.FlyBody.Parent or Fly.FlyGyro.Parent) then return; end;

	local velocity = Vector3.zero;
	local moveVector = ControlModule:GetMoveVector();

	velocity = -((current_camera.CFrame.LookVector * moveVector.Z) - (current_camera.CFrame.RightVector * moveVector.X));

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity += current_camera.CFrame.UpVector; end;
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity -= current_camera.CFrame.UpVector; end;

	Fly.FlyBody.Velocity = velocity * Fly.Speed; Fly.FlyGyro.CFrame = current_camera.CFrame;
end);

luna_xyz_env.Library:OnUnload(function()
	Fly.Loaded = false;
end);

----- || METHODS || -----

function Fly:Toggle(value: boolean)

	if not Loaded.Loaded then return warn('[FLY]: Module is not initialized. Please re-execute the module.'); end;
	if luna_xyz_env.Maid.FlyCharacterAdded then luna_xyz_env.Maid.FlyCharacterAdded = nil; end;
	
	local character = LP.Character or LP.CharacterAdded:Wait();

	local rootPart = character and character:FindFirstChild("HumanoidRootPart");
	local humanoid = character and character:FindFirstChildOfClass("Humanoid");

	if not rootPart then return warn("[FLY]: HumanoidRootPart is missing or nil."); end;
	if humanoid then humanoid.PlatformStand = value; end;

	self.Enabled = value;

	self.FlyBody.Parent = if value then rootPart else nil;
	self.FlyGyro.Parent = if value then rootPart else nil;

	luna_xyz_env.Maid.FlyCharacterAdded = LP.CharacterAdded:Connect(function()
		
		if not (self.Loaded or Fly.Enabled) then return; end;

		if self.FlyBody then self.FlyBody:Destroy(); self.FlyBody = nil; end;
		if self.FlyGyro then self.FlyGyro:Destroy(); self.FlyGyro = nil; end;

		task.wait(.3);
		self:Setup(); self:Toggle(true);
	end);
	
	return self;
end;

function Fly:SetSpeed(speed: number)
	self.Speed = speed; return self.Speed;
end;

----- || FINALIZE || -----

Fly.Loaded = true;
return Fly;
