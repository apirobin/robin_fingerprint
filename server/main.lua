ESX = exports[“es_extended”]:getSharedObject()

function PerformScan(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.RequireJob and not Config.AllowedJobs[xPlayer.job.name] then
        TriggerClientEvent('esx:showNotification', source, Config.Texts.NoPermission)
        TriggerServerNotification(source, Config.Texts.NoPermission)
        return
    end

    local players = GetPlayers()
    local closestPlayer, closestDistance = nil, 3

    for _, playerId in pairs(players) do
        if playerId ~= source then
            local targetPed = GetPlayerPed(playerId)
            local playerCoords = GetEntityCoords(targetPed)
            local sourceCoords = GetEntityCoords(GetPlayerPed(source))

            local distance = #(sourceCoords - playerCoords)
            if distance < closestDistance then
                closestPlayer, closestDistance = playerId, distance
            end
        end
    end

    if not closestPlayer then
        TriggerServerNotification(source, Config.Texts.NoPlayerNearby)
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(closestPlayer)
    local targetName = targetPlayer.getName()
    local targetId = closestPlayer
    local targetIdentifier = targetPlayer.identifier

    TriggerServerNotification(source, (Config.Texts.ScanSuccess):format(targetName, targetId))

    local copName = xPlayer.getName()
    local copIdentifier = xPlayer.identifier
    local copId = source

    PerformHttpRequest(Config.DiscordLogs.PublicLogWebhook, function() end, 'POST', json.encode({
        username = "Fingerscanner",
        embeds = {{
            color = 3447003,
            description = (Config.DiscordLogs.LogPublicFormat):format(copName, targetName)
        }}
    }), { ['Content-Type'] = 'application/json' })

    PerformHttpRequest(Config.DiscordLogs.AdminLogWebhook, function() end, 'POST', json.encode({
        username = "Fingerscanner",
        embeds = {{
            color = 15158332,
            description = (Config.DiscordLogs.LogAdminFormat):format(copName, targetName, copIdentifier, targetIdentifier, copId, targetId)
        }}
    }), { ['Content-Type'] = 'application/json' })
end

function TriggerServerNotification(target, message)
    TriggerClientEvent('esx:showNotification', target, message)
end

if Config.UseItem then
    ESX.RegisterUsableItem(Config.Item, function(source)
        PerformScan(source)
    end)
else
    RegisterCommand(Config.CommandName, function(source)
        PerformScan(source)
    end, false)
end
