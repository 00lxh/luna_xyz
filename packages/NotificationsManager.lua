local getgenv = (getgenv or function() return _G; end);

local CacheFoler = luna_xyz_env:GetService("Cache");
local games_metadata = luna_xyz_env.games_metadata;

local Notifications = {
	NotifyVolume = 2; NotifySound = true; NotifyType = "luna.xyz"; NotifySoundId = 82845990304289; DefaultSoundId = 82845990304289; customNotifications = {};
};

local suppoerted_formats = { notify = true; };
if isfolder and makefolder then makefolder("luna_xyz"); makefolder("luna_xyz/custom"); end;

local formats_text = {};
for format in suppoerted_formats do table.insert(formats_text, ('".%s"'):format(format)); end;

function Notifications:GetCustomNotifications()

	Notifications.customNotifications = {};

	local notifications = (isfolder and isfolder("luna_xyz/custom")) and listfiles and listfiles("luna_xyz/custom") or {};
	if not (luna_xyz_env.SupportsFileSystem or #notifications > 0) then return Notifications.customNotifications; end;

	for _, path in notifications do

		local notification_name = path:match(".+\\(.+)") or path;
		Logger.debug(('Initializing %s.lua..'):format(notification_name));

		if not suppoerted_formats[(path:match("%.([%w]+)$") or ""):lower()] then

			Logger.error(('Failed to initialize custom notification %s.lua'):format(notification_name));
			Logger.error(('    RUNTIME ERROR: Invalid extension type must be %s'):format(table.concat(formats_text, ", ")));

			continue;
		end;

		local compile_func = loadfile or function(p)
			return loadstring(readfile(p));
		end;

		local success, data = compile_func(path)();

		if not success then

			Logger.error(('Failed to initialize custom notification %s.lua'):format(notification_name));
			Logger.error(('    RUNTIME ERROR: %s'):format(tostring(data)));

			continue;
		end;

		if not data.Name then

			Logger.error(('Failed to initialize custom notification %s.lua'):format(notification_name));
			Logger.error(('    RUNTIME ERROR: Invalid title argument (string expected, got %s)'):format(tostring(typeof(data.Name))));

			continue;
		end;

		if not data.Notify then

			Logger.error(('Failed to initialize custom notification %s.lua'):format(notification_name));
			Logger.error(('    RUNTIME ERROR: Invalid function argument (function expected, got %s)'):format(tostring(typeof(data.Notify))));

			continue;
		end;

		Notifications.customNotifications[data.Name] = data;
		Logger.debug(('Custom notification %s.lua initialized successfully.'):format(notification_name));
	end;

	return Notifications.customNotifications;
end;

function Notifications:Notify(options, _time)

	if typeof(options) ~= "table" then
		options = { Description = tostring(options); Time = _time or 5; };
	end;

	assert(options, "Argument #1 missing or nil");
	assert(typeof(options) == "table", ('Invalid argument #1 to "Notify" (table expected, got %s)'):format(typeof(options)));

	local customNotify = Notifications.customNotifications[Notifications.NotifyType];

	local success, data = pcall(function()

		if customNotify then return customNotify:Notify(options); end;

		return luna_xyz_env.Library:Notify({

			Icon = "rbxassetid://5012126105"; Time = options.Time or 5; Description = tostring(options.Description);
			Title = ('<b><font size="20">luna.xyz - %s</font></b>'):format(games_metadata.luna_xyz.Version);
		});
	end);

	if success and data then

		if Notifications.NotifySound and not (customNotify and customNotify.OverwriteNotifySound) then

			local notifySound = Instance.new("Sound", CacheFoler);

			notifySound.PlayOnRemove = true; notifySound.Volume = Notifications.NotifyVolume;
			notifySound.SoundId = string.format("rbxassetid://%d", Notifications.NotifySoundId);

			notifySound:Destroy();
		end;

		return data;
	end;

	return nil;
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

luna_xyz_env.Notify = Notifications.Notify;
return Notifications;
