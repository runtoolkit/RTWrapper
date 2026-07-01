# Storage-backed menu launcher.
execute unless data storage rtwrapper:ui menu.target run data modify storage rtwrapper:ui menu.target set value "@s"
execute unless data storage rtwrapper:ui menu.item run data modify storage rtwrapper:ui menu.item set value "minecraft:stone"
execute unless data storage rtwrapper:ui menu.count run data modify storage rtwrapper:ui menu.count set value "1"
execute unless data storage rtwrapper:ui menu.x run data modify storage rtwrapper:ui menu.x set value "0"
execute unless data storage rtwrapper:ui menu.y run data modify storage rtwrapper:ui menu.y set value "80"
execute unless data storage rtwrapper:ui menu.z run data modify storage rtwrapper:ui menu.z set value "0"
execute unless data storage rtwrapper:ui menu.selector run data modify storage rtwrapper:ui menu.selector set value "@s"
execute unless data storage rtwrapper:ui menu.safe run data modify storage rtwrapper:ui menu.safe set value "1b"
function rtwrapper:ui/open/render with storage rtwrapper:ui menu
