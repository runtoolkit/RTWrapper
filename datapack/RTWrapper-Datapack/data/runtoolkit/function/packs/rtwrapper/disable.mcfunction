# Disable RTWrapper manager hooks. Functions remain present, but the global
# manager stops running RTWrapper-managed load/tick hooks.
scoreboard players set rtwrapper rtk.enabled 0
scoreboard players set rtwrapper rtk.loaded 0
scoreboard players add #rtwrapper_disables rtk.status 1
scoreboard players set #auto_tick rtw.config 0

data modify storage runtoolkit:state packs.rtwrapper.enabled set value 0b
data modify storage runtoolkit:state packs.rtwrapper.loaded set value 0b
data modify storage runtoolkit:state packs.rtwrapper.status set value "disabled"
data modify storage runtoolkit:state packs.rtwrapper.last_action set value "disable"
data modify storage rtwrapper:runtime config.auto_tick set value 0b
data modify storage rtwrapper:runtime queue set value []
data remove storage rtwrapper:runtime current
execute if score #silent rtw.config matches 0 run tellraw @a [{"text":"[Runtoolkit] Disabled RTWrapper manager hooks and cleared runtime queue","color":"yellow"}]
