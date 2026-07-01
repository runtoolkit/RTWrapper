# Dynamic list row for RTWrapper.
execute if score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"enabled","color":"green"},{"text":" v1.0.2+26.2","color":"gray"},{"text":" deps:","color":"dark_gray"},{"text":" StringLib","color":"yellow"}]
execute unless score rtwrapper rtk.enabled matches 1.. run tellraw @s [{"text":" - RTWrapper ","color":"aqua"},{"text":"disabled","color":"red"},{"text":" v1.0.2+26.2","color":"gray"}]
execute if score stringlib rtk.enabled matches 1.. run tellraw @s [{"text":"   dependency StringLib: ","color":"gray"},{"text":"detected","color":"green"}]
execute unless score stringlib rtk.enabled matches 1.. run tellraw @s [{"text":"   dependency StringLib: ","color":"gray"},{"text":"missing","color":"red"},{"text":" https://github.com/CMDred/StringLib","color":"yellow"}]
