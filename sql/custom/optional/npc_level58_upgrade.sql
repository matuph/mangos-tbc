-- ============================================================================
-- OPTIONAL CUSTOM: Character Upgrade NPC - Level 58
-- CMaNGOS TBC 2.4.3 + Eluna
--
-- This file is OPTIONAL and is NOT part of the default TBC database.
-- Execute it manually only if the Level 58 Upgrade NPC is wanted.
--
-- Runtime logic:
--   lua_scripts/npc_level58_upgrade.lua
--
-- NPC entry: 90005
-- Cost:      500 Gold
-- Target:    Level 58
-- ============================================================================

-- ---------------------------------------------------------------------------
-- NPC
-- ---------------------------------------------------------------------------
DELETE FROM creature_template WHERE entry = 90005;

INSERT INTO creature_template
    (entry, modelid1, modelid2, modelid3, modelid4,
     name, subname, minlevel, maxlevel, faction, npcflag,
     speed_walk, speed_run, scale, rank, unit_flags, type, type_flags,
     flags_extra, ScriptName)
VALUES
    (90005, 1960, 0, 0, 0,
     'Charakter-Aufwerter',
     'Level 58 / Ausruestung / 500 Gold',
     60, 60, 35, 1,
     1.0, 1.14286, 1.0, 0, 0, 7, 0,
     0, '');

-- ---------------------------------------------------------------------------
-- SERVICE CONFIGURATION
-- All changeable settings are stored here.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS custom_level58_upgrade_config
(
    npc_entry       INT UNSIGNED NOT NULL,
    required_level  TINYINT UNSIGNED NOT NULL,
    target_level    TINYINT UNSIGNED NOT NULL,
    cost_copper     INT UNSIGNED NOT NULL,
    gossip_text     VARCHAR(255) NOT NULL,
    confirm_text    VARCHAR(255) NOT NULL,
    success_text    VARCHAR(255) NOT NULL,
    error_level     VARCHAR(255) NOT NULL,
    error_money     VARCHAR(255) NOT NULL,
    error_inventory VARCHAR(255) NOT NULL,
    PRIMARY KEY (npc_entry)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DELETE FROM custom_level58_upgrade_config WHERE npc_entry = 90005;

INSERT INTO custom_level58_upgrade_config
    (npc_entry, required_level, target_level, cost_copper,
     gossip_text, confirm_text, success_text,
     error_level, error_money, error_inventory)
VALUES
    (90005, 58, 58, 5000000,
     'Charakter auf Level 58 aufwerten - Kosten: 500 Gold',
     'Bist du sicher? Dein Charakter wird auf Level 58 gesetzt und erhaelt das passende Dungeon-Set 1. Kosten: 500 Gold.',
     'Charakter-Upgrade abgeschlossen: Level 58 und passendes Dungeon-Set 1 erhalten.',
     'Dein Charakter ist bereits Level 58 oder hoeher.',
     'Du benoetigst 500 Gold fuer das Charakter-Upgrade.',
     'Dein Inventar hat nicht genug Platz fuer das vollstaendige Dungeon-Set. Es wurde nichts berechnet.');

-- ---------------------------------------------------------------------------
-- CLASS -> DUNGEON SET 1 ITEMS
-- TBC class IDs:
--   1 Warrior, 2 Paladin, 3 Hunter, 4 Rogue, 5 Priest,
--   7 Shaman, 8 Mage, 9 Warlock, 11 Druid
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS custom_level58_upgrade_items
(
    npc_entry   INT UNSIGNED NOT NULL,
    class_id    TINYINT UNSIGNED NOT NULL,
    item_order  TINYINT UNSIGNED NOT NULL,
    item_entry  INT UNSIGNED NOT NULL,
    PRIMARY KEY (npc_entry, class_id, item_order),
    KEY idx_upgrade_items_class (npc_entry, class_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DELETE FROM custom_level58_upgrade_items WHERE npc_entry = 90005;

INSERT INTO custom_level58_upgrade_items
    (npc_entry, class_id, item_order, item_entry)
VALUES
    -- Warrior - Valor
    (90005, 1, 1, 16730),
    (90005, 1, 2, 16731),
    (90005, 1, 3, 16732),
    (90005, 1, 4, 16733),
    (90005, 1, 5, 16734),
    (90005, 1, 6, 16735),
    (90005, 1, 7, 16736),
    (90005, 1, 8, 16737),

    -- Paladin - Lightforge
    (90005, 2, 1, 16722),
    (90005, 2, 2, 16723),
    (90005, 2, 3, 16724),
    (90005, 2, 4, 16725),
    (90005, 2, 5, 16726),
    (90005, 2, 6, 16727),
    (90005, 2, 7, 16728),
    (90005, 2, 8, 16729),

    -- Hunter - Beaststalker
    (90005, 3, 1, 16674),
    (90005, 3, 2, 16675),
    (90005, 3, 3, 16676),
    (90005, 3, 4, 16677),
    (90005, 3, 5, 16678),
    (90005, 3, 6, 16679),
    (90005, 3, 7, 16680),
    (90005, 3, 8, 16681),

    -- Rogue - Shadowcraft
    (90005, 4, 1, 16707),
    (90005, 4, 2, 16708),
    (90005, 4, 3, 16709),
    (90005, 4, 4, 16710),
    (90005, 4, 5, 16711),
    (90005, 4, 6, 16712),
    (90005, 4, 7, 16713),
    (90005, 4, 8, 16721),

    -- Priest - Devout
    (90005, 5, 1, 16690),
    (90005, 5, 2, 16691),
    (90005, 5, 3, 16692),
    (90005, 5, 4, 16693),
    (90005, 5, 5, 16694),
    (90005, 5, 6, 16695),
    (90005, 5, 7, 16696),
    (90005, 5, 8, 16697),

    -- Shaman - The Elements
    (90005, 7, 1, 16666),
    (90005, 7, 2, 16667),
    (90005, 7, 3, 16668),
    (90005, 7, 4, 16669),
    (90005, 7, 5, 16670),
    (90005, 7, 6, 16671),
    (90005, 7, 7, 16672),
    (90005, 7, 8, 16673),

    -- Mage - Magister
    (90005, 8, 1, 16682),
    (90005, 8, 2, 16683),
    (90005, 8, 3, 16684),
    (90005, 8, 4, 16685),
    (90005, 8, 5, 16686),
    (90005, 8, 6, 16687),
    (90005, 8, 7, 16688),
    (90005, 8, 8, 16689),

    -- Warlock - Dreadmist
    (90005, 9, 1, 16698),
    (90005, 9, 2, 16699),
    (90005, 9, 3, 16700),
    (90005, 9, 4, 16701),
    (90005, 9, 5, 16702),
    (90005, 9, 6, 16703),
    (90005, 9, 7, 16704),
    (90005, 9, 8, 16705),

    -- Druid - Wildheart
    (90005, 11, 1, 16706),
    (90005, 11, 2, 16714),
    (90005, 11, 3, 16715),
    (90005, 11, 4, 16716),
    (90005, 11, 5, 16717),
    (90005, 11, 6, 16718),
    (90005, 11, 7, 16719),
    (90005, 11, 8, 16720);

-- ============================================================================
-- END OPTIONAL CUSTOM SQL
-- ============================================================================
