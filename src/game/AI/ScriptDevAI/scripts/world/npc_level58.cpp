/*
 * Character Upgrade NPC for CMaNGOS TBC 2.4.3
 *
 * Upgrade service:
 *   - character level 58
 *   - class appropriate Dungeon Set 1 starter armor
 *   - costs 500 gold
 *
 * Entry: 90005
 * ScriptName: npc_level58_upgrade
 */

#include "AI/ScriptDevAI/include/sc_common.h"

namespace
{
    enum UpgradeActions
    {
        ACTION_UPGRADE = GOSSIP_ACTION_INFO_DEF + 1,
    };

    // WoW money is stored in copper. 500 gold = 5,000,000 copper.
    static const uint32 UPGRADE_COST = 5000000;
    static const uint32 UPGRADE_LEVEL = 58;

    // Classic Dungeon Set 1 / Tier 0 armor, one set for each TBC class.
    static const uint32 WarriorSet[] = { 16730, 16731, 16732, 16733, 16734, 16735, 16736, 16737 };
    static const uint32 PaladinSet[] = { 16722, 16723, 16724, 16725, 16726, 16727, 16728, 16729 };
    static const uint32 HunterSet[]  = { 16674, 16675, 16676, 16677, 16678, 16679, 16680, 16681 };
    static const uint32 RogueSet[]   = { 16707, 16708, 16709, 16710, 16711, 16712, 16713, 16721 };
    static const uint32 PriestSet[]  = { 16690, 16691, 16692, 16693, 16694, 16695, 16696, 16697 };
    static const uint32 ShamanSet[]  = { 16666, 16667, 16668, 16669, 16670, 16671, 16672, 16673 };
    static const uint32 MageSet[]    = { 16682, 16683, 16684, 16685, 16686, 16687, 16688, 16689 };
    static const uint32 WarlockSet[] = { 16698, 16699, 16700, 16701, 16702, 16703, 16704, 16705 };
    static const uint32 DruidSet[]   = { 16706, 16714, 16715, 16716, 16717, 16718, 16719, 16720 };

    template <size_t N>
    void GiveArmorSet(Player* player, const uint32 (&items)[N])
    {
        for (size_t i = 0; i < N; ++i)
        {
            if (Item* item = player->StoreNewItemInInventorySlot(items[i], 1))
                player->SendNewItem(item, 1, true, false);
        }
    }

    void GiveClassArmor(Player* player)
    {
        switch (player->getClass())
        {
            case CLASS_WARRIOR: GiveArmorSet(player, WarriorSet); break;
            case CLASS_PALADIN: GiveArmorSet(player, PaladinSet); break;
            case CLASS_HUNTER:  GiveArmorSet(player, HunterSet); break;
            case CLASS_ROGUE:   GiveArmorSet(player, RogueSet); break;
            case CLASS_PRIEST:  GiveArmorSet(player, PriestSet); break;
            case CLASS_SHAMAN:  GiveArmorSet(player, ShamanSet); break;
            case CLASS_MAGE:    GiveArmorSet(player, MageSet); break;
            case CLASS_WARLOCK: GiveArmorSet(player, WarlockSet); break;
            case CLASS_DRUID:   GiveArmorSet(player, DruidSet); break;
            default: break;
        }
    }

    void AddUpgradeMenu(Player* player)
    {
        player->ADD_GOSSIP_ITEM(
            GOSSIP_ICON_TRAINER,
            "Level 58 Upgrade - 500 Gold",
            GOSSIP_SENDER_MAIN,
            ACTION_UPGRADE);
    }
}

bool GossipHello_npc_level58_upgrade(Player* player, Creature* creature)
{
    if (player->GetLevel() < UPGRADE_LEVEL)
    {
        AddUpgradeMenu(player);
        player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    }
    else
    {
        player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    }

    return true;
}

bool GossipSelect_npc_level58_upgrade(Player* player, Creature* /*creature*/, uint32 /*sender*/, uint32 action)
{
    if (action != ACTION_UPGRADE)
    {
        player->CLOSE_GOSSIP_MENU();
        return true;
    }

    // Upgrade is only available below level 58.
    if (player->GetLevel() >= UPGRADE_LEVEL)
    {
        player->SendNotification("Dein Charakter ist bereits Level 58 oder hoeher.");
        player->CLOSE_GOSSIP_MENU();
        return true;
    }

    // Do not charge the player unless enough money is available.
    if (player->GetMoney() < UPGRADE_COST)
    {
        player->SendNotification("Du benoetigst 500 Gold fuer das Charakter-Upgrade.");
        player->CLOSE_GOSSIP_MENU();
        return true;
    }

    // Charge exactly 500 gold before granting the upgrade.
    player->ModifyMoney(-static_cast<int32>(UPGRADE_COST));

    // CMaNGOS handles the normal level-dependent player values through SetLevel.
    player->SetLevel(UPGRADE_LEVEL);

    // Give the class appropriate Dungeon Set 1 starter armor.
    GiveClassArmor(player);

    player->SendNotification("Charakter-Upgrade abgeschlossen: Level 58 und passende Dungeon-Ruestung erhalten.");
    player->CLOSE_GOSSIP_MENU();
    return true;
}

void AddSC_npc_level58_upgrade()
{
    Script* script = new Script;
    script->Name = "npc_level58_upgrade";
    script->pGossipHello = &GossipHello_npc_level58_upgrade;
    script->pGossipSelect = &GossipSelect_npc_level58_upgrade;
    script->RegisterSelf(false);
}
