# Enqueue many conditional requests and run according to runSafeMode.
# runSafeMode:0b => immediate full drain. runSafeMode:1b => run one safe step; remaining queue waits for autotick/manual run_next.
function rtwrapper:api/enqueue_many
execute if data storage rtwrapper:runtime batch{runSafeMode:1b} run function rtwrapper:core/run/run_next
execute unless data storage rtwrapper:runtime batch{runSafeMode:1b} run function rtwrapper:core/run/run_actions
