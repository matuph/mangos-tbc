/*
 * Custom Buffer NPC for CMaNGOS TBC 2.4.3
 *
 * Provides the common raid/party-style long-duration buffs through gossip.
 * Database entry: 90001
 * ScriptName: npc_buffer
 */

#include "AI/ScriptDevAI/include/sc_common.h"

namespace
{
    enum BufferActions
    {
        ACTION_BUFF_ALL = GOSSIP_ACTION_INFO_DEF + 1,
        ACTION_BUFF_INT = GOSSIP_ACTION_INFO_DEF + 2,
        ACTION_BUFF_FORT = GOSSIP_ACTION_INFO_DEF + 3,
        ACTION_BUFF_SPIRIT = GOSSIP_ACTION_INFO_DEF + 4,
        ACTION_BUFF_MOTW = GOSSIP_ACTION_INFO_DEF + 5,
        ACTION_BUFF_SHADOW = GOSSIP_ACTION_INFO_DEF + 6,
    };

    // TBC 2.4.3 max-rank single-target buffs.
    enum BufferSpells
    {
        SPELL_ARCANE_INTELLECT = 27126,
        SPELL_POWER_WORD_FORTITUDE = 25389,
        SPELL_PRAYER_OF_SPIRIT = 32999,
        SPELL_MARK_OF_THE_WILD = 26990,
        SPELL_SHADOW_PROTECTION = 25433,
    };

    void CastBufferSpell(Player* player, uint32 spellId)
    {
        if (!player)
            return;

        player->CastSpell(player, spellId, TRIGGERED_OLD_TRIGGERED);
    }

    void CastAllBuffs(Player* player)
    {
        CastBufferSpell(player, SPELL_ARCANE_INTELLECT);
        CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
        CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
        CastBufferSpell(player, SPELL_MARK_OF_THE_WILD);
        CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
    }
}

bool GossipHello_npc_buffer(Player* player, Creature* creature)
{
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Alle wichtigen Buffs", GOSSIP_SENDER_MAIN, ACTION_BUFF_ALL);
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Arkane Intelligenz", GOSSIP_SENDER_MAIN, ACTION_BUFF_INT);
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Machtwort: Seelenstärke", GOSSIP_SENDER_MAIN, ACTION_BUFF_FORT);
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Gebet der Willenskraft", GOSSIP_SENDER_MAIN, ACTION_BUFF_SPIRIT);
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Mal der Wildnis", GOSSIP_SENDER_MAIN, ACTION_BUFF_MOTW);
    player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Schattenschutz", GOSSIP_SENDER_MAIN, ACTION_BUFF_SHADOW);
    player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    return true;
}

bool GossipSelect_npc_buffer(Player* player, Creature* creature, uint32 /*sender*/, uint32 action)
{
    switch (action)
    {
        case ACTION_BUFF_ALL:
            CastAllBuffs(player);
            break;
        case ACTION_BUFF_INT:
            CastBufferSpell(player, SPELL_ARCANE_INTELLECT);
            break;
        case ACTION_BUFF_FORT:
            CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
            break;
        case ACTION_BUFF_SPIRIT:
            CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
            break;
        case ACTION_BUFF_MOTW:
            CastBufferSpell(player, SPELL_MARK_OF_THE_WILD);
            break;
        case ACTION_BUFF_SHADOW:
            CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
            break;
        default:
            break;
    }

    player->CLOSE_GOSSIP_MENU();
    return true;
}

void AddSC_npc_buffer()
{
    Script* script = new Script;
    script->Name = "npc_buffer";
    script->pGossipHello = &GossipHello_npc_buffer;
    script->pGossipSelect = &GossipSelect_npc_buffer;
    script->RegisterSelf(false);
}
