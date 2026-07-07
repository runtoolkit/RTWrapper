# RTWrapper

RTWrapper is a Fabric mod + standalone datapack for Java Edition 26.2. The mod embeds the same datapack data tree, while `datapack/RTWrapper-Datapack/` can be zipped and installed separately.

--
# ⚠️ WARNING — DO NOT DOWNLOAD OR RUN THIS DATAPACK

**Do not download, install, or run this datapack unless you fully understand its contents and trust its source.**

This repository contains experimental development and testing components. It is **not intended for general use** and may be incomplete, unstable, or unsafe for production environments.

If you are looking for a normal Minecraft datapack, **this is not one**. Use it only for development or security research in an isolated environment after reviewing the source code.

**If you are unsure what this project does, do not use it.**

---

## Layout

```text
src/main/                         Fabric mod skeleton, Mojang official names
datapack/RTWrapper-Datapack/      Standalone datapack root
datapack/commands-26.2.json       Command wrapper manifest + command parameter names
docs/API.md                       API/storage protocol
scripts/validate_datapack.py      Datapack/static wrapper validator
src/gametest/                     Fabric server GameTests
```

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

Autotick usage:

```mcfunction
function rtwrapper:api/autotick/on

data modify storage rtwrapper:api request set value {cmd:"say",params:{message:"queued hello"}}
function rtwrapper:api/enqueue
```

Autotick processes one queued action per tick. Use `function rtwrapper:api/run` only for immediate full queue drain.

See [`docs/API.md`](docs/API.md) for the full protocol and debug/silent controls.

## Loaded-pack discovery

RTWrapper also installs the shared `runtoolkit` namespace:

```text
data/runtoolkit/function/...
data/runtoolkit/advancement/root.json
data/runtoolkit/advancement/packs/rtwrapper.json
```

After `/reload`, players get a visible **Advancements > Runtoolkit** tab via the `minecraft:tick` advancement trigger. This is intentionally not revoked, so it can be used as a stable visual list of loaded Runtoolkit datapacks without reading a long `/datapack list` output.

Quick check:

```mcfunction
function runtoolkit:api/status
```

## Build

Minecraft 26.2 targets Java 25. Use a JDK 25 toolchain and Gradle 9.5+. For 26.1+ Fabric, the build uses `net.fabricmc.fabric-loom` with Mojang official names directly, so there is intentionally no `mappings loom.officialMojangMappings()` dependency.

```bash
python3 scripts/validate_datapack.py
./gradlew build
```

Build outputs:

- Fabric mod jar: `build/libs/rtwrapper-<version>.jar`
- Standalone datapack zip: `build/libs/RTWrapper-Datapack-<version>.zip`

The `build` task also runs server GameTests through Fabric API's GameTest integration.

## Updating command wrappers for 26.3+

1. Update `COMMANDS` / `DEBUG_COMMANDS` and `COMMAND_PARAMS` in `scripts/generate_wrappers.py`.
2. Update `minecraft_version`, `fabric_version`, and possibly `PACK_FORMAT`.
3. Run:

```bash
python3 scripts/generate_wrappers.py
python3 scripts/validate_datapack.py
./gradlew build
```

## Safety

RTWrapper intentionally exposes privileged macro-command execution for trusted datapacks/admins. Do not copy untrusted player-controlled text into `rtwrapper:api request` or `rtwrapper:api params`.
