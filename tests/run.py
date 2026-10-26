"""Run migration integration checks against this configuration's own plugins/tools."""
import json
import os
import subprocess
import tempfile
from pathlib import Path

config = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='nvim-pack-smoke-') as directory:
    root = Path(directory)
    (root / 'stylua.toml').write_text('indent_type = "Spaces"\nindent_width = 4\n')
    (root / '.luarc.json').write_text('{}\n')
    (root / 'pyproject.toml').write_text('[project]\nname = "pack-smoke"\nversion = "0.1.0"\n')
    (root / 'package.json').write_text('{"name":"pack-smoke","private":true}\n')
    (root / 'state/nvim-pack-test').mkdir(parents=True)
    env = os.environ.copy()
    env.update({
        'NVIM_APPNAME': 'nvim-pack-test',
        'XDG_CONFIG_HOME': str(config.parent),
        'XDG_STATE_HOME': str(root / 'state'),
        'XDG_CACHE_HOME': str(root / 'cache'),
        'NVIM_LOG_FILE': str(root / 'nvim.log'),
        'NVIM_PACK_EXPECTED_MAPS': str(config / 'tests/mappings.json'),
    })
    result = subprocess.run(['nvim', '--headless', '-n', '-u', 'NONE', '-i', 'NONE', '-c',
        f'lua dofile("{config}/tests/json.lua")'], env=env, cwd=root,
        capture_output=True, text=True, timeout=30)
    print(f'JSON mappings: exit {result.returncode}\n{result.stdout}{result.stderr}', flush=True)
    if result.returncode:
        raise SystemExit(result.returncode)
    (root / 'Cargo.toml').write_text('[package]\nname = "pack_smoke"\nversion = "0.1.0"\nedition = "2021"\n[[bin]]\nname = "pack_smoke"\npath = "main.rs"\n')
    notebook = root / 'notebook.ipynb'
    notebook.write_text(json.dumps({
        'nbformat': 4, 'nbformat_minor': 5,
        'metadata': {'kernelspec': {'display_name': 'Python 3', 'language': 'python', 'name': 'python3'},
                     'language_info': {'name': 'python'}, 'custom': {'retained': True}},
        'cells': [
            {'id': 'code-cell', 'cell_type': 'code', 'execution_count': None, 'metadata': {'tag': 'keep'},
             'outputs': [], 'source': ['value = 1\n']},
            {'id': 'markdown-cell', 'cell_type': 'markdown', 'metadata': {}, 'source': ['# Notes\n']},
        ],
    }) + '\n')
    result = subprocess.run(['nvim', '--headless', '-n', '-i', 'NONE', str(notebook), '-c',
        f'lua dofile("{config}/tests/notebook.lua")'], env=env, cwd=root,
        capture_output=True, text=True, timeout=60)
    print(f'Notebook: exit {result.returncode}\n{result.stdout}{result.stderr}', flush=True)
    if result.returncode:
        raise SystemExit(result.returncode)
    for name, filetype, content in [('main.lua', 'lua', 'local answer = 42\nreturn answer\n'),
                                    ('main.py', 'python', 'answer = 42\n'),
                                    ('main.ts', 'typescript', 'const answer: number = 42\n'),
                                    ('main.rs', 'rust', 'fn main() {}\n')]:
        path = root / name
        path.write_text(content)
        report = root / (filetype + '.txt')
        env['NVIM_PACK_EXPECT_FT'] = filetype
        env['NVIM_PACK_TEST_RESULT'] = str(report)
        result = subprocess.run(['nvim', '--headless', '-i', 'NONE', str(path), '-c',
            f'lua dofile("{config}/tests/smoke.lua")'], env=env, cwd=root,
            capture_output=True, text=True, timeout=60)
        print(f'{filetype}: exit {result.returncode}\n{result.stdout}{result.stderr}', flush=True)
        if result.returncode:
            raise SystemExit(result.returncode)
    for configured in (False, True):
        project = Path(directory) / ('configured' if configured else 'unconfigured')
        (project / 'docs').mkdir(parents=True)
        if configured:
            (project / 'styles/Local').mkdir(parents=True)
            (project / '.vale.ini').write_text('StylesPath = styles\nMinAlertLevel = suggestion\n[*.{md,txt}]\nBasedOnStyles = Local\n')
            (project / 'styles/Local/Bad.yml').write_text('extends: existence\nmessage: "Avoid badword."\nlevel: warning\ntokens:\n  - badword\n')
        for extension in ('md', 'txt'):
            path = project / 'docs' / ('test.' + extension)
            path.write_text('# Heading\n\n### Skipped level\n\nbadword\n' if extension == 'md' else 'This contains badword.\n')
            env['TEST_VALE_CONFIGURED'] = '1' if configured else '0'
            result = subprocess.run(['nvim', '--headless', '-i', 'NONE', '--cmd',
                f'lua dofile("{config}/tests/capture.lua")', str(path), '-c',
                f'lua dofile("{config}/tests/prose.lua")'],env=env,cwd=Path(directory),
                capture_output=True,text=True,timeout=45)
            print(f'Vale configured={configured}/{extension}: exit {result.returncode}\n{result.stdout}{result.stderr}',flush=True)
            if result.returncode: raise SystemExit(result.returncode)
    print('All integration suites passed', flush=True)
