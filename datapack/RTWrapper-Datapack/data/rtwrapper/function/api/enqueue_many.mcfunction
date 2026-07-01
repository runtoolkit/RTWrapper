# Enqueue many conditional requests.
# Supported storage shapes:
#   rtwrapper:api batch = {requests:[{req:{cmd:"...",params:{...}},args:[...]}],runSafeMode:1b}
#   rtwrapper:api requests = [{req:{...},args:[...]}] plus optional rtwrapper:api runSafeMode
# Each item args[] is copied to req.conditions[].
data remove storage rtwrapper:runtime batch
execute if data storage rtwrapper:api batch.requests[0] run data modify storage rtwrapper:runtime batch set from storage rtwrapper:api batch
execute unless data storage rtwrapper:runtime batch.requests[0] if data storage rtwrapper:api requests[0] run data modify storage rtwrapper:runtime batch.requests set from storage rtwrapper:api requests
execute if data storage rtwrapper:api runSafeMode run data modify storage rtwrapper:runtime batch.runSafeMode set from storage rtwrapper:api runSafeMode
execute unless data storage rtwrapper:runtime batch.runSafeMode run data modify storage rtwrapper:runtime batch.runSafeMode set value 0b
execute if data storage rtwrapper:runtime batch.requests[0] run function rtwrapper:api/batch/enqueue_next
