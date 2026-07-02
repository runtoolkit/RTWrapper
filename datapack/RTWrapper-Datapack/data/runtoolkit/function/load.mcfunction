summon minecarft:interaction ~ ~ ~ {Tags:["RTWrapper"],CustomName:{"text": "RTWrapper"}}

execute as @e[type=minecaraft:interaction,tag=RTWrapper] at @s run say Starting test mode...

execute as @e[type=minecaraft:interaction,tag=RTWrapper] at @s run scoreboard objectives add rtw.tickTest dummy

execute as @e[type=minecraft:interaction,tag=RTWrapper] at @s run kill @s[type=minecraft:interaction]