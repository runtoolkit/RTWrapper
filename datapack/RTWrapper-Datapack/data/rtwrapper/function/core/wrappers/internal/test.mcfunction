# RTWrapper generated named-parameter dispatcher for /test.
# Provide contiguous parameters in this order:
# action, test_name, rotation, tests_per_row
scoreboard players set #pc rtw.status 0
execute if data storage rtwrapper:runtime current.params.action run scoreboard players set #pc rtw.status 1
execute if data storage rtwrapper:runtime current.params.test_name run scoreboard players set #pc rtw.status 2
execute if data storage rtwrapper:runtime current.params.rotation run scoreboard players set #pc rtw.status 3
execute if data storage rtwrapper:runtime current.params.tests_per_row run scoreboard players set #pc rtw.status 4
execute if score #pc rtw.status matches 0 run function rtwrapper:core/wrappers/internal/variants/test_0
execute if score #pc rtw.status matches 1 run function rtwrapper:core/wrappers/internal/variants/test_1 with storage rtwrapper:runtime current.params
execute if score #pc rtw.status matches 2 run function rtwrapper:core/wrappers/internal/variants/test_2 with storage rtwrapper:runtime current.params
execute if score #pc rtw.status matches 3 run function rtwrapper:core/wrappers/internal/variants/test_3 with storage rtwrapper:runtime current.params
execute if score #pc rtw.status matches 4 run function rtwrapper:core/wrappers/internal/variants/test_4 with storage rtwrapper:runtime current.params
