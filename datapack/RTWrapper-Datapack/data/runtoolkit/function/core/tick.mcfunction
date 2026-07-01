# Runtoolkit common tick hook.
# Advancement completion is handled by advancement trigger minecraft:tick.
# Keep this function lightweight and do not revoke advancements here.
execute if score #rtwrapper rtk.loaded matches 1 run scoreboard players add #rtwrapper_ticks rtk.loaded 0
