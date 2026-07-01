# Runtoolkit global datapack manager bootstrap.
# All Runtoolkit datapacks register through #runtoolkit:register, then the
# manager runs enabled pack load hooks through #runtoolkit:load.
scoreboard objectives add rtk.registered dummy
scoreboard objectives add rtk.enabled dummy
scoreboard objectives add rtk.loaded dummy
scoreboard objectives add rtk.status dummy

data modify storage runtoolkit:registry packs set value {}
data modify storage runtoolkit:runtime missing_dependencies set value []
scoreboard players set #dependency_errors rtk.status 0
scoreboard players add #reloads rtk.status 1

function #runtoolkit:register
function #runtoolkit:load
