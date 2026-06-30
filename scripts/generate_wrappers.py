#!/usr/bin/env python3
"""Generate RTWrapper command macro wrappers for the current target manifest.

The generated 26.2 wrappers intentionally do NOT use a single catch-all
and do NOT expose meaningless numeric positional names.
Every command has a dispatcher plus parameter-count variants using meaningful
names for that command.

Example variants:
- tp_4:          $tp $(target) $(x) $(y) $(z)
- give_3:        $give $(target) $(item) $(count)
- scoreboard_5:  $scoreboard $(category) $(action) $(subject) $(objective) $(value)

Provide contiguous parameters in the documented order for a command. If a
syntax branch needs to group multiple vanilla tokens, put that group in one
parameter value.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACK = ROOT / "datapack" / "RTWrapper-Datapack"
INTERNAL_DIR = PACK / "data" / "rtwrapper" / "function" / "core" / "wrappers" / "internal"
VARIANT_DIR = INTERNAL_DIR / "variants"
API_CMD_DIR = PACK / "data" / "rtwrapper" / "function" / "api" / "commands"
HANDLER_DIR = PACK / "data" / "rtwrapper" / "function" / "core" / "wrappers" / "handler"

TARGET = "Java Edition 26.2"
PACK_FORMAT = 104

# Java Edition 26.2 normal commands and aliases.
COMMANDS = [
    "advancement", "attribute", "ban", "ban-ip", "banlist", "bossbar", "clear",
    "clone", "damage", "data", "datapack", "debug", "defaultgamemode", "deop",
    "dialog", "difficulty", "effect", "enchant", "execute", "experience", "fetchprofile",
    "fill", "fillbiome", "forceload", "function", "gamemode", "gamerule", "give",
    "help", "item", "jfr", "kick", "kill", "list", "locate", "loot", "me",
    "msg", "op", "pardon", "pardon-ip", "particle", "perf", "place", "playsound",
    "publish", "random", "recipe", "reload", "return", "ride", "rotate", "save-all",
    "save-off", "save-on", "say", "schedule", "scoreboard", "seed", "setblock",
    "setidletimeout", "setworldspawn", "spawnpoint", "spectate", "spreadplayers", "stop",
    "stopsound", "stopwatch", "summon", "swing", "tag", "team", "teammsg", "teleport",
    "tell", "tellraw", "test", "tick", "time", "title", "tm", "tp", "transfer", "trigger",
    "unpublish", "version", "w", "waypoint", "weather", "whitelist", "worldborder", "xp",
]

# Debug/dev commands present in Java builds only when debug properties are enabled.
DEBUG_COMMANDS = [
    "chase", "debugconfig", "debugmobspawning", "debugpath", "raid", "serverpack",
    "spawn_armor_trims", "warden_spawn_tracker",
]

# Commands that are known to parse without parameters. Every other _0 variant
# returns fail to avoid datapack load errors from incomplete commands.
ZERO_PARAM_COMMANDS = {
    "banlist", "difficulty", "help", "list", "reload", "save-all",
    "save-off", "save-on", "seed", "stop", "version",
}

# Meaningful ordered parameter names per command. Keep names lowercase snake_case
# and unique inside each command list. Values can contain spaces, so complex
# syntax branches can still group several vanilla tokens into one parameter.
COMMAND_PARAMS = {
    "advancement": ["action", "targets", "range", "advancement"],
    "attribute": ["target", "attribute", "action", "value", "modifier_id", "modifier_value", "modifier_operation"],
    "ban": ["target", "reason"],
    "ban-ip": ["target", "reason"],
    "banlist": ["filter"],
    "bossbar": ["action", "id", "name", "property", "value", "players"],
    "clear": ["targets", "item", "max_count"],
    "clone": ["begin", "end", "destination", "mask_mode", "clone_mode", "filter"],
    "damage": ["target", "amount", "damage_type", "location_or_by", "source", "cause"],
    "data": ["action", "target_kind", "target", "path", "operation", "source_kind", "source", "source_path", "value"],
    "datapack": ["action", "name", "position", "anchor"],
    "debug": ["action", "target"],
    "defaultgamemode": ["gamemode"],
    "deop": ["targets"],
    "dialog": ["action", "targets", "dialog"],
    "difficulty": ["difficulty"],
    "effect": ["action", "targets", "effect", "duration", "amplifier", "hide_particles"],
    "enchant": ["targets", "enchantment", "level"],
    "execute": [f"step{i:02d}" for i in range(1, 33)],
    "experience": ["action", "targets", "amount", "unit"],
    "fetchprofile": ["name"],
    "fill": ["from_pos", "to_pos", "block", "mode", "filter"],
    "fillbiome": ["from_pos", "to_pos", "biome", "replace", "filter"],
    "forceload": ["action", "from_pos", "to_pos"],
    "function": ["function_id", "mode", "source", "path"],
    "gamemode": ["gamemode", "target"],
    "gamerule": ["rule", "value"],
    "give": ["target", "item", "count"],
    "help": ["command"],
    "item": ["action", "target_kind", "target", "slot", "modifier", "source_kind", "source", "source_slot", "item", "count"],
    "jfr": ["action"],
    "kick": ["target", "reason"],
    "kill": ["targets"],
    "list": ["uuids"],
    "locate": ["category", "id"],
    "loot": ["action", "target", "target_slot", "source_kind", "source", "tool"],
    "me": ["message"],
    "msg": ["target", "message"],
    "op": ["targets"],
    "pardon": ["targets"],
    "pardon-ip": ["target"],
    "particle": ["particle", "pos", "delta", "speed", "count", "mode", "viewers"],
    "perf": ["action"],
    "place": ["type", "id", "pos", "rotation", "mirror", "integrity", "seed"],
    "playsound": ["sound", "source", "targets", "pos", "volume", "pitch", "min_volume"],
    "publish": ["allow_commands", "gamemode", "port"],
    "random": ["action", "range", "sequence"],
    "recipe": ["action", "targets", "recipe"],
    "reload": [],
    "return": ["mode", "value", "command"],
    "ride": ["target", "action", "vehicle"],
    "rotate": ["target", "rotation_or_facing", "facing_position", "facing_entity", "facing_anchor"],
    "save-all": ["flush"],
    "save-off": [],
    "save-on": [],
    "say": ["message"],
    "schedule": ["action", "function_id", "time", "mode"],
    "scoreboard": ["category", "action", "subject", "objective", "value", "operation", "source", "source_objective"],
    "seed": [],
    "setblock": ["pos", "block", "mode"],
    "setidletimeout": ["minutes"],
    "setworldspawn": ["pos", "angle"],
    "spawnpoint": ["targets", "pos", "angle"],
    "spectate": ["target", "player"],
    "spreadplayers": ["center", "spread_distance", "max_range", "height_mode", "respect_teams", "targets"],
    "stop": [],
    "stopsound": ["targets", "source", "sound"],
    "stopwatch": ["action", "id"],
    "summon": ["entity", "pos", "nbt"],
    "swing": ["target", "hand"],
    "tag": ["targets", "action", "name"],
    "team": ["action", "team", "display_name", "option", "value", "targets"],
    "teammsg": ["message"],
    "teleport": ["target", "x", "y", "z", "rotation", "facing_mode", "facing_target", "facing_anchor"],
    "tell": ["target", "message"],
    "tellraw": ["targets", "message"],
    "test": ["action", "test_name", "rotation", "tests_per_row"],
    "tick": ["action", "value"],
    "time": ["action", "value"],
    "title": ["targets", "action", "title", "fade_in", "stay", "fade_out"],
    "tm": ["message"],
    "tp": ["target", "x", "y", "z", "rotation", "facing_mode", "facing_target", "facing_anchor"],
    "transfer": ["hostname", "port", "players"],
    "trigger": ["objective", "action", "value"],
    "unpublish": [],
    "version": [],
    "w": ["target", "message"],
    "waypoint": ["action", "id", "property", "value", "targets"],
    "weather": ["weather", "duration"],
    "whitelist": ["action", "target"],
    "worldborder": ["action", "value", "time"],
    "xp": ["action", "targets", "amount", "unit"],
    "chase": ["action", "targets"],
    "debugconfig": ["action", "option", "value"],
    "debugmobspawning": ["action"],
    "debugpath": ["target"],
    "raid": ["action"],
    "serverpack": ["action", "id", "url", "hash"],
    "spawn_armor_trims": ["target"],
    "warden_spawn_tracker": ["target"],
}

CONVENIENCE_WRAPPERS = {
    "tp_pos": """# Convenience macro wrapper for: /tp <target> <x> <y> <z>\n# Required storage keys: target, x, y, z.\n$tp $(target) $(x) $(y) $(z)\n""",
    "tp_pos_rot": """# Convenience macro wrapper for: /tp <target> <x> <y> <z> <rotation>\n# Required storage keys: target, x, y, z, rotation.\n$tp $(target) $(x) $(y) $(z) $(rotation)\n""",
    "teleport_pos": """# Convenience macro wrapper for: /teleport <targets> <x> <y> <z>\n# Required storage keys: targets, x, y, z.\n$teleport $(targets) $(x) $(y) $(z)\n""",
    "teleport_pos_rot": """# Convenience macro wrapper for: /teleport <targets> <x> <y> <z> <rotation>\n# Required storage keys: targets, x, y, z, rotation.\n$teleport $(targets) $(x) $(y) $(z) $(rotation)\n""",
    "give_item": """# Convenience macro wrapper for: /give <target> <item>[components] <count>\n# Required storage keys: target, item, components, count. Use components:\"\" when omitted.\n$give $(target) $(item)$(components) $(count)\n""",
}


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8", newline="\n")


def params_for(cmd: str) -> list[str]:
    try:
        return COMMAND_PARAMS[cmd]
    except KeyError as exc:
        raise KeyError(f"Missing COMMAND_PARAMS entry for {cmd}") from exc


def generated_variant_text(cmd: str, count: int, names: list[str]) -> str:
    if count == 0:
        if cmd in ZERO_PARAM_COMMANDS:
            return f"# RTWrapper generated zero-parameter variant for /{cmd}.\n{cmd}\n"
        return f"# /{cmd} has no safe/generated zero-parameter form in RTWrapper.\nreturn fail\n"

    used = names[:count]
    macros = " ".join(f"$({key})" for key in used)
    return (
        f"# RTWrapper generated {count}-parameter macro variant for /{cmd}.\n"
        f"# Parameters: {', '.join(used)}\n"
        f"${cmd} {macros}\n"
    )


def generated_dispatcher_text(cmd: str, names: list[str]) -> str:
    lines = [
        f"# RTWrapper generated named-parameter dispatcher for /{cmd}.",
        "# Provide contiguous parameters in this order:",
        f"# {', '.join(names) if names else '(none)'}",
        "scoreboard players set #pc rtw.status 0",
    ]
    for count, name in enumerate(names, start=1):
        lines.append(
            f"execute if data storage rtwrapper:runtime current.params.{name} "
            f"run scoreboard players set #pc rtw.status {count}"
        )
    lines.append(
        f"execute if score #pc rtw.status matches 0 "
        f"run function rtwrapper:core/wrappers/internal/variants/{cmd}_0"
    )
    for count in range(1, len(names) + 1):
        lines.append(
            f"execute if score #pc rtw.status matches {count} "
            f"run function rtwrapper:core/wrappers/internal/variants/{cmd}_{count} "
            f"with storage rtwrapper:runtime current.params"
        )
    return "\n".join(lines) + "\n"


def generated_api_command_text(cmd: str, names: list[str]) -> str:
    return (
        f"# Direct named-parameter API for /{cmd}.\n"
        f"# Parameter order: {', '.join(names) if names else '(none)'}\n"
        "data modify storage rtwrapper:runtime current.params set from storage rtwrapper:api params\n"
        f"function rtwrapper:core/wrappers/internal/{cmd}\n"
        "data remove storage rtwrapper:runtime current.params\n"
    )


def validate_param_names() -> None:
    expected_commands = set(COMMANDS + DEBUG_COMMANDS)
    actual_commands = set(COMMAND_PARAMS)
    missing = sorted(expected_commands - actual_commands)
    extra = sorted(actual_commands - expected_commands)
    if missing or extra:
        raise SystemExit(f"COMMAND_PARAMS mismatch; missing={missing}, extra={extra}")
    for cmd, names in COMMAND_PARAMS.items():
        if len(names) != len(set(names)):
            raise SystemExit(f"Duplicate parameter names for {cmd}: {names}")
        for name in names:
            if not name.replace("_", "").isalnum() or name[0].isdigit() or name != name.lower():
                raise SystemExit(f"Invalid parameter name for {cmd}: {name}")


def main() -> None:
    validate_param_names()
    INTERNAL_DIR.mkdir(parents=True, exist_ok=True)
    VARIANT_DIR.mkdir(parents=True, exist_ok=True)
    API_CMD_DIR.mkdir(parents=True, exist_ok=True)
    HANDLER_DIR.mkdir(parents=True, exist_ok=True)

    for directory in (INTERNAL_DIR, VARIANT_DIR, API_CMD_DIR):
        if directory.exists():
            for file in directory.glob("*.mcfunction"):
                file.unlink()

    # Remove obsolete handler helpers from older generator versions.
    for obsolete in ("detect_argc.mcfunction", "detect_param_count.mcfunction", "normalize_args.mcfunction"):
        path = HANDLER_DIR / obsolete
        if path.exists():
            path.unlink()

    for cmd in COMMANDS + DEBUG_COMMANDS:
        names = params_for(cmd)
        write(INTERNAL_DIR / f"{cmd}.mcfunction", generated_dispatcher_text(cmd, names))
        write(API_CMD_DIR / f"{cmd}.mcfunction", generated_api_command_text(cmd, names))
        for count in range(len(names) + 1):
            write(VARIANT_DIR / f"{cmd}_{count}.mcfunction", generated_variant_text(cmd, count, names))

    for name, content in CONVENIENCE_WRAPPERS.items():
        write(INTERNAL_DIR / f"{name}.mcfunction", content)
        write(
            API_CMD_DIR / f"{name}.mcfunction",
            "# Direct API convenience wrapper. Put named params in storage rtwrapper:api params.\n"
            f"function rtwrapper:core/wrappers/internal/{name} with storage rtwrapper:api params\n",
        )

    metadata = {
        "target": TARGET,
        "pack_format": PACK_FORMAT,
        "namespace": "rtwrapper",
        "variant_dispatch": True,
        "command_params": COMMAND_PARAMS,
        "wrapper_protocol": {
            "queued_request": "storage rtwrapper:api request = {cmd:\"<wrapper file>\", params:{<meaningful_name>:\"<token/group>\", ...}} then function rtwrapper:api/run",
            "direct_params": "storage rtwrapper:api params = {<meaningful_name>:\"<token/group>\", ...} then function rtwrapper:api/commands/<command>",
            "parameter_rule": "provide contiguous parameters in the order listed for the command; unused empty params are not appended",
            "convenience_params": "tp_pos/tp_pos_rot/teleport_pos/teleport_pos_rot/give_item accept named macro variables for common forms",
        },
        "commands": COMMANDS,
        "debug_commands": DEBUG_COMMANDS,
        "convenience_wrappers": sorted(CONVENIENCE_WRAPPERS),
    }
    write(ROOT / "datapack" / "commands-26.2.json", json.dumps(metadata, indent=2) + "\n")
    variant_count = sum(len(params_for(cmd)) + 1 for cmd in COMMANDS + DEBUG_COMMANDS)
    print(
        f"Generated {len(COMMANDS) + len(DEBUG_COMMANDS)} command dispatchers, "
        f"{variant_count} variants, + {len(CONVENIENCE_WRAPPERS)} convenience wrappers"
    )


if __name__ == "__main__":
    main()
