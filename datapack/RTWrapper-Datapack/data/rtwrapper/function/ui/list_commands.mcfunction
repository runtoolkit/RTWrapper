# Trigger value 3: list command wrapper categories in chat.
scoreboard players set @s rtw.temp 1
tellraw @s [{"text":"[RTWrapper] Command wrappers (26.2)","color":"gold","bold":true}]
tellraw @s [{"text":" - advancement, attribute, bossbar, clear, clone, damage, data, datapack","color":"yellow"}]
tellraw @s [{"text":" - debug, defaultgamemode, dialog, difficulty, effect, enchant, execute, experience","color":"yellow"}]
tellraw @s [{"text":" - fetchprofile, fill, fillbiome, forceload, function, gamemode, gamerule, give","color":"yellow"}]
tellraw @s [{"text":" - help, item, jfr, kick, kill, list, locate, loot","color":"yellow"}]
tellraw @s [{"text":" - me/msg/tell/w, op/deop, pardon/ban, particle, perf, place, playsound, publish/unpublish","color":"yellow"}]
tellraw @s [{"text":" - random, recipe, reload, return, ride, rotate, save-all/save-on/save-off, say","color":"yellow"}]
tellraw @s [{"text":" - schedule, scoreboard, seed, setblock, setidletimeout, setworldspawn, spawnpoint, spectate","color":"yellow"}]
tellraw @s [{"text":" - spreadplayers, stop, stopsound, stopwatch, summon, swing, tag, team/teammsg/tm","color":"yellow"}]
tellraw @s [{"text":" - teleport/tp, tellraw, test, tick, time, title, transfer, trigger","color":"yellow"}]
tellraw @s [{"text":" - version, waypoint, weather, whitelist, worldborder, xp","color":"yellow"}]
tellraw @s [{"text":"Use datapack/commands-26.2.json for meaningful params. Use function rtwrapper:ui/open for dialog UI.","color":"gray"}]
