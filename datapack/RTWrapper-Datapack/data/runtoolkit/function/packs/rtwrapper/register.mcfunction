# Register RTWrapper with the global Runtoolkit manager.
scoreboard objectives add rtk.registered dummy
scoreboard objectives add rtk.enabled dummy
scoreboard objectives add rtk.loaded dummy
scoreboard objectives add rtk.status dummy
scoreboard objectives add rtw.config dummy
scoreboard objectives add rtw.status dummy
scoreboard objectives add rtw.temp dummy

scoreboard players set rtwrapper rtk.registered 1
execute unless score rtwrapper rtk.enabled matches 0.. run scoreboard players set rtwrapper rtk.enabled 1
scoreboard players set #rtwrapper_dependency_ok rtk.status 0
scoreboard players add #rtwrapper_registers rtk.status 1

data modify storage runtoolkit:state packs.rtwrapper set value {id:"rtwrapper",registered:1b,enabled:1b,loaded:0b,dependency_ok:0b,status:"registered",last_action:"register",version:"1.0.3+26.2"}
execute unless score rtwrapper rtk.enabled matches 1.. run data modify storage runtoolkit:state packs.rtwrapper.enabled set value 0b

data modify storage runtoolkit:registry packs.rtwrapper set value {id:"rtwrapper",name:"RTWrapper",version:"1.0.3+26.2",namespace:"rtwrapper",kind:"datapack",advancement:"runtoolkit:packs/rtwrapper",dependencies:["stringlib"],state_storage:"runtoolkit:state packs.rtwrapper",hooks:{register:"runtoolkit:packs/rtwrapper/register",load:"runtoolkit:packs/rtwrapper/load",tick:"runtoolkit:packs/rtwrapper/tick",list:"runtoolkit:packs/rtwrapper/list",enable:"runtoolkit:packs/rtwrapper/enable",disable:"runtoolkit:packs/rtwrapper/disable",reload:"runtoolkit:packs/rtwrapper/reload",check_dependencies:"runtoolkit:packs/rtwrapper/check_dependencies"}}
