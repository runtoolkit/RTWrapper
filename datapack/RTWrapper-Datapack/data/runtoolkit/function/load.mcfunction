summon minecraft:interaction ~ ~ ~ {Tags:["RTWrapper"],CustomName:{"text": "RTWrapper"}}

execute as @e[type=minecraft:interaction,tag=RTWrapper] at @s run say Starting test mode...

execute as @e[type=minecraft:interaction,tag=RTWrapper] at @s run scoreboard objectives add rtw.test dummy

execute as @e[type=minecraft:interaction,tag=RTWrapper] at @s run scoreboard players set #init rtw.test 1

execute as @e[type=minecraft:interaction,tag=RTWrapper] at @s run kill @s[type=minecraft:interaction]