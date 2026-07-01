# RTWrapper trigger dispatcher.
# rtw.temp: 1 accepted/success, 0 canceled/error.
scoreboard players set @s rtw.temp 0
execute unless entity @s[tag=rtwrapper.testMode] run tellraw @s [{"text":"[RTWrapper] Trigger canceled: ","color":"red"},{"text":"rtwrapper.testMode required. Run function rtwrapper:api/testmode/on","color":"yellow"}]

# Positive button values.
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 1 run function rtwrapper:ui/open
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 2 run function rtwrapper:trigger/run_request
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 3 run function rtwrapper:ui/list_commands
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 4 run function runtoolkit:dpman
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 5 run function rtwrapper:ui/batch
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 6 run function rtwrapper:ui/selector
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 7 run function rtwrapper:ui/preset/give
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 8 run function rtwrapper:ui/preset/tp
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 9 run function rtwrapper:ui/settings
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 10 run function rtwrapper:api/debug/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 11 run function rtwrapper:api/debug/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 12 run function rtwrapper:api/silent/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 13 run function rtwrapper:api/silent/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 14 run function rtwrapper:api/autotick/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 15 run function rtwrapper:api/autotick/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 16 run function rtwrapper:ui/settings/safe
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 17 run function rtwrapper:api/testmode/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 18 run function rtwrapper:ui/preset/batch
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 19 run function rtwrapper:api/run_many
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 20 run function rtwrapper:ui/selector/check_self
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 21 run function rtwrapper:ui/selector/check_all_limited
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 22 run function rtwrapper:ui/selector/check_entity_player
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 23 run function rtwrapper:ui/selector/check_player_name
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 24 run function runtoolkit:dpman/enable_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 25 run function runtoolkit:dpman/disable_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 26 run function runtoolkit:dpman/reload_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 27 run function runtoolkit:api/list
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 28 run function runtoolkit:api/dump_registry
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches 29 run function runtoolkit:api/reload_all

# Negative option values from dialog single_option inputs (-01, -010, -018...).
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -1 run function rtwrapper:trigger/run_request
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -2 run function rtwrapper:ui/list_commands
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -3 run function runtoolkit:dpman
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -4 run function rtwrapper:ui/batch
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -5 run function rtwrapper:ui/selector
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -6 run function rtwrapper:ui/settings
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -7 run function rtwrapper:ui/preset/give
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -8 run function rtwrapper:ui/preset/tp
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -10 run function rtwrapper:api/debug/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -11 run function rtwrapper:api/debug/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -12 run function rtwrapper:api/silent/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -13 run function rtwrapper:api/silent/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -14 run function rtwrapper:api/autotick/on
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -15 run function rtwrapper:api/autotick/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -16 run function rtwrapper:ui/settings/safe
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -17 run function rtwrapper:api/testmode/off
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -18 run function rtwrapper:ui/preset/batch
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -19 run function rtwrapper:api/run_many
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -20 run function rtwrapper:ui/selector/check_self
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -21 run function rtwrapper:ui/selector/check_all_limited
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -22 run function rtwrapper:ui/selector/check_entity_player
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -23 run function rtwrapper:ui/selector/check_player_name
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -24 run function runtoolkit:dpman/enable_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -25 run function runtoolkit:dpman/disable_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -26 run function runtoolkit:dpman/reload_rtwrapper
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -27 run function runtoolkit:api/list
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -28 run function runtoolkit:api/dump_registry
execute if entity @s[tag=rtwrapper.testMode] if score @s RTWrapper matches -29 run function runtoolkit:api/reload_all

execute if entity @s[tag=rtwrapper.testMode] unless score @s RTWrapper matches -29..29 run tellraw @s [{"text":"[RTWrapper] Unknown trigger value.","color":"red"}]
execute if score @s rtw.temp matches 0 run tellraw @s [{"text":"[RTWrapper] Operation ended with rtw.temp=0 (canceled/error).","color":"red"}]
scoreboard players set @s RTWrapper 0
scoreboard players enable @s RTWrapper
