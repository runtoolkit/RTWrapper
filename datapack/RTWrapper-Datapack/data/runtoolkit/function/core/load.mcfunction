# Runtoolkit common registry bootstrap.
# This namespace is shared by Runtoolkit datapacks so loaded modules can be
# discovered without relying on /datapack list.
scoreboard objectives add rtk.loaded dummy
function runtoolkit:packs/rtwrapper/register
