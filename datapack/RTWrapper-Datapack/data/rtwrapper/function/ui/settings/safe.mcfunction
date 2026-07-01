data modify storage rtwrapper:settings request_defaults set value {runSafeMode:1b}
tellraw @s [{"text":"[RTWrapper] Recommended default noted: runSafeMode=1b","color":"gold"}]
scoreboard players set @s rtw.temp 1
