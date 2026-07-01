data modify storage rtwrapper:api batch set value {runSafeMode:1b,requests:[{req:{cmd:"say",params:{message:"RTWrapper batch item 1"},runSafeMode:1b},args:[]},{req:{cmd:"say",params:{message:"RTWrapper batch item 2"},runSafeMode:1b},args:[]}]}
tellraw @s [{"text":"[RTWrapper] Preset batch set. Use function rtwrapper:api/run_many.","color":"gold"}]
scoreboard players set @s rtw.temp 1
