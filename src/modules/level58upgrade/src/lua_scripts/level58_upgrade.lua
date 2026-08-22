-- ============================================================================
-- Character Upgrade NPC - Level 58
-- Eluna runtime only; all service configuration is stored in SQL.
-- SQL: sql/custom/npc_level58_upgrade.sql
-- NPC entry: 90005
-- ============================================================================

local NPC_ENTRY = 90005
local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2
local GOSSIP_SENDER = 90005
local GOSSIP_ACTION_UPGRADE = 1
local GOSSIP_TEXT_ID = 1

local Config = nil
local ItemsByClass = {}

local function LoadConfiguration()
    Config = nil
    ItemsByClass = {}

    local config = WorldDBQuery([[SELECT
        required_level,
        target_level,
        cost_copper,
        gossip_text,
        confirm_text,
        success_text,
        error_level,
        error_money,
        error_inventory
        FROM custom_level58_upgrade_config
        WHERE npc_entry = 90005
        LIMIT 1;]])

    if not config then
        print("[Level58Upgrade] ERROR: SQL configuration for NPC 90005 not found.")
        return false
    end

    Config = {
        requiredLevel = config:GetUInt32(0),
        targetLevel = config:GetUInt32(1),
        cost = config:GetUInt32(2),
        gossipText = config:GetString(3),
        confirmText = config:GetString(4),
        successText = config:GetString(5),
        errorLevel = config:GetString(6),
        errorMoney = config:GetString(7),
        errorInventory = config:GetString(8)
    }

    local items = WorldDBQuery([[SELECT class_id, item_order, item_entry
        FROM custom_level58_upgrade_items
        WHERE npc_entry = 90005
        ORDER BY class_id, item_order;]])

    if items then
        repeat
            local classId = items:GetUInt32(0)
            local itemEntry = items:GetUInt32(2)

            if not ItemsByClass[classId] then
                ItemsByClass[classId] = {}
            end

            table.insert(ItemsByClass[classId], itemEntry)
        until not items:NextRow()
    end

    local classCount = 0
    for _ in pairs(ItemsByClass) do
        classCount = classCount + 1
    end

    print("[Level58Upgrade] Loaded SQL configuration: target level " ..
        Config.targetLevel .. ", cost " .. Config.cost .. " copper, " ..
        classCount .. " class sets.")

    return true
end

local function SendUpgradeMenu(player, creature)
    player:GossipClearMenu()

    if not Config then
        player:SendNotification("Der Charakter-Aufwerter ist momentan nicht konfiguriert.")
        player:GossipComplete()
        return
    end

    if player:GetLevel() >= Config.requiredLevel then
        player:GossipMenuAddItem(0, "Kein Upgrade erforderlich - Level bereits erreicht", GOSSIP_SENDER, 0)
        player:GossipSendMenu(GOSSIP_TEXT_ID, creature)
        return
    end

    player:GossipMenuAddItem(
        4,
        Config.gossipText,
        GOSSIP_SENDER,
        GOSSIP_ACTION_UPGRADE,
        false,
        Config.confirmText,
        Config.cost
    )

    player:GossipMenuAddItem(0, "Abbrechen", GOSSIP_SENDER, 0)
    player:GossipSendMenu(GOSSIP_TEXT_ID, creature)
end

local function RollbackItems(player, addedItems)
    for _, item in ipairs(addedItems) do
        if item then
            player:RemoveItem(item, 1)
        end
    end
end

local function OnHello(event, player, creature)
    SendUpgradeMenu(player, creature)
    return true
end

local function OnSelect(event, player, creature, sender, intid, code, menuId)
    if sender ~= GOSSIP_SENDER or intid ~= GOSSIP_ACTION_UPGRADE then
        player:GossipComplete()
        return true
    end

    if not Config then
        player:SendNotification("Der Charakter-Aufwerter ist momentan nicht konfiguriert.")
        player:GossipComplete()
        return true
    end

    -- Server-side checks are mandatory. The gossip money requirement is only UI help.
    if player:GetLevel() >= Config.requiredLevel then
        player:SendNotification(Config.errorLevel)
        player:GossipComplete()
        return true
    end

    if player:GetCoinage() < Config.cost then
        player:SendNotification(Config.errorMoney)
        player:GossipComplete()
        return true
    end

    local classId = player:GetClass()
    local classItems = ItemsByClass[classId]

    if not classItems or #classItems == 0 then
        player:SendNotification("Fuer deine Klasse ist kein Dungeon-Set konfiguriert.")
        player:GossipComplete()
        return true
    end

    -- Add all items first. If one item cannot be stored, remove everything added
    -- during this transaction and do not charge the player.
    local addedItems = {}

    for _, itemEntry in ipairs(classItems) do
        local item = player:AddItem(itemEntry, 1)
        if not item then
            RollbackItems(player, addedItems)
            player:SendNotification(Config.errorInventory)
            player:GossipComplete()
            return true
        end

        table.insert(addedItems, item)
    end

    -- Everything is available now: charge and apply the level change.
    player:ModifyMoney(-Config.cost)
    player:SetLevel(Config.targetLevel)
    player:SaveToDB()

    player:SendNotification(Config.successText)
    player:GossipComplete()
    return true
end

if LoadConfiguration() then
    RegisterCreatureGossipEvent(NPC_ENTRY, GOSSIP_EVENT_ON_HELLO, OnHello)
    RegisterCreatureGossipEvent(NPC_ENTRY, GOSSIP_EVENT_ON_SELECT, OnSelect)
    print("[Level58Upgrade] Eluna script registered for NPC 90005.")
end
