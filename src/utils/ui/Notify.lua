local Notifications = {
	
	NotifyVolume = 2; NotifySound = true; NotifyType = "luna.xyz";
	NotifySoundId = 82845990304289; DefaultSoundId = 82845990304289;
};

local customNotifications = {};
local CacheFoler = luna_xyz_env:GetService("Cache");

function Notifications:Notify(options, _time)
	
	if typeof(options) ~= "table" then
		options = { Description = tostring(options); Time = _time or 5; };
	end;
	
	assert(options, "Argument #1 missing or nil");
	assert(typeof(options) == "table", ('Invalid argument #1 to "Notify" (table expected, got %s)'):format(typeof(options)));
	
	local customNotification = customNotifications[Notifications.NotifyType];

	if Notifications.NotifySound and not (customNotification and customNotification.OverwriteNotifySound) then

		local notifySound = Instance.new("Sound", CacheFoler);
		notifySound.PlayOnRemove = true;

		notifySound.Volume = Notifications.NotifyVolume;
		notifySound.SoundId = string.format("rbxassetid://%d", Notifications.NotifySoundId);

		notifySound:Destroy();
	end;
	
	if customNotification then
		return customNotification:Notify(options);
	end;

	return luna_xyz_env.Library:Notify({

		Icon = "rbxassetid://5012126105"; Time = options.Time or 5;
		Title = ('<b><font size="20">luna.xyz - %s</font></b>'):format(luna_xyz_env.versions["luna_xyz_loader"]); Description = tostring(options.Description);
	});
end;

function Notifications:GetCustomNotifications()
	
	customNotifications = {};
	if not luna_xyz_env._SupportsFileSystem or #listfiles("luna_xyz/assets") <= 0 then return customNotifications; end;
	
	local startTime = os.clock();
	Logger.debug("Loading custom notifications..");
	
	for i, v in pairs(listfiles("luna_xyz/assets")) do

		local startTime2 = os.clock(); local notification_name = v:match(".+\\(.+)") or v;
		Logger.debug('Loading custom notification ' .. notification_name .. '..');

		if not ({lua=true, luau=true, txt=true})[(v:match("%.([%w]+)$") or ""):lower()] then

			Logger.error(('Failed to load custom notification %s - (%s)'):format(notification_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: Invalid extension type must be ".lua", ".luau", ".txt"');

			continue;
		end;
		
		local __s, __d = pcall(function()
			return loadfile and loadfile(v)() or loadstring(readfile(v))();
		end);

		if not __s then

			Logger.error(('Failed to load custom notification %s.lua - (%s)'):format(notification_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: ' .. tostring(__d));

			continue;
		end;
		
		if not __d.Name then

			Logger.error(('Failed to load custom notification %s.lua - (%s)'):format(notification_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: Invalid title argument (string expected, got ' .. typeof(__d.Name) .. ')');

			continue;
		end;
		
		if not __d.Notify then

			Logger.error(('Failed to load custom notification %s.lua - (%s)'):format(notification_name, string.format("%.2f", os.clock() - startTime2)));
			Logger.error('    RUNTIME ERROR: Invalid Notify function (function expected, got ' .. typeof(__d.Notify) .. ')');

			continue;
		end;

		customNotifications[__d.Name] = __d;
		Logger.success(('Custom notification %s loaded successfully. - (%s)'):format(notification_name, string.format("%.2f", os.clock() - startTime2)));
	end;
	
	Logger.success(('Loaded luna.xyz custom notifications. - (%s)'):format(string.format("%.2f", os.clock() - startTime)));
	return customNotifications;
end;

function Notifications:SetNotifyTpe(notifyTpe: string)

	assert(luna_xyz_env:IsString(notifyTpe), "Invalid notification type.");
	Notifications.NotifyType = notifyTpe;
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

function luna_xyz_env:Notify(...) Notifications:Notify(...); end;
return Notifications;
