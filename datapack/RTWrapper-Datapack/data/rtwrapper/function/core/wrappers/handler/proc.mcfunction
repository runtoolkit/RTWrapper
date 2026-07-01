# Normalise request shape, then prepare dispatch.
# Supported request shapes:
#   {cmd:"tp", params:{target:"@s", x:"0", y:"80", z:"0"}, runSafeMode:1b}
#   {type:"tp", params:{target:"@s", x:"0", y:"80", z:"0"}, conditions:[...]}
# Parameter rule: provide contiguous named parameters in the documented command order.
execute unless data storage rtwrapper:runtime current.cmd if data storage rtwrapper:runtime current.type run data modify storage rtwrapper:runtime current.cmd set from storage rtwrapper:runtime current.type
execute unless data storage rtwrapper:runtime current.params if data storage rtwrapper:runtime current.args run data modify storage rtwrapper:runtime current.params set from storage rtwrapper:runtime current.args
execute unless data storage rtwrapper:runtime current.params run data modify storage rtwrapper:runtime current.params set value {}
execute unless data storage rtwrapper:runtime current.runSafeMode run data modify storage rtwrapper:runtime current.runSafeMode set value 0b

scoreboard players set #conditions rtw.temp 1
execute if data storage rtwrapper:runtime current.conditions[0] run function rtwrapper:condition/check/0
execute if data storage rtwrapper:runtime current.conditions[1] run function rtwrapper:condition/check/1
execute if data storage rtwrapper:runtime current.conditions[2] run function rtwrapper:condition/check/2
execute if data storage rtwrapper:runtime current.conditions[3] run function rtwrapper:condition/check/3
execute if data storage rtwrapper:runtime current.conditions[4] run function rtwrapper:condition/check/4
execute if data storage rtwrapper:runtime current.conditions[5] run function rtwrapper:condition/check/5
execute if data storage rtwrapper:runtime current.conditions[6] run function rtwrapper:condition/check/6
execute if data storage rtwrapper:runtime current.conditions[7] run function rtwrapper:condition/check/7

execute if score #conditions rtw.temp matches 1.. if data storage rtwrapper:runtime current.cmd run function rtwrapper:core/wrappers/handler/dispatch
execute if score #conditions rtw.temp matches 1.. unless data storage rtwrapper:runtime current.cmd run function rtwrapper:core/wrappers/handler/error_missing_cmd
execute unless score #conditions rtw.temp matches 1.. run scoreboard players add #skipped rtw.status 1

data remove storage rtwrapper:runtime current
