--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #            Prefech_DonatorLock By Prefech 28-10-2021              #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

function GiveDonatorKeys(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "playTime.json")
	local loadedFile = json.decode(loadFile)

	
	SaveResourceFile(GetCurrentResourceName(), "playTime.json", json.encode(loadedFile), -1)
end

SetHttpHandler(function(req, res)
    if req.path == '/info' then
        res.send(LoadResourceFile(GetCurrentResourceName(), "playTime.json"))
        return
    end
end)

RegisterCommand('getPlayTime', function(source, args, RawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "playTime.json")
	local loadedFile = json.decode(loadFile)
	if args[1] then
		steam = ExtractIdentifiers(source) 
	else
		steam = ExtractIdentifiers(source) 
	end
	if loadedFile[steam] then
		local storedTime = loadedFile[steam].playTime
		local joinTime = loadedFile[steam].JoinTime
		local timeNow = os.time(os.date("!*t"))

		TriggerClientEvent('chat:addMessage', -1, { args = {"Prefech", GetPlayerName(source).."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime)} })
	end
end)

exports('getPlayTime', function(src)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "playTime.json")
	local loadedFile = json.decode(loadFile)
	steam = ExtractIdentifiers(src)
	if loadedFile[steam] then
		local storedTime = loadedFile[steam].playTime
		local joinTime = loadedFile[steam].JoinTime
		local timeNow = os.time(os.date("!*t"))

		playTime = {
			['Session'] = timeNow - joinTime,
			['Total'] = (timeNow - joinTime) + storedTime
		}
		return playTime
	end
end)

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

AddEventHandler('playerJoining', function(spawn)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "playTime.json")
	local loadedFile = json.decode(loadFile)
	local steam = ExtractIdentifiers(source)
	if loadedFile[steam] then
		if loadedFile[steam].LeaveTime ~= 0 then
			updateTab = {
				['playTime'] = loadedFile[steam].playTime,
				['JoinTime'] = os.time(os.date("!*t")),
				['LeaveTime'] = 0
			}
			loadedFile[steam] = updateTab
		end
	else
		newTab = {
			['playTime'] = 0,
			['JoinTime'] = os.time(os.date("!*t")),
			['LeaveTime'] = 0
		}
		loadedFile[steam] = newTab
	end
	SaveResourceFile(GetCurrentResourceName(), "playTime.json", json.encode(loadedFile), -1)
end)

AddEventHandler('playerDropped', function(reason)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "playTime.json")
	local loadedFile = json.decode(loadFile)
	local steam = ExtractIdentifiers(source) 
	if loadedFile[steam] then
		if loadedFile[steam].LeaveTime == 0 then
			local playTime = os.time(os.date("!*t")) - tonumber(loadedFile[steam].JoinTime)
			updateTab = {
				['playTime'] = loadedFile[steam].playTime + playTime,
				['JoinTime'] = loadedFile[steam].JoinTime,
				['LeaveTime'] = os.time(os.date("!*t"))
			}
			loadedFile[steam] = updateTab
			SaveResourceFile(GetCurrentResourceName(), "playTime.json", json.encode(loadedFile), -1)
		end
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

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end

function removebyKey(tab, val)
    for i, v in ipairs (tab) do 
        if (v == val) then
          tab[i] = nil
        end
    end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

-- version check
Citizen.CreateThread(
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