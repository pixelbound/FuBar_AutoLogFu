local Tablet = AceLibrary("Tablet-2.0")

local files = {
    icon_on = "Interface\\AddOns\\FuBar_AutoLogFu\\AutoLog_on.tga",
    icon_off = "Interface\\AddOns\\FuBar_AutoLogFu\\AutoLog_off.tga",
}

-------------------------------------
--      Namespace Declaration      --
-------------------------------------

AutoLogFu = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0", "AceHook-2.0")
AutoLogFu.hideWithoutStandby = true
AutoLogFu.hasIcon = files.icon_on
AutoLogFu:RegisterDB("AutoLogFuDB")
AutoLogFu:RegisterDefaults("profile", {
    chat_log = true,
    combat_log = false,
})
local opts = {type = "group", handler = AutoLogFu, args = {
    chat_log = {
        type = "toggle",
        name = "Chat Log",
        desc = "Log chat messages",
        order = 1,
        get = "IsChatLogged",
        set = "SetChatLogged",
    },
    combat_log = {
        type = "toggle",
        name = "Combat Log",
        desc = "Log combat messages",
        order = 1,
        get = "IsCombatLogged",
        set = "SetCombatLogged",
    },

}}
AutoLogFu:RegisterChatCommand({"/autologfu"}, opts)
AutoLogFu.OnMenuRequest = opts

---------------------------
--      Accessors        --
---------------------------

function AutoLogFu:IsChatLogged()
    return self.db.profile.chat_log
end

function AutoLogFu:SetChatLogged(v)
    if self.db.profile.chat_log ~= v then
        self.db.profile.chat_log = v
        self:Update()
    end
end

function AutoLogFu:IsCombatLogged()
    return self.db.profile.combat_log
end

function AutoLogFu:SetCombatLogged(v)
    if self.db.profile.combat_log ~= v then
        self.db.profile.combat_log = v
        self:Update()
    end
end

---------------------------
--        Methods        --
---------------------------

function AutoLogFu:OnEnable()
    if self:IsChatLogged() then
        LoggingChat(true)
    else
        LoggingChat(false)
    end
    if self:IsCombatLogged() then
        LoggingCombat(true)
    else
        LoggingCombat(false)
    end
end

function AutoLogFu:OnDisable()
    LoggingChat(false)
    LoggingCombat(false)
end

function AutoLogFu:OnClick()
    if self:IsChatLogged() then
        self:SetChatLogged(false)
    else
        self:SetChatLogged(true)
    end
end

function AutoLogFu:OnTextUpdate()
    local text = ""
    local icon = files.icon_on

    if self:IsChatLogged() and self:IsCombatLogged() then
        text = "All"
    elseif self:IsChatLogged() then
        text = "Chat"
    elseif self:IsCombatLogged() then
        text = "Combat"
    else
        text = "No log"
        icon = files.icon_off
    end

    self:SetText(text)
    self:SetIcon(icon)
end

function AutoLogFu:BoolSettingText(v)
    if v then return "On" else return "Off" end
end

function AutoLogFu:OnTooltipUpdate()
    Tablet:SetTitle("AutoLogFu")
    cat = Tablet:AddCategory("text", "Settings", "columns", 2)
    cat:AddLine("text", "Log Chat", "text2", self:BoolSettingText(self:IsChatLogged()))
    cat:AddLine("text", "Log Combat", "text2", self:BoolSettingText(self:IsCombatLogged()))
end