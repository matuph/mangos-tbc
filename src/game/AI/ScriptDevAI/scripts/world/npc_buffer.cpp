/*
 * Custom Buffer NPC for CMaNGOS TBC 2.4.3
 *
 * Standard buffs plus class-specific recommended buff presets through gossip.
 * Database entry: 90001
 * ScriptName: npc_buffer
 */

#include "AI/ScriptDevAI/include/sc_common.h"

extern void AddSC_npc_playertreff();

namespace
{
    enum BufferActions
    {
        ACTION_BUFF_ALL = GOSSIP_ACTION_INFO_DEF + 1,
        ACTION_BUFF_INT,
        ACTION_BUFF_FORT,
        ACTION_BUFF_SPIRIT,
        ACTION_BUFF_MOTW,
        ACTION_BUFF_THORNS,
        ACTION_BUFF_SHADOW,
        ACTION_CLASS_MENU,
        ACTION_CLASS_WARRIOR,
        ACTION_CLASS_PALADIN,
        ACTION_CLASS_HUNTER,
        ACTION_CLASS_ROGUE,
        ACTION_CLASS_PRIEST,
        ACTION_CLASS_SHAMAN,
        ACTION_CLASS_MAGE,
        ACTION_CLASS_WARLOCK,
        ACTION_CLASS_DRUID,
        ACTION_BACK_MAIN,
    };

    enum BufferSpells
    {
        SPELL_ARCANE_INTELLECT      = 27126,
        SPELL_POWER_WORD_FORTITUDE = 25389,
        SPELL_PRAYER_OF_SPIRIT     = 32999,
        SPELL_MARK_OF_THE_WILD     = 26990,
        SPELL_THORNS               = 26992,
        SPELL_SHADOW_PROTECTION    = 25433,
        SPELL_BLESSING_OF_MIGHT    = 27140,
        SPELL_BLESSING_OF_KINGS    = 20217,
    };

    void CastBufferSpell(Player* player, uint32 spellId)
    {
        if (player)
            player->CastSpell(player, spellId, TRIGGERED_OLD_TRIGGERED);
    }

    void CastStandardBuffs(Player* player)
    {
        CastBufferSpell(player, SPELL_ARCANE_INTELLECT);
        CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
        CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
        CastBufferSpell(player, SPELL_MARK_OF_THE_WILD);
        CastBufferSpell(player, SPELL_THORNS);
        CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
    }

    void CastClassBuffs(Player* player, uint32 classId)
    {
        if (!player)
            return;

        switch (classId)
        {
            case CLASS_WARRIOR:
            case CLASS_ROGUE:
            case CLASS_HUNTER:
            case CLASS_SHAMAN:
            case CLASS_DRUID:
                CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
                CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
                CastBufferSpell(player, SPELL_MARK_OF_THE_WILD);
                CastBufferSpell(player, SPELL_THORNS);
                CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
                break;
            case CLASS_PALADIN:
                CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
                CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
                CastBufferSpell(player, SPELL_MARK_OF_THE_WILD);
                CastBufferSpell(player, SPELL_THORNS);
                CastBufferSpell(player, SPELL_BLESSING_OF_KINGS);
                CastBufferSpell(player, SPELL_BLESSING_OF_MIGHT);
                break;
            case CLASS_PRIEST:
                CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
                CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
                CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
                break;
            case CLASS_MAGE:
                CastBufferSpell(player, SPELL_ARCANE_INTELLECT);
                CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
                CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
                break;
            case CLASS_WARLOCK:
                CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE);
                CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT);
                CastBufferSpell(player, SPELL_SHADOW_PROTECTION);
                break;
        }
    }

    void AddMainMenu(Player* player)
    {
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Standard-Buffs", GOSSIP_SENDER_MAIN, ACTION_BUFF_ALL);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Klassen-Buff-Menue", GOSSIP_SENDER_MAIN, ACTION_CLASS_MENU);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Arkane Intelligenz", GOSSIP_SENDER_MAIN, ACTION_BUFF_INT);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Machtwort: Seelenstaerke", GOSSIP_SENDER_MAIN, ACTION_BUFF_FORT);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Gebet der Willenskraft", GOSSIP_SENDER_MAIN, ACTION_BUFF_SPIRIT);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Mal der Wildnis", GOSSIP_SENDER_MAIN, ACTION_BUFF_MOTW);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Dornen", GOSSIP_SENDER_MAIN, ACTION_BUFF_THORNS);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Schattenschutz", GOSSIP_SENDER_MAIN, ACTION_BUFF_SHADOW);
    }

    void AddClassMenu(Player* player)
    {
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Krieger", GOSSIP_SENDER_MAIN, ACTION_CLASS_WARRIOR);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Paladin", GOSSIP_SENDER_MAIN, ACTION_CLASS_PALADIN);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Jager", GOSSIP_SENDER_MAIN, ACTION_CLASS_HUNTER);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Schurke", GOSSIP_SENDER_MAIN, ACTION_CLASS_ROGUE);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Priester", GOSSIP_SENDER_MAIN, ACTION_CLASS_PRIEST);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Schamane", GOSSIP_SENDER_MAIN, ACTION_CLASS_SHAMAN);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Magier", GOSSIP_SENDER_MAIN, ACTION_CLASS_MAGE);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Hexenmeister", GOSSIP_SENDER_MAIN, ACTION_CLASS_WARLOCK);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Druide", GOSSIP_SENDER_MAIN, ACTION_CLASS_DRUID);
        player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "Zurueck", GOSSIP_SENDER_MAIN, ACTION_BACK_MAIN);
    }
}

bool GossipHello_npc_buffer(Player* player, Creature* creature)
{
    AddMainMenu(player);
    player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
    return true;
}

bool GossipSelect_npc_buffer(Player* player, Creature* creature, uint32 /*sender*/, uint32 action)
{
    switch (action)
    {
        case ACTION_BUFF_ALL:   CastStandardBuffs(player); break;
        case ACTION_BUFF_INT:   CastBufferSpell(player, SPELL_ARCANE_INTELLECT); break;
        case ACTION_BUFF_FORT:  CastBufferSpell(player, SPELL_POWER_WORD_FORTITUDE); break;
        case ACTION_BUFF_SPIRIT:CastBufferSpell(player, SPELL_PRAYER_OF_SPIRIT); break;
        case ACTION_BUFF_MOTW:  CastBufferSpell(player, SPELL_MARK_OF_THE_WILD); break;
        case ACTION_BUFF_THORNS:CastBufferSpell(player, SPELL_THORNS); break;
        case ACTION_BUFF_SHADOW:CastBufferSpell(player, SPELL_SHADOW_PROTECTION); break;
        case ACTION_CLASS_MENU:
            AddClassMenu(player);
            player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
            return true;
        case ACTION_CLASS_WARRIOR:   CastClassBuffs(player, CLASS_WARRIOR); break;
        case ACTION_CLASS_PALADIN:   CastClassBuffs(player, CLASS_PALADIN); break;
        case ACTION_CLASS_HUNTER:    CastClassBuffs(player, CLASS_HUNTER); break;
        case ACTION_CLASS_ROGUE:     CastClassBuffs(player, CLASS_ROGUE); break;
        case ACTION_CLASS_PRIEST:    CastClassBuffs(player, CLASS_PRIEST); break;
        case ACTION_CLASS_SHAMAN:    CastClassBuffs(player, CLASS_SHAMAN); break;
        case ACTION_CLASS_MAGE:      CastClassBuffs(player, CLASS_MAGE); break;
        case ACTION_CLASS_WARLOCK:   CastClassBuffs(player, CLASS_WARLOCK); break;
        case ACTION_CLASS_DRUID:     CastClassBuffs(player, CLASS_DRUID); break;
        case ACTION_BACK_MAIN:
            AddMainMenu(player);
            player->SEND_GOSSIP_MENU(907, creature->GetObjectGuid());
            return true;
        default: break;
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

    // Keep the Playertreff services in the same custom-script registration path.
    AddSC_npc_playertreff();
}
