# Macro dependency check: a dependency is satisfied only when its rtk.enabled
# score is 1 or greater. Missing dependencies are recorded in runtime storage.
$execute unless score $(id) rtk.enabled matches 1.. run scoreboard players add #dependency_errors rtk.status 1
$execute unless score $(id) rtk.enabled matches 1.. run data modify storage runtoolkit:runtime missing_dependencies append value "$(id)"
