# Load RTWrapper manager hooks. Core bootstrap runs when the manager entry is enabled.
# Missing StringLib is recorded as a dependency warning; core RTWrapper still loads.
execute if score rtwrapper rtk.enabled matches 1.. run scoreboard players add #rtwrapper_loads rtk.status 1
execute if score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.last_action set value "load"
execute if score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.status set value "loading"
execute if score rtwrapper rtk.enabled matches 1.. run function runtoolkit:packs/rtwrapper/check_dependencies
execute if score rtwrapper rtk.enabled matches 1.. run function rtwrapper:core/load
execute if score rtwrapper rtk.enabled matches 1.. run scoreboard players set rtwrapper rtk.loaded 1
execute if score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.loaded set value 1b
execute if score rtwrapper rtk.enabled matches 1.. if score #dependency_errors rtk.status matches 0 run data modify storage runtoolkit:state packs.rtwrapper.status set value "loaded"
execute if score rtwrapper rtk.enabled matches 1.. unless score #dependency_errors rtk.status matches 0 run data modify storage runtoolkit:state packs.rtwrapper.status set value "loaded_with_dependency_warnings"
execute unless score rtwrapper rtk.enabled matches 1.. run scoreboard players set rtwrapper rtk.loaded 0
execute unless score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.loaded set value 0b
execute unless score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.status set value "disabled"
