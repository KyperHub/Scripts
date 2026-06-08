-- دالة إظهار الإشعار المخصص لتحديثات KyperHub
local function showUpdateNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KyperHub Update!",
        Text = "A new version of KyperHub is available! Join our Discord to get the latest update: https://discord.gg/bWGz5R33YZ",
        Duration = 10, -- سيظهر الإشعار لمدة 10 ثوانٍ
        Icon = "rbxassetid://12345678" -- يمكنك استبدال هذا برابط أيقونة KyperHub الخاصة بك إذا توفرت
    })
end

-- تنفيذ الإشعار عند تشغيل السكربت
showUpdateNotification()
