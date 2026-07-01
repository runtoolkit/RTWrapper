# Dynamic list row for RTWrapper.
execute if score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"enabled","color":"green"},{"text":" v1.0.0+26.2","color":"gray"}]
execute unless score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"disabled","color":"red"},{"text":" v1.0.0+26.2","color":"gray"}]
