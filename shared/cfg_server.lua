Config = {}

-- Job configuration
Config.AllowedJobs = {
    ["police"] = true,
    ["ambulance"] = true
}
Config.RequireJob = true

-- Log configuration
Config.DiscordLogs = {
    PublicLogWebhook = "", --This log will be seen by the LSPD highranks
    AdminLogWebhook = "", -- This log will be seen by HolyRP Administrators
    LogPublicFormat = "**Fingerscan:**\nPolizist: %s\nSpieler: %s",
    LogAdminFormat = "**Fingerscan:**\nPolizist: %s\nSpieler: %s\nPolizist Identifier: %s\nSpieler Identifier: %s\nPolizist ID: %d\nSpieler ID: %d"
}
