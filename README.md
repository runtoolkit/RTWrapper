# RTWrapper

RTWrapper is a Fabric mod + standalone datapack for Minecraft Java Edition 26.2. The mod embeds the same datapack data tree, while `datapack/RTWrapper-Datapack/` can be zipped and installed separately.

## Requirements

| Component | Version |
| --- | --- |
| Minecraft | 26.2 |
| Java | 25 |
| Fabric Loader | see `fabric.mod.json` |
| Fabric API | see `gradle.properties` |
| Gradle | 9.5+ |
| Optional dependency | [StringLib](https://github.com/CMDred/StringLib) for CRE player-name selector validation |

## Installation

### Fabric mod

1. Build or download `rtwrapper-<version>.jar`.
2. Put it in `mods/` with Fabric API.
3. Run `/reload` once after the server starts.
4. Check status:

```mcfunction
function runtoolkit:api/status
```

### Standalone datapack

1. Put `RTWrapper-Datapack-<version>.zip` in `<world>/datapacks/`.
2. Optional but recommended: put StringLib in the same datapacks folder.
3. Run:

```mcfunction
reload
function runtoolkit:api/status
```

Do not install both the mod and standalone datapack at the same time; both provide the same namespaces.

## Basic request API

Generated command wrappers use meaningful command-specific parameter names. There is no generated catch-all or generic numeric parameter API.

```mcfunction
# /tp @s 0 80 0
data modify storage rtwrapper:api request set value {cmd:"tp",params:{target:"@s",x:"0",y:"80",z:"0"},runSafeMode:1b}
function rtwrapper:api/run

# /give @s minecraft:stone 1
data modify storage rtwrapper:api request set value {cmd:"give",params:{target:"@s",item:"minecraft:stone",count:"1"},runSafeMode:1b}
function rtwrapper:api/run

# direct command API
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",count:"1"}
function rtwrapper:api/commands/give
```

Parameter order and names are in `datapack/commands-26.2.json` under `command_params`.

## runSafeMode

Single request `runSafeMode` defaults to `0b`.

- `runSafeMode:0b`: immediate full queue drain.
- `runSafeMode:1b`: safe one-step execution via `run_next`.

Prefer `runSafeMode:1b` for player/user-generated requests.

## Batch requests

Use `rtwrapper:api/run_many` for conditional multi-request execution.

```mcfunction
data modify storage rtwrapper:api batch set value {runSafeMode:1b,requests:[{req:{cmd:"give",params:{target:"@s",item:"minecraft:stone",count:"1"}},args:[{type:"score",name:"#allow",objective:"myScore",value:"1"}]},{req:{cmd:"function",params:{function_id:"my_pack:do_thing"}},args:[{type:"predicate",id:"my_pack:my_predicate"}]}]}
function rtwrapper:api/run_many
```

Each item is:

```snbt
{req:{...normal RTWrapper request...},args:[...conditions...]}
```

Supported conditions:

```snbt
{type:"predicate",id:"my_pack:my_predicate"}
{type:"score",name:"#allow",objective:"myScore",value:"1"}
{type:"score",name:"#allow",score:"myScore",value:"1"}
```

## Queue / autotick

```mcfunction
function rtwrapper:api/autotick/on

data modify storage rtwrapper:api request set value {cmd:"say",params:{message:"queued hello"},runSafeMode:1b}
function rtwrapper:api/enqueue
```

Autotick processes one queued action per tick. Use `function rtwrapper:api/run` only for immediate full queue drain.

## Core selector detection

Selector detection lives in `core:selector/detect`.

```mcfunction
data modify storage core:selector input.value set value "@s"
function core:selector/detect
data get storage core:selector result
```

Allowed:

- player names, validated with StringLib as no `@` and length 3..16
- `@s`
- restricted `@a[limit=1]` / nearest variants
- restricted `@e[type=player,limit=1]` / nearest variants

Rejected:

- `@p`
- `@r`
- unrestricted `@a`
- unrestricted or non-player `@e`

The detector reads storage first and returns fail when `storage core:selector input.value` is missing.

## Runtoolkit manager

RTWrapper installs the shared `runtoolkit` namespace and manager tags:

```text
#runtoolkit:register
#runtoolkit:load
#runtoolkit:tick
#runtoolkit:list
#runtoolkit:enable
#runtoolkit:disable
#runtoolkit:reload
```

Useful commands:

```mcfunction
function runtoolkit:api/list
function runtoolkit:api/status
function runtoolkit:api/dump_registry
function runtoolkit:dpman
```

Manager enable/disable/reload controls Runtoolkit hooks, not vanilla `/datapack enable|disable`:

```mcfunction
data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/disable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/enable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/reload
```

There is no RTWrapper dialog UI, no `rtwrapper.testMode` tag, and no `RTWrapper` trigger objective.

## Build

```bash
python3 scripts/validate_datapack.py
./gradlew build
```

Build outputs:

- `build/libs/rtwrapper-<version>.jar`
- `build/libs/RTWrapper-Datapack-<version>.zip`

## Updating command wrappers

1. Edit `COMMANDS`, `DEBUG_COMMANDS`, and `COMMAND_PARAMS` in `scripts/generate_wrappers.py`.
2. Run:

```bash
python3 scripts/generate_wrappers.py
python3 scripts/validate_datapack.py
./gradlew build
```

## License

MIT. See [`LICENSE`](LICENSE).

## Safety

RTWrapper exposes privileged macro-command execution for trusted datapacks/admins. Do not copy untrusted player-controlled text into `rtwrapper:api request` or `rtwrapper:api params`.
