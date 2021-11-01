--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #             Prefech_playTime By Prefech 31-10-2021                #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

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
