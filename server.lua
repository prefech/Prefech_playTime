--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #             Prefech_playTime By Prefech 28-10-2021                #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

local IDENTIFIER = "steam:" -- add the identifier type and a : after

SetHttpHandler(function(req, res)
    if req.path == '/info' then
        res.send(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
        return
    end
end)

RegisterCommand('getPlayTime', function(source, args)
	local loadedFile = json.decode(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
    local identifier

	if args[1] then
		identifier = ExtractIdentifiers(args[1]) 
	else
		identifier = ExtractIdentifiers(source) 
	end

	if loadedFile[identifier] then
		local storedTime = loadedFile[identifier].playTime
		local joinTime = loadedFile[identifier].joinTime
		local timeNow = os.time(os.date("!*t"))

		TriggerClientEvent('chat:addMessage', -1, { args = {"Prefech", GetPlayerName(source).."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime)} })
	end
end)

exports('getPlayTime', function(source)
	local loadedFile = json.decode(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
	local identifier = ExtractIdentifiers(source)

	if loadedFile[identifier] then
		local storedTime = loadedFile[identifier].playTime
		local joinTime = loadedFile[identifier].joinTime
		local timeNow = os.time(os.date("!*t"))

		return {
			session = timeNow - joinTime,
			total = (timeNow - joinTime) + storedTime
		}
	end
end)

function SecondsToClock(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600 )
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60) 
	seconds = seconds - minutes * 60
    local result = string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)

	if days == 0 and hours == 0 and minutes == 0 then
		result = string.format("%d seconds.", seconds)
	elseif days == 0 and hours == 0 then
		result = string.format("%d minutes, %d seconds.", minutes, seconds)
	elseif days == 0 then
		result = string.format("%d hours, %d minutes, %d seconds.", hours, minutes, seconds)
	end

    return result
end

RegisterNetEvent('playerJoining', function(spawn)
	local loadedFile = json.encode(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
	local identifier = ExtractIdentifiers(source)

	if loadedFile[identifier] then
		if loadedFile[identifier].leaveTime ~= 0 then
			loadedFile[identifier] = {
				['playTime'] = loadedFile[identifier].playTime,
				['joinTime'] = os.time(os.date("!*t")),
				['leaveTime'] = 0
			}
		end
	else
		loadedFile[identifier] = {
			['playTime'] = 0,
			['joinTime'] = os.time(os.date("!*t")),
			['leaveTime'] = 0
		}
	end

	SaveResourceFile(GetCurrentResourceName(), "playTime.json", json.encode(loadedFile), -1)
end)

RegisterNetEvent('playerDropped', function(reason)
	local loadedFile = json.decode(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
	local identifier = ExtractIdentifiers(source) 

	if loadedFile[identifier] then
		if loadedFile[identifier].leaveTime == 0 then
			local playTime = os.time(os.date("!*t")) - tonumber(loadedFile[identifier].joinTime)
			loadedFile[identifier] = {
				['playTime'] = loadedFile[identifier].playTime + playTime,
				['joinTime'] = loadedFile[identifier].joinTime,
				['leaveTime'] = os.time(os.date("!*t"))
			}

			SaveResourceFile(GetCurrentResourceName(), "playTime.json", json.encode(loadedFile), -1)
		end
	end
end)

function ExtractIdentifiers(source)
	for i = 1, #GetPlayerIdentifiers(source) do
		if string.match(GetPlayerIdentifiers(source)[i], IDENTIFIER) then
			return GetPlayerIdentifiers(source)[i]
		end
	end
end

-- version check
CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/Prefech/Prefech_playTime/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1-------------------------------------------------------
^1Prefech_playTime
^1UPDATE: %s AVAILABLE
^1CHANGELOG: %s
^1-------------------------------------------------------^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('^1Prefech_playTime unable to check version^0')
					end
				end,
				'GET'
			)
		end
	end
)
