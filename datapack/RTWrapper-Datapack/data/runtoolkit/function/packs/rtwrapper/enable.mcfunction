# Enable RTWrapper manager hooks. This does not run /datapack enable; it controls
# Runtoolkit-managed execution hooks.
scoreboard players set rtwrapper rtk.enabled 1
function runtoolkit:packs/rtwrapper/load
tellraw @a [{"text":"[Runtoolkit] Enabled RTWrapper","color":"green"}]
