# Consume rtwrapper:api request.
# Default runSafeMode is 0b: immediate drain of current request + queue.
# runSafeMode:1b: process at most one action with run_next.
scoreboard players set #run_safe rtw.temp 0
execute if data storage rtwrapper:api request.cmd unless data storage rtwrapper:api request.runSafeMode run data modify storage rtwrapper:api request.runSafeMode set value 0b
execute unless data storage rtwrapper:api request.cmd if data storage rtwrapper:api request.type unless data storage rtwrapper:api request.runSafeMode run data modify storage rtwrapper:api request.runSafeMode set value 0b
execute if data storage rtwrapper:api request{runSafeMode:1b} run scoreboard players set #run_safe rtw.temp 1
execute if score #run_safe rtw.temp matches 1 run function rtwrapper:core/run/run_next
execute unless score #run_safe rtw.temp matches 1 if data storage rtwrapper:api request.cmd run function rtwrapper:api/enqueue
execute unless score #run_safe rtw.temp matches 1 unless data storage rtwrapper:api request.cmd if data storage rtwrapper:api request.type run function rtwrapper:api/enqueue
execute unless score #run_safe rtw.temp matches 1 run function rtwrapper:core/run/run_actions
