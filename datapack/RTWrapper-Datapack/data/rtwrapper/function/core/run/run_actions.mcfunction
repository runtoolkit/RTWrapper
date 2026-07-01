# Immediate drain mode: processes a direct request or queued requests until the queue is empty.
# Do not use this from the tick loop; autotick uses core/run/run_next to process one action per tick.
# Silent mode suppresses RTWrapper's own tellraw debug/status messages. It does not
# permanently change vanilla gamerules.
execute if score #debug rtw.config matches 1.. if score #silent rtw.config matches 0 run tellraw @a[tag=rtwrapper.debug] [{"text":"[RTWrapper] run_actions drain","color":"gold"}]
function rtwrapper:core/wrappers/handler/main
execute if data storage rtwrapper:runtime queue[0] run function rtwrapper:core/run/run_actions
