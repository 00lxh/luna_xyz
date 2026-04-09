local Fly = { FlyBody = nil; FlyGyro = nil; Enabled = false; Speed = 15; Loaded = false };
local ControlModule = Services:GetServices("ControlModule");

function Fly:Setup()
	
	local flyBody = Instance.new("BodyVelocity");
	flyBody.Velocity, flyBody.MaxForce = Vector3.zero, Vector3.one * 9e9;

	local flyGyro = Instance.new("BodyGyro");
	
	flyGyro.MaxTorque, flyGyro.P = Vector3.one * 9e9, 9e4;
	Fly.FlyBody, Fly.FlyGyro = flyBody, flyGyro;

	luna_xyz_env.Maid.Fly = luna_xyz_env.RunService.RenderStepped:Connect(function()
		
		if not Fly.Enabled or not luna_xyz_env then return; end;

		local velocity = Vector3.zero;
		local moveVector = ControlModule:GetMoveVector();
		
		velocity = -((luna_xyz_env.Camera.CFrame.LookVector * moveVector.Z) - (luna_xyz_env.Camera.CFrame.RightVector * moveVector.X));

		if luna_xyz_env.UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity += luna_xyz_env.Camera.CFrame.UpVector; end;
		if luna_xyz_env.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity -= luna_xyz_env.Camera.CFrame.UpVector; end;

		Fly.FlyBody.Velocity = velocity * Fly.Speed;
		Fly.FlyGyro.CFrame = luna_xyz_env.Camera.CFrame;
	end);
	
	Fly.Loaded = true;
end;

function Fly:Toggle(value: boolean)
	
	if not Fly.Loaded then return warn('Use "Fly:Setup()" before using this function.'); end;

	if not luna_xyz_env.RootPart then return warn("luna_xyz_env.RootPart is missing or nil."); end;
	if luna_xyz_env.Humanoid then luna_xyz_env.Humanoid.PlatformStand = value; end;
	
	Fly.Enabled = value;
	
	Fly.FlyBody.Parent = if value then luna_xyz_env.RootPart else nil;
	Fly.FlyGyro.Parent = if value then luna_xyz_env.RootPart else nil;
end;

function Fly:SetSpeed(speed: number)
	Fly.Speed = speed;
end;

return Fly;