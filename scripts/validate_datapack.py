#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACK = ROOT / 'datapack' / 'RTWrapper-Datapack'
META = ROOT / 'datapack' / 'commands-26.2.json'
RESOURCE_RE = re.compile(r'^[a-z0-9_./-]+$')
PARAM_RE = re.compile(r'^[a-z][a-z0-9_]*$')
GENERIC_RE = re.compile(r'\b(?:arg|p)\d+\b')
ADV_REVOKE_RE = re.compile(r'(^|\s)advancement\s+revoke(\s|$)')


def fail(message: str) -> None:
    print(f'[validateDatapack] ERROR: {message}', file=sys.stderr)
    raise SystemExit(1)


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except Exception as exc:  # noqa: BLE001 - validator should print concise failures
        fail(f'{path.relative_to(ROOT)} is not valid JSON: {exc}')


def advancement_uses_tick(path: Path) -> bool:
    data = load_json(path)
    criteria = data.get('criteria')
    if not isinstance(criteria, dict):
        return False
    return any(isinstance(value, dict) and value.get('trigger') == 'minecraft:tick' for value in criteria.values())


def main() -> None:
    if not PACK.exists():
        fail('datapack/RTWrapper-Datapack is missing')

    # Validate every datapack JSON file early, including advancements and tags.
    for path in PACK.rglob('*.json'):
        load_json(path)

    pack_mcmeta = load_json(PACK / 'pack.mcmeta')
    pack_section = pack_mcmeta.get('pack', {})
    if pack_section.get('min_format') != 107 or pack_section.get('max_format') != 107:
        fail('pack.mcmeta must declare min_format=107 and max_format=107 for the 26.2 target')

    required_tag_values = {
        'load': {'rtwrapper:core/load', 'runtoolkit:core/load'},
        'tick': {'rtwrapper:core/tick', 'runtoolkit:core/tick'},
    }
    for tag, required_values in required_tag_values.items():
        data = load_json(PACK / 'data' / 'minecraft' / 'tags' / 'function' / f'{tag}.json')
        values = set(data.get('values', []))
        if not required_values.issubset(values):
            fail(f'{tag}.json missing values: {sorted(required_values - values)}')

    for advancement in [
        PACK / 'data' / 'runtoolkit' / 'advancement' / 'root.json',
        PACK / 'data' / 'runtoolkit' / 'advancement' / 'packs' / 'rtwrapper.json',
    ]:
        if not advancement.exists():
            fail(f'missing Runtoolkit advancement {advancement.relative_to(ROOT)}')
        if not advancement_uses_tick(advancement):
            fail(f'{advancement.relative_to(ROOT)} must use trigger minecraft:tick')

    metadata = load_json(META)
    if not metadata.get('variant_dispatch'):
        fail('commands-26.2.json must declare variant_dispatch=true')
    command_params = metadata.get('command_params')
    if not isinstance(command_params, dict) or not command_params:
        fail('commands-26.2.json must declare command_params')

    commands = metadata['commands'] + metadata.get('debug_commands', [])
    convenience = set(metadata.get('convenience_wrappers', []))
    expected = set(commands) | convenience
    if set(command_params) != set(commands):
        fail('command_params keys must match commands + debug_commands')

    for cmd, names in command_params.items():
        if len(names) != len(set(names)):
            fail(f'duplicate meaningful parameter names for {cmd}: {names}')
        for name in names:
            if not PARAM_RE.match(name):
                fail(f'invalid parameter name for {cmd}: {name}')
            if GENERIC_RE.search(name):
                fail(f'generic positional parameter name is not allowed for {cmd}: {name}')

    internal = PACK / 'data' / 'rtwrapper' / 'function' / 'core' / 'wrappers' / 'internal'
    variants = internal / 'variants'
    api_commands = PACK / 'data' / 'rtwrapper' / 'function' / 'api' / 'commands'
    variant_count = 0
    for cmd in sorted(expected):
        if not RESOURCE_RE.match(cmd):
            fail(f'invalid command wrapper path: {cmd}')
        wrapper = internal / f'{cmd}.mcfunction'
        direct = api_commands / f'{cmd}.mcfunction'
        if not wrapper.exists():
            fail(f'missing internal wrapper for {cmd}')
        if not direct.exists():
            fail(f'missing API command wrapper for {cmd}')

        text = wrapper.read_text(encoding='utf-8')
        if '$(tail)' in text or GENERIC_RE.search(text):
            fail(f'{wrapper.relative_to(ROOT)} uses a forbidden generic/tail parameter')

        if cmd in convenience:
            if '$(' not in text:
                fail(f'{wrapper.relative_to(ROOT)} does not contain a macro variable')
            continue

        names = command_params[cmd]
        if 'scoreboard players set #pc rtw.status 0' not in text:
            fail(f'{wrapper.relative_to(ROOT)} does not compute parameter count')
        for count, name in enumerate(names, start=1):
            if f'current.params.{name}' not in text:
                fail(f'{wrapper.relative_to(ROOT)} does not detect parameter {name}')

        for count in range(len(names) + 1):
            variant_count += 1
            variant = variants / f'{cmd}_{count}.mcfunction'
            if not variant.exists():
                fail(f'missing generated variant {variant.relative_to(ROOT)}')
            variant_text = variant.read_text(encoding='utf-8')
            if '$(tail)' in variant_text or GENERIC_RE.search(variant_text):
                fail(f'{variant.relative_to(ROOT)} uses a forbidden generic/tail parameter')
            if count > 0:
                for key in (names[0], names[count - 1]):
                    if f'$({key})' not in variant_text:
                        fail(f'{variant.relative_to(ROOT)} missing placeholder $({key})')

    for fn in PACK.rglob('*.mcfunction'):
        rel = fn.relative_to(PACK)
        if any(part != part.lower() for part in rel.parts):
            fail(f'function path must be lowercase: {rel}')
        if not RESOURCE_RE.match(str(rel.with_suffix('')).replace('data/', '')):
            fail(f'invalid function resource path: {rel}')
        for i, line in enumerate(fn.read_text(encoding='utf-8').splitlines(), start=1):
            if line.rstrip() != line:
                fail(f'trailing whitespace at {rel}:{i}')
            if line.startswith('/'):
                fail(f'mcfunction lines must not start with / at {rel}:{i}')
            if ADV_REVOKE_RE.search(line):
                fail(f'advancement revoke is not allowed for loaded-pack registry at {rel}:{i}')

    print(f'[validateDatapack] OK: {len(expected)} wrappers, {variant_count} named variants, runtoolkit advancements use minecraft:tick, format=107')


if __name__ == '__main__':
    main()
