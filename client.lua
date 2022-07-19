--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

playTime = nil
RegisterNetEvent('Prefech:sendIdentifiers')
AddEventHandler('Prefech:sendIdentifiers', function(_playTime)
	playTime = _playTime
end)

exports('getPlayTime', function(src)
	TriggerServerEvent('Prefech:getIdentifiers')
	Citizen.Wait(500)
	return playTime
end)
