# RTWrapper

RTWrapper is a Fabric mod + standalone datapack for Java Edition 26.2. The mod embeds the same datapack data tree, while `datapack/RTWrapper-Datapack/` can be zipped and installed separately.

## Requirements

| Component        | Version                          |
|-------------------|-----------------------------------|
| Minecraft         | 26.2 ("Chaos Cubed")              |
| Java              | 25 (JDK 25 toolchain required)    |
| Fabric Loader     | matches `fabric.mod.json` — verify against `build/libs` manifest before release |
| Fabric API        | matches `fabric.mod.json`         |
| Gradle            | 9.5+                              |
| Pack format       | see `pack.mcmeta` in the datapack root — bump this in lockstep with `PACK_FORMAT` in `scripts/generate_wrappers.py` |

RTWrapper is built and tested against 26.2 only. It has not been validated against 26.1 or 26.3 — see "Updating command wrappers" below before attempting cross-version use.

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

Named convenience wrapper example:

```mcfunction
# $give $(target) $(item)$(components) $(count)
data modify storage rtwrapper:api params set value {target:"@s",item:"minecraft:stone",components:"",count:"1"}
function rtwrapper:api/commands/give_item
```

### `run` vs `enqueue`/autotick

Two distinct execution paths exist — they are not interchangeable:

- **`rtwrapper:api/run`** executes the request in `rtwrapper:api request` (or `rtwrapper:api params` for direct command wrappers) immediately, synchronously, in the current tick. Use this for one-off calls where you need the result available before your function continues.
- **`rtwrapper:api/enqueue`** + autotick pushes the request onto a queue that is drained one action per tick by `rtwrapper:api/autotick/on`. Use this when issuing many commands in a burst (e.g. spawning many entities, batch scoreboard writes) where spreading load across ticks avoids a single-tick lag spike. The tradeoff is latency: an enqueued action is not guaranteed to execute in the same tick it was queued.

Calling `rtwrapper:api/run` while autotick is on and the queue is non-empty performs a full immediate drain of the queue — see below.

Autotick usage:

```mcfunction
function rtwrapper:api/autotick/on
data modify storage rtwrapper:api request set value {cmd:"say",params:{message:"queued hello"}}
function rtwrapper:api/enqueue
```

Autotick processes one queued action per tick. Use `function rtwrapper:api/run` only for immediate full queue drain.

See [`docs/API.md`](docs/API.md) for the full protocol and debug/silent controls.

## `commands-26.2.json`

This file is the single source of truth for what `generate_wrappers.py` emits — it is not just a manifest, it defines every wrapper function that exists under `rtwrapper:api/commands/`. Structure:

- Top-level: one entry per supported vanilla command (`tp`, `give`, `scoreboard`, etc.)
- Each entry lists ordered parameter names for that command's positional wrapper variant(s) — this is what determines the exact param order you must supply in `params:{...}` when calling that command's `<command>_<N>` variant.
- Named convenience wrappers (like `give_item`) are derived from this file per the macro syntax comment above their definition (e.g. `$give $(target) $(item)$(components) $(count)`).

If you add or change a command's parameters, edit this file first, then regenerate (see "Updating command wrappers" below) — hand-editing generated function files under `data/rtwrapper/function/api/commands/` directly will be overwritten on next generation.

## Build

Minecraft 26.2 targets Java 25. Use a JDK 25 toolchain and Gradle 9.5+. For 26.1+ Fabric, the build uses `net.fabricmc.fabric-loom` with Mojang official names directly, so there is intentionally no `mappings loom.officialMojangMappings()` dependency.

```bash
python3 scripts/validate_datapack.py
./gradlew build
```

Build outputs:
- Fabric mod jar: `build/libs/rtwrapper-<version>.jar`
- Standalone datapack zip: `build/libs/RTWrapper-Datapack-<version>.zip`

The `build` task also runs server GameTests through Fabric API's GameTest integration — these spin up a headless test server as part of the Gradle build itself (not a separate CI-only step) and will fail the build on test failure. Running `./gradlew build` locally runs the same GameTests that run in CI; there is no separate local/CI test split. To run only the GameTests without a full build, use:

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

Bumping `PACK_FORMAT` without updating every consuming datapack (including any `runtoolkit:` namespace dependents) will silently break `/reload` behavior on older packs — Minecraft does not always hard-error on a pack_format mismatch, it may just warn and load anyway with undefined wrapper behavior. Verify with `function runtoolkit:api/status` after any pack_format bump, don't assume silence means success.

## License

No license file is currently present in this repository. Until one is added, default copyright applies and no reuse, modification, or redistribution rights are granted to third parties beyond what's needed to view the source. If this repo is intended to be public or to accept external contributions, add a `LICENSE` file before relying on that assumption.

## Safety

RTWrapper intentionally exposes privileged macro-command execution for trusted datapacks/admins. Do not copy untrusted player-controlled text into `rtwrapper:api request` or `rtwrapper:api params`.
