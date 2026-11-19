---- || LOADING CHECK || -----

local getgenv = (getgenv or function() return _G; end);

local newcclosure = (newcclosure or function(fn: any) return fn; end);
local islclosure = (islclosure or function(fn: any) return debug.info(fn, "s") ~= "[C]"; end);
local getrawmetatable = (getrawmetatable or function(t: any) return t; end);

---- || TABLES || -----

local luna_xyz_env = getgenv().luna_xyz_env or {};

local functions_hooked, signals_hooked = { oth = {}; normal_hook = {}; meta_hook = {}; }, {};
local HookService, Quartz = {}, getgenv().Quartz or luna_xyz_env.Quartz;

if not Quartz then

	Quartz = loadstring(game:HttpGet("https://gitlab.com/upio/quartz/-/releases/permalink/latest/downloads/Quartz.luau"))();
	Quartz = Quartz.new(); Quartz:TestAll(); getgenv().Quartz = Quartz;
end;

----- || HOOKS || -----

function HookService:Hook(Original, Replacement)

	if oth and oth.hook and iscclosure(Original) then

		local hooked_function = oth.hook(Original, Replacement);
		table.insert(functions_hooked.oth, Original);

		return hooked_function;
	end;

	if islclosure(Replacement) then Replacement = newcclosure(Replacement); end;
	if not Quartz:GetFunction("hookfunction") then return Original; end;

	local hooked_function = hookfunction(Original, Replacement);
	table.insert(functions_hooked.normal_hook, Original);

	return hooked_function;
end;

function HookService:HookMetaMethod(object, method, hook)

	local Metatable = getrawmetatable(object);
	local originalMethod = rawget(Metatable, method);

	assert(typeof(originalMethod) == "function", `{method} is not a function in the metatable of {object}`);

	if oth and oth.hook then

		local hooked_function = oth.hook(originalMethod, hook);
		table.insert(functions_hooked.oth, originalMethod);

		return hooked_function;
	end;

	if islclosure(hook) then hook = newcclosure(hook); end;

	if not Quartz:GetFunction("hookmetamethod") and Quartz:GetFunction("getrawmetatable") then

		setreadonly(Metatable, false); rawset(Metatable, method, hook); setreadonly(Metatable, true);
		return originalMethod;
	end;

	local hooked_function = hookmetamethod(object, method, hook);
	functions_hooked.meta_hook[hook] = { __obj = object; __method = method; __old = hooked_function; };

	return hooked_function;
end;

function HookService:HookRemote(object, method, callback)
	
	callback = callback or function() return nil; end;
	if not Quartz:GetFunction("getnamecallmethod") then return callback; end;

	local old__namecall; old__namecall = HookService:HookMetaMethod(game, "__namecall", function(self, ...)

		if (typeof(object) ~= "string" and self == object or tostring(self) == tostring(object)) and getnamecallmethod() == tostring(method) then
			return callback(self, ...);
		end;

		return old__namecall(self, ...);
	end);

	return old__namecall;
end;

function HookService:DisableConnection(Signal)

	if not Quartz:GetFunction("getconnections") then return; end;

	for _, v in next, getconnections(Signal) do v:Disable(); end;
	table.insert(signals_hooked, Signal);
end;

function HookService:EnableConnection(Signal)

	if not Quartz:GetFunction("getconnections") then return; end;

	for _, v in next, getconnections(Signal) do v:Enable(); end;
	table.remove(signals_hooked, table.find(signals_hooked, Signal));
end;

function HookService:IsCompatible()
	return Quartz and Quartz:GetFunction("hookfunction") and Quartz:GetFunction("hookmetamethod") and Quartz:GetFunction("getconnections") or false;
end;

function HookService:DoCleaning()

	if oth and oth.unhook then	

		for _, v in functions_hooked.oth do oth.unhook(v); end;
		table.clear(functions_hooked.oth);
	end;

	if isfunctionhooked and restorefunction then

		for _, v in functions_hooked.normal_hook do if isfunctionhooked(v) then restorefunction(v); end; end;
		table.clear(functions_hooked.normal_hook);
	end;

	if hookmetamethod then

		for _, v in functions_hooked.meta_hook do hookmetamethod(v.__obj, v.__method, v.__old); end;
		table.clear(functions_hooked.meta_hook);
	end;

	if not Quartz:GetFunction("getconnections") then return; end;

	for _, Signal in pairs(signals_hooked) do
		for _, v in next, getconnections(Signal) do v:Enable(); end;
	end;

	table.clear(signals_hooked);
end;

----- || FINALIZE || -----

return HookService;
