#!/usr/bin/env python3
"""Lightweight release guard for obvious base placeholders/secrets.
Not a security scanner; qa-release still requires manual review.
"""
import argparse
import re
from pathlib import Path

DEFAULT_PATTERNS = [
    r'com\.example',
    r'Flutter App Factory Base',
    r'jsonplaceholder\.typicode\.com',
    r'example\.invalid',
    r'YOUR[_ -]?(API|APP|CLIENT|SECRET|TOKEN|KEY)',
]
SECRET_PATTERNS = [
    re.compile(r'(?i)(api[_-]?key|client[_-]?secret|access[_-]?token)\s*[:=]\s*[\"\']?[A-Za-z0-9_\-]{24,}'),
]
EXTS = {'.dart', '.yaml', '.yml', '.json', '.xml', '.plist', '.gradle', '.kts', '.xcconfig', '.md'}
SKIP_PARTS = {'.git', '.dart_tool', 'build', 'output'}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--root', default='.')
    ap.add_argument('--out', default='output/release/release-guard.md')
    args = ap.parse_args()
    root = Path(args.root)
    findings = []
    for path in root.rglob('*'):
        if not path.is_file() or path.suffix.lower() not in EXTS:
            continue
        if any(part in SKIP_PARTS for part in path.parts):
            continue
        try:
            text = path.read_text(encoding='utf-8', errors='ignore')
        except Exception:
            continue
        for pat in DEFAULT_PATTERNS:
            if re.search(pat, text, re.I):
                findings.append(('PLACEHOLDER', str(path), pat))
        for pat in SECRET_PATTERNS:
            if pat.search(text):
                findings.append(('POSSIBLE_SECRET', str(path), pat.pattern))
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    lines = ['# Release guard', '', '| severity | file | match |', '|---|---|---|']
    lines += [f'| {sev} | `{p}` | `{pat}` |' for sev, p, pat in findings]
    if not findings:
        lines.append('| PASS | - | no obvious base placeholder/secret pattern |')
    out.write_text('\n'.join(lines)+'\n', encoding='utf-8')
    print('findings=', len(findings), '->', out)
    raise SystemExit(1 if findings else 0)


if __name__ == '__main__':
    main()
