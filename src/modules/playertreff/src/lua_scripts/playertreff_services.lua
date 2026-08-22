local PORTAL, BUFFER, PREMIUM, WEAPONS = 90000, 90001, 90033, 90034
local PREMIUM_COST = 50000 -- five gold, in copper
local BUFFS = {27126, 25389, 32999, 26990, 26992, 25433}
local CLASS_BUFF = {
    [1] = 27140, [2] = 20217, [3] = 27140, [4] = 27140, [5] = 20217,
    [7] = 27140, [8] = 20217, [9] = 20217, [11] = 27140
}
local WEAPON_SKILLS = {
    [1]={196,197,198,199,201,202,227,264,266}, [2]={196,197,198,199,201,202},
    [3]={196,197,200,201,202,227,264,266}, [4]={196,198,201,227,266},
    [5]={198,227}, [7]={196,197,198,199,227}, [8]={201,227},
    [9]={201,227}, [11]={198,199,200,227}
}

local function close(player) player:GossipComplete() end
local function hello(event, player, creature)
    player:GossipClearMenu()
    if creature:GetEntry() == PORTAL then
        player:GossipMenuAddItem(2, "Nach Shattrath", 0, 1)
        player:GossipMenuAddItem(2, "Nach Sturmwind", 0, 2)
        player:GossipMenuAddItem(2, "Nach Orgrimmar", 0, 3)
    elseif creature:GetEntry() == WEAPONS then
        player:GossipMenuAddItem(3, "Alle fuer meine Klasse erlaubten Waffenfertigkeiten lernen", 0, 10)
    else
        player:GossipMenuAddItem(5, creature:GetEntry() == PREMIUM and "Premium-Segen (5 Gold)" or "Kostenlose Standard-Segen", 0, 20)
    end
    player:GossipSendMenu(1, creature)
    return true
end

local function selected(event, player, creature, sender, action)
    local entry = creature:GetEntry()
    if entry == PORTAL then
        if player:IsInCombat() then player:SendNotification("Im Kampf ist keine Reise moeglich."); return close(player) end
        if action == 1 then player:Teleport(530, -1863.0, 4998.0, -21.2, 2.1)
        elseif action == 2 then player:Teleport(0, -8833.0, 628.0, 94.0, 1.0)
        elseif action == 3 then player:Teleport(1, 1502.0, -4415.0, 22.0, 0.0) end
    elseif entry == WEAPONS and action == 10 then
        for _, skill in ipairs(WEAPON_SKILLS[player:GetClass()] or {}) do
            player:SetSkill(skill, 1, math.max(player:GetSkillValue(skill), 1), player:GetLevel() * 5)
        end
        player:SendNotification("Erlaubte Waffenfertigkeiten wurden freigeschaltet.")
    elseif (entry == BUFFER or entry == PREMIUM) and action == 20 then
        if entry == PREMIUM then
            if player:GetCoinage() < PREMIUM_COST then player:SendNotification("Du benoetigst 5 Gold."); return close(player) end
            player:ModifyMoney(-PREMIUM_COST)
        end
        for _, spell in ipairs(BUFFS) do player:CastSpell(player, spell, true) end
        local classSpell = CLASS_BUFF[player:GetClass()]
        if classSpell then player:CastSpell(player, classSpell, true) end
    end
    close(player)
    return true
end

for _, entry in ipairs({PORTAL, BUFFER, PREMIUM, WEAPONS}) do
    RegisterCreatureGossipEvent(entry, 1, hello)
    RegisterCreatureGossipEvent(entry, 2, selected)
end
