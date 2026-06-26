local HookService = loadstring(game:HttpGet("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/HookService.lua"))();
local AdonisBypasser, AdonisAnticheatThreads = {}, {};

function AdonisBypasser:Detect()

	if not getreg or not getgc or not isfunctionhooked then
		return false;
	end;

	local adonisDetected = false;

	for _, thread in getreg() do

		if typeof(thread) ~= "thread" then continue; end;
		local source = debug.info(thread, 1, "s");

		if source and (source:match(".Core.Anti") or source:match(".Plugins.Anti_Cheat")) then

			adonisDetected = true;
			table.insert(AdonisAnticheatThreads, thread);
		end;
	end;

	return adonisDetected;
end;

function AdonisBypasser:Bypass()

	for _, thread in AdonisAnticheatThreads do
		pcall(coroutine.close, thread);
	end;

	local adonisTables = {};
	local contendorAdonisTables = filtergc("table", { Keys = { "Detected"; "RLocked"; } });

	for _, adonisTable in contendorAdonisTables do

		if typeof(rawget(adonisTable, "Detected")) ~= "function" then continue; end;
		table.insert(adonisTables, adonisTable);
	end;

	for _, adonis in adonisTables do
		for _, detectionFunc in adonis do

			if typeof(detectionFunc) ~= "function" or isfunctionhooked(detectionFunc) then continue; end;

			HookService:Hook(detectionFunc, function(action, info, nocrash)
				
				coroutine.yield();
				return task.wait(9e9);
			end);
		end;
	end;

	return true;
end;

return AdonisBypasser;
