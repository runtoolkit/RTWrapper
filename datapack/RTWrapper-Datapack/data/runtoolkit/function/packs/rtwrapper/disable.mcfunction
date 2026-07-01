# Disable RTWrapper manager hooks. Functions remain present, but the global
# manager will stop running RTWrapper load/tick hooks.
scoreboard players set rtwrapper rtk.enabled 0
scoreboard players set rtwrapper rtk.loaded 0
tellraw @a [{"text":"[Runtoolkit] Disabled RTWrapper manager hooks","color":"yellow"}]
