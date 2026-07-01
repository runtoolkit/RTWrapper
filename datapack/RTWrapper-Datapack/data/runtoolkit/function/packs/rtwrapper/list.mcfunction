# Dynamic list row for RTWrapper. Also refreshes a machine-readable list row.
data modify storage runtoolkit:runtime list.rtwrapper set from storage runtoolkit:state packs.rtwrapper
execute if score rtwrapper rtk.enabled matches 1.. if score rtwrapper rtk.loaded matches 1.. run data modify storage runtoolkit:runtime list.rtwrapper.display_status set value "enabled_loaded"
execute if score rtwrapper rtk.enabled matches 1.. unless score rtwrapper rtk.loaded matches 1.. run data modify storage runtoolkit:runtime list.rtwrapper.display_status set value "enabled_not_loaded"
execute unless score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:runtime list.rtwrapper.display_status set value "disabled"
execute if score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"enabled","color":"green"},{"text":" v1.0.3+26.2","color":"gray"},{"text":" deps:","color":"dark_gray"},{"text":" StringLib","color":"yellow"}]
execute unless score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"disabled","color":"red"},{"text":" v1.0.3+26.2","color":"gray"}]
execute if score stringlib rtk.enabled matches 1.. run tellraw @s [{"text":"   dependency StringLib: ","color":"gray"},{"text":"detected","color":"green"}]
execute unless score stringlib rtk.enabled matches 1.. run tellraw @s [{"text":"   dependency StringLib: ","color":"gray"},{"text":"missing","color":"red"},{"text":" https://github.com/CMDred/StringLib","color":"yellow"}]
