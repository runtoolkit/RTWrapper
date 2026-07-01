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
MISSING_STORAGE_MODIFY_PATH_RE = re.compile(r'(^|\s)data\s+modify\s+storage\s+\S+\s+set\s+value(\s|$)')
MISSING_STORAGE_TEST_PATH_RE = re.compile(r'(^|\s)data\s+storage\s+\S+\s+run(\s|$)')


def fail(message: str) -> None:
    print(f'[validateDatapack] ERROR: {message}', file=sys.stderr)
    raise SystemExit(1)


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except Exception as exc:
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

    for path in PACK.rglob('*.json'):
        load_json(path)

    pack_mcmeta = load_json(PACK / 'pack.mcmeta')
    pack_section = pack_mcmeta.get('pack', {})
    if pack_section.get('min_format') != [107, 1] or pack_section.get('max_format') != [107, 1]:
        fail('pack.mcmeta must declare min_format=[107, 1] and max_format=[107, 1] for the 26.2 target')

    required_tag_values = {
        'load': {'runtoolkit:core/load'},
        'tick': {'runtoolkit:core/tick'},
    }
    for tag, required_values in required_tag_values.items():
        data = load_json(PACK / 'data' / 'minecraft' / 'tags' / 'function' / f'{tag}.json')
        values = set(data.get('values', []))
        if not required_values.issubset(values):
            fail(f'{tag}.json missing values: {sorted(required_values - values)}')

    for tag in ['register', 'load', 'tick', 'list', 'enable', 'disable', 'reload']:
        tag_path = PACK / 'data' / 'runtoolkit' / 'tags' / 'function' / f'{tag}.json'
        if not tag_path.exists():
            fail(f'missing runtoolkit function tag {tag_path.relative_to(ROOT)}')
        values = set(load_json(tag_path).get('values', []))
        expected_value = f'runtoolkit:packs/rtwrapper/{tag}'
        if expected_value not in values:
            fail(f'{tag_path.relative_to(ROOT)} missing {expected_value}')

    required_functions = [
        PACK / 'data' / 'runtoolkit' / 'function' / 'api' / 'enable.mcfunction',
        PACK / 'data' / 'runtoolkit' / 'function' / 'api' / 'disable.mcfunction',
        PACK / 'data' / 'runtoolkit' / 'function' / 'api' / 'reload.mcfunction',
        PACK / 'data' / 'runtoolkit' / 'function' / 'api' / 'list.mcfunction',
        PACK / 'data' / 'runtoolkit' / 'function' / 'manager' / 'require.mcfunction',
        PACK / 'data' / 'runtoolkit' / 'function' / 'dpman.mcfunction',
        PACK / 'data' / 'core' / 'function' / 'selector' / 'detect.mcfunction',
        PACK / 'data' / 'rtwrapper' / 'function' / 'api' / 'run_many.mcfunction',
        PACK / 'data' / 'rtwrapper' / 'function' / 'api' / 'enqueue_many.mcfunction',
        PACK / 'data' / 'rtwrapper' / 'function' / 'condition' / 'check_current.mcfunction',
    ]
    for function in required_functions:
        if not function.exists():
            fail(f'missing required manager/selector/batch function {function.relative_to(ROOT)}')

    core_load = (PACK / 'data' / 'rtwrapper' / 'function' / 'core' / 'load.mcfunction').read_text(encoding='utf-8')
    if 'scoreboard objectives add rtw.temp dummy' not in core_load:
        fail('rtwrapper:core/load must create rtw.temp')
    if 'scoreboard objectives add RTWrapper trigger' in core_load:
        fail('RTWrapper trigger objective must not be present after removing in-game trigger UI')

    core_tick = (PACK / 'data' / 'rtwrapper' / 'function' / 'core' / 'tick.mcfunction').read_text(encoding='utf-8')
    if 'rtwrapper:trigger/' in core_tick or 'scores={RTWrapper=' in core_tick:
        fail('rtwrapper:core/tick must not process removed RTWrapper trigger UI')

    for forbidden in ['dialog show', 'rtwrapper.testMode', 'trigger RTWrapper', 'RTWrapper trigger']:
        for path in PACK.rglob('*.mcfunction'):
            if forbidden in path.read_text(encoding='utf-8'):
                fail(f'forbidden removed UI/testMode token {forbidden!r} in {path.relative_to(ROOT)}')

    selector_detect = (PACK / 'data' / 'core' / 'function' / 'selector' / 'detect.mcfunction').read_text(encoding='utf-8')
    for forbidden_selector in ['"@p"', '"@r"']:
        if forbidden_selector in selector_detect:
            fail(f'core selector detect must not allow {forbidden_selector}')
    for required_selector in ['input.value', 'stringlib:util/find', '@s', '@a[limit=1]', '@e[type=player,limit=1]']:
        if required_selector not in selector_detect:
            fail(f'core selector detect missing {required_selector}')

    rtw_register = (PACK / 'data' / 'runtoolkit' / 'function' / 'packs' / 'rtwrapper' / 'register.mcfunction').read_text(encoding='utf-8')
    if 'dependencies:["stringlib"]' not in rtw_register:
        fail('RTWrapper manager registration must declare StringLib dependency')

    rtw_check = (PACK / 'data' / 'runtoolkit' / 'function' / 'packs' / 'rtwrapper' / 'check_dependencies.mcfunction').read_text(encoding='utf-8')
    if 'stringlib:util/find' not in rtw_check:
        fail('RTWrapper dependency check must probe StringLib')

    api_run = (PACK / 'data' / 'rtwrapper' / 'function' / 'api' / 'run.mcfunction').read_text(encoding='utf-8')
    if 'runSafeMode' not in api_run or 'rtwrapper:core/run/run_next' not in api_run:
        fail('rtwrapper:api/run must support runSafeMode safe execution')
    batch_run = (PACK / 'data' / 'rtwrapper' / 'function' / 'api' / 'run_many.mcfunction').read_text(encoding='utf-8')
    if 'runSafeMode' not in batch_run or 'rtwrapper:api/enqueue_many' not in batch_run:
        fail('rtwrapper:api/run_many must support batch runSafeMode')

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
        for _, name in enumerate(names, start=1):
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
            if MISSING_STORAGE_MODIFY_PATH_RE.search(line):
                fail(f'missing storage path before set value at {rel}:{i}')
            if MISSING_STORAGE_TEST_PATH_RE.search(line):
                fail(f'missing storage path before run at {rel}:{i}')

    print(f'[validateDatapack] OK: {len(expected)} wrappers, {variant_count} named variants, no dialog/testMode, format=107')


if __name__ == '__main__':
    main()
