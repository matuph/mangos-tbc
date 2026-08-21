-- Level 58 character upgrade NPC
-- Entry: 90005
-- ScriptName: npc_level58_upgrade
-- Grants level 58, class-appropriate Dungeon Set 1 armor and 500 gold.

INSERT INTO creature_template
    (entry, modelid1, modelid2, modelid3, modelid4, name, subname,
     minlevel, maxlevel, faction, npcflag, speed_walk, speed_run,
     scale, rank, unit_flags, type, type_flags, flags_extra, ScriptName)
VALUES
    (90005, 1960, 0, 0, 0, 'Charakter-Aufwerter', 'Level 58 / Ausruestung / 500 Gold',
     60, 60, 35, 1, 1.0, 1.14286,
     1.0, 0, 0, 7, 0, 0, 'npc_level58_upgrade')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    subname = VALUES(subname),
    minlevel = VALUES(minlevel),
    maxlevel = VALUES(maxlevel),
    faction = VALUES(faction),
    npcflag = VALUES(npcflag),
    ScriptName = VALUES(ScriptName);
