-- CMaNGOS TBC 2.4.3 - Playertreff
-- Builds on 9001_npc_buffer.sql.
-- NPCs are intentionally NOT spawned automatically.
-- Use .npc add <entry> at your desired Playertreff location.

SET @MODEL := 2240;

-- ------------------------------------------------------------
-- NPC entries
-- ------------------------------------------------------------
-- 90010 Dungeon-Set 1
-- 90011 Dungeon-Set 2
-- 90012 Dungeon-Set 3
-- 90013 Ruestungsmeister
-- 90014 Waffenmeister
-- 90015 Juwelier (Edelsteine/Ringe/Schmuck)
-- 90016 Taschenhaendler
-- 90017 Mount-Haendler
-- 90018 Gildenbankier
-- 90019 Berufsmeister
-- 90020 Alchemie-Materialien
-- 90021 Schmiedekunst-Materialien
-- 90022 Verzauberkunst-Materialien
-- 90023 Ingenieurskunst-Materialien
-- 90024 Juwelenschleifen-Materialien
-- 90025 Lederverarbeitung-Materialien
-- 90026 Schneiderei-Materialien
-- 90027 Kraeuterkunde-Materialien
-- 90028 Bergbau-Materialien
-- 90029 Kuerschnerei-Materialien
-- 90030 Kochen-Materialien
-- 90031 Angeln-Materialien
-- 90032 Erste-Hilfe-Materialien

DELETE FROM `npc_vendor` WHERE `entry` BETWEEN 90010 AND 90017 OR `entry` BETWEEN 90020 AND 90032;
DELETE FROM `creature_template` WHERE `entry` BETWEEN 90010 AND 90032;

/* Legacy-layout reference, intentionally inactive on the current TBC-DB schema.
-- Vendor / service NPC templates. npcflag 2 = vendor, 8192 = banker.
INSERT INTO `creature_template`
(`entry`,`heroic_entry`,`modelid_A`,`modelid_A2`,`modelid_H`,`modelid_H2`,`name`,`minlevel`,`maxlevel`,`minhealth`,`maxhealth`,`minmana`,`maxmana`,`armor`,`faction_A`,`faction_H`,`npcflag`,`speed`,`scale`,`rank`,`mindmg`,`maxdmg`,`dmgschool`,`attackpower`,`baseattacktime`,`rangeattacktime`,`unit_flags`,`dynamicflags`,`family`,`trainer_type`,`trainer_spell`,`class`,`race`,`minrangedmg`,`maxrangedmg`,`rangedattackpower`,`type`,`type_flags`,`lootid`,`pickpocketloot`,`skinloot`,`resistance1`,`resistance2`,`resistance3`,`resistance4`,`resistance5`,`resistance6`,`spell1`,`spell2`,`spell3`,`spell4`,`PetSpellDataId`,`mingold`,`maxgold`,`AIName`,`MovementType`,`InhabitType`,`RacialLeader`,`RegenHealth`,`equipment_id`,`mechanic_immune_mask`,`flags_extra`,`ScriptName`)
VALUES
(90010,0,@MODEL,0,@MODEL,0,'Dungeonmeister I',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90011,0,@MODEL,0,@MODEL,0,'Dungeonmeister II',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90012,0,@MODEL,0,@MODEL,0,'Dungeonmeister III',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90013,0,@MODEL,0,@MODEL,0,'Ruestungsmeister',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90014,0,@MODEL,0,@MODEL,0,'Waffenmeister',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90015,0,@MODEL,0,@MODEL,0,'Juwelier',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90016,0,@MODEL,0,@MODEL,0,'Taschenhaendler',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90017,0,@MODEL,0,@MODEL,0,'Mount-Haendler',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90018,0,@MODEL,0,@MODEL,0,'Gildenbankier',70,70,10000,10000,0,0,1000,35,35,8192,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90019,0,@MODEL,0,@MODEL,0,'Berufsmeister',70,70,10000,10000,0,0,1000,35,35,1,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,'npc_playertreff_professions'),
(90020,0,@MODEL,0,@MODEL,0,'Alchemie-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90021,0,@MODEL,0,@MODEL,0,'Schmiedekunst-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90022,0,@MODEL,0,@MODEL,0,'Verzauberkunst-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90023,0,@MODEL,0,@MODEL,0,'Ingenieurskunst-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90024,0,@MODEL,0,@MODEL,0,'Juwelenschleifen-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90025,0,@MODEL,0,@MODEL,0,'Lederverarbeitung-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90026,0,@MODEL,0,@MODEL,0,'Schneiderei-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90027,0,@MODEL,0,@MODEL,0,'Kraeuterkunde-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90028,0,@MODEL,0,@MODEL,0,'Bergbau-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90029,0,@MODEL,0,@MODEL,0,'Kurschnerei-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90030,0,@MODEL,0,@MODEL,0,'Kochen-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90031,0,@MODEL,0,@MODEL,0,'Angeln-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,''),
(90032,0,@MODEL,0,@MODEL,0,'Erste-Hilfe-Materialien',70,70,10000,10000,0,0,1000,35,35,2,1,1,0,1,2,0,0,2000,2000,0,0,0,0,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,0,1,0,0,0,'');

*/

DROP PROCEDURE IF EXISTS `pt_seed_npc`;
DELIMITER //
CREATE PROCEDURE `pt_seed_npc`(IN new_entry INT UNSIGNED, IN new_name VARCHAR(100), IN new_flags INT UNSIGNED)
BEGIN
  DROP TEMPORARY TABLE IF EXISTS `pt_seed`;
  CREATE TEMPORARY TABLE `pt_seed` LIKE `creature_template`;
  INSERT INTO `pt_seed` SELECT * FROM `creature_template` WHERE `Entry`=1;
  UPDATE `pt_seed` SET `Entry`=new_entry, `Name`=new_name, `SubName`='Playertreff',
    `MinLevel`=70, `MaxLevel`=70, `Faction`=35, `NpcFlags`=new_flags,
    `TrainerType`=0, `TrainerSpell`=0, `TrainerClass`=0, `TrainerRace`=0,
    `TrainerTemplateId`=0, `VendorTemplateId`=0, `GossipMenuId`=0, `ScriptName`='';
  INSERT INTO `creature_template` SELECT * FROM `pt_seed`;
END//
DELIMITER ;
CALL `pt_seed_npc`(90010,'Dungeonmeister I',2);
CALL `pt_seed_npc`(90011,'Dungeonmeister II',2);
CALL `pt_seed_npc`(90012,'Dungeonmeister III',2);
CALL `pt_seed_npc`(90013,'Ruestungsmeister',2);
CALL `pt_seed_npc`(90014,'Waffenmeister',2);
CALL `pt_seed_npc`(90015,'Juwelier',2);
CALL `pt_seed_npc`(90016,'Taschenhaendler',2);
CALL `pt_seed_npc`(90017,'Mount-Haendler',2);
CALL `pt_seed_npc`(90018,'Gildenbankier',8388608);
CALL `pt_seed_npc`(90019,'Berufsmeister',1);
CALL `pt_seed_npc`(90020,'Alchemie-Materialien',2);
CALL `pt_seed_npc`(90021,'Schmiedekunst-Materialien',2);
CALL `pt_seed_npc`(90022,'Verzauberkunst-Materialien',2);
CALL `pt_seed_npc`(90023,'Ingenieurskunst-Materialien',2);
CALL `pt_seed_npc`(90024,'Juwelenschleifen-Materialien',2);
CALL `pt_seed_npc`(90025,'Lederverarbeitung-Materialien',2);
CALL `pt_seed_npc`(90026,'Schneiderei-Materialien',2);
CALL `pt_seed_npc`(90027,'Kraeuterkunde-Materialien',2);
CALL `pt_seed_npc`(90028,'Bergbau-Materialien',2);
CALL `pt_seed_npc`(90029,'Kuerschnerei-Materialien',2);
CALL `pt_seed_npc`(90030,'Kochen-Materialien',2);
CALL `pt_seed_npc`(90031,'Angeln-Materialien',2);
CALL `pt_seed_npc`(90032,'Erste-Hilfe-Materialien',2);
DROP PROCEDURE `pt_seed_npc`;

-- ------------------------------------------------------------
-- Ruestung: good green/blue TBC gear from level 1 to 70.
-- Class restrictions remain enforced by item_template.
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90013, 0, `entry`, 0, 0, 0
FROM `item_template`
WHERE `class` = 4 AND `Quality` IN (2,3) AND `RequiredLevel` BETWEEN 1 AND 70
  AND `InventoryType` IN (1,3,5,6,7,8,9,10,11,16,20)
ORDER BY `ItemLevel`, `entry` LIMIT 250;

-- ------------------------------------------------------------
-- Waffen: green/blue weapons from level 1 to 70.
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90014, 0, `entry`, 0, 0, 0
FROM `item_template`
WHERE `class` = 2 AND `Quality` IN (2,3) AND `RequiredLevel` BETWEEN 1 AND 70
ORDER BY `ItemLevel`, `entry` LIMIT 250;

-- ------------------------------------------------------------
-- Dungeon Set 1 / 2 / 3. Names are taken from TBC item data;
-- missing names are simply ignored, making the update safe across DB revisions.
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90010, 0, `entry`, 0, 0, 0 FROM `item_template`
WHERE `Quality` >= 3 AND (`name` LIKE 'Devout %' OR `name` LIKE 'Dreadmist %' OR `name` LIKE 'Magister%'
 OR `name` LIKE 'Wildheart %' OR `name` LIKE 'Shadowcraft %' OR `name` LIKE 'Beaststalker %'
 OR `name` LIKE 'Lightforge %' OR `name` LIKE 'Valor %') ORDER BY `entry`;

INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90011, 0, `entry`, 0, 0, 0 FROM `item_template`
WHERE `Quality` >= 3 AND (`name` LIKE 'Deathmist %' OR `name` LIKE 'Sorcerer%'
 OR `name` LIKE 'Soulforge %' OR `name` LIKE 'Heroism %' OR `name` LIKE 'Darkmantle %'
 OR `name` LIKE 'Beast Lord %' OR `name` LIKE 'Feralheart %') ORDER BY `entry`;

INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90012, 0, `entry`, 0, 0, 0 FROM `item_template`
WHERE `Quality` >= 3 AND (`name` LIKE 'Incanter%'
 OR `name` LIKE 'Doomplate %' OR `name` LIKE 'Bold %' OR `name` LIKE 'Hallowed %'
 OR `name` LIKE 'Moonglade %' OR `name` LIKE 'Assassination %' OR `name` LIKE 'Beast Lord %') ORDER BY `entry`;

-- ------------------------------------------------------------
-- Juwelier: raw TBC gems + rings/necklaces/trinkets from the DB.
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90015,0,23436,0,0,0),(90015,0,23437,0,0,0),(90015,0,23438,0,0,0),
(90015,0,23439,0,0,0),(90015,0,23440,0,0,0),(90015,0,23441,0,0,0),
(90015,0,24027,0,0,0),(90015,0,24028,0,0,0),(90015,0,24029,0,0,0),
(90015,0,24030,0,0,0),(90015,0,24031,0,0,0),(90015,0,24032,0,0,0),
(90015,0,24033,0,0,0),(90015,0,24034,0,0,0);
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`)
SELECT 90015,0,`entry`,0,0,0 FROM `item_template`
WHERE `class`=4 AND `Quality` IN (2,3) AND `RequiredLevel` BETWEEN 1 AND 70 AND `InventoryType` IN (2,11,12)
ORDER BY `ItemLevel`, `entry` LIMIT 150;

-- ------------------------------------------------------------
-- Bags
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90016,0,4496,0,0,0),(90016,0,4497,0,0,0),(90016,0,4498,0,0,0),
(90016,0,10050,0,0,0),(90016,0,21841,0,0,0),(90016,0,21843,0,0,0);

-- ------------------------------------------------------------
-- Mounts: TBC mount items. Item requirements/faction remain enforced.
-- ------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90017,0,29465,0,0,0),(90017,0,29466,0,0,0),(90017,0,29467,0,0,0),
(90017,0,29468,0,0,0),(90017,0,29469,0,0,0),(90017,0,29470,0,0,0),
(90017,0,29471,0,0,0),(90017,0,29472,0,0,0);

-- ------------------------------------------------------------
-- Profession materials - intentionally separated by profession.
-- Unlimited stock (maxcount=0).
-- ------------------------------------------------------------
-- Alchemy: herbs and basic vials/reagents
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90020,0,2447,0,0,0),(90020,0,765,0,0,0),(90020,0,785,0,0,0),(90020,0,2449,0,0,0),
(90020,0,2450,0,0,0),(90020,0,3355,0,0,0),(90020,0,3356,0,0,0),(90020,0,3357,0,0,0),
(90020,0,3358,0,0,0),(90020,0,3818,0,0,0),(90020,0,3820,0,0,0),(90020,0,3819,0,0,0),
(90020,0,3821,0,0,0),(90020,0,3824,0,0,0),(90020,0,8831,0,0,0),(90020,0,8836,0,0,0),
(90020,0,8838,0,0,0),(90020,0,13463,0,0,0),(90020,0,13464,0,0,0),(90020,0,13465,0,0,0),
(90020,0,13466,0,0,0),(90020,0,13467,0,0,0),(90020,0,13468,0,0,0),(90020,0,13463,0,0,0),
(90020,0,3371,0,0,0),(90020,0,8925,0,0,0);

-- Blacksmithing: TBC ores/bars + classic progression materials
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90021,0,2770,0,0,0),(90021,0,2771,0,0,0),(90021,0,2772,0,0,0),(90021,0,2775,0,0,0),
(90021,0,2776,0,0,0),(90021,0,3858,0,0,0),(90021,0,10620,0,0,0),(90021,0,23424,0,0,0),
(90021,0,23425,0,0,0),(90021,0,23426,0,0,0),(90021,0,23427,0,0,0),(90021,0,23445,0,0,0),
(90021,0,23446,0,0,0),(90021,0,2840,0,0,0),(90021,0,2841,0,0,0),(90021,0,2842,0,0,0),
(90021,0,3575,0,0,0),(90021,0,3576,0,0,0),(90021,0,3859,0,0,0),(90021,0,3860,0,0,0),
(90021,0,6037,0,0,0),(90021,0,3864,0,0,0),(90021,0,12359,0,0,0),(90021,0,12360,0,0,0),
(90021,0,12361,0,0,0),(90021,0,23445,0,0,0),(90021,0,23446,0,0,0),(90021,0,3466,0,0,0),
(90021,0,2880,0,0,0),(90021,0,3466,0,0,0);

-- Enchanting
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90022,0,10940,0,0,0),(90022,0,10938,0,0,0),(90022,0,10939,0,0,0),(90022,0,10978,0,0,0),
(90022,0,10998,0,0,0),(90022,0,11082,0,0,0),(90022,0,11084,0,0,0),(90022,0,11083,0,0,0),
(90022,0,11134,0,0,0),(90022,0,11135,0,0,0),(90022,0,11137,0,0,0),(90022,0,11139,0,0,0),
(90022,0,11175,0,0,0),(90022,0,11176,0,0,0),(90022,0,11177,0,0,0),(90022,0,14343,0,0,0),
(90022,0,22445,0,0,0),(90022,0,22446,0,0,0),(90022,0,22447,0,0,0),(90022,0,22448,0,0,0),
(90022,0,22449,0,0,0),(90022,0,22450,0,0,0),(90022,0,22451,0,0,0),(90022,0,22452,0,0,0),
(90022,0,22456,0,0,0),(90022,0,22457,0,0,0),(90022,0,22460,0,0,0),(90022,0,22461,0,0,0),
(90022,0,22462,0,0,0),(90022,0,22463,0,0,0);

-- Engineering
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90023,0,4361,0,0,0),(90023,0,4363,0,0,0),(90023,0,4364,0,0,0),(90023,0,4365,0,0,0),
(90023,0,4371,0,0,0),(90023,0,4375,0,0,0),(90023,0,4377,0,0,0),(90023,0,4382,0,0,0),
(90023,0,4387,0,0,0),(90023,0,4390,0,0,0),(90023,0,4399,0,0,0),(90023,0,4400,0,0,0),
(90023,0,10505,0,0,0),(90023,0,10507,0,0,0),(90023,0,10560,0,0,0),(90023,0,10561,0,0,0),
(90023,0,10558,0,0,0),(90023,0,16006,0,0,0),(90023,0,16000,0,0,0),(90023,0,16008,0,0,0),
(90023,0,15992,0,0,0),(90023,0,15994,0,0,0),(90023,0,15996,0,0,0),(90023,0,23445,0,0,0),
(90023,0,23446,0,0,0),(90023,0,23782,0,0,0),(90023,0,23783,0,0,0);

-- Jewelcrafting materials
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90024,0,1705,0,0,0),(90024,0,1529,0,0,0),(90024,0,7910,0,0,0),(90024,0,12800,0,0,0),
(90024,0,12364,0,0,0),(90024,0,23107,0,0,0),(90024,0,23436,0,0,0),(90024,0,23437,0,0,0),
(90024,0,23438,0,0,0),(90024,0,23439,0,0,0),(90024,0,23440,0,0,0),(90024,0,23441,0,0,0),
(90024,0,23427,0,0,0),(90024,0,23445,0,0,0),(90024,0,23446,0,0,0);

-- Leatherworking
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90025,0,2318,0,0,0),(90025,0,2319,0,0,0),(90025,0,4231,0,0,0),(90025,0,4232,0,0,0),
(90025,0,4234,0,0,0),(90025,0,4304,0,0,0),(90025,0,8167,0,0,0),(90025,0,8170,0,0,0),
(90025,0,15407,0,0,0),(90025,0,15408,0,0,0),(90025,0,15409,0,0,0),(90025,0,8171,0,0,0),
(90025,0,21887,0,0,0),(90025,0,25700,0,0,0),(90025,0,25649,0,0,0);

-- Tailoring
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90026,0,2589,0,0,0),(90026,0,2592,0,0,0),(90026,0,4305,0,0,0),(90026,0,4338,0,0,0),
(90026,0,14047,0,0,0),(90026,0,21877,0,0,0),(90026,0,21842,0,0,0),(90026,0,24271,0,0,0),
(90026,0,24272,0,0,0),(90026,0,24273,0,0,0),(90026,0,24291,0,0,0),(90026,0,24249,0,0,0),
(90026,0,2604,0,0,0),(90026,0,14341,0,0,0),(90026,0,2320,0,0,0),(90026,0,2321,0,0,0);

-- Herbalism
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) SELECT 90027,0,`entry`,0,0,0 FROM `item_template` WHERE `entry` IN (2447,765,785,2449,2450,2453,2452,3355,3356,3357,3358,3818,3819,3820,3821,3824,8831,8836,8838,13463,13464,13465,13466,13467,13468,22785,22786,22787,22789,22790,22791);

-- Mining
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) SELECT 90028,0,`entry`,0,0,0 FROM `item_template` WHERE `entry` IN (2770,2771,2772,2775,2776,3858,10620,11370,12359,12360,12361,23424,23425,23426,23427,23445,23446,2840,2841,2842,3575,3576,3859,3860,3864,6037);

-- Skinning
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) SELECT 90029,0,`entry`,0,0,0 FROM `item_template` WHERE `entry` IN (2318,2319,2934,4231,4232,4234,4304,8167,8170,15407,15408,15409,8171,21887,25699,25700);

-- Cooking
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) SELECT 90030,0,`entry`,0,0,0 FROM `item_template` WHERE `entry` IN (769,1015,1080,2672,2673,2674,2675,2677,2678,2679,2680,2681,2886,3712,5465,5466,5467,5469,5470,5471,5472,5473,5503,5504,5508,5526,7974,8959,12037,12203,12204,12205,12206,12207,12208,12223,13754,13755,13756,13758,13759,13760,20424,27668,27669,27671,27674,27676,27677,27678,27681,27682,27684,27685,27686,27687,27688,27690,27692,27694,27697,27698,27699,27700,27701,27702,27703,27704,27705,27706,27707,27708);

-- Fishing: basic rods, lures and bait
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90031,0,6256,0,0,0),(90031,0,6529,0,0,0),(90031,0,6530,0,0,0),(90031,0,6532,0,0,0),
(90031,0,6533,0,0,0),(90031,0,6538,0,0,0),(90031,0,6539,0,0,0),(90031,0,6365,0,0,0),
(90031,0,6366,0,0,0),(90031,0,6367,0,0,0),(90031,0,6529,0,0,0);

-- First Aid
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`) VALUES
(90032,0,2581,0,0,0),(90032,0,2582,0,0,0),(90032,0,3530,0,0,0),(90032,0,3531,0,0,0),
(90032,0,6450,0,0,0),(90032,0,6451,0,0,0),(90032,0,14529,0,0,0),(90032,0,14530,0,0,0),
(90032,0,21990,0,0,0),(90032,0,21991,0,0,0),(90032,0,21992,0,0,0),(90032,0,21993,0,0,0);

-- NOTE: Premium Buffer 90001 remains the central buff NPC from 9001_npc_buffer.sql.
-- The Playertreff service NPCs are not spawned automatically to avoid forcing a location.

-- ---------------------------------------------------------------------------
-- Dynamic Eluna services and SQL-only trainers
-- ---------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `pt_clone_npc`;
DELIMITER //
CREATE PROCEDURE `pt_clone_npc`(IN new_entry INT UNSIGNED, IN new_name VARCHAR(100), IN new_subname VARCHAR(100), IN new_flags INT UNSIGNED)
BEGIN
  DROP TEMPORARY TABLE IF EXISTS `pt_npc`;
  CREATE TEMPORARY TABLE `pt_npc` LIKE `creature_template`;
  INSERT INTO `pt_npc` SELECT * FROM `creature_template` WHERE `entry`=90019;
  UPDATE `pt_npc` SET `entry`=new_entry, `name`=new_name,
    `NpcFlags`=new_flags, `ScriptName`='';
  DELETE FROM `creature_template` WHERE `entry`=new_entry;
  INSERT INTO `creature_template` SELECT * FROM `pt_npc`;
  DROP TEMPORARY TABLE `pt_npc`;
END//
DELIMITER ;

CALL `pt_clone_npc`(90000,'Reisemeister','Portale zum Playertreff',1);
CALL `pt_clone_npc`(90001,'Azerothischer Puffer','Kostenlose Segen',1);
CALL `pt_clone_npc`(90033,'Premium-Puffer','Segen fuer 5 Gold',1);
CALL `pt_clone_npc`(90034,'Waffenmeister','Klassengerechte Waffenfertigkeiten',1);

CALL `pt_clone_npc`(90040,'Kriegerlehrer','Krieger',16);
CALL `pt_clone_npc`(90041,'Paladinlehrer','Paladin',16);
CALL `pt_clone_npc`(90042,'Jaegerlehrer','Jaeger',16);
CALL `pt_clone_npc`(90043,'Schurkenlehrer','Schurke',16);
CALL `pt_clone_npc`(90044,'Priesterlehrer','Priester',16);
CALL `pt_clone_npc`(90045,'Schamanenlehrer','Schamane',16);
CALL `pt_clone_npc`(90046,'Magierlehrer','Magier',16);
CALL `pt_clone_npc`(90047,'Hexenmeisterlehrer','Hexenmeister',16);
CALL `pt_clone_npc`(90048,'Druidenlehrer','Druide',16);

CALL `pt_clone_npc`(90050,'Alchemielehrer','Alchemie',16);
CALL `pt_clone_npc`(90051,'Schmiedelehrer','Schmiedekunst',16);
CALL `pt_clone_npc`(90052,'Verzauberungslehrer','Verzauberkunst',16);
CALL `pt_clone_npc`(90053,'Ingenieurslehrer','Ingenieurskunst',16);
CALL `pt_clone_npc`(90054,'Juwelenschleiferlehrer','Juwelenschleifen',16);
CALL `pt_clone_npc`(90055,'Lederverarbeitungslehrer','Lederverarbeitung',16);
CALL `pt_clone_npc`(90056,'Schneiderlehrer','Schneiderei',16);
CALL `pt_clone_npc`(90057,'Kraeuterkundelehrer','Kraeuterkunde',16);
CALL `pt_clone_npc`(90058,'Bergbaulehrer','Bergbau',16);
CALL `pt_clone_npc`(90059,'Kuerschnereilehrer','Kuerschnerei',16);
CALL `pt_clone_npc`(90060,'Kochlehrer','Kochen',16);
CALL `pt_clone_npc`(90061,'Angellehrer','Angeln',16);
CALL `pt_clone_npc`(90062,'Erste-Hilfe-Lehrer','Erste Hilfe',16);
DROP PROCEDURE `pt_clone_npc`;

UPDATE `creature_template` SET `TrainerType`=0 WHERE `Entry` BETWEEN 90040 AND 90048;
UPDATE `creature_template` SET `TrainerType`=2 WHERE `Entry` BETWEEN 90050 AND 90062;

DELETE FROM `npc_trainer` WHERE `entry` BETWEEN 90040 AND 90062;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`)
SELECT 90040,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=914;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90041,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=928;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90042,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=5117;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90043,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=918;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90044,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=376;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90045,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=5882;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90046,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=5497;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90047,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=5495;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90048,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=4217;

INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90050,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=1386;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90051,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=4258;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90052,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=1317;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90053,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=5518;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90054,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=19063;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90055,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=11097;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90056,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=1346;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90057,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=812;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90058,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=4254;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90059,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=1292;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90060,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=8306;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90061,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=3607;
INSERT INTO `npc_trainer` (`entry`,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel`) SELECT 90062,`spell`,`spellcost`,`reqskill`,`reqskillvalue`,`reqlevel` FROM `npc_trainer` WHERE `entry`=2326;

