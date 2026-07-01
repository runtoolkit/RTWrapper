# Registration hook for RTWrapper. Other Runtoolkit datapacks can mirror this pattern.
scoreboard objectives add rtk.loaded dummy
scoreboard players set #rtwrapper rtk.loaded 1
data modify storage runtoolkit:registry packs.rtwrapper set value {id:"rtwrapper",name:"RTWrapper",version:"0.1.1+26.2",kind:"datapack",advancement:"runtoolkit:packs/rtwrapper"}
