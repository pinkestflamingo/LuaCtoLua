function string_split(inputstr, sep)
	if sep == nil then
	    sep = "%s";
	end
	local t={};
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	    table.insert(t, str);
	end
	return t;
end

function case(value, table, default)
    if rawget(table, value) then
        return rawget(table, value)();
    end
    return default();
end

local LuaStack  = {}
local LuaC_code = [[
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
getfield -1 Destroy
pushvalue -2
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 face
getfield -1 Destroy
pushvalue -2
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getglobal Instance
getfield -1 new
pushstring SpecialMesh
pushvalue -4
pcall 2 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
pushstring rbxassetid://23265118
setfield -2 MeshId
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
pushstring rbxassetid://450502375
setfield -2 TextureId
]];

function format_index(index)
    if type(index) == "string" then
        index = tonumber(index)
    end
	if index < 0 and #LuaStack > 0 then
		return (#LuaStack + 1) - (index * (-1))
	end
	return index
end

local Lua_code  = ""
for Index, Value in pairs(string_split(LuaC_code, "\n")) do
	local ParsedLine 	= string_split(Value, " ");

	local Operator   	= ParsedLine[1];
	local OperatorSize 	= string.len(Operator);
	local Arguments     = string_split(string.sub(Value, OperatorSize + 2, -1), " ");

	case(Operator,
	{
		getglobal 		= function()
			local Global = table.concat(Arguments, " ");

			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = %s;", #LuaStack + 1, Global));

			table.insert(LuaStack, Global);
		end,
		getfield		= function() 
			local SkipByLength = OperatorSize + string.len(ParsedLine[2]) + 3;
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = v%d['%s'];", #LuaStack + 1, format_index(ParsedLine[2]), string.sub(Value, SkipByLength, -1)));

			table.insert(LuaStack, string.sub(Value, SkipByLength, -1));
		end,
		setfield		= function() 
			local SkipByLength = OperatorSize + string.len(ParsedLine[2]) + 3;
			Lua_code = string.format("%s\n%s", Lua_code, string.format("v%d['%s'] = v%d;", format_index(ParsedLine[2]), string.sub(Value, SkipByLength, -1), #LuaStack));

			table.remove(LuaStack, #LuaStack - 1);
		end,
		call   			= function() 
			local ArgumentCount 	= tonumber(ParsedLine[2]);
			local ReturnCount   	= tonumber(ParsedLine[3]);
			local FunctionOnStack 	= string.format("v%d", #LuaStack - format_index(ArgumentCount));
			local Arguments         = "";
			local ArgumentCache     = {};
			local Returns           = "";
			for I = 1, ArgumentCount do
				table.insert(ArgumentCache, string.format("v%d", (#LuaStack + 1 - I)))
			end
			for I, V in next, ArgumentCache do
				Arguments = string.format("%s, %s", string.format("v%d", (#LuaStack + 1 - I)), Arguments);
			end
			Arguments = string.sub(Arguments, 1, -3);

			for I = 1, ReturnCount do
				table.insert(LuaStack, "unknown_return_value");
				if string.len(Returns) < 1 then
					Returns = "local " .. string.format("v%d, ", #LuaStack);
				else
					Returns = string.format("%s%s", Returns, string.format("v%d, ", #LuaStack))
				end
			end
			Returns = string.sub(Returns, 1, -3)
			if string.len(Returns) > 5 then
				Returns = string.format("%s = ", Returns)
			end

			Lua_code = string.format("%s\n%s%s", Lua_code, Returns, string.format("%s(%s);", FunctionOnStack, Arguments));
		end,
		pcall   		= function() 
			local ArgumentCount 	= tonumber(ParsedLine[2]);
			local ReturnCount   	= tonumber(ParsedLine[3]);
			local FunctionOnStack 	= string.format("v%d", #LuaStack - format_index(ArgumentCount));
			local Arguments         = "";
			local ArgumentCache     = {};
			local Returns           = "";
			for I = 1, ArgumentCount do
				table.insert(ArgumentCache, string.format("v%d", (#LuaStack + 1 - I)))
			end
			for I, V in next, ArgumentCache do
				Arguments = string.format("%s, %s", string.format("v%d", (#LuaStack + 1 - I)), Arguments);
			end
			Arguments = string.sub(Arguments, 1, -3);

			for I = 1, ReturnCount do
				table.insert(LuaStack, "unknown_return_value");
				if string.len(Returns) < 1 then
					Returns = "local " .. string.format("v%d, ", #LuaStack);
				else
					Returns = string.format("%s%s", Returns, string.format("v%d, ", #LuaStack))
				end
			end
			Returns = string.sub(Returns, 1, -3)
			if string.len(Returns) > 5 then
				Returns = string.format("%s = ", Returns)
			end

			Lua_code = string.format("%s\n%s%s", Lua_code, Returns, string.format("%s(%s);", FunctionOnStack, Arguments));
		end,
		pushnumber 		= function()
			local Number = table.concat(Arguments, " ");
			
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = %s;", #LuaStack + 1, Number));

			table.insert(LuaStack, String);
		end,
		pushinteger		= function()
			local Number = table.concat(Arguments, " ");
			
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = %s;", #LuaStack + 1, Number));

			table.insert(LuaStack, String);
		end,
		pushvalue 		= function()
			local PositionAtStack = format_index(tonumber(ParsedLine[2]))
			
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = v%d;", #LuaStack + 1, PositionAtStack));

			table.insert(LuaStack, "unknown_push_value");
		end,
		pushboolean		= function()
			local Boolean = table.concat(Arguments, " ");
			
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = %s;", #LuaStack + 1, Boolean));

			table.insert(LuaStack, String);
		end,
		pushstring 		= function()
			local String = table.concat(Arguments, " ");
			
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = '%s';", #LuaStack + 1, String));

			table.insert(LuaStack, String);
		end,
		pushnil 		= function()
			Lua_code = string.format("%s\n%s", Lua_code, string.format("local v%d = nil;", #LuaStack + 1));

			table.insert(LuaStack, "nil");
		end,
		wait    		= function()
			Lua_code = string.format("%s\n%s", Lua_code, string.format("wait(%d)", ParsedLine[2]));
		end, 
		pop     		= function()
			local PopAmount = tonumber(ParsedLine[2]);
			for _ = 1, PopAmount do 
				table.remove(LuaStack, #LuaStack)
			end
		end,
		settop          = function()
			local Number = tonumber(table.concat(Arguments, " "));
			if Number == 0 then
				LuaStack = {}
			else
				Number = format_index(Number)
				for I, _ in next, LuaStack do
					if Number > I then
						table.remove(LuaStack, I)
					end
				end
			end
		end,
		emptystack 		= function()
			LuaStack = {}
		end,
	}, 
    function()
		print(Operator, "is not supported yet.");
	end)
end 

print("--; Converted from LuaC to Lua using Dimenzia™", Lua_code)
