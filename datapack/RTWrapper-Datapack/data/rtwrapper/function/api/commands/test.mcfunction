# Direct named-parameter API for /test.
# Parameter order: action, test_name, rotation, tests_per_row
data modify storage rtwrapper:runtime current.params set from storage rtwrapper:api params
function rtwrapper:core/wrappers/internal/test
data remove storage rtwrapper:runtime current.params
