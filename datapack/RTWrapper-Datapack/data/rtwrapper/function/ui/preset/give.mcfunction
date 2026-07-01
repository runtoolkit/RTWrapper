data modify storage rtwrapper:api request set value {cmd:"give",params:{target:"@s",item:"minecraft:stone",count:"1"},runSafeMode:1b}
tellraw @s [{"text":"[RTWrapper] Preset request set: give @s minecraft:stone 1. Use trigger RTWrapper set 2 to run.","color":"gold"}]
scoreboard players set @s rtw.temp 1
