# Enable RTWrapper manager hooks. This does not call vanilla /datapack enable.
scoreboard players set rtwrapper rtk.enabled 1
scoreboard players add #rtwrapper_enables rtk.status 1
data modify storage runtoolkit:state packs.rtwrapper.enabled set value 1b
data modify storage runtoolkit:state packs.rtwrapper.last_action set value "enable"
data modify storage runtoolkit:state packs.rtwrapper.status set value "enabling"
function runtoolkit:packs/rtwrapper/load
execute if score #silent rtw.config matches 0 run tellraw @a [{"text":"[Runtoolkit] Enabled RTWrapper manager hooks","color":"green"}]
