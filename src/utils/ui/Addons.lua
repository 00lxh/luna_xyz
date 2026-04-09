local addons = {};

local AddonsTab = luna_xyz_env.Window:AddTab("Addons", "boxes");
local lastPosition = 1;

if not luna_xyz_env._SupportsFileSystem then

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
		Text = "\nluna.xyz was unable to create addons folder (<b>ERROR: FileSystem API</b>)\n<i>If the error persists, please contact the development team.</i>";
	});

	return {};
end;

if #listfiles("luna_xyz/addons") <= 0 then

	AddonsTab:UpdateWarningBox({

		Title = '<font size="20">luna.xyz - FileSystem API ERROR</font>', Visible = true;
		Text = "\nYour addons FOLDER is empty! (luna_xyz/addons)."
	});

	return {};
end;

repeat task.wait() until getgenv().luna_xyz_loaded;
if not luna_xyz_addons then getgenv().luna_xyz_addons = {}; end;

AddonsTab:UpdateWarningBox({

	Title = '<font size="20">luna.xyz - WARNING</font>', Visible = true;
	Text = "\nThis tab is for UN-OFFICIAL addons made for luna.xyz, We are not responsible for what addons you will use. You are putting yourself <b>AT RISK</b> since you are executing third-party scripts.";
});

for i, v in pairs(listfiles("luna_xyz/addons")) do

	local startTime = os.time(); local addon_name = v:match(".+\\(.+)") or v;
	Logger.event('Loading addon ' .. addon_name .. '..');

	local __s, file_data = pcall(function()
		return loadfile(v)();
	end);

	if not luna_xyz_addons.AddonInfo then

		Logger.error('Failed to load addon ' .. addon_name .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: "AddonInfo" table not found.');

		continue;
	end;

	local addon_info = luna_xyz_addons.AddonInfo;
	
	if not addon_info.Game or not luna_xyz_env:IsValidGame(addon_info.Game) then

		Logger.error('Failed to load addon ' .. addon_name .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: The game "' .. tostring(addon_info.Game) .. '" is not supported by luna.xyz!');

		continue;
	end;
	
	if not addon_info.Title  then

		Logger.error('Failed to load addon ' .. addon_name .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: You must enter a valid addon title!');

		continue;
	end;

	luna_xyz_addons.Groupbox = lastPosition == 1 and AddonsTab:AddLeftGroupbox(addon_info.Title, addon_info.Icon or "") or AddonsTab:AddRightGroupbox(addon_info.Title, addon_info.Icon or "");
	if lastPosition == 1 then lastPosition = 2; else lastPosition = 1; end;
	
	local __s, __e = pcall(function()
		return loadfile(v)();
	end);
	
	if not __s then

		Logger.error('Failed to load addon ' .. addon_name .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: ' .. tostring(__e));

		continue;
	end;
	
	Logger.success('The addon ' .. addon_name .. ' loaded successfully. - (' .. string.format("%.2f", os.time() - startTime) .. ')');
end;

return {};
