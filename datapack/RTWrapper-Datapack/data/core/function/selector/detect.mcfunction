# Core selector detector.
# Input:  storage core:selector input.value = "<player name or allowed selector>"
# Output: storage core:selector result = {valid:<bool>,kind:"...",value:"..."}
# Return: success if accepted, fail if missing/rejected.
# Allowed: player names (StringLib-checked no @), @s, restricted @a, restricted @e[type=player,...].
# Rejected: @p, @r, unrestricted @a, unrestricted @e, any string containing @ that is not exact-allowlisted.
scoreboard objectives add core.selector dummy
scoreboard objectives add rtw.temp dummy
scoreboard players set #valid core.selector 0
scoreboard players set #has_at core.selector 0
scoreboard players set #length core.selector 0
scoreboard players set #selector_valid rtw.temp 0
data modify storage core:selector result set value {valid:0b,kind:"missing",reason:"missing input.value"}
execute unless data storage core:selector input.value run return fail

data modify storage core:selector result set value {valid:0b,kind:"rejected",reason:"not an allowed selector/player name"}
execute if entity @s run scoreboard players set @s rtw.temp 0

# Exact allowed selector forms.
execute if data storage core:selector input{value:"@s"} run function core:selector/private/accept_self
execute if data storage core:selector input{value:"@a[limit=1]"} run function core:selector/private/accept_limited_all
execute if data storage core:selector input{value:"@a[sort=nearest,limit=1]"} run function core:selector/private/accept_limited_all
execute if data storage core:selector input{value:"@a[limit=1,sort=nearest]"} run function core:selector/private/accept_limited_all
execute if data storage core:selector input{value:"@e[type=player,limit=1]"} run function core:selector/private/accept_limited_entity_player
execute if data storage core:selector input{value:"@e[type=player,sort=nearest,limit=1]"} run function core:selector/private/accept_limited_entity_player
execute if data storage core:selector input{value:"@e[type=player,limit=1,sort=nearest]"} run function core:selector/private/accept_limited_entity_player
execute if score #valid core.selector matches 1.. run return 1

# Player-name validation needs StringLib. If StringLib is not detected, fail safely.
execute unless score stringlib rtk.enabled matches 1.. run data modify storage core:selector result set value {valid:0b,kind:"missing_dependency",reason:"StringLib required for player-name validation"}
execute unless score stringlib rtk.enabled matches 1.. run return fail

# Reject any string containing @. If no @ and length is 3..16, accept as player name.
data modify storage stringlib:input find.String set from storage core:selector input.value
data modify storage stringlib:input find.Find set value "@"
data modify storage stringlib:input find.n set value 1
execute store success score #has_at core.selector run function stringlib:util/find
execute store result score #length core.selector run data get storage core:selector input.value
execute if score #has_at core.selector matches 0 if score #length core.selector matches 3..16 run function core:selector/private/accept_player_name
execute if score #valid core.selector matches 1.. run return 1
return fail
