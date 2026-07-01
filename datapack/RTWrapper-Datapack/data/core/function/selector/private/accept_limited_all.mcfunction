scoreboard players set #valid core.selector 1
scoreboard players set #selector_valid rtw.temp 1
execute if entity @s run scoreboard players set @s rtw.temp 1
data modify storage core:selector result set value {valid:1b,kind:"limited_all"}
data modify storage core:selector result.value set from storage core:selector input.value
