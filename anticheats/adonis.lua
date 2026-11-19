local HookService = loadstring(game:HttpGet("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/packages/universal/HookService.lua"))();
local AdonisBypasser, AdonisAnticheatThreads, adonisDetected, adonisBypassed = {}, {}, false, false;

----- || METHODS || -----

function AdonisBypasser:Detect()
	
	if not AdonisBypasser:CanBypass() then return adonisDetected; end;

	for _, thread in getreg() do

		if typeof(thread) ~= "thread" then continue; end;
		local source = debug.info(thread, 1, "s");

		if source and (source:match(".Core.Anti") or source:match(".Plugins.Anti_Cheat")) then
			adonisDetected = true; table.insert(AdonisAnticheatThreads, thread);
		end;
	end;

	return adonisDetected;
end;

function AdonisBypasser:Bypass()
	
	if not adonisDetected then return; end;
	local adonisTables = {};

	for _, thread in AdonisAnticheatThreads do pcall(coroutine.close, thread); end;
	local contendorAdonisTables = filtergc("table", { Keys = { "Detected"; "RLocked"; } }, false);

	for _, adonisTable in contendorAdonisTables do

		if typeof(rawget(adonisTable, "Detected")) ~= "function" then continue; end;
		table.insert(adonisTables, adonisTable);
	end;

	for _, adonis in adonisTables do
		for _, detectionFunc in adonis do

			if typeof(detectionFunc) ~= "function" or isfunctionhooked(detectionFunc) then continue; end;
			HookService:Hook(detectionFunc, function(action, info, nocrash) coroutine.yield(); return task.wait(9e9); end);
		end;
	end;
	
	adonisBypassed = true;
end;

function AdonisBypasser:CanBypass()
	return getreg and filtergc and isfunctionhooked and HookService:IsCompatible();
end;

function AdonisBypasser:IsBypassed()
	return adonisBypassed;
end;

----- || FINALIZE || -----

return AdonisBypasser;