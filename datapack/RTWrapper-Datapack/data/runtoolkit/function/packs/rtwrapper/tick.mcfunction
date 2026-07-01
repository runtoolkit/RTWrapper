# Managed tick hook for RTWrapper.
execute if score rtwrapper rtk.enabled matches 1.. if score rtwrapper rtk.loaded matches 1.. run scoreboard players add #rtwrapper_ticks rtk.status 1
execute if score rtwrapper rtk.enabled matches 1.. if score rtwrapper rtk.loaded matches 1.. store result storage runtoolkit:state packs.rtwrapper.ticks int 1 run scoreboard players get #rtwrapper_ticks rtk.status
execute if score rtwrapper rtk.enabled matches 1.. if score rtwrapper rtk.loaded matches 1.. run function rtwrapper:core/tick
