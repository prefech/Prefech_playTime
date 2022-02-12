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

SetHttpHandler(function(req, res)
    if req.path == '/info' then
		local result = MySQL.query.await('SELECT * FROM prefech_playtime', {})
		playTime = {}
		for k,v in pairs(result) do
			playTime[v.steam_hex] = {
				['playTime'] = v.playTime,
				['lastJoin'] = v.lastJoin,
				['lastLeave'] = v.lastLeave
			}
		end

        res.send(json.encode(playTime))
        return
    end
end)

RegisterCommand('getPlayTime', function(source, args, RawCommand)
	if args[1] then
		steam = ExtractIdentifiers(args[1])
	else
		steam = ExtractIdentifiers(source)
	end

	local result = MySQL.query.await('SELECT * FROM prefech_playtime WHERE steam_hex = ?', {steam})
	if result[1] ~= nil then
		local storedTime = result[1].playTime
		local joinTime = result[1].lastJoin
		local timeNow = os.time(os.date("!*t"))

		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", GetPlayerName(source).."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime)} })
	end
end)

exports('getPlayTime', function(src)
	steam = ExtractIdentifiers(src)
	local result = MySQL.query.await('SELECT * FROM prefech_playtime WHERE steam_hex = ?', {steam})
	if result[1] ~= nil then
		local storedTime = result[1].playTime
		local joinTime = result[1].lastJoin
		local timeNow = os.time(os.date("!*t"))

		playTime = {
			['Session'] = timeNow - joinTime,
			['Total'] = (timeNow - joinTime) + storedTime
		}
		return playTime
	end
end)

RegisterNetEvent('playerJoining')
AddEventHandler('playerJoining', playerJoin)

RegisterNetEvent('playerDropped')
AddEventHandler('playerDropped', playerDrop)

RegisterNetEvent('Prefech:getIdentifiers')
AddEventHandler('Prefech:getIdentifiers', function()
	steam = ExtractIdentifiers(source)
	local result = MySQL.query.await('SELECT * FROM prefech_playtime WHERE steam_hex = ?', {steam})
	if result[1] ~= nil then
		local storedTime = result[1].playTime
		local joinTime = result[1].lastJoin
		local timeNow = os.time(os.date("!*t"))

		playTime = {
			['Session'] = timeNow - joinTime,
			['Total'] = (timeNow - joinTime) + storedTime
		}
		TriggerClientEvent('Prefech:sendIdentifiers', source, playTime)
	end
end)

function playerJoin()
	local steam = ExtractIdentifiers(source)
	if steam ~= nil then
		local result = MySQL.query.await("SELECT * FROM prefech_playtime WHERE steam_hex = '?'", {steam})
		if result[1] ~= nil then
			MySQL.query.await("UPDATE prefech_playtime SET lastJoin = ?, lastLeave = 0, WHERE steam_hex = '?'", {os.time(os.date("!*t")), steam})
		else
			MySQL.query.await('INSERT INTO prefech_playtime (id, steam_hex, playTime, lastJoin, lastLeave) VALUES (NULL, ?, 0, ?, 0);', {steam, os.time(os.date("!*t"))})
		end
	else
		print("^1Prefech_playTime: Error! Player "..GetPlayerName(source).." is connected without steam and playtime will not be recorded.^0")
	end
end

function playerDrop()
	local timeNow = os.time(os.date("!*t"))
	local steam = ExtractIdentifiers(source)
	if steam ~= nil then
		local result = MySQL.query.await("SELECT * FROM prefech_playtime WHERE steam_hex = '?'", {steam})

		local result = MySQL.query.await("SELECT * FROM prefech_playtime WHERE steam_hex = '?'", {steam})
		if result[1] ~= nil then
			local playTime = timeNow - result[1].lastJoin
			print(playTime)
			MySQL.query.await("UPDATE prefech_playtime SET playTime = ?, lastLeave = ? WHERE steam_hex = '?'", {(playTime + result[1].playTime), timeNow, steam})
		end
	end
end

function ExtractIdentifiers(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
           return id
		end
    end
	return nil
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
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw then
			local v = json.decode(vRaw)
			PerformHttpRequest('https://raw.githubusercontent.com/Prefech/Prefech_playTime/master/version.json', function(code, res, headers)
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
					print('^1Prefech_playTime unable to check version^0')
				end
			end, 'GET')
		end
	end
)
