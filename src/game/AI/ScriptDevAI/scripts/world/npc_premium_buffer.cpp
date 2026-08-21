/*
 * Premium Buffer for CMaNGOS TBC 2.4.3
 * Entry: 90033
 * ScriptName: npc_premium_buffer
 * Cost: 5 gold
 */

#include "AI/ScriptDevAI/include/sc_common.h"

namespace
{
    enum Actions
    {
        ACTION_PREMIUM = GOSSIP_ACTION_INFO_DEF + 1,
        ACTION_STANDARD,
        ACTION_CLASS,
    };

    enum Spells
    {
        SPELL_ARCANE_INTELLECT       = 27126,
        SPELL_POWER_WORD_FORTITUDE  = 25389,
        SPELL_PRAYER_OF_SPIRIT      = 32999,
        SPELL_MARK_OF_THE_WILD      = 26990,
        SPELL_THORNS                = 26992,
        SPELL_SHADOW_PROTECTION     = 25433,
        SPELL_BLESSING_OF_MIGHT     = 27140,
        SPELL_BLESSING_OF_KINGS     = 20217,
        SPELL_RESURRECTION_SICKNESS = 15007,
    };

    // WoW money is stored in copper: 5 gold = 50,000 copper.
    static const uint32 PREMIUM_COST = 50000;

    void Buff(Player* player, uint32 spellId)
    {
        player->CastSpell(player, spellId, TRIGGERED_OLD_TRIGGERED);
    }

    void StandardBuffs(Player* player)
    {
        Buff(player, SPELL_ARCANE_INTELLECT);
        Buff(player, SPELL_POWER_WORD_FORTITUDE);
        Buff(player, SPELL_PRAYER_OF_SPIRIT);
        Buff(player, SPELL_MARK_OF_THE_WILD);
        Buff(player, SPELL_THORNS);
        Buff(player, SPELL_SHADOW_PROTECTION);
    }

    void ClassBuff(Player* player)
    {
        switch (player->getClass())
        {
            case CLASS_WARRIOR:
            case CLASS_ROGUE:
            case CLASS_HUNTER:
            case CLASS_SHAMAN:
            case CLASS_DRUID:
                Buff(player, SPELL_POWER_WORD_FORTITUDE);
                Buff(player, SPELL_PRAYER_OF_SPIRIT);
                Buff(player, SPELL_MARK_OF_THE_WILD);
                Buff(player, SPELL_THORNS);
                Buff(player, SPELL_SHADOW_PROTECTION);
                break;
            case CLASS_PALADIN:
                Buff(player, SPELL_POWER_WORD_FORTITUDE);
                Buff(player, SPELL_PRAYER_OF_SPIRIT);
                Buff(player, SPELL_MARK_OF_THE_WILD);
                Buff(player, SPELL_THORNS);
                Buff(player, SPELL_BLESSING_OF_KINGS);
                Buff(player, SPELL_BLESSING_OF_MIGHT);
                break;
            case CLASS_PRIEST:
                Buff(player, SPELL_POWER_WORD_FORTITUDE);
                Buff(player, SPELL_PRAYER_OF_SPIRIT);
                Buff(player, SPELL_SHADOW_PROTECTION);
                break;
            case CLASS_MAGE:
                Buff(player, SPELL_ARCANE_INTELLECT);
                Buff(player, SPELL_POWER_WORD_FORTITUDE);
                Buff(player, SPELL_PRAYER_OF_SPIRIT);
                break;
            case CLASS_WARLOCK:
                Buff(player, SPELL_POWER_WORD_FORTITUDE);
                Buff(player, SPELL_PRAYER_OF_SPIRIT);
                Buff(player, SPELL_SHADOW_PROTECTION);
                break;
            default:
                break;
        }
    }

    void AddMenu(Player* player)
    {
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "PREMIUM-BUFF - 5 Gold", GOSSIP_SENDER_MAIN, ACTION_PREMIUM);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Standard-Buffs", GOSSIP_SENDER_MAIN, ACTION_STANDARD);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Klassen-Buffs", GOSSIP_SENDER_MAIN, ACTION_CLASS);
    }
}

bool GossipHello_npc_premium_buffer(Player* player, Creature* creature)
{
    AddMenu(player);
    player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    return true;
}

bool GossipSelect_npc_premium_buffer(Player* player, Creature* /*creature*/, uint32 /*sender*/, uint32 action)
{
    switch (action)
    {
        case ACTION_PREMIUM:
            if (player->GetMoney() < PREMIUM_COST)
            {
                player->CLOSE_GOSSIP_MENU();
                return true;
            }

            player->ModifyMoney(-int32(PREMIUM_COST));
            StandardBuffs(player);
            ClassBuff(player);
            // TBC Resurrection Sickness.
            player->RemoveAurasDueToSpell(SPELL_RESURRECTION_SICKNESS);
            player->CLOSE_GOSSIP_MENU();
            return true;

        case ACTION_STANDARD:
            StandardBuffs(player);
            player->CLOSE_GOSSIP_MENU();
            return true;

        case ACTION_CLASS:
            ClassBuff(player);
            player->CLOSE_GOSSIP_MENU();
            return true;

        default:
            player->CLOSE_GOSSIP_MENU();
            return true;
    }
}

void AddSC_npc_premium_buffer()
{
    Script* script = new Script;
    script->Name = "npc_premium_buffer";
    script->pGossipHello = &GossipHello_npc_premium_buffer;
    script->pGossipSelect = &GossipSelect_npc_premium_buffer;
    script->RegisterSelf(false);
}
