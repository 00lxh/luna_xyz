getgenv().Services = {};
local cloneref = (cloneref or function(instance: any) return instance end);

local luna_storage = Instance.new("Folder", gethui and gethui() or cloneref(game:GetService("CoreGui")));
luna_storage.Name = "luna_storage";

function Services:GetService(serviceName: string)
	
	assert(serviceName, "Argument #1 missing or nil");
	assert(typeof(serviceName) == "string", 'Invalid argument #1 to "GetService" (string expected, got ' .. typeof(serviceName) .. ')');
	
	if serviceName:lower() == "cache" then return luna_storage; end;
	if luna_xyz_env.loaded_libs[serviceName] then return luna_xyz_env.loaded_libs[serviceName]; end;
	
	local service = cloneref(game:GetService(serviceName));
	luna_xyz_env[serviceName] = service;
	
	return service;
end;

function Services:GetServices(serviceNames: table)
	
	assert(serviceNames, "Argument #1 missing or nil");
	assert(typeof(serviceNames) == "table", 'Invalid argument #1 to "GetServices" (string expected, got ' .. typeof(serviceName) .. ')');
	
	for _, serviceName: string in ipairs(serviceNames) do
		Services:GetService(serviceName);
	end;
end;

return Services;
