local HookService = loadstring(game:HttpGet("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/HookService.lua"))();
local AdonisBypasser, AdonisAnticheatThreads = {}, {};

function AdonisBypasser:Detect()

	if not getreg or not getgc or not isfunctionhooked then
		return false;
	end;

	local AdonisDetected = false;

	for _, thread in getreg() do

		if typeof(thread) ~= "thread" then continue; end;
		local Source = debug.info(thread, 1, "s");

		if Source and (Source:match(".Core.Anti") or Source:match(".Plugins.Anti_Cheat")) then

			AdonisDetected = true;
			table.insert(AdonisAnticheatThreads, thread);
		end;
	end;

	return AdonisDetected;
end;

function AdonisBypasser:Bypass()

	for _, thread in AdonisAnticheatThreads do
		pcall(coroutine.close, thread);
	end;

	local AdonisTables = {};
	local ContendorAdonisTables = filtergc("table", { Keys = { "Detected", "RLocked" } });

	for _, AdonisTable in ContendorAdonisTables do

		if typeof(rawget(AdonisTable, "Detected")) ~= "function" then continue; end;
		table.insert(AdonisTables, AdonisTable);
	end;

	for _, Adonis in AdonisTables do
		for _, DetectionFunc in Adonis do

			if typeof(DetectionFunc) ~= "function" or isfunctionhooked(DetectionFunc) then continue; end;

			HookService:Hook(DetectionFunc, function(action, info, nocrash)
				coroutine.yield(); return task.wait(9e9)
			end);
		end;
	end;

	return true;
end;

return AdonisBypasser;