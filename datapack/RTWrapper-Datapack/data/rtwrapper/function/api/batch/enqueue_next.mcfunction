data modify storage rtwrapper:runtime batch.current set from storage rtwrapper:runtime batch.requests[0]
data remove storage rtwrapper:runtime batch.requests[0]
data modify storage rtwrapper:runtime batch.request set from storage rtwrapper:runtime batch.current.req
execute if data storage rtwrapper:runtime batch.current.args run data modify storage rtwrapper:runtime batch.request.conditions set from storage rtwrapper:runtime batch.current.args
execute unless data storage rtwrapper:runtime batch.request.runSafeMode run data modify storage rtwrapper:runtime batch.request.runSafeMode set from storage rtwrapper:runtime batch.runSafeMode
data modify storage rtwrapper:runtime queue append from storage rtwrapper:runtime batch.request
data remove storage rtwrapper:runtime batch.current
data remove storage rtwrapper:runtime batch.request
execute if data storage rtwrapper:runtime batch.requests[0] run function rtwrapper:api/batch/enqueue_next
