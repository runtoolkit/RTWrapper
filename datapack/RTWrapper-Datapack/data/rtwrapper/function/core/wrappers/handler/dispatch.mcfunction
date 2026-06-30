# Debug, accounting, then dynamic macro dispatch into core/wrappers/internal/<cmd>.mcfunction.
scoreboard players add #processed rtw.status 1
execute if score #debug rtw.config matches 1.. if score #silent rtw.config matches 0 run function rtwrapper:core/wrappers/handler/debug_dispatch with storage rtwrapper:runtime current
function rtwrapper:core/wrappers/handler/exec with storage rtwrapper:runtime current
