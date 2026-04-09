local UICreator = {};
local ThemeManager = Services:GetService("ThemeManager");

luna_xyz_env.Library = Services:GetService("Library");
luna_xyz_env.SaveManager = Services:GetService("SaveManager");

luna_xyz_env.Toggles = getgenv().Library.Toggles;
luna_xyz_env.Options = getgenv().Library.Options;

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

function UICreator:CreateWindow()
	
	Logger.wait("Loading main window..");
	luna_xyz_env.time_elapsed = 0;
	
	local Window = luna_xyz_env.Library:CreateWindow({

		Title = "luna.xyz";
		Footer = 'Game: ' .. luna_xyz_env.ScriptName .. ' | Game Build: ' .. tostring(luna_xyz_env.versions[luna_xyz_env.ScriptLoader]) .. ' | Loader Build: ' .. tostring(luna_xyz_env.versions["luna_xyz_loader"]) .. ' | Made by 00._lxh';

		IconSize = UDim2.fromOffset(20, 20);
		Icon = "rbxassetid://5012126105";

		Center = true; AutoShow = true; Resizable = true; ShowCustomCursor = true;
		NotifySide = "Right"; MenuFadeTime = 0; TabPadding = 2;
	});
	
	luna_xyz_env.Library.ForceCheckbox = true; 
	Logger.success("Main window loaded.");
	
	----- || NOTIFICATIONS || -----
	
	Logger.wait("Loading notifications module..");

	luna_xyz_env.NotifyVolume = 2;
	luna_xyz_env.NotifySound = true;
	
	luna_xyz_env.NotifySoundID = 82845990304289;
	luna_xyz_env.Notify = Services:GetService("Notify");
	
	Logger.success("Notifications module loaded.");
	
	----- || HOME || -----
	
	Logger.wait("Creating home tab..");
	local HomeTab = Window:AddTab("Home", "house");
	
	HomeTab:UpdateWarningBox({

		Title = '<font size="20">Welcome to <font color="rgb(255, 200, 76)">luna.xyz</font></font>!', Visible = true; IsNormal = true;
		Text = '\n<b>Moon fun fact:\n</b>' .. moonFunFacts[math.random(1, #moonFunFacts)];
	});
	
	local AccountGroup = HomeTab:AddLeftGroupbox("Account", "circle-user-round");
	
	local ScriptStatusGroup = HomeTab:AddRightGroupbox("Script Status", "scroll");
	local AnalyticsGroup = HomeTab:AddRightGroupbox("Analytics", "chart-no-axes-combined");
	
	AccountGroup:AddImage("MyImage", {
		
		Height = 200;
		Image = luna_xyz_env.Players:GetUserThumbnailAsync(luna_xyz_env.LP.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420);
	});
	
	AccountGroup:AddLabel(GetGreeting() .. ', ' .. luna_xyz_env.LP.DisplayName .. ' - <b>Member</b>', true);
	AccountGroup:AddDivider();
	
	AccountGroup:AddButton("Join Discord", function()

		local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))();

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then

			luna_xyz_env.Notify:Notify('Discord link: ' .. luna_xyz_env.discord_id, 10);
			return;
		end;

		setclipboard(luna_xyz_env.discord_id);
		luna_xyz_env.Notify:Notify("Copied discord link to clipboard!");
	end);
	
	AccountGroup:AddButton({

		Text = "Scriptblox Profile";

		Func = function()

			if not setclipboard then

				luna_xyz_env.Notify:Notify("Scriptblox link: https://scriptblox.com/u/00_lxh", 10);
				return;
			end;

			setclipboard("https://scriptblox.com/u/00_lxh");
			luna_xyz_env.Notify:Notify("Copied Scriptblox link to clipboard!");
		end;
	});
	
	for i, v in pairs(luna_xyz_env.supported_games) do
		
		if v.GameId == 142823291 then continue; end;
		
		local placeName = i:gsub("_", " "):gsub("(%a)(%w*)", function(a, b)
			return a:upper() .. b:lower();
		end);
		
		local text_color = (game.PlaceId == v.GameId or game.GameId == v.GameId) and "66, 149, 245" or "255, 255, 255";
		ScriptStatusGroup:AddLabel('[🟢] <b><font color="rgb(' .. text_color  .. ')">' .. placeName .. '</font></b>', true);
	end;
	
	ScriptStatusGroup:AddDivider();
	ScriptStatusGroup:AddLabel('<b>Join our official Discord server to see a detailed log of updates and the status of the scripts!</b>', true);
	
	AnalyticsGroup:AddLabel('Exploit: <b>' .. identifyexecutor() .. ' - ' .. select(2, identifyexecutor()) .. '</b>', true);
	AnalyticsGroup:AddLabel('Total Executions: <b>' .. luna_xyz_env.analytics_data.TotalExecutions .. '</b>', true);
	
	AnalyticsGroup:AddLabel('Total playtime: <b>' .. luna_xyz_env:formatTime(luna_xyz_env.analytics_data.PlayTime[tostring(luna_xyz_env.LP)]) .. '</b>', true);
	local time_elapsed = AnalyticsGroup:AddLabel("Time Elapsed: <b>00:00:00:00</b>", true);
	
	task.spawn(function()
		while task.wait(1) and luna_xyz_env do
			
			luna_xyz_env.time_elapsed += 1;
			time_elapsed:SetText('Time Elapsed: <b>' .. luna_xyz_env:formatTime(luna_xyz_env.time_elapsed) .. '</b>');
			
			luna_xyz_env.analytics_data.PlayTime[tostring(luna_xyz_env.LP)] += luna_xyz_env.time_elapsed;
			writefile("luna_xyz/analytics/stats.json", luna_xyz_env.HttpService:JSONEncode(luna_xyz_env.analytics_data));
		end;
	end);
	
	Logger.success("Home tab created.");

	----- || FUNCITONS CHECK || -----

	luna_xyz_env.CheckToggle = function(toggleName: string, value: boolean)
		return luna_xyz_env.Toggles[toggleName] and luna_xyz_env.Toggles[toggleName].Value == value;
	end;
	
	luna_xyz_env.CheckOption = function(optionName: string, value: any)
		return luna_xyz_env.Options[optionName] and (typeof(luna_xyz_env.Options[optionName].Value) == "table" and luna_xyz_env.Options[optionName].Value[value] or luna_xyz_env.Options[optionName].Value == value);
	end;
	
	----- || UNLOAD HANDLER || -----

	luna_xyz_env.Library:OnUnload(function()

		if Services:GetService("Cache") then Services:GetService("Cache"):Destroy(); end;
		
		luna_xyz_env.Library.Unloaded = true;
		luna_xyz_env.Maid:DoCleaning(); luna_xyz_env.HookService:Destroy(); --Logger:Destroy(); --ESP:Destroy();

		getgenv().luna_xyz_env = nil; getgenv().luna_xyz_addons = nil;
		getgenv().luna_xyz_loading = nil; getgenv().luna_xyz_loaded = nil;
	end);

	return Window;
end;

function UICreator:CreateTimeoutInfoTab()
		
	local ErrorTab = luna_xyz_env.Window:AddTab("Error", "triangle-alert");
	
	ErrorTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - RUNTIME ERROR</font>', Visible = true;
		Text = "\nluna.xyz was unable to load in time (<b>ERROR: timeout</b>)\n<i>If the error persists, please contact the development team.</i>";
	});

	local ResourcesGroup = ErrorTab:AddLeftGroupbox("Resources");
	local ErrorInfoGroup = ErrorTab:AddRightGroupbox("Error Info");
	
	ResourcesGroup:AddLabel('Discord link:\n' .. luna_xyz_env.discord_id, true);
	ResourcesGroup:AddDivider();
	
	ResourcesGroup:AddButton("Join Discord", function()
		
		local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))();
		
		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });
		
	end):AddButton("Copy Link", function()

		if not setclipboard then
			
			luna_xyz_env.Notify:Notify('Discord link: ' .. luna_xyz_env.discord_id, 10);
			return;
		end;
		
		setclipboard(luna_xyz_env.discord_id);
		luna_xyz_env.Notify:Notify("Copied discord link to clipboard!");
	end);

	ErrorInfoGroup:AddLabel("Timeout error usually means the game's owner has moved something to a different location which breaks the code that has already been written.\n\nPlease wait for the development team to fix this issue. If the issue persists, please contact us.", true);
end;

function UICreator:CreateSettingsTab()
	
	Logger.wait("Creating settings tab..");
	local SettingsTab = luna_xyz_env.Window:AddTab("Settings", "cog");
	
	if not luna_xyz_env._SupportsFileSystem then
		
		SettingsTab:UpdateWarningBox({

			Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
			Text = "\nluna.xyz was unable to save settings and custom themes (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
		});
	end;
	
	local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Options", "cog");
	local UIGroup = SettingsTab:AddRightTabbox("UI");
	
	local UI_Tab = UIGroup:AddTab("UI", "app-window");
	local NotificationsTab = UIGroup:AddTab("Notify", "bell");
	
	----- || MENU || -----
	
	MenuGroup:AddToggle("ToggleWaterMark", {

		Text = "Toggle Watermark";
		Default = true;

		Callback = function(value)
			
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

		Callback = function(Value)
			luna_xyz_env.Library.ShowCustomCursor = Value;
		end;
	});
	
	MenuGroup:AddToggle("ForceCheckbox", {

		Text = "Force Checkbox";
		Default = luna_xyz_env.Library.ForceCheckbox;

		Callback = function(Value)
			luna_xyz_env.Library.ForceCheckbox = Value;
		end;
	});
	
	MenuGroup:AddDivider();
	
	MenuGroup:AddToggle("DiscordRichPresence", {
		Text = "Discord Rich Presence"; Default = false;
	});
	
	MenuGroup:AddToggle("ExecuteOnTeleport", {
		Text = "Execute on Teleport"; Default = false;
	});
	
	MenuGroup:AddDivider();
	
	MenuGroup:AddButton("Join Discord", function()

		local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))();

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then

			luna_xyz_env.Notify:Notify('Discord link: ' .. luna_xyz_env.discord_id, 10);
			return;
		end;

		setclipboard(luna_xyz_env.discord_id);
		luna_xyz_env.Notify:Notify("Copied discord link to clipboard!");
	end);
	
	MenuGroup:AddButton("Unload", function() luna_xyz_env.Library:Unload(); end);
	luna_xyz_env.Library.ToggleKeybind = luna_xyz_env.Options.MenuKeybind;
	
	----- || UI || -----
	
	UI_Tab:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", { Default = "LeftAlt", NoUI = true, Text = "Menu keybind" });
	
	UI_Tab:AddDropdown("DPIDropdown", {

		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" };
		Default = "100%";

		Text = "DPI Scale";

		Callback = function(Value)
			
			Value = Value:gsub("%%", "");
			luna_xyz_env.Library:SetDPIScale(tonumber(Value));
		end;
	}); 
	
	----- || NOTIFICATIONS || -----

	NotificationsTab:AddToggle("PlayAlertSound", {

		Text = "Play Alert Sound";
		Default = true;

		Callback = function(Value)
			luna_xyz_env.NotifySound = Value;
		end;
	});
	
	NotificationsTab:AddDropdown("NotificationSide", {

		Values = { "Left", "Right" };
		Default = "Right";

		Text = "Notification Side";

		Callback = function(Value)
			luna_xyz_env.Library:SetNotifySide(Value);
		end;
	});
	
	NotificationsTab:AddSlider("NotifyVolume", {

		Text = "Notify Volume";
		Compact = false;
		
		Default = luna_xyz_env.NotifyVolume;
		Min = 0; Max = 5; Rounding = 1;

		Callback = function(value)
			luna_xyz_env.NotifyVolume = value;
		end;
	});
	
	NotificationsTab:AddInput("NotificationSoundID", {
		
		Text = "Notification Sound ID";
		
		Default = "rbxassetid://82845990304289"; Placeholder = "rbxassetid://82845990304289";
		Numeric = false; Finished = true; ClearTextOnFocus = false;

		Callback = function(Value)
			
			Value = Value:gsub("rbxassetid://", "");
			luna_xyz_env.NotifySoundID = tonumber(Value);
		end;
	});
	
	NotificationsTab:AddButton("Reset Sound to Default", function()	
		luna_xyz_env.Library.Options.NotificationSoundID:SetValue("rbxassetid://82845990304289");
	end);
	
	NotificationsTab:AddButton("Test Notification", function()
		luna_xyz_env.Notify:Notify("This is a test notification. You can change the sound settings above.");
	end);
	
	Logger.success("Settings tab created.");
	
	----- || SETTINGS || -----
	
	Logger.wait("Loading default theme..");
	
	ThemeManager:SetLibrary(luna_xyz_env.Library);
	luna_xyz_env.SaveManager:SetLibrary(luna_xyz_env.Library);
	
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
	Logger.wait("Loading settings..");
	
	luna_xyz_env.SaveManager:IgnoreThemeSettings();
	luna_xyz_env.SaveManager:BuildConfigSection(SettingsTab);

	luna_xyz_env.SaveManager:SetFolder("luna_xyz/saves/" .. luna_xyz_env.ScriptLoader);
	luna_xyz_env.SaveManager:LoadAutoloadConfig();

	luna_xyz_env.Maid:GiveTask(luna_xyz_env.LP.OnTeleport:Connect(function()
		
		if not luna_xyz_env.Toggles.ExecuteOnTeleport.Value or getgenv().queued_to_teleport then return; end;
		getgenv().queued_to_teleport = true;
		
		--queue_on_teleport([[ loadstring(game:HttpGet("https://github.com/notpoiu/mspaint/releases/latest/download/Script.luau"))() ]]);
	end));

	Logger.success("All settings loaded.");
	return SettingsTab;
end;

function UICreator:CreateCreditsTab()
	
	Logger.wait("Creating credits tab..");
	local CreditsTab = luna_xyz_env.Window:AddTab("Credits", "users");
	
	local OwnersSection = CreditsTab:AddLeftGroupbox("Owners", "moon");
	
	--local DevelopersSection = CreditsTab:AddLeftGroupbox("Developers", "scroll");
	local TestersSection = CreditsTab:AddLeftGroupbox("Testers", "flask-conical");
	
	local ContributorsSection = CreditsTab:AddRightGroupbox("Contributors", "puzzle");
	local CommunitySection = CreditsTab:AddRightGroupbox("Community", "message-circle");
	
	----- || OWNERS || -----
	
	OwnersSection:AddLabel('[<font color="rgb(255, 200, 76)">00._lxh</font>] - Owner of luna.xyz', true);
	
	----- || DEVELOPERS || ----
	
	----- || TESTERS || -----
	
	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">rubie</font>] - Tester of revenant sunrisen', true);
	TestersSection:AddLabel('[<font color="rgb(0, 255, 0)">TexRBLX</font>] - Tester of rakoof, project lazarus', true);
	
	----- || CONTRIBUTORS || -----

	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">TexRBLX</font>] - Helped with rakoof, rake remastered, project lazarus', true);
	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">Ryo Yamada</font>] - Helped with revenant sunrisen', true);
	
	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">deividcomsono</font>] - Obsidian UI library developer', true);
	ContributorsSection:AddLabel('[<font color="rgb(0, 255, 0)">mspaint</font>] - Inspiration for the new version of luna.xyz', true);
	
	ContributorsSection:AddLabel('[<font color="rgb(255, 102, 204)">You</font>] - Thanks for all the support and for using my script', true);
	
	----- || COMMUNITY || -----
	
	CommunitySection:AddLabel('Official luna.xyz socials', true);
	
	CommunitySection:AddButton("Join Discord", function()

		local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))();

		Inviter.Join(luna_xyz_env.discord_id);
		Inviter.Prompt({ name = "luna.xyz"; invite = luna_xyz_env.discord_id; });

	end):AddButton("Copy Link", function()

		if not setclipboard then

			luna_xyz_env.Notify:Notify('Discord link: ' .. luna_xyz_env.discord_id, 10);
			return;
		end;

		setclipboard(luna_xyz_env.discord_id);
		luna_xyz_env.Notify:Notify("Copied discord link to clipboard!");
	end);

	CommunitySection:AddButton({

		Text = "Scriptblox Profile";

		Func = function()

			if not setclipboard then

				luna_xyz_env.Notify:Notify("Scriptblox link: https://scriptblox.com/u/00_lxh", 10);
				return;
			end;

			setclipboard("https://scriptblox.com/u/00_lxh");
			luna_xyz_env.Notify:Notify("Copied Scriptblox link to clipboard!");
		end;
	});
	
	Logger.success("Credits tab created.");
	return CreditsTab;
end;

return UICreator;