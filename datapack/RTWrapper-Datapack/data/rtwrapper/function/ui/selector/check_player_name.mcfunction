data modify storage core:selector input.value set value "Steve"
execute store success score @s rtw.temp run function core:selector/detect
data get storage core:selector result
