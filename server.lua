--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/  __/ _ \  _/ _ \/ __|  _ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

SetHttpHandler(function(req, res)
    if req.path == "/info" then	
		local result = StartFindKvp('Prefech:PlayTime:')
		playTime = {}
		if result ~= -1 then
			local key = true
			while key do
				Wait(0)
				key = FindKvp(result)
				if key then
					local value = split(GetResourceKvpString(key), ';')
					playTime[value[1]] = {
						["steamhex"] = value[1],
						["playtime"] = value[2],
						["lastjoin"] = value[3],
						["lastleave"] = value[4],
						["username"] = value[5]
					}		
				end
			end
			EndFindKvp(result)
		end	
		res.send(json.encode(playTime))
        return
    end
end)

RegisterCommand("getPlayTime", function(source, args, RawCommand)
	if args[1] then id = args[1] steam = ExtractIdentifiers(args[1]) else id = source steam = ExtractIdentifiers(source) end
	local result = GetResourceKvpString('Prefech:PlayTime:'..steam)
	if result ~= nil then
		local value = split(result, ';')
		local storedTime = value[2]
		local joinTime = value[3]
		local timeNow = os.time(os.date("!*t"))
		if source == 0 then
			print(GetPlayerName(id).."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime))
		else
			TriggerClientEvent("chat:addMessage", source, { args = {"Prefech", GetPlayerName(id).."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime)} })
		end
	end
end)

exports("getPlayTime", function(src)
	local steam = ExtractIdentifiers(src)
	local result = GetResourceKvpString('Prefech:PlayTime:'..steam)
	if result ~= nil then
		local value = split(result, ';')
		local storedTime = value[2]
		local joinTime = value[3]
		local timeNow = os.time(os.date("!*t"))

		playTime = {
			["Session"] = timeNow - joinTime,
			["Total"] = (timeNow - joinTime) + storedTime
		}
		return playTime
	end
end)

AddEventHandler("playerJoining", function(source, oldID)
	local src = source
	local steam = ExtractIdentifiers(src)
	if steam ~= nil then
		local result = GetResourceKvpString('Prefech:PlayTime:'..steam)		
		if result ~= nil then
			local value = split(result, ';')
			SetResourceKvp('Prefech:PlayTime:'..steam, steam..';'..value[2]..';'..os.time(os.date("!*t"))..';0;'..GetPlayerName(src))
		else
			SetResourceKvp('Prefech:PlayTime:'..steam, steam..';0;'..os.time(os.date("!*t"))..';0;'..GetPlayerName(src))
		end
	else
		print("^1Prefech_playTime: Error! Player "..GetPlayerName(source).." is connected without steam and playtime will not be recorded.^0")
	end
end)

AddEventHandler("playerDropped", function(reason)
	local src = source
	local timeNow = os.time(os.date("!*t"))
	local steam = ExtractIdentifiers(src)
	if steam ~= nil then
		local result = GetResourceKvpString('Prefech:PlayTime:'..steam)
		if result ~= nil then			
			local value = split(result, ';')
			local playTime = timeNow - tonumber(value[3])			
			SetResourceKvp('Prefech:PlayTime:'..steam, steam..';'..tonumber(value[2]) + playTime..';'..value[3]..';'..os.time(os.date("!*t"))..';'..GetPlayerName(src))
		end
	end
end)

RegisterNetEvent("Prefech:getIdentifiers")
AddEventHandler("Prefech:getIdentifiers", function()
	local src = source
	local steam = ExtractIdentifiers(src)
	local result = GetResourceKvpString('Prefech:PlayTime:'..steam)
	if result ~= nil then
		local value = split(result, ';')
		local storedTime = value[2]
		local joinTime = value[3]
		local timeNow = os.time(os.date("!*t"))

		playTime = {
			["Session"] = timeNow - joinTime,
			["Total"] = (timeNow - joinTime) + storedTime
		}
		return playTime
	end
end)

function ExtractIdentifiers(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
           return id
		end
    end
	return nil
end

function split(inputstr, sep)
	if sep == nil then
	   sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	   table.insert(t, str)
	end
	return t
 end

function SecondsToClock(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600 )
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	if days == 0 and hours == 0 and minutes == 0 then
		return string.format("%d seconds.", seconds)
	elseif days == 0 and hours == 0 then
		return string.format("%d minutes, %d seconds.", minutes, seconds)
	elseif days == 0 then
		return string.format("%d hours, %d minutes, %d seconds.", hours, minutes, seconds)
	else
		return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
	end
	return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
end

-- version check
CreateThread(function()
	local vRaw = LoadResourceFile(GetCurrentResourceName(), "version.json")
	if vRaw then
		local v = json.decode(vRaw)
		PerformHttpRequest("https://raw.githubusercontent.com/Prefech/Prefech_playTime/master/version.json", function(code, res, headers)
			if code == 200 then
				local rv = json.decode(res)
				if rv.version ~= v.version then
					print(([[^1-------------------------------------------------------
^1Prefech_playTime
^1UPDATE: %s AVAILABLE
^1CHANGELOG: %s
^1-------------------------------------------------------^0]]):format(rv.version, rv.changelog))
				end
			else
				print("^1Prefech_playTime unable to check version^0")
			end
		end, "GET")
	end
end)
