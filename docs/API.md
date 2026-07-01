# RTWrapper API

Namespace: `rtwrapper`
Target: Java Edition 26.2.

## Single request

```mcfunction
data modify storage rtwrapper:api request set value {cmd:"give",params:{target:"@s",item:"minecraft:stone",count:"1"},runSafeMode:1b}
function rtwrapper:api/run
```

`type` is accepted as an alias for `cmd`.

`runSafeMode` defaults to `0b`:

- `0b`: immediate full drain.
- `1b`: safe one-step execution.

## Direct command API

```mcfunction
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",count:"1"}
function rtwrapper:api/commands/give
```

Parameter names are defined in `datapack/commands-26.2.json`.

## Batch requests

```mcfunction
data modify storage rtwrapper:api batch set value {runSafeMode:1b,requests:[{req:{cmd:"give",params:{target:"@s",item:"minecraft:stone",count:"1"}},args:[{type:"score",name:"#allow",objective:"myScore",value:"1"}]},{req:{cmd:"function",params:{function_id:"my_pack:do_thing"}},args:[{type:"predicate",id:"my_pack:my_predicate"}]}]}
function rtwrapper:api/run_many
```

Item shape:

```snbt
{req:{...normal RTWrapper request...},args:[...conditions...]}
```

Supported conditions:

```snbt
{type:"predicate",id:"my_pack:my_predicate"}
{type:"score",name:"#allow",objective:"myScore",value:"1"}
{type:"score",name:"#allow",score:"myScore",value:"1"}
```

Internally `args[]` is copied to `conditions[]` on the queued request.

## Queue and autotick

```mcfunction
function rtwrapper:api/autotick/on

data modify storage rtwrapper:api request set value {cmd:"say",params:{message:"queued hello"},runSafeMode:1b}
function rtwrapper:api/enqueue
```

Autotick runs one action per tick.

## Core selector detection

```mcfunction
data modify storage core:selector input.value set value "@s"
function core:selector/detect
data get storage core:selector result
```

Allowed:

- player names, StringLib-validated as no `@` and length 3..16
- `@s`
- restricted `@a[limit=1]` forms
- restricted `@e[type=player,limit=1]` forms

Rejected:

- `@p`
- `@r`
- unrestricted `@a`
- unrestricted or non-player `@e`

If input storage is missing, the function returns fail before doing detection.

## Runtoolkit manager

```mcfunction
function runtoolkit:api/list
function runtoolkit:api/status
function runtoolkit:api/dump_registry
function runtoolkit:dpman
```

Manager hooks:

```text
#runtoolkit:register
#runtoolkit:load
#runtoolkit:tick
#runtoolkit:list
#runtoolkit:enable
#runtoolkit:disable
#runtoolkit:reload
```

RTWrapper's manager hooks are stateful and do more than print text. They maintain:

```text
storage runtoolkit:state packs.rtwrapper
storage runtoolkit:runtime list.rtwrapper
storage runtoolkit:runtime missing_dependencies
scoreboard rtk.enabled / rtk.loaded / rtk.status
```

`disable` also disables `#auto_tick` and clears `storage rtwrapper:runtime queue` so disabled manager hooks cannot continue processing queued work.


Enable/disable/reload one managed pack:

```mcfunction
data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/disable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/enable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/reload
```

Dependency helper:

```mcfunction
data modify storage runtoolkit:api request set value {id:"required_pack"}
function runtoolkit:api/require
```

The Runtoolkit advancement registry uses `minecraft:tick` and is never revoked.

## Restored trigger menus

RTWrapper provides an opt-in menu system gated behind `rtwrapper.testMode`.

```mcfunction
function rtwrapper:api/testmode/on
trigger RTWrapper set 1
```

Trigger values:

```mcfunction
trigger RTWrapper set 1  # RTWrapper main menu
trigger RTWrapper set 2  # Run current request
trigger RTWrapper set 3  # List wrappers in chat
trigger RTWrapper set 4  # Runtoolkit manager menu
trigger RTWrapper set 5  # Batch request menu
trigger RTWrapper set 6  # core:selector tools menu
```

The menus use inline `dialog show` screens and are wired to current APIs: `core:selector/detect`, `rtwrapper:api/run_many`, `runSafeMode`, and `runtoolkit:dpman`. The dialogs use input controls (`text`, `boolean`, `single_option`). Storage-backed menus render current defaults through macro functions, and every dialog action dispatches through `trigger RTWrapper set ...`; option ids use the `-0<number>` form such as `-01`, `-010`, `-024`. Disable access:

```mcfunction
function rtwrapper:api/testmode/off
```
