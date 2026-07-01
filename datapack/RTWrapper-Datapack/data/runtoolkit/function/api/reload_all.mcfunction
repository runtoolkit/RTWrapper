# Re-register and reload all enabled Runtoolkit packs without using /reload.
data modify storage runtoolkit:registry packs set value {}
data modify storage runtoolkit:runtime missing_dependencies set value []
scoreboard players set #dependency_errors rtk.status 0
scoreboard players add #manager_reloads rtk.status 1
function #runtoolkit:register
function #runtoolkit:reload
