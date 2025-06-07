-- Create main frame
local f = CreateFrame("Frame")

local WARNING_TEXT = "SHACKLES INCOMING!"
local WARNING_DEBUFF_TEXT = "YOU ARE SHACKLED!"
local DEBUFF_NAME = "Shackles of the Legion"

-- Create the warning frame
local warningFrame = CreateFrame("Frame", nil, UIParent)
warningFrame:SetWidth(400)
warningFrame:SetHeight(100)
warningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
warningFrame:Hide()

local warningText = warningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
warningText:SetAllPoints()
warningText:SetTextColor(1, 0, 0)
warningText:SetText(WARNING_TEXT)
warningText:SetShadowColor(0, 0, 0, 1)
warningText:SetShadowOffset(2, -2)

-- Fullscreen dim background
local glowFrame = CreateFrame("Frame", nil, UIParent)
glowFrame:SetAllPoints(UIParent)
glowFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
glowFrame:SetBackdropColor(0, 0, 0, 0.5)
glowFrame:Hide()

-- Timer
local timerFrame = CreateFrame("Frame")
timerFrame:Hide()

local elapsedTime = 0

timerFrame:SetScript("OnUpdate", function()
    elapsedTime = elapsedTime + arg1
    if elapsedTime >= 9 then
        warningFrame:Hide()
        glowFrame:Hide()
        this:Hide()
    end
end)

-- Function to show warning
local function ShowWarning(text)
    warningText:SetText(text)
    warningFrame:Show()
    glowFrame:Show()
    PlaySoundFile("Interface\\AddOns\\ShacklesAlert\\alert.wav")
    elapsedTime = 0
    timerFrame:Show()
end

-- Scan player debuffs
local function CheckPlayerDebuffs()
    for i = 1, 40 do
        local name = UnitDebuff("player", i)
        if not name then break end
        if name == DEBUFF_NAME then
            ShowWarning(WARNING_DEBUFF_TEXT)
            break
        end
    end
end

-- Event handler
f:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
f:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
f:RegisterEvent("PLAYER_AURAS_CHANGED")

f:SetScript("OnEvent", function()
    if event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_MONSTER_EMOTE" then
        local msg = arg1
        if msg and string.find(string.lower(msg), "shackles of the legion") then
            ShowWarning(WARNING_TEXT)
        end
    elseif event == "PLAYER_AURAS_CHANGED" then
        CheckPlayerDebuffs()
    end
end)

-- Slash command to test
SLASH_SHACKLESALERT1 = "/shacklesalert"
SlashCmdList["SHACKLESALERT"] = function(msg)
    if msg == "test" then
        ShowWarning("TEST WARNING")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000ShacklesAlert Commands:|r")
        DEFAULT_CHAT_FRAME:AddMessage("/shacklesalert test - Test the warning")
    end
end

-- === Astral Insight Warning ===

local astralInsightTexture = "Interface\\Icons\\Ability_Creature_Cursed_03"


-- Create frame for the Astral Insight warning
local astralWarningFrame = CreateFrame("Frame", nil, UIParent)
astralWarningFrame:SetWidth(400)
astralWarningFrame:SetHeight(100)
astralWarningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
astralWarningFrame:Hide()

local astralText = astralWarningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
astralText:SetPoint("LEFT", 60, 0)
astralText:SetTextColor(1, 1, 0)
astralText:SetText("DO NOT CAST")
astralText:SetShadowOffset(2, -2)

local astralIcon = astralWarningFrame:CreateTexture(nil, "ARTWORK")
astralIcon:SetWidth(48)
astralIcon:SetHeight(48)
astralIcon:SetPoint("LEFT", astralWarningFrame, "LEFT", 0, 0)
astralIcon:SetTexture(astralInsightTexture)

-- Create a fullscreen dark glow overlay
local astralGlow = CreateFrame("Frame", nil, UIParent)
astralGlow:SetAllPoints(UIParent)
astralGlow.texture = astralGlow:CreateTexture(nil, "BACKGROUND")
astralGlow.texture:SetAllPoints()
astralGlow.texture:SetTexture(0, 0, 0, 0.6)
astralGlow:Hide()

-- Function to check for Astral Insight debuff
local function CheckAstralInsight()
    local found = false
    for i = 0, 15 do
        local buffIndex = GetPlayerBuff(i, "HARMFUL")
        if buffIndex >= 0 then
            local texture = GetPlayerBuffTexture(buffIndex)
            if texture == astralInsightTexture then
                astralWarningFrame:Show()
                astralGlow:Show()
                astralText:SetText("DO NOT CAST")
                astralText:SetTextColor(1, 1, 0)
                astralIcon:SetTexture(texture)
                found = true
                break
            end
        end
    end

    if not found then
        astralWarningFrame:Hide()
        astralGlow:Hide()
    end
end

-- Frame to run OnUpdate checks for the debuff
local astralCheckFrame = CreateFrame("Frame")
astralCheckFrame:SetScript("OnUpdate", function()
    CheckAstralInsight()
end)
-- === Don't Move Warning ===

local dontMoveTexture = "Interface\\Icons\\Spell_Fire_Immolation"

-- Create frame for the Don't Move warning
local dontMoveWarningFrame = CreateFrame("Frame", nil, UIParent)
dontMoveWarningFrame:SetWidth(400)
dontMoveWarningFrame:SetHeight(100)
dontMoveWarningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
dontMoveWarningFrame:Hide()

local dontMoveText = dontMoveWarningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
dontMoveText:SetPoint("LEFT", 60, 0)
dontMoveText:SetTextColor(1, 0, 0)
dontMoveText:SetText("DON'T MOVE!")
dontMoveText:SetShadowOffset(2, -2)

local dontMoveIcon = dontMoveWarningFrame:CreateTexture(nil, "ARTWORK")
dontMoveIcon:SetWidth(48)
dontMoveIcon:SetHeight(48)
dontMoveIcon:SetPoint("LEFT", dontMoveWarningFrame, "LEFT", 0, 0)
dontMoveIcon:SetTexture(dontMoveTexture)

-- Create a fullscreen dark glow overlay for Don't Move warning
local dontMoveGlow = CreateFrame("Frame", nil, UIParent)
dontMoveGlow:SetAllPoints(UIParent)
dontMoveGlow.texture = dontMoveGlow:CreateTexture(nil, "BACKGROUND")
dontMoveGlow.texture:SetAllPoints()
dontMoveGlow.texture:SetTexture(0, 0, 0, 0.6)
dontMoveGlow:Hide()

-- Function to check for Don't Move debuff
-- Flag to track if sound has played
local dontMovePlaying = false

local function CheckDontMove()
    local found = false
    for i = 0, 15 do
        local buffIndex = GetPlayerBuff(i, "HARMFUL")
        if buffIndex >= 0 then
            local texture = GetPlayerBuffTexture(buffIndex)
            if texture == dontMoveTexture then
                dontMoveWarningFrame:Show()
                dontMoveGlow:Show()
                dontMoveIcon:SetTexture(texture)
                dontMoveText:SetText("DON'T MOVE!")
                dontMoveText:SetTextColor(1, 0, 0)

                if not dontMovePlaying then
                    PlaySoundFile("Interface\\AddOns\\ShacklesAlert\\alert.wav")
                    dontMovePlaying = true
                end

                found = true
                break
            end
        end
    end

    if not found then
        dontMoveWarningFrame:Hide()
        dontMoveGlow:Hide()
        dontMovePlaying = false
    end
end

-- Frame OnUpdate calling the check function
local dontMoveCheckFrame = CreateFrame("Frame")
dontMoveCheckFrame:SetScript("OnUpdate", function()
    CheckDontMove()
end)