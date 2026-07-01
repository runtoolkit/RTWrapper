# Trigger value 2: run the current RTWrapper API request.
execute if data storage rtwrapper:api request.cmd run scoreboard players set @s rtw.temp 1
execute unless data storage rtwrapper:api request.cmd if data storage rtwrapper:api request.type run scoreboard players set @s rtw.temp 1
execute if data storage rtwrapper:api request.params.target run data modify storage rtwrapper:api string.value set from storage rtwrapper:api request.params.target
execute if data storage rtwrapper:api request.params.target run function rtwrapper:string/detect_selector
execute if score @s rtw.temp matches 1 run function rtwrapper:api/run
execute unless score @s rtw.temp matches 1 run tellraw @s [{"text":"[RTWrapper] No rtwrapper:api request.cmd/type found.","color":"red"}]
