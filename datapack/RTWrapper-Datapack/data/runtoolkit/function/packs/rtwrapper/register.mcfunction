# Register RTWrapper with the global Runtoolkit manager.
scoreboard objectives add rtk.registered dummy
scoreboard objectives add rtk.enabled dummy
scoreboard objectives add rtk.loaded dummy
scoreboard objectives add rtk.status dummy

scoreboard players set rtwrapper rtk.registered 1
execute unless score rtwrapper rtk.enabled matches 0.. run scoreboard players set rtwrapper rtk.enabled 1

data modify storage runtoolkit:registry packs.rtwrapper set value {id:"rtwrapper",name:"RTWrapper",version:"1.0.1+26.2",namespace:"rtwrapper",kind:"datapack",advancement:"runtoolkit:packs/rtwrapper",dependencies:["stringlib"],hooks:{register:"runtoolkit:packs/rtwrapper/register",load:"runtoolkit:packs/rtwrapper/load",tick:"runtoolkit:packs/rtwrapper/tick",list:"runtoolkit:packs/rtwrapper/list",enable:"runtoolkit:packs/rtwrapper/enable",disable:"runtoolkit:packs/rtwrapper/disable",reload:"runtoolkit:packs/rtwrapper/reload",check_dependencies:"runtoolkit:packs/rtwrapper/check_dependencies"}}
