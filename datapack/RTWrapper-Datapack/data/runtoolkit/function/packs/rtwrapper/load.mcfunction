# Load RTWrapper only when enabled and dependency checks pass.
execute if score rtwrapper rtk.enabled matches 1.. run function runtoolkit:packs/rtwrapper/check_dependencies
execute if score rtwrapper rtk.enabled matches 1.. if score #dependency_errors rtk.status matches 0 run function rtwrapper:core/load
execute if score rtwrapper rtk.enabled matches 1.. if score #dependency_errors rtk.status matches 0 run scoreboard players set rtwrapper rtk.loaded 1
execute if score rtwrapper rtk.enabled matches 1.. unless score #dependency_errors rtk.status matches 0 run tellraw @a [{"text":"[Runtoolkit] RTWrapper dependency check failed: ","color":"red"},{"nbt":"missing_dependencies","storage":"runtoolkit:runtime","color":"yellow"}]
