# RTWrapper API

Namespace: `rtwrapper`
Target: Java Edition 26.2 / pack format 104.

## Storage protocol

Queued or immediate execution uses `storage rtwrapper:api request`.

RTWrapper no longer uses a single `$(tail)` catch-all. Generated command wrappers use meaningful command-specific parameter names stored under `params`.

```mcfunction
# /tp @s 0 80 0
data modify storage rtwrapper:api request set value {cmd:"tp",params:{target:"@s",x:"0",y:"80",z:"0"}}
function rtwrapper:api/run

# /scoreboard players set #smoke rtw.test 1
data modify storage rtwrapper:api request set value {cmd:"scoreboard",params:{category:"players",action:"set",subject:"#smoke",objective:"rtw.test",value:"1"}}
function rtwrapper:api/run
```

`type` is accepted as an alias for `cmd`:

```mcfunction
data modify storage rtwrapper:api request set value {type:"give",params:{target:"@s",item:"minecraft:stone",count:"1"}}
function rtwrapper:api/run
```

Parameter order is command-specific and recorded in `datapack/commands-26.2.json` under `command_params`. Examples:

```json
{
  "tp": ["target", "x", "y", "z", "rotation", "facing_mode", "facing_target", "facing_anchor"],
  "give": ["target", "item", "count"],
  "scoreboard": ["category", "action", "subject", "objective", "value", "operation", "source", "source_objective"]
}
```

Important rule: provide contiguous parameters in that command's order. The dispatcher detects the highest present meaningful name and calls the matching variant, so unused params are not appended to the final command.

The handler flow is:

```text
rtwrapper:api/run
  -> core/run/run_actions
    -> core/wrappers/handler/main
      -> proc
        -> dispatch
          -> exec
            -> core/wrappers/internal/<cmd>
              -> core/wrappers/internal/variants/<cmd>_<N>
```

A generated variant looks like:

```mcfunction
$<command> $(meaningful_name_a) $(meaningful_name_b) ...
```

Put one token or one already-formatted Brigadier group in each parameter. For example, JSON/text messages can still be stored as one parameter value if Minecraft expects that parameter as one continuous component.

## Direct API command wrappers

You can also place parameters in `storage rtwrapper:api params` and call a direct API function:

```mcfunction
# /give @s minecraft:stone 1
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",count:"1"}
function rtwrapper:api/commands/give
```

The direct API copies `rtwrapper:api params` to runtime storage and invokes `core/wrappers/internal/<command>`, which chooses the correct `<command>_<N>` variant.

## Convenience named wrappers

The datapack still includes named examples for common macro use:

```mcfunction
# $tp $(target) $(x) $(y) $(z)
data modify storage rtwrapper:api params set value {target:"@s",x:"0",y:"80",z:"0"}
function rtwrapper:api/commands/tp_pos

# $tp $(target) $(x) $(y) $(z) $(rotation)
data modify storage rtwrapper:api params set value {target:"@s",x:"0",y:"80",z:"0",rotation:"0 0"}
function rtwrapper:api/commands/tp_pos_rot

# $give $(target) $(item)$(components) $(count)
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",components:"",count:"1"}
function rtwrapper:api/commands/give_item
```

For `give_item`, `components:""` is allowed because it is concatenated directly to `item`, not appended as a separate trailing token.

## Debug / silent

```mcfunction
function rtwrapper:api/debug/listen
function rtwrapper:api/debug/on
function rtwrapper:api/silent/off
function rtwrapper:api/status
```

`silent` suppresses RTWrapper's own debug/status tellraw output. It intentionally does not permanently toggle vanilla gamerules.

## Auto tick

Auto tick is disabled by default. Enable it only when you want the queue drained every tick:

```mcfunction
function rtwrapper:api/autotick/on
function rtwrapper:api/autotick/off
```

## Security note

Every macro command runs with the permission/context of the function caller. Only write trusted strings into `rtwrapper:api request` or `rtwrapper:api params`.
