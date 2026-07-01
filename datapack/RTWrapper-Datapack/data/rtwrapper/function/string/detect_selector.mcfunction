# Detect @p/@a/@s/@r/@e in storage rtwrapper:api string.value using StringLib.
# Output: @s rtw.temp = 1 if a selector token is found, 0 otherwise.
scoreboard players set @s rtw.temp 0
scoreboard players set #selector_match rtw.temp 0
scoreboard players set #selector_found rtw.temp 0
execute unless data storage rtwrapper:api string.value run tellraw @s [{"text":"[RTWrapper] selector detect canceled: storage rtwrapper:api string.value missing","color":"red"}]
execute if data storage rtwrapper:api string.value run function rtwrapper:string/detect_selector/run
execute if score @s rtw.temp matches 1 run data modify storage rtwrapper:runtime selector set value {found:1b}
execute unless score @s rtw.temp matches 1 run data modify storage rtwrapper:runtime selector set value {found:0b}
