# Reload RTWrapper through the manager.
scoreboard players add #rtwrapper_reloads rtk.status 1
data modify storage runtoolkit:state packs.rtwrapper.last_action set value "reload"
data modify storage runtoolkit:state packs.rtwrapper.status set value "reloading"
function runtoolkit:packs/rtwrapper/register
function runtoolkit:packs/rtwrapper/load
execute if score #silent rtw.config matches 0 run tellraw @a [{"text":"[Runtoolkit] Reloaded RTWrapper manager state","color":"aqua"}]
