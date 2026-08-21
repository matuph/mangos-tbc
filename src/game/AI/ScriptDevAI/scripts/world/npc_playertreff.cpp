/*
 * Playertreff service NPCs for CMaNGOS TBC 2.4.3
 *
 * Entry 90010..90018 are defined in the matching database update.
 * Vendor NPCs use the normal npc_vendor system; this script handles
 * the profession-learning NPC only.
 */

#include "AI/ScriptDevAI/include/sc_common.h"

namespace
{
    enum PlayertreffActions
    {
        ACTION_ALCHEMY = GOSSIP_ACTION_INFO_DEF + 1,
        ACTION_BLACKSMITHING,
        ACTION_ENCHANTING,
        ACTION_ENGINEERING,
        ACTION_JEWELCRAFTING,
        ACTION_LEATHERWORKING,
        ACTION_TAILORING,
        ACTION_HERBALISM,
        ACTION_MINING,
        ACTION_SKINNING,
        ACTION_COOKING,
        ACTION_FISHING,
        ACTION_FIRST_AID,
    };

    // TBC 2.4.3 profession/rank learning spells.
    const uint32 Alchemy[]        = { 2259, 3101, 3464, 11611, 28596 };
    const uint32 Blacksmithing[]  = { 2018, 3100, 3538, 9785, 29844 };
    const uint32 Enchanting[]     = { 7411, 7412, 7413, 13920, 28029 };
    const uint32 Engineering[]    = { 4036, 4037, 4038, 12656, 30350 };
    const uint32 Jewelcrafting[]  = { 25229, 28894, 28895, 28897, 28899, 28901 };
    const uint32 Leatherworking[] = { 2108, 3104, 3811, 10662, 32549 };
    const uint32 Tailoring[]      = { 3908, 3909, 3910, 12180, 26790 };
    const uint32 Herbalism[]      = { 2366, 2368, 3570, 11993, 28695 };
    const uint32 Mining[]         = { 2575, 2576, 3564, 10248, 29354 };
    const uint32 Skinning[]       = { 8613, 8617, 8618, 10768, 32678 };
    const uint32 Cooking[]        = { 2550, 3102, 3413, 18260, 33359 };
    const uint32 Fishing[]        = { 7620, 7731, 7732, 18248, 33095 };
    const uint32 FirstAid[]       = { 3273, 3274, 7924, 10846, 27028 };

    template <size_t N>
    void LearnRanks(Player* player, const uint32 (&spells)[N])
    {
        for (size_t i = 0; i < N; ++i)
            player->CastSpell(player, spells[i], TRIGGERED_OLD_TRIGGERED);
    }

    void AddProfessionMenu(Player* player)
    {
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Alchemie bis 375", GOSSIP_SENDER_MAIN, ACTION_ALCHEMY);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Schmiedekunst bis 375", GOSSIP_SENDER_MAIN, ACTION_BLACKSMITHING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Verzauberkunst bis 375", GOSSIP_SENDER_MAIN, ACTION_ENCHANTING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Ingenieurskunst bis 375", GOSSIP_SENDER_MAIN, ACTION_ENGINEERING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Juwelenschleifen bis 375", GOSSIP_SENDER_MAIN, ACTION_JEWELCRAFTING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Lederverarbeitung bis 375", GOSSIP_SENDER_MAIN, ACTION_LEATHERWORKING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Schneiderei bis 375", GOSSIP_SENDER_MAIN, ACTION_TAILORING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Kräuterkunde bis 375", GOSSIP_SENDER_MAIN, ACTION_HERBALISM);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Bergbau bis 375", GOSSIP_SENDER_MAIN, ACTION_MINING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Kürschnerei bis 375", GOSSIP_SENDER_MAIN, ACTION_SKINNING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Kochen bis 375", GOSSIP_SENDER_MAIN, ACTION_COOKING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Angeln bis 375", GOSSIP_SENDER_MAIN, ACTION_FISHING);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Erste Hilfe bis 375", GOSSIP_SENDER_MAIN, ACTION_FIRST_AID);
    }
}

bool GossipHello_npc_playertreff_professions(Player* player, Creature* creature)
{
    AddProfessionMenu(player);
    player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    return true;
}

bool GossipSelect_npc_playertreff_professions(Player* player, Creature* creature, uint32 /*sender*/, uint32 action)
{
    switch (action)
    {
        case ACTION_ALCHEMY:        LearnRanks(player, Alchemy); break;
        case ACTION_BLACKSMITHING:  LearnRanks(player, Blacksmithing); break;
        case ACTION_ENCHANTING:     LearnRanks(player, Enchanting); break;
        case ACTION_ENGINEERING:    LearnRanks(player, Engineering); break;
        case ACTION_JEWELCRAFTING:  LearnRanks(player, Jewelcrafting); break;
        case ACTION_LEATHERWORKING: LearnRanks(player, Leatherworking); break;
        case ACTION_TAILORING:      LearnRanks(player, Tailoring); break;
        case ACTION_HERBALISM:      LearnRanks(player, Herbalism); break;
        case ACTION_MINING:         LearnRanks(player, Mining); break;
        case ACTION_SKINNING:       LearnRanks(player, Skinning); break;
        case ACTION_COOKING:        LearnRanks(player, Cooking); break;
        case ACTION_FISHING:        LearnRanks(player, Fishing); break;
        case ACTION_FIRST_AID:      LearnRanks(player, FirstAid); break;
        default:                    break;
    }

    player->CLOSE_GOSSIP_MENU();
    return true;
}

void AddSC_npc_playertreff()
{
    Script* script = new Script;
    script->Name = "npc_playertreff_professions";
    script->pGossipHello = &GossipHello_npc_playertreff_professions;
    script->pGossipSelect = &GossipSelect_npc_playertreff_professions;
    script->RegisterSelf(false);
}
