# Trigger objective is available to every player, but handler actions are gated
# behind rtwrapper.testMode for in-game experimental UI features.
scoreboard players enable @a RTWrapper
execute as @a[scores={RTWrapper=1..}] run function rtwrapper:trigger/handle

# Disabled by default. Enable with: function rtwrapper:api/autotick/on
# Autotick intentionally processes only one action per tick. Use rtwrapper:api/run
# when you explicitly want to drain the whole queue immediately.
execute if score #auto_tick rtw.config matches 1.. run function rtwrapper:core/run/run_next
