local FileManager, hash_cache = { FilesLoaded = false; }, {};

if not luna_xyz_env._SupportsFileSystem then
	
	Logger.warn('The executor ' .. identifyexecutor() .. ' - ' .. select(2, identifyexecutor()) .. ' doesnt support file system, some features will be disabled.');
	
	getgenv().isfile = function(path)
		
		assert(path, "missing argument #1 to 'isfile' (string expected, got nil)");
		return (FileManager[path] and FileManager[path].type == "file") or false;
	end;

	getgenv().writefile = function(path, content)
		
		assert(path, "missing argument #1 to 'writefile' (string expected, got nil)");

		if (FileManager[path] and FileManager[path].type == "folder") then error(("%s is not a valid file name"):format(path), 0); end;
		FileManager[path] = { type = "file"; contents = content; };
	end;
	
	getgenv().delfile = function(path)
		
		assert(path, "missing argument #1 to 'delfile' (string expected, got nil)");

		if not FileManager[path] or (FileManager[path] and FileManager[path].type == "folder") then error(("%s is not a valid file name"):format(path)); end;
		FileManager[path] = nil;
	end;
	
	getgenv().readfile = function(path)
		
		assert(path, "missing argument #1 to 'readfile' (string expected, got nil)");

		local file = FileManager[path];
		if not file or file.type == "folder" then error(("%s is not a valid file name"):format(path), 0)  end;

		return file.contents;
	end;
	
	getgenv().loadfile = function(path)

		assert(path, "missing argument #1 to 'loadfile' (string expected, got nil)");
		return loadstring(readfile(path));
	end;
	
	getgenv().listfiles = function(path)
		
		assert(path, "missing argument #1 to 'listfiles' (string expected, got nil)");

		if path:sub(1, 3) == "./" then path = path:sub(4, -1); elseif path:sub(1, 2) == "." then path = path:sub(3, -1); end;
		if not FileManager[path] or (FileManager[path] and FileManager[path].type == "file") then error(("%s is not a valid folder name"):format(path)); end;

		local result = {};

		for v in FileManager do
			if v:sub(1, #path) == path and v ~= path then table.insert(result, v); end;
		end;

		return result;
	end;
	
	getgenv().isfolder = function(path)
		
		assert(path, "missing argument #1 to 'isfolder' (string expected, got nil)");

		if path:sub(-1, -1) == "/" then path = path:sub(1, #path - 1); end;
		local folder = FileManager[path];

		if not folder then return false; end;
		return folder.type == "folder";
	end;

	getgenv().makefolder = function(path)
		
		assert(path, "missing argument #1 to 'makefolder' (string expected, got nil)");

		if FileManager[path] then error(("%s is not a valid folder name"):format(path), 0); end;
		if path:sub(-1, -1) == "/" then path = path:sub(1, #path - 1); end;

		FileManager[path] = { type = "folder"; };
	end;

	getgenv().delfolder = function(path)
		
		assert(path, "missing argument #1 to 'delfolder' (string expected, got nil)");

		if not FileManager[path] or (FileManager[path] and FileManager[path].type == "file") then error(("%s is not a valid folder name"):format(path)); end;
		FileManager[path] = nil;
	end;
end;

local modules_list = {
	
	{ name = "UI", data = {
		
		{ name = "Library", url = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua" },
		
		{ name = "ThemeManager", url = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua" },
		{ name = "SaveManager", url = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua" },
		
		{ name = "Notify", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/ui/Notify.lua" },
		{ name = "UIManager", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/ui/UIManager.lua" },
		
		{ name = "Addons", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/ui/Addons.lua" },
	}},

	{ name = "universal", data = {
		
		{ name = "ControlModule", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/universal/ControlModule.lua" },
		
		{ name = "Fly", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/universal/Fly.lua" },
		{ name = "ESP", url = "https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau" },
	}},

	{ name = "system", data = {
		
		{ name = "BloxstrapRPC", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/system/BloxstrapRPC.lua" },
		{ name = "Environment", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/system/Environment.lua" },
	}},

	{ name = "HookService", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/HookService.lua" },
	
	{ name = "Signal", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/Signal.lua" },
	{ name = "Maid", url = "https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/src/utils/Maid.lua" },
}

local luna_files = {

	["addons"] = {}; ["analytics"] = {};
	["assets"] = {}; ["saves"] = {};

	["core"] = {
		["WARNING.txt"] = { _t = "file"; content = "WARNING:\nDO NOT DELETE THESE FILES!\n\nThis may have unexpected consequences and may break your linked key if you have one. Only use the 'Erase Local Files' button if you need these to be erased.\n\n- Thank you <3!"; };
	};

	["logs"] = {
		["NOTICE.txt"] = { _t = "file"; content = "WARNING:\nDo NOT share these logs with anyone other than the developers.\n\nThey may contain sensitive information such as but not limited to: Username, HWID, and Security Tokens.\nThese logs are crash reports and are only helpful to the developers. You may delete these if needed. Logs older than 10 days are automatically deleted.\n\n- Thank you <3!"; };
	};

	["utils"] = {

		["UI"] = { _t = "folder"; content = {}; };
		["universal"] = { _t = "folder"; content = {}; };

		["system"] = { _t = "folder"; content = {}; };
		["WARNING.txt"] = { _t = "file"; content = "WARNING:\nDO NOT DELETE THESE FILES!\n\nThis may have unexpected consequences and may cause luna.xyz to stop working. Only use the 'Erase Local Files' button if you need these to be erased.\n\n- Thank you <3!"; };
	};
};

local analytics_data_template = {

	["executor"] = identifyexecutor();
	["TotalExecutions"] = 0; ["PlayTime"] = { [tostring(luna_xyz_env.LP)] = 0; };
};

----- || METHODS || -----

function FileManager:GetHash(str: string)

	local hash = 2166136261;

	for i = 1, #str do

		hash = bit32.bxor(hash, string.byte(str, i));
		hash = (hash * 16777619) % 2^32;
	end;

	return string.format("%08x", hash);
end;

function FileManager:MergeTables(default, current)
	
	for key, value in pairs(default) do
		if current[key] == nil then current[key] = value; elseif typeof(value) == "table" and typeof(current[key]) == "table" then		
			FileManager:MergeTables(value, current[key]);
		end;
	end;
end;

function FileManager:LoadModule(module_path: string, module_data: string)
	
	local startTime = os.time();
	Logger.wait('Checking module: ' .. module_path .. '.lua');

	local local_file = 'luna_xyz/utils/'.. module_path .. '.lua';
	local cache  = hash_cache[module_path];

	local __s, __e = pcall(game.HttpGet, game, module_data);

	if not __s then

		Logger.error('Failed to fetch module ' .. module_path .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: ' .. tostring(__e));

		return;
	end;

	local remoteHash = FileManager:GetHash(__e);
	local needsUpdate = not cache or cache.hash ~= remoteHash or cache.url ~= module_data or not isfile(local_file);

	if needsUpdate then

		local startTime2 = os.time();

		hash_cache[module_path] = { hash = remoteHash; url = module_data; time = os.time(); };
		writefile("luna_xyz/hash_cache.json", luna_xyz_env.HttpService:JSONEncode(hash_cache));

		writefile(local_file, __e);
		Logger.info('Module ' .. module_path ..  '.lua updated. - (' .. string.format("%.2f", os.time() - startTime2) .. ')');
	end;

	local __s, __e = pcall(function()
		return loadfile and loadfile(local_file)() or loadstring(readfile(local_file))();
	end);

	if not __s then

		Logger.error('Failed to load module ' .. module_path .. '.lua - (' .. string.format("%.2f", os.time() - startTime) .. ')');
		Logger.error('    RUNTIME ERROR: ' .. tostring(__e));

		return;
	end;

	luna_xyz_env.loaded_libs[module_path:match(".+/(.+)") or module_path] = __e;
	Logger.success('The module ' .. module_path .. '.lua loaded successfully. - (' .. string.format("%.2f", os.time() - startTime) .. ')');
end;

----- || FILE CHECK || -----

local startTime = os.time();
Logger.wait("Checking files integrity..");

for folder_name, folder_data in pairs(luna_files) do

	if #folder_data == 0 then

		if isfolder('luna_xyz/' .. tostring(folder_name)) then continue; end;
		makefolder('luna_xyz/' .. tostring(folder_name));
		
		Logger.debug('The folder "luna_xyz/' .. tostring(folder_name) .. '" was not found, Creaitng a new one..');
	end;

	for file_name, file_data in pairs(folder_data) do

		if file_data._t == "folder" and not isfolder('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name)) then

			makefolder('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name));
			Logger.debug('The folder "luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name) .. '" was not found, Creaitng a new one..');

			for a, b in pairs(file_data.content) do

				writefile('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name) .. '/' .. tostring(a), tostring(b));
				if isfile('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name) .. '/' .. tostring(a)) then continue; end;
				
				Logger.debug('The file "luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name) .. '/' .. tostring(a) .. '" was not found, Creaitng a new one..');
			end;

		elseif file_data._t == "file" and not isfile('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name)) then

			writefile('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name), tostring(file_data.content));
			if isfile('luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name), tostring(file_data.content)) then continue; end;
			
			Logger.debug('The file "luna_xyz/' .. tostring(folder_name) .. '/' .. tostring(file_name) .. '" was not found, Creaitng a new one..');
		end;
	end;
end;

for _, file_path in pairs(listfiles("luna_xyz/logs")) do

	local startTime2 = os.time();

	local filename = tostring(file_path):match("([^\\]+)$");
	filename = filename:match("(.+)%..+$");

	local months, days, years = filename:match("(%d+)%-(%d+)%-(%d+)");
	if not(months or days or years) then continue; end;

	local fileTime = os.time({ year = years, month = months, day = days });
	local difference = os.difftime(os.time(), fileTime);

	local delete_days = 10;
	if not (difference >= (delete_days * 24 * 60 * 60)) then continue; end;

	Logger.warn('Deleting log file "' .. tostring(file_path):gsub("\\", "/") .. '" because is 10 days old. - (' .. string.format("%.2f", os.time() - startTime) .. ')');
	delfile(file_path);
end;

if not isfile("luna_xyz/whaaaattt.mp3") and (crypt and crypt.base64decode) then
	writefile("luna_xyz/whaaaattt.mp3", crypt.base64decode(game:HttpGet("https://raw.githubusercontent.com/00lxh/luna_xyz/refs/heads/main/assets/whaaaattt.txt")));
end;

if isfolder("luna_xyz/modules") then delfolder("luna_xyz/modules"); end;
Logger.success('Files integrity good. - (' .. string.format("%.2f", os.time() - startTime) .. ')');

----- || CACHE CHECK || -----

local startTime2 = os.time();
Logger.wait("Fetching cache data..");

if isfile("luna_xyz/hash_cache.json") then
	hash_cache = luna_xyz_env.HttpService:JSONDecode(readfile("luna_xyz/hash_cache.json"));
end;

Logger.success('Loaded cache data. - (' .. string.format("%.2f", os.time() - startTime2) .. ')');

----- || ANALITYCS CHECK || -----

startTime2 = os.time();
Logger.wait("Fetching analytics data..");

if not isfile("luna_xyz/analytics/stats.json") then
	writefile("luna_xyz/analytics/stats.json", luna_xyz_env.HttpService:JSONEncode(analytics_data_template));
end;

local analytics_data = luna_xyz_env.HttpService:JSONDecode(readfile("luna_xyz/analytics/stats.json"));
FileManager:MergeTables(analytics_data_template, analytics_data);

analytics_data.TotalExecutions += 1;
luna_xyz_env.analytics_data = analytics_data;

writefile("luna_xyz/analytics/stats.json", luna_xyz_env.HttpService:JSONEncode(analytics_data));
Logger.success('Loaded analytics data. - (' .. string.format("%.2f", os.time() - startTime2) .. ')');

----- || MODULES CHECK || -----

startTime = os.time();
Logger.wait("Fetching hub modules..");

for _, module in ipairs(modules_list) do

	if not module.data then
		
		FileManager:LoadModule(module.name, module.url);
		continue;
	end;
	
	for _, sub in ipairs(module.data) do
		FileManager:LoadModule(module.name .. '/' .. sub.name, sub.url)
	end;
end;

Logger.success('Loaded hub modules. - (' .. string.format("%.2f", os.time() - startTime) .. ')');
FileManager.FilesLoaded = true;

return FileManager;
