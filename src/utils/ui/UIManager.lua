local UICreator = {};

local HttpService = luna_xyz_env:GetService("HttpService");
local Players = luna_xyz_env:GetService("Players");

local StatsService = luna_xyz_env:GetService("Stats");
local RunService = luna_xyz_env:GetService("RunService");

local serverStats = StatsService:FindFirstChild("Network") and StatsService.Network:FindFirstChild("ServerStatsItem");
local pingStats = serverStats and serverStats:FindFirstChild("Data Ping");

local floor = math.floor;
luna_xyz_env.Library = luna_xyz_env:GetService("Library");

local Inviter = luna_xyz_env:GetService("DiscordInvites");
local Notifications = luna_xyz_env:GetService("Notify");

local ThemeManager = luna_xyz_env:GetService("ThemeManager");
local SaveManager = luna_xyz_env:GetService("SaveManager");

luna_xyz_env.Toggles = getgenv().Library.Toggles;

luna_xyz_env.Options = getgenv().Library.Options;
luna_xyz_env.Labels = getgenv().Library.Labels;


local moonFunFacts = {
	"The Moon is drifting away from Earth at about 3.8 centimeters per year.";
	"The same side of the Moon always faces Earth due to tidal locking.";
	"A day on the Moon (sunrise to sunrise) lasts about 29.5 Earth days.";
	"The Moon has moonquakes, some caused by Earth's gravity.";
	"Footprints left on the Moon can last for millions of years due to no atmosphere.";
	"The Moon has no atmosphere, so there is no weather or wind.";
	"The far side of the Moon was first seen by humans in 1959.";
	"The Moon is the fifth largest moon in the solar system.";
	"The Moon's gravity is about one-sixth of Earth's gravity.";
	"There is water ice on the Moon, especially in permanently shadowed craters.";
	"The Moon was formed about 4.5 billion years ago after a giant impact.";
	"The Moon helps stabilize Earth's rotation and climate.";
	"Temperatures on the Moon can range from about -173°C to 127°C.";
	"The Moon has mountains higher than Mount Everest.";
	"Astronauts brought back about 382 kilograms of Moon rocks.";
	"The Moon has a very weak magnetic field compared to Earth.";
	"The Moon causes tides in Earth's oceans.";
	"The first human landing on the Moon was in 1969";
	"The Moon reflects sunlight, it does not produce its own light.";
	"There are no sounds on the Moon because there is no air.";
	"The Moon is slowly becoming tidally locked more strongly over time, stabilizing its rotation even further.";
	"The Moon has a diameter of about 3,474 kilometers, roughly one-quarter the size of Earth.";
	"The Moon’s surface is covered in a fine dust called regolith.";
	"There are over 1,600 named craters on the Moon.";
	"The largest crater on the Moon is the South Pole–Aitken basin.";
	"The Moon has no liquid water on its surface due to lack of atmosphere and pressure.";
	"The Moon experiences extreme temperature changes because it lacks an atmosphere.";
	"The Moon’s orbit around Earth takes about 27.3 days (sidereal month).";
	"The Moon appears larger near the horizon due to the Moon illusion.";
	"The Moon has 'seas' called maria, which are actually solidified lava plains.";
	"The Moon's core is very small compared to Earth's core.";
	"The Moon has been visited by 12 astronauts in total.";
	"The Moon’s gravity affects not only oceans but also Earth’s crust slightly.";
	"The Moon has tiny amounts of an atmosphere called an exosphere.";
	"The Moon is gradually slowing Earth's rotation over millions of years.";
	"The Moon’s surface is darker than it appears, similar to worn asphalt.";
	"The Moon has no protection from space radiation or meteorites.";
	"Some craters on the Moon have never seen sunlight.";
	"The Moon was once much closer to Earth and appeared larger in the sky.";
	"The Moon helps create eclipses when it aligns with Earth and the Sun.";
};

local function GetGreeting()

	local hour = os.date("*t").hour;

	if hour >= 5 and hour < 12 then

		return "Good morning";

	elseif hour >= 12 and hour < 19 then

		return "Good afternoon";
	end;

	return "Good evening";
end;

local function GetStatus()

	local isBeta = getgenv().luna_xyz_beta and luna_xyz_env.IS_PREMIUM;
	return (isBeta and '<font color="rgb(170, 85, 255)">🧪 Beta Tester</font>') or (luna_xyz_env.IS_PREMIUM and '<font color="rgb(255, 255, 0)">✨ Premium</font>') or '🔓 Freemium';
end;

function UICreator:CreateMainWindow(system_data)

	system_data = system_data or {};
	luna_xyz_env.IS_PREMIUM = (system_data.KeyData and system_data.KeyData.PREMIUM_KEY) or false;

	Logger.debug("Loading main window..");

	local Window = luna_xyz_env.Library:CreateWindow({

		Title = "luna.xyz";
		Footer = ('Game: %s | Game Build: %s | Loader Build: %s | Made by 00._lxh'):format(luna_xyz_env.ScriptName, tostring(luna_xyz_env.versions[luna_xyz_env.ScriptLoader]), tostring(luna_xyz_env.versions["luna_xyz_loader"]));

		IconSize = UDim2.fromOffset(20, 20);
		Icon = "rbxassetid://5012126105";

		NotifySide = "Right"; Center = true; AutoShow = false;
		Resizable = true; ShowCustomCursor = true;
	});

	luna_xyz_env.Library.ForceCheckbox = true; 
	Logger.success("Main window loaded.");

	----- || HOME || -----

	Logger.debug("Creating home tab..");
	local HomeTab = Window:AddTab("Home", "house");

	HomeTab:UpdateWarningBox({

		Title = '<font size="20">Welcome to <font color="rgb(255, 200, 76)">luna.xyz</font></font>!', Visible = true; IsNormal = true;
		Text = ('\n<b>Moon fun fact:\n%s</b>'):format(moonFunFacts[math.random(1, #moonFunFacts)]);
	});

	local AccountGroup = HomeTab:AddLeftGroupbox("Account", "circle-user-round");

	local ScriptStatusGroup = HomeTab:AddRightGroupbox("Script Status", "scroll");
	local InfoGroupBox = HomeTab:AddRightTabbox("SYstemInfo");

	local AnalyticsGroup = InfoGroupBox:AddTab("Analytics", "chart-no-axes-combined");
	local KeyGroup = InfoGroupBox:AddTab("Key", "key-round");

	AccountGroup:AddImage("MyImage", {

		Height = 200;
		Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420);
	});

	AccountGroup:AddLabel(('%s, %s\n» <b>%s</b>'):format(GetGreeting(), Players.LocalPlayer.DisplayName, GetStatus()), true , "MyInfo");
	AccountGroup:AddDivider();

	AccountGroup:AddButton("Join Discord", function()

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then
			return Notifications:Notify(('Discord link: %s'):format(luna_xyz_env.discord_id), 10);
		end;

		setclipboard(luna_xyz_env.discord_id);
		Notifications:Notify("Copied discord link to clipboard!");
	end);

	AccountGroup:AddButton({

		Text = "Copy Key Link";

		Func = function()

			if not setclipboard then
				return Notifications:Notify("Key link: https://jnkie.com/get-key/luna-xyz", 10);
			end;

			setclipboard("https://jnkie.com/get-key/luna-xyz");
			Notifications:Notify("Copied Scriptblox link to clipboard!");
		end;
	});

	for name, info in pairs(luna_xyz_env.supported_games) do
		
		if info.Hidden then continue; end;

		local placeName = name:gsub("_", " "):gsub("(%a)(%w*)", function(a, b)
			return a:upper() .. b:lower();
		end);

		local text_color = (game.PlaceId == info.GameId or game.GameId == info.GameId) and "66, 149, 245" or "255, 255, 255";
		ScriptStatusGroup:AddLabel(('[%s] <b><font color="rgb(%s)">%s</font></b>'):format(info.Status, text_color, placeName), true);
	end;

	ScriptStatusGroup:AddDivider();
	ScriptStatusGroup:AddLabel('<b>Join our official Discord server to see a detailed log of updates and the status of the scripts!</b>', true);

	AnalyticsGroup:AddLabel(('Exploit: <b>%s - %s</b>'):format(identifyexecutor(), select(2, identifyexecutor())), true);
	AnalyticsGroup:AddLabel(('Total Executions: <b>%s</b>'):format(luna_xyz_env.analytics_data.TotalExecutions), true);

	AnalyticsGroup:AddDivider();
	AnalyticsGroup:AddLabel(('Total playtime: <b>%s</b>'):format(luna_xyz_env:FormatTime(luna_xyz_env.analytics_data.PlayTime[tostring(Players.LocalPlayer)])), true);

	local time_elapsed = AnalyticsGroup:AddLabel("Time Elapsed: <b>00:00:00:00</b>", true);
	local startTime, previousPlayTime = os.clock(), (luna_xyz_env.analytics_data.PlayTime[tostring(Players.LocalPlayer)] or 0);
	
	task.spawn(function()
		while task.wait(1) and luna_xyz_env do

			local elapsed = math.floor(os.clock() - startTime);

			luna_xyz_env.analytics_data.PlayTime[tostring(Players.LocalPlayer)] = previousPlayTime + elapsed;
			time_elapsed:SetText(('Time Elapsed: <b>%s</b>'):format(luna_xyz_env:FormatTime(elapsed)));

			if (elapsed % 10) == 0 then
				writefile("luna_xyz/analytics/stats.json", HttpService:JSONEncode(luna_xyz_env.analytics_data));
			end;
		end;
	end);

	local time_left = KeyGroup:AddLabel(('Time Left: <b>%s</b>'):format(luna_xyz_env:FormatTime((system_data.KeyData and system_data.KeyData.EXPIRES_AT or 0) - os.time())), true);
	KeyGroup:AddLabel(('Created At: <b>%s</b>'):format(os.date("%m/%d/%y - %H:%M:%S", (system_data.KeyData and system_data.KeyData.CREATED_AT or 0))), true);

	task.spawn(function()
		while task.wait(1) and luna_xyz_env and (system_data.KeyData and system_data.KeyData.EXPIRES_AT) do

			local current_time = (system_data.KeyData and system_data.KeyData.EXPIRES_AT or 0) - os.time();

			if current_time <= 0 then time_left:SetText('Time Left: <b>Key Expired</b>'); continue; end;
			time_left:SetText(('Time Left: <b>%s</b>'):format(luna_xyz_env:FormatTime(current_time)));
		end;
	end);

	KeyGroup:AddDivider();

	KeyGroup:AddLabel(('Discord: <b>%s</b>'):format((system_data.DiscordData and system_data.DiscordData.DISCORD_USERNAME) or "Unknown"), true);
	KeyGroup:AddLabel(('DiscordId: <b>%s</b>'):format((system_data.DiscordData and system_data.DiscordData.DISCORD_ID) or "Unknown"), true);

	Logger.success("Home tab created.");
	
	----- || WATERMARK || -----
	
	local waterMark = luna_xyz_env.Library:AddDraggableLabel(('%s - luna.xyz | %s FPS | %s ms | %s'):format(luna_xyz_env.ScriptName, "N/A", "N/A", tostring(luna_xyz_env.versions[luna_xyz_env.ScriptLoader])));
	local deltaTimesInterval, frame_count, current_fps, lastUpdated, updateInterval = 0, 0, 0, os.clock(), 0.3;
	
	pcall(function()
		luna_xyz_env.Maid:GiveTask(RunService.RenderStepped:Connect(function(delta)
			
			deltaTimesInterval += delta;
			frame_count += 1;
			
			local current_time = os.clock();

			if (current_time - lastUpdated) >= updateInterval then

				current_fps = frame_count / deltaTimesInterval;
				deltaTimesInterval, frame_count = 0, 0; lastUpdated = current_time;
			end;
			
			local current_ping = pingStats and floor(pingStats:GetValue()) or "N/A";
			waterMark:SetText(('%s - luna.xyz | %.1f FPS | %s ms | %s'):format(luna_xyz_env.ScriptName, current_fps, current_ping, tostring(luna_xyz_env.versions[luna_xyz_env.ScriptLoader])));
		end));
	end);

	luna_xyz_env.waterMark = waterMark;
	luna_xyz_env.waterMark:SetVisible(true);

	----- || UNLOAD HANDLER || -----

	luna_xyz_env.Library:OnUnload(function()

		if luna_xyz_env:GetService("Cache") then luna_xyz_env:GetService("Cache"):Destroy(); end;
		luna_xyz_env.Maid:DoCleaning(); luna_xyz_env.HookService:DoCleaning();

		luna_xyz_env.Library.Unloaded = true;
		mstudio45_ESP:Destroy();

		getgenv().luna_xyz_env = nil; getgenv().luna_xyz_addons = nil;
		getgenv().luna_xyz_loading = nil; getgenv().luna_xyz_loaded = nil;
	end);

	return Window;
end;

function UICreator:CreateKeyWindow(__callback)

	Logger.debug("Loading key window..");

	local Window = luna_xyz_env.Library:CreateWindow({

		Title = "luna.xyz";
		Footer = ('Game: %s | Game Build: %s | Loader Build: %s | Made by 00._lxh'):format(luna_xyz_env.ScriptName, tostring(luna_xyz_env.versions[luna_xyz_env.ScriptLoader]), tostring(luna_xyz_env.versions["luna_xyz_loader"]));

		IconSize = UDim2.fromOffset(20, 20);
		Icon = "rbxassetid://5012126105";

		NotifySide = "Right"; Center = true; AutoShow = true;
		Resizable = true; ShowCustomCursor = true; Size = UDim2.fromOffset(625, 360);
	});

	Logger.success("Key window loaded.");

	----- || KEY || -----

	Logger.debug("Creating key tab..");
	local KeyTab = Window:AddKeyTab("Key", "key-round");

	KeyTab:AddLabel('<b><font size="25">luna.xyz Key System</font></b>', true);
	KeyTab:AddLabel("Thanks for supporting & using luna.xyz. Your support help us to continue developing luna.xyz!", true);

	KeyTab:AddKeyBox(__callback);

	KeyTab:AddLabel('Are you lost? Go to <b><font color="rgb(172, 215, 230)">Info</font></b> tab', true);
	Logger.success("Key tab created.");

	----- || INFO || -----

	Logger.debug("Creating info tab..");
	local InfoTab = Window:AddTab("Info", "info");

	local KeyGroup = InfoTab:AddLeftGroupbox("Key", "info");
	local HelpGroup = InfoTab:AddRightGroupbox("Help", "info");

	KeyGroup:AddLabel('luna.xyz uses multiple ad providers for the key system. You can choose the one you like most.', true);

	KeyGroup:AddButton("Copy Link", function()

		if not setclipboard then
			return Notifications:Notify('Discord link: https://jnkie.com/get-key/luna-xyz', 10);
		end;

		setclipboard('https://jnkie.com/get-key/luna-xyz');
		Notifications:Notify("Copied discord link to clipboard!");
	end);

	KeyGroup:AddDivider();
	KeyGroup:AddLabel('<b><font color="rgb(255, 0, 0)">WARING: Disable your adblocker before using linkvertise to prevent 1h wait time.</font></b>', true);

	HelpGroup:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", { Default = "LeftAlt", NoUI = true, Text = "Menu keybind" });

	HelpGroup:AddButton("Join Discord", function()

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then
			return Notifications:Notify(('Discord link: %s'):format(luna_xyz_env.discord_id), 10);
		end;

		setclipboard(luna_xyz_env.discord_id);
		Notifications:Notify("Copied discord link to clipboard!");
	end);

	HelpGroup:AddButton("Unload", function() luna_xyz_env.Library:Unload(); end);
	luna_xyz_env.Library.ToggleKeybind = luna_xyz_env.Options.MenuKeybind;

	Logger.success("Info tab created.");

	----- || UNLOAD HANDLER || -----

	luna_xyz_env.Library:OnUnload(function()

		if luna_xyz_env:GetService("Cache") then luna_xyz_env:GetService("Cache"):Destroy(); end;
		luna_xyz_env.Maid:DoCleaning(); luna_xyz_env.HookService:DoCleaning();

		luna_xyz_env.Library.Unloaded = true;
		mstudio45_ESP:Destroy();

		getgenv().luna_xyz_env = nil; getgenv().luna_xyz_addons = nil;
		getgenv().luna_xyz_loading = nil; getgenv().luna_xyz_loaded = nil;
	end);

	return Window;
end;

function UICreator:CreateSettingsTab()

	Logger.debug("Creating settings tab..");
	local SettingsTab = luna_xyz_env.Window:AddTab("Settings", "cog");

	if not luna_xyz_env._SupportsFileSystem then

		SettingsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nluna.xyz was unable to save settings and custom themes (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
		});
	end;

	local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Options", "cog");
	local UIGroupBox = SettingsTab:AddRightTabbox("UI");

	local UI_Tab = UIGroupBox:AddTab("UI", "app-window");
	local NotificationsTab = UIGroupBox:AddTab("Notify", "bell");

	----- || MENU || -----

	MenuGroup:AddToggle("ToggleWaterMark", {

		Text = "Toggle Watermark";
		Default = true;

		Callback = function(value)
			
			if not luna_xyz_env.waterMark then return; end;
			luna_xyz_env.waterMark:SetVisible(value);
		end;
	});
	
	MenuGroup:AddToggle("IncognitoMode", {

		Text = "Incognito Mode";
		Default = false;

		Callback = function(value)

			if value then
				
				luna_xyz_env.Options.MyImage:SetImage(getcustomasset and getcustomasset("luna_xyz/assets/luna_v3.png") or Players:GetUserThumbnailAsync(1, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420));
				luna_xyz_env.Options.MyImage:SetScaleType(Enum.ScaleType.Crop);
				
				luna_xyz_env.Labels.MyInfo:SetText(('%s, %s\n» <b>%s</b>'):format(GetGreeting(), "luna.xyz", '<font color="rgb(255, 200, 76)">🌙 luna.xyz</font>'));
				return;
			end;
			
			luna_xyz_env.Options.MyImage:SetImage(Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420));
			luna_xyz_env.Options.MyImage:SetScaleType(Enum.ScaleType.Fit);
			
			luna_xyz_env.Labels.MyInfo:SetText(('%s, %s\n» <b>%s</b>'):format(GetGreeting(), Players.LocalPlayer.DisplayName, GetStatus()));
		end;
	});

	MenuGroup:AddToggle("KeybindMenuOpen", {

		Default = luna_xyz_env.Library.KeybindFrame.Visible;
		Text = "Open Keybind Menu";

		Callback = function(value)
			luna_xyz_env.Library.KeybindFrame.Visible = value;
		end;
	});

	MenuGroup:AddToggle("ShowCustomCursor", {

		Text = "Custom Cursor";
		Default = luna_xyz_env.Library.ShowCustomCursor;

		Callback = function(value)
			luna_xyz_env.Library.ShowCustomCursor = value;
		end;
	});

	MenuGroup:AddToggle("ForceCheckbox", {

		Text = "Force Checkbox";
		Default = luna_xyz_env.Library.ForceCheckbox;

		Callback = function(value)
			luna_xyz_env.Library.ForceCheckbox = value;
		end;
	});

	MenuGroup:AddDivider();

	MenuGroup:AddToggle("ExecuteOnTeleport", {
		Text = "Execute on Teleport"; Default = false;
	});

	MenuGroup:AddToggle("DiscordRichPresence", {
		Text = "Discord Rich Presence"; Default = true;
	});

	MenuGroup:AddToggle("CreateLogs", {

		Text = "Create Logs";
		Default = (isfile and readfile and isfile("luna_xyz/saves/save_logs.txt") and readfile("luna_xyz/saves/save_logs.txt") == "true");

		Callback = function(value)
			writefile("luna_xyz/saves/save_logs.txt", tostring(value));
		end;
	});

	MenuGroup:AddDivider();

	MenuGroup:AddButton("Join Discord", function()

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then
			return Notifications:Notify(('Discord link: %s'):format(luna_xyz_env.discord_id), 10);
		end;

		setclipboard(luna_xyz_env.discord_id);
		Notifications:Notify("Copied discord link to clipboard!");
	end);

	MenuGroup:AddButton("Unload", function() luna_xyz_env.Library:Unload(); end);

	----- || UI || -----

	UI_Tab:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", { Default = "LeftAlt", NoUI = true, Text = "Menu keybind" });
	luna_xyz_env.Library.ToggleKeybind = luna_xyz_env.Options.MenuKeybind;

	UI_Tab:AddDropdown("DPIDropdown", {

		Text = "DPI Scale"; Default = "100%";
		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" };

		Callback = function(value)

			value = value:gsub("%%", "");
			luna_xyz_env.Library:SetDPIScale(tonumber(value));
		end;
	}); 

	----- || NOTIFICATIONS || -----

	NotificationsTab:AddDropdown("NotificationSide", {

		Values = { "Left", "Right" };
		Default = "Right";

		Text = "Notification Side";

		Callback = function(Value)
			luna_xyz_env.Library:SetNotifySide(Value);
		end;
	});

	NotificationsTab:AddDropdown("NotificationStyle", {

		Text = "Notification Style"; Default = "luna.xyz";
		Values = { "luna.xyz" };

		Callback = function(value)
			Notifications:SetNotifyTpe(value);
		end;
	});

	for i, v in pairs(Notifications:GetCustomNotifications()) do
		luna_xyz_env.Options.NotificationStyle:AddValues(i);
	end;

	NotificationsTab:AddToggle("NotificationSound", {

		Text = "Notification Sound";
		Default = true;

		Callback = function(value)
			Notifications:ToggleSound(value);
		end;
	});

	NotificationsTab:AddSlider("NotificationVolume", {

		Text = "Notification Volume";
		Compact = false;

		Default = Notifications.NotifyVolume;
		Min = 0; Max = 5; Rounding = 1;

		Callback = function(value)
			Notifications:SetVolume(value);
		end;
	});

	NotificationsTab:AddInput("NotificationSoundID", {

		Text = "Notification Sound ID";

		Default = "rbxassetid://82845990304289"; Placeholder = "rbxassetid://82845990304289";
		Numeric = false; Finished = true; ClearTextOnFocus = false;

		Callback = function(value)

			value = value:gsub("rbxassetid://", "");
			Notifications:SetSoundId(tonumber(value));
		end;
	});

	NotificationsTab:AddButton("Reset Sound to Default", function()	
		luna_xyz_env.Library.Options.NotificationSoundID:SetValue("rbxassetid://82845990304289");
	end);

	NotificationsTab:AddButton("Test Notification", function()
		Notifications:Notify("This is a test notification. You can change the notification settings above.");
	end);

	Logger.success("Settings tab created.");

	----- || SETTINGS || -----

	Logger.debug("Loading default theme..");

	ThemeManager:SetLibrary(luna_xyz_env.Library);
	SaveManager:SetLibrary(luna_xyz_env.Library);

	local __s, __d = pcall(function()
		ThemeManager:SetDefaultTheme({

			BackgroundColor = Color3.fromRGB(15, 15, 15); MainColor = Color3.fromRGB(25, 25, 25);
			AccentColor = Color3.fromRGB(255, 200, 76); OutlineColor = Color3.fromRGB(40, 40, 40);

			FontColor = Color3.new(1, 1, 1); FontFace = Enum.Font.Code;
		});
	end);

	if not __s then

		Logger.error("Failed to load Default theme");
		Logger.error('    RUNTIME ERROR: ' .. tostring(__d));

	else Logger.success("Default theme loaded."); end;

	ThemeManager:ApplyToTab(SettingsTab);
	Logger.debug("Loading settings..");

	SaveManager:IgnoreThemeSettings();
	SaveManager:BuildConfigSection(SettingsTab);

	SaveManager:SetFolder("luna_xyz/saves/" .. luna_xyz_env.ScriptLoader);
	SaveManager:LoadAutoloadConfig();

	luna_xyz_env.Maid:GiveTask(Players.LocalPlayer.OnTeleport:Connect(function()

		if not queue_on_teleport or not luna_xyz_env.Toggles.ExecuteOnTeleport.Value or queued_to_teleport then return; end;
		getgenv().queued_to_teleport = true;

		queue_on_teleport([[ loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/fac6b129defbda2cf7d7a4cfaf9a7ae28589934ccb46cb06858577fd2c34e64b/download"))(); ]]);
	end));

	Logger.success("All settings loaded.");
	return SettingsTab;
end;

function UICreator:CreateCreditsTab()

	Logger.debug("Creating credits tab..");
	local CreditsTab = luna_xyz_env.Window:AddTab("Credits", "users");

	local OwnersSection = CreditsTab:AddLeftGroupbox("Owners", "moon");

	local DevelopersSection = CreditsTab:AddLeftGroupbox("Developers", "scroll");
	local TestersSection = CreditsTab:AddLeftGroupbox("Testers", "flask-conical");

	local ContributorsSection = CreditsTab:AddRightGroupbox("Contributors", "puzzle");
	local CommunitySection = CreditsTab:AddRightGroupbox("Community", "message-circle");

	----- || OWNERS || -----

	OwnersSection:AddLabel('[<font color="rgb(255, 200, 76)">00._lxh</font>] - Owner of luna.xyz', true);

	----- || DEVELOPERS || ----
	
	DevelopersSection:AddLabel('[<font color="rgb(0, 255, 0)">TexRBLX</font>] - Original owner of Violence District Script', true);

	----- || TESTERS || -----

	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">rubie</font>] - Tester of Revenant Sunrisen, Violence District', true);
	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">TexRBLX</font>] - Tester of Rakoof, Project Lazarus', true);
	
	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">Mr.Storm</font>] - Tester of Violence District', true);
	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">88404</font>] - Tester of Rake Remastered, Violence District', true);

	----- || CONTRIBUTORS || -----

	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">TexRBLX</font>] - Helped with Rakoof, Rake Remastered, Project Lazarus, Violence District', true);
	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">Ryo Yamada</font>] - Helped with revenant sunrisen', true);

	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">deividcomsono</font>] - Obsidian UI library developer', true);
	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">mspaint</font>] - Inspiration for the new version of luna.xyz', true);

	ContributorsSection:AddLabel('[<font color="rgb(255, 102, 204)">You</font>] - Thanks for all the support and for using my script', true);

	----- || COMMUNITY || -----

	CommunitySection:AddLabel('Official luna.xyz socials', true);

	CommunitySection:AddButton("Join Discord", function()

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then
			return Notifications:Notify(('Discord link: %s'):format(luna_xyz_env.discord_id), 10);
		end;

		setclipboard(luna_xyz_env.discord_id);
		Notifications:Notify("Copied discord link to clipboard!");
	end);

	CommunitySection:AddButton({

		Text = "Scriptblox Profile";

		Func = function()

			if not setclipboard then
				return Notifications:Notify("Scriptblox link: https://scriptblox.com/u/00_lxh", 10);
			end;

			setclipboard("https://scriptblox.com/u/00_lxh");
			Notifications:Notify("Copied Scriptblox link to clipboard!");
		end;
	});

	Logger.success("Credits tab created.");
	return CreditsTab;
end;

return UICreator;
