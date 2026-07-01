data modify storage rtwrapper:api request set value {cmd:"tp",params:{target:"@s",x:"0",y:"80",z:"0"},runSafeMode:1b}
tellraw @s [{"text":"[RTWrapper] Preset request set: tp @s 0 80 0. Use trigger RTWrapper set 2 to run.","color":"gold"}]
scoreboard players set @s rtw.temp 1
