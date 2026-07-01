# Load RTWrapper manager hooks. Core bootstrap always runs so trigger/objectives
# exist even when optional managed dependencies are missing; dependency status is
# still reported and selector helpers require StringLib.
execute if score rtwrapper rtk.enabled matches 1.. run function runtoolkit:packs/rtwrapper/check_dependencies
execute if score rtwrapper rtk.enabled matches 1.. run function rtwrapper:core/load
execute if score rtwrapper rtk.enabled matches 1.. if score #dependency_errors rtk.status matches 0 run scoreboard players set rtwrapper rtk.loaded 1
execute if score rtwrapper rtk.enabled matches 1.. unless score #dependency_errors rtk.status matches 0 run scoreboard players set rtwrapper rtk.loaded 0
execute if score rtwrapper rtk.enabled matches 1.. unless score #dependency_errors rtk.status matches 0 run tellraw @a [{"text":"[Runtoolkit] RTWrapper dependency warning: ","color":"yellow"},{"nbt":"missing_dependencies","storage":"runtoolkit:runtime","color":"red"},{"text":". Selector detection helpers need StringLib.","color":"gray"}]
