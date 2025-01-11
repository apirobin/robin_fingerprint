Config = Config or {}

-- Job-Configuration
Config.AllowedJobs = {
    ["police"] = true,
    ["ambulance"] = true
}
Config.RequireJob = true

-- Discord Logs
Config.DiscordLogs = {
    PublicLogWebhook = "", -- Public-Log webhook
    AdminLogWebhook = "", -- Admin-Log webhook
    SuccessColor = 3447003, -- Color for Success
    ErrorColor = 15158332, -- Color for Failure
    Texts = {
        LogSuccessTitle = "✅ Fingerscan Erfolgreich",
        LogNoPlayerTitle = "❌ Fingerscan Fehlgeschlagen",
        LogPublicFormat = "👮 Polizist: **%s**\n🧍 Zielspieler: **%s**",
        LogAdminFormat = "👮 Polizist: **%s**\n🧍 Zielspieler: **%s**\n👮 Polizist Identifier: `%s`\n🧍 Spieler Identifier: `%s`\n👮 Polizist ID: `%d`\n🧍 Spieler ID: `%d`",
        LogNoPlayerFormat = "👮 Polizist: **%s**\n👮 Polizist Identifier: `%s`\n📌 Fehler: Kein Spieler in der Nähe gefunden!"
    }
}
