# RTWrapper trigger dispatcher.
# rtw.temp: 1 means accepted/success, 0 means canceled/error.
scoreboard players set @s rtw.temp 0
execute unless entity @s[tag=rtwrapper.testMode] run tellraw @s [{"text":"[RTWrapper] Trigger canceled: ","color":"red"},{"text":"rtwrapper.testMode tag required. Run function rtwrapper:api/testmode/on","color":"yellow"}]

execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 1 run function rtwrapper:ui/open
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 2 run function rtwrapper:trigger/run_request
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 3 run function rtwrapper:ui/list_commands
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 4 run function runtoolkit:dpman
execute if entity @s[tag=rtwrapper.testMode] unless score @s RTWrapper matches 1..4 run tellraw @s [{"text":"[RTWrapper] Unknown trigger value. Use 1=dialog, 2=run, 3=list, 4=dpman.","color":"red"}]

execute if score @s rtw.temp matches 0 run tellraw @s [{"text":"[RTWrapper] Operation ended with rtw.temp=0 (canceled/error).","color":"red"}]
scoreboard players set @s RTWrapper 0
scoreboard players enable @s RTWrapper
