local HookingService, hookedFunctions, signalFunctions = {}, {}, {};
HookingService.ClassName = "HookingService"

function HookingService:Hook(__callback, __callback_hook)

	local hooked_function = hookfunction(__callback, __callback_hook);
	hookedFunctions[__callback] = hooked_function;

	return hooked_function;
end;

function HookingService:HookRemote(Object, __callback)

	__callback = __callback or function() return nil; end;

	local Old_Namecall; Old_Namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)

		if (getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer") and (typeof(Object) ~= "string" and self == Object or tostring(self) == tostring(Object)) then
			return __callback(self, ...);
		end;

		return Old_Namecall(self, ...);
	end));

	hookedFunctions[__callback] = { __hook = "__namecall"; __old = Old_Namecall; };
end;

function HookingService:NameCallHook(Object, Method, __callback)

	__callback = __callback or function() return nil; end;

	local Old_Namecall; Old_Namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)

		if getnamecallmethod() == Method and (typeof(Object) ~= "string" and self == Object or tostring(self) == tostring(Object)) then
			return __callback(self, ...);
		end;

		return Old_Namecall(self, ...);
	end));

	hookedFunctions[__callback] = { __hook = "__namecall"; __old = Old_Namecall; };
end;

function HookingService:IndexHook(Object, Property, Value)

	local Old_newIndex; Old_newIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, __k, ...)

		if (typeof(Object) ~= "string" and self == Object or tostring(self) == tostring(Object)) and __k == Property then
			return Value;
		end;

		return Old_newIndex(self, __k, ...);
	end));

	local Old_Index; Old_Index = hookmetamethod(game, "__index", newcclosure(function(self, __k, ...)

		if (typeof(Object) ~= "string" and self == Object or tostring(self) == tostring(Object)) and __k == Property then
			return Value;
		end;

		return Old_Index(self, __k, ...);
	end));

	hookedFunctions[Old_newIndex] = { __hook = "__newindex"; __old = Old_newIndex; };
	hookedFunctions[Old_Index] = { __hook = "__index"; __old = Old_Index; };
end;

function HookingService:DisableConnection(Signal)

	table.insert(signalFunctions, Signal);
	for _, v in next, getconnections(Signal) do v:Disable(); end;
end;

function HookingService:Destroy()

	for i, v in pairs(hookedFunctions) do
		if typeof(i) == "function" and typeof(v) == "function" and ishooked(i) then restorefunction(i); end;
		if typeof(i) == "function" and typeof(v) == "table" then hookmetamethod(game, v.__hook, v.__old); end;
	end;

	for _, v in pairs(signalFunctions) do
		for _, b in next, getconnections(v) do b:Enable(); end;
	end;

	table.clear(hookedFunctions); table.clear(signalFunctions);
end;

return HookingService;