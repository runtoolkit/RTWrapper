# Trigger value 2: run the current RTWrapper API request.
scoreboard players set @s rtw.temp 0
execute if data storage rtwrapper:api request.cmd run scoreboard players set @s rtw.temp 1
execute unless data storage rtwrapper:api request.cmd if data storage rtwrapper:api request.type run scoreboard players set @s rtw.temp 1
execute if score @s rtw.temp matches 1 if data storage rtwrapper:api request.params.target run data modify storage core:selector input.value set from storage rtwrapper:api request.params.target
execute if score @s rtw.temp matches 1 if data storage rtwrapper:api request.params.target store success score @s rtw.temp run function core:selector/detect
execute if score @s rtw.temp matches 1 run function rtwrapper:api/run
execute unless score @s rtw.temp matches 1 run tellraw @s [{"text":"[RTWrapper] Request missing or selector check failed.","color":"red"}]
