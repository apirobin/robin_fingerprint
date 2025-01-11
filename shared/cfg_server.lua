Config = Config or {}

-- Job-Konfiguration
Config.AllowedJobs = {
    ["police"] = true,
    ["ambulance"] = true
}
Config.RequireJob = true

-- Discord-Log-Konfiguration
Config.DiscordLogs = {
    PublicLogWebhook = "https://discord.com/api/webhooks/1327587612105637888/nPxAzYm9xdxsr8gNHIsZxWBfkKSNP6uVaKcv2Unsf8rx41-ylmC-QtlZq5SYuUl4dA8L", -- Webhook für öffentliche Logs
    AdminLogWebhook = "https://discord.com/api/webhooks/1327587612105637888/nPxAzYm9xdxsr8gNHIsZxWBfkKSNP6uVaKcv2Unsf8rx41-ylmC-QtlZq5SYuUl4dA8L", -- Webhook für Admin-Logs
    SuccessColor = 3447003, -- Blau für Erfolg
    ErrorColor = 15158332, -- Rot für Fehler
    Texts = {
        LogSuccessTitle = "✅ Fingerscan Erfolgreich",
        LogNoPlayerTitle = "❌ Fingerscan Fehlgeschlagen",
        LogPublicFormat = "👮 Polizist: **%s**\n🧍 Zielspieler: **%s**",
        LogAdminFormat = "👮 Polizist: **%s**\n🧍 Zielspieler: **%s**\n👮 Polizist Identifier: `%s`\n🧍 Spieler Identifier: `%s`\n👮 Polizist ID: `%d`\n🧍 Spieler ID: `%d`",
        LogNoPlayerFormat = "👮 Polizist: **%s**\n👮 Polizist Identifier: `%s`\n📌 Fehler: Kein Spieler in der Nähe gefunden!"
    }
}
