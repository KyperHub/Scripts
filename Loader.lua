-- تعريف الـ Place IDs الخاصة بماب Life Sentence
-- يمكنك إضافة أي ID إضافي للماب في هذا الجدول لاحقاً
local ValidPlaces = {
    [13083893317] = true, -- الـ ID الذي زودتني به
    -- [1234567890] = true, -- مثال لأي Place فرعي آخر
}

-- دالة إظهار الإشعار المخصص
local function sendNotification(title, text)
    local StarterGui = game:GetService("StarterGui")
    -- نستخدم pcall لتجنب أي أخطاء في حال كان الـ Core غير متاح
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 10,
        })
    end)
end

-- التحقق من الماب
local CurrentPlaceId = game.PlaceId

if ValidPlaces[CurrentPlaceId] then
    -- إشعار التحديث أولاً
    sendNotification("KyperHub", "New update available! Join our Discord: https://discord.gg/bWGz5R33YZ")
    
    -- تحميل السكربت الرئيسي
    loadstring(game:HttpGet("https://pastebin.com/raw/0NAyS5qt"))()
else
    -- إشعار الماب غير مدعوم
    sendNotification("KyperHub", "This game is not supported.")
end
