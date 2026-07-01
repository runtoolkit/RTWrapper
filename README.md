# RTWrapper

RTWrapper is a Fabric mod + standalone datapack for Java Edition 26.2. The mod embeds the same datapack data tree, while `datapack/RTWrapper-Datapack/` can be zipped and installed separately.

## Requirements

| Component | Version |
| --- | --- |
| Minecraft | 26.2 ("Chaos Cubed") |
| Java | 25 (JDK 25 toolchain required) |
| Fabric Loader | matches `fabric.mod.json` — verify against `build/libs` manifest before release |
| Fabric API | matches `fabric.mod.json` |
| Gradle | 9.5+ |
| Pack format | see `pack.mcmeta` in the datapack root — bump this in lockstep with `PACK_FORMAT` in `scripts/generate_wrappers.py` |

RTWrapper is built and tested against 26.2 only. It has not been validated against 26.1 or 26.3 — see "Updating command wrappers" below before attempting cross-version use.

Optional-but-managed dependency: [StringLib](https://github.com/CMDred/StringLib). RTWrapper's selector-detection helpers and dependency manager probe `stringlib:util/find`; install StringLib if you want those helpers and a clean dependency status.

## Layout

```text
src/main/                         Fabric mod skeleton, Mojang official names
datapack/RTWrapper-Datapack/      Standalone datapack root
datapack/commands-26.2.json       Command wrapper manifest + command parameter names
docs/API.md                       API/storage protocol
scripts/validate_datapack.py      Datapack/static wrapper validator
src/gametest/                     Fabric server GameTests
```

## Installation

### As a Fabric mod

1. Install Fabric Loader for Minecraft 26.2.
2. Install Fabric API matching your Loader version.
3. Download or build `rtwrapper-<version>.jar` (see Build below).
4. Drop the jar into your `mods/` folder.
5. Launch the game or server. The mod embeds its datapack automatically — no separate install step needed.
6. In-world, run `/reload` once to ensure the embedded datapack functions are registered, then verify with:

   ```mcfunction
   function runtoolkit:api/status
   ```

### As a standalone datapack (no mod)

1. Download or build `RTWrapper-Datapack-<version>.zip` (see Build below).
2. Place the zip into your world's `datapacks/` folder (`<world>/datapacks/RTWrapper-Datapack-<version>.zip`), or into `datapacks/` under your server root for a server.
3. If the world is already running, run `/reload`. Otherwise this loads automatically on world start.
4. Confirm the datapack is active — check **Advancements > Runtoolkit** in-game, or run:

   ```mcfunction
   function runtoolkit:api/status
   ```

Do not install both the mod and the standalone datapack zip on the same instance — they embed the same `rtwrapper:` and `runtoolkit:` namespaces and will conflict on `/reload` (duplicate function/advancement registration). Pick one.

## Datapack API quick start

Generated command wrappers use meaningful command-specific parameter names. There is no generated catch-all or generic numeric parameter API.

Provide the named parameters in the order listed for that command in `datapack/commands-26.2.json`. The dispatcher calls the exact `<command>_<N>` variant and does not append unused params.

```mcfunction
# /tp @s 0 80 0 via queued handler
data modify storage rtwrapper:api request set value {cmd:"tp",params:{target:"@s",x:"0",y:"80",z:"0"}}
function rtwrapper:api/run

# /give @s minecraft:stone 1 via direct API
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",count:"1"}
function rtwrapper:api/commands/give

# /scoreboard players set #smoke rtw.test 1
data modify storage rtwrapper:api request set value {cmd:"scoreboard",params:{category:"players",action:"set",subject:"#smoke",objective:"rtw.test",value:"1"}}
function rtwrapper:api/run
```

## In-game trigger UI (testMode)

RTWrapper creates these objectives on load:

```mcfunction
scoreboard objectives add rtw.temp dummy
scoreboard objectives add RTWrapper trigger
```

`rtw.temp` is used by temporary UI/trigger systems: `1` means accepted/success, `0` means canceled/error. In-game trigger UI is gated behind the `rtwrapper.testMode` tag. Enable it per player:

```mcfunction
function rtwrapper:api/testmode/on
```

Then use:

```mcfunction
trigger RTWrapper set 1  # Open RTWrapper dialog
trigger RTWrapper set 2  # Run current rtwrapper:api request via rtwrapper:api/run
trigger RTWrapper set 3  # List command wrappers in chat
trigger RTWrapper set 4  # Open runtoolkit:dpman
```

Disable test mode:

```mcfunction
function rtwrapper:api/testmode/off
```

Named convenience wrapper example:

```mcfunction
# $give $(target) $(item)$(components) $(count)
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",components:"",count:"1"}
function rtwrapper:api/commands/give_item
```

### `run` vs `enqueue` / autotick

Two distinct execution paths exist — they are not interchangeable:

- **`rtwrapper:api/run`** executes the request in `rtwrapper:api request` immediately and drains the queue synchronously in the current tick. Use this for one-off calls where you need the result before your function continues.
- **`rtwrapper:api/enqueue`** pushes the request onto a queue. With `rtwrapper:api/autotick/on`, the queue is processed one action per tick. Use this when issuing many commands in a burst where spreading load across ticks avoids a single-tick lag spike.

Autotick usage:

```mcfunction
function rtwrapper:api/autotick/on

data modify storage rtwrapper:api request set value {cmd:"say",params:{message:"queued hello"}}
function rtwrapper:api/enqueue
```

Autotick processes one queued action per tick. Use `function rtwrapper:api/run` only for immediate full queue drain.

See [`docs/API.md`](docs/API.md) for the full protocol and debug/silent controls.

## Runtoolkit manager / loaded-pack discovery

RTWrapper installs the shared `runtoolkit` namespace so Runtoolkit packs can be managed globally:

```text
data/runtoolkit/function/
data/runtoolkit/tags/function/
data/runtoolkit/advancement/root.json
data/runtoolkit/advancement/packs/rtwrapper.json
```

After `/reload`, players get a visible **Advancements > Runtoolkit** tab via the `minecraft:tick` advancement trigger. This is intentionally not revoked, so it can be used as a stable visual list of loaded Runtoolkit datapacks without reading a long `/datapack list` output.

Dynamic list/status:

```mcfunction
function runtoolkit:api/status
function runtoolkit:api/list
function runtoolkit:api/dump_registry
```

Manager controls for one pack:

```mcfunction
data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/disable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/enable

data modify storage runtoolkit:api request set value {id:"rtwrapper"}
function runtoolkit:api/reload
```

Bulk manager hooks:

```mcfunction
function runtoolkit:api/disable_all
function runtoolkit:api/enable_all
function runtoolkit:api/reload_all
```

This manager does not call vanilla `/datapack disable|enable`; it controls Runtoolkit-managed registration/load/tick hooks. Functions still exist when a pack is manager-disabled, but the global manager stops running that pack's managed hooks.

Other Runtoolkit projects can join the system by adding functions to these tags:

```text
#runtoolkit:register
#runtoolkit:load
#runtoolkit:tick
#runtoolkit:list
#runtoolkit:enable
#runtoolkit:disable
#runtoolkit:reload
```

## `commands-26.2.json`

This file is the single source of truth for what `generate_wrappers.py` emits:

- Top-level command lists define supported vanilla commands (`tp`, `give`, `scoreboard`, etc.).
- `command_params` lists ordered meaningful parameter names for each command.
- Named convenience wrappers (like `give_item`) are generated alongside the vanilla command wrappers.

If you add or change a command's parameters, edit `scripts/generate_wrappers.py` first, regenerate, then validate. Hand-editing generated function files under `data/rtwrapper/function/api/commands/` directly will be overwritten on next generation.

## Build

Minecraft 26.2 targets Java 25. Use a JDK 25 toolchain and Gradle 9.5+. For 26.1+ Fabric, the build uses `net.fabricmc.fabric-loom` with Mojang official names directly, so there is intentionally no `mappings loom.officialMojangMappings()` dependency.

```bash
python3 scripts/validate_datapack.py
./gradlew build
```

Build outputs:

- Fabric mod jar: `build/libs/rtwrapper-<version>.jar`
- Standalone datapack zip: `build/libs/RTWrapper-Datapack-<version>.zip`

The `build` task also runs server GameTests through Fabric API's GameTest integration. These spin up a headless test server as part of the Gradle build and fail the build on test failure. To run only the GameTests without a full build, use:

```bash
./gradlew runGametest
```

## Updating command wrappers for 26.3+

1. Update `COMMANDS` / `DEBUG_COMMANDS` and `COMMAND_PARAMS` in `scripts/generate_wrappers.py`.
2. Update `minecraft_version`, `fabric_version`, and possibly `PACK_FORMAT`.
3. Run:

```bash
python3 scripts/generate_wrappers.py
python3 scripts/validate_datapack.py
./gradlew build
```

Bumping `PACK_FORMAT` without updating every consuming datapack (including any `runtoolkit:` namespace dependents) can break `/reload` behavior on older packs. Verify with `function runtoolkit:api/status` after any pack format bump; don't assume silence means success.

## License

MIT. See [`LICENSE`](LICENSE).

## Safety

RTWrapper intentionally exposes privileged macro-command execution for trusted datapacks/admins. Do not copy untrusted player-controlled text into `rtwrapper:api request` or `rtwrapper:api params`.
