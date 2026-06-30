# RTWrapper core bootstrap.
# Scoreboards are intentionally stable fake-player state; existing values are not overwritten.
scoreboard objectives add rtw.config dummy
scoreboard objectives add rtw.status dummy
scoreboard objectives add rtw.test dummy

execute unless score #debug rtw.config matches 0.. run scoreboard players set #debug rtw.config 0
execute unless score #silent rtw.config matches 0.. run scoreboard players set #silent rtw.config 1
execute unless score #auto_tick rtw.config matches 0.. run scoreboard players set #auto_tick rtw.config 0
execute unless score #processed rtw.status matches 0.. run scoreboard players set #processed rtw.status 0
execute unless score #errors rtw.status matches 0.. run scoreboard players set #errors rtw.status 0

# Bind storage roots if missing. Other packs may write rtwrapper:api request/args.
execute unless data storage rtwrapper:runtime config run data modify storage rtwrapper:runtime config set value {version:"26.2",debug:0b,silent:1b,auto_tick:0b}
execute unless data storage rtwrapper:runtime queue run data modify storage rtwrapper:runtime queue set value []
execute unless data storage rtwrapper:runtime current run data modify storage rtwrapper:runtime current set value {}
execute unless data storage rtwrapper:api request run data modify storage rtwrapper:api request set value {}
execute unless data storage rtwrapper:api params run data modify storage rtwrapper:api params set value {}

execute if score #debug rtw.config matches 1.. run tellraw @a[tag=rtwrapper.debug] [{"text":"[RTWrapper] load complete","color":"gold"}]
