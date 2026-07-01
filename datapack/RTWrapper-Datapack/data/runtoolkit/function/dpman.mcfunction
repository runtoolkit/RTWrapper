# Dialog-free Runtoolkit datapack manager entrypoint.
tellraw @s [{"text":"[Runtoolkit] Datapack Manager","color":"gold","bold":true}]
function runtoolkit:api/list
tellraw @s [{"text":"Commands:","color":"yellow"}]
tellraw @s [{"text":" data modify storage runtoolkit:api request set value {id:\"rtwrapper\"}","color":"gray"}]
tellraw @s [{"text":" function runtoolkit:api/enable | disable | reload","color":"gray"}]
tellraw @s [{"text":" function runtoolkit:api/reload_all / enable_all / disable_all / dump_registry","color":"gray"}]
