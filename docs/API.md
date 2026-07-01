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

## Removed UI systems

RTWrapper no longer provides the experimental dialog UI, `rtwrapper.testMode`, or the `RTWrapper` trigger objective. Use command functions directly.
