local Notifications = {
	NotifyVolume = 2; NotifySound = true; NotifySoundId = 82845990304289; DefaultSoundId = 82845990304289;
};

local CacheFoler = luna_xyz_env:GetService("Cache");

function Notifications:Notify(str: string, time: number)

	if Notifications.NotifySound then

		local notifySound = Instance.new("Sound", CacheFoler);
		notifySound.PlayOnRemove = true;

		notifySound.Volume = Notifications.NotifyVolume;
		notifySound.SoundId = string.format("rbxassetid://%d", Notifications.NotifySoundId);

		notifySound:Destroy();
	end;

	luna_xyz_env.Library:Notify({

		Icon = "rbxassetid://5012126105"; Time = time or 5;
		Title = '<b><font size="20">luna.xyz - ' .. tostring(luna_xyz_env.versions["luna_xyz_loader"]) .. '</font></b>'; Description = tostring(str);
	});
end;

function Notifications:GetCustomNotifications()
	
	return {};
end;

function Notifications:SetVolume(volume: number)
	
	assert(luna_xyz_env:IsNumber(volume), "Invalid Volume number.");
	Notifications.NotifyVolume = volume;
end;

function Notifications:SetSoundId(soundId: number)
	
	assert(luna_xyz_env:IsNumber(soundId), "Invalid Volume number.");
	Notifications.NotifySoundId = soundId;
end;

function Notifications:ToggleSound(value: boolean)
	Notifications.NotifySound = luna_xyz_env:ParseBoolean(value);
end;

return Notifications;
