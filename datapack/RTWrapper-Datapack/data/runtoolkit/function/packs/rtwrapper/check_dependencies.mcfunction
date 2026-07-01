# RTWrapper has no Runtoolkit dependencies.
data modify storage runtoolkit:runtime missing_dependencies set value []
scoreboard players set #dependency_errors rtk.status 0
scoreboard players set rtwrapper rtk.loaded 0
