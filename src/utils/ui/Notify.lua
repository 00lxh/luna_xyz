local Notifications = {};
local CacheFoler = Services:GetService("Cache");

function Notifications:Notify(str: string, time: number)
	
	if luna_xyz_env.NotifySound then
		
		local notifySound = Instance.new("Sound", CacheFoler);
		notifySound.PlayOnRemove = true;
		
		notifySound.Volume = luna_xyz_env.NotifyVolume;
		notifySound.SoundId = string.format("rbxassetid://%d", luna_xyz_env.NotifySoundID);

		notifySound:Destroy();
	end;
	
	luna_xyz_env.Library:Notify({

		Icon = "rbxassetid://5012126105"; Time = time or 5;
		Title = '<b><font size="20">luna.xyz - ' .. tostring(luna_xyz_env.hub_version) .. '</font></b>'; Description = tostring(str);
	});
end;

return Notifications;