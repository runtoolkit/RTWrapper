# Processes one direct request or one queued request, then drains the queue recursively.
# Silent mode suppresses RTWrapper's own tellraw debug/status messages. It does not
# permanently change vanilla gamerules.
execute if score #debug rtw.config matches 1.. if score #silent rtw.config matches 0 run tellraw @a[tag=rtwrapper.debug] [{"text":"[RTWrapper] run_actions","color":"gold"}]
function rtwrapper:core/wrappers/handler/main
execute if data storage rtwrapper:runtime queue[0] run function rtwrapper:core/run/run_actions
