data modify storage stringlib:input find.String set from storage rtwrapper:api string.value

data modify storage stringlib:input find.Find set value "@p"
data modify storage stringlib:input find.n set value 1
execute store success score #selector_match rtw.temp run function stringlib:util/find
execute if score #selector_match rtw.temp matches 1.. run scoreboard players set @s rtw.temp 1

data modify storage stringlib:input find.Find set value "@a"
execute store success score #selector_match rtw.temp run function stringlib:util/find
execute if score #selector_match rtw.temp matches 1.. run scoreboard players set @s rtw.temp 1

data modify storage stringlib:input find.Find set value "@s"
execute store success score #selector_match rtw.temp run function stringlib:util/find
execute if score #selector_match rtw.temp matches 1.. run scoreboard players set @s rtw.temp 1

data modify storage stringlib:input find.Find set value "@r"
execute store success score #selector_match rtw.temp run function stringlib:util/find
execute if score #selector_match rtw.temp matches 1.. run scoreboard players set @s rtw.temp 1

data modify storage stringlib:input find.Find set value "@e"
execute store success score #selector_match rtw.temp run function stringlib:util/find
execute if score #selector_match rtw.temp matches 1.. run scoreboard players set @s rtw.temp 1

execute if score @s rtw.temp matches 1 run tellraw @s [{"text":"[RTWrapper] Selector token detected by StringLib","color":"green"}]
execute unless score @s rtw.temp matches 1 run tellraw @s [{"text":"[RTWrapper] No selector token detected by StringLib","color":"gray"}]
