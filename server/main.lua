ESX = exports["es_extended"]:getSharedObject()

-- Config laden
Config = Config or {}

-- Laden der shared Config-Dateien
local clientConfig = LoadResourceFile(GetCurrentResourceName(), "shared/cfg_client.lua")
local serverConfig = LoadResourceFile(GetCurrentResourceName(), "shared/cfg_server.lua")

if clientConfig then
    local clientChunk = assert(load(clientConfig))
    clientChunk()
end

if serverConfig then
    local serverChunk = assert(load(serverConfig))
    serverChunk()
end

-- Spieler benachrichtigen
function NotifyPlayer(target, message)
    TriggerClientEvent('esx:showNotification', target, message)
end

-- Spieler in der Nähe finden
function GetClosestPlayer(source, maxDistance)
    local players = GetPlayers()
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local closestPlayer, closestDistance = nil, maxDistance

    for _, playerId in ipairs(players) do
        if tonumber(playerId) ~= tonumber(source) then -- Spieler darf nicht sich selbst sein
            local playerPed = GetPlayerPed(playerId)
            if DoesEntityExist(playerPed) then -- Sicherstellen, dass der Ped existiert
                local playerCoords = GetEntityCoords(playerPed)
                local distance = #(sourceCoords - playerCoords)
                if distance < closestDistance then
                    closestPlayer, closestDistance = playerId, distance
                end
            end
        end
    end

    return closestPlayer, closestDistance
end

-- Logs an Discord senden
function SendDiscordLog(webhook, title, description, color)
    if webhook and webhook ~= "" then
        PerformHttpRequest(webhook, function() end, 'POST', json.encode({
            username = "Fingerscanner",
            embeds = {{
                title = title, -- Titel des Logs
                description = description, -- Beschreibung des Logs
                color = color or 3447003, -- Farbe des Logs (Standard: Blau)
                author = {
                    name = "Fingerscanner System",
                    icon_url = "https://cdn.discordapp.com/avatars/907594318674526230/e07e7ba39a38e11211f0762634bf9033?size=1024"
                },
                thumbnail = {
                    url = "https://cdn.discordapp.com/avatars/907594318674526230/e07e7ba39a38e11211f0762634bf9033?size=1024"
                },
                footer = {
                    text = "Fingerscanner-Protokoll",
                    icon_url = "https://cdn.discordapp.com/avatars/907594318674526230/e07e7ba39a38e11211f0762634bf9033?size=1024"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") -- UTC-Zeit für Konsistenz
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end

-- Hauptfunktion für den Fingerscan
function PerformScan(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local copName = xPlayer.getName()
    local copIdentifier = xPlayer.identifier

    -- Berechtigungsprüfung
    if Config.RequireJob and not Config.AllowedJobs[xPlayer.job.name] then
        NotifyPlayer(source, Config.Texts.NoPermission)
        return
    end

    -- Spieler in der Nähe finden
    local closestPlayer, closestDistance = GetClosestPlayer(source, 3)
    if not closestPlayer then -- Kein Spieler in der Nähe
        NotifyPlayer(source, Config.Texts.NoPlayerNearby)
        SendDiscordLog(Config.DiscordLogs.AdminLogWebhook, Config.DiscordLogs.Texts.LogNoPlayerTitle, 
            (Config.DiscordLogs.Texts.LogNoPlayerFormat):format(copName, copIdentifier), Config.DiscordLogs.ErrorColor)
        return
    end

    -- Zielspieler-Daten abrufen
    local targetPlayer = ESX.GetPlayerFromId(closestPlayer)
    if not targetPlayer then -- Ungültiger Spieler
        NotifyPlayer(source, Config.Texts.ScanFailed)
        return
    end

    -- Daten des Zielspielers
    local targetName = targetPlayer.getName()
    local targetIdentifier = targetPlayer.identifier

    -- Erfolgsmeldung an den Spieler
    NotifyPlayer(source, (Config.Texts.ScanSuccess):format(targetName, closestPlayer))

    -- Logs senden
    SendDiscordLog(Config.DiscordLogs.PublicLogWebhook, Config.DiscordLogs.Texts.LogSuccessTitle, 
        (Config.DiscordLogs.Texts.LogPublicFormat):format(copName, targetName), Config.DiscordLogs.SuccessColor)
    
    SendDiscordLog(Config.DiscordLogs.AdminLogWebhook, Config.DiscordLogs.Texts.LogSuccessTitle, 
        (Config.DiscordLogs.Texts.LogAdminFormat):format(copName, targetName, copIdentifier, targetIdentifier, source, closestPlayer), 
        Config.DiscordLogs.SuccessColor)
end

-- Command oder Item registrieren
if Config.UseItem then
    ESX.RegisterUsableItem(Config.Item, function(source)
        PerformScan(source)
    end)
else
    RegisterCommand(Config.CommandName, function(source)
        PerformScan(source)
    end, false)
end
