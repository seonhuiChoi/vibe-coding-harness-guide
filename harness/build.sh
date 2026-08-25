#!/usr/bin/env bash
# index.html (독립 실행 문서) -> dist/artifact.html (게시용 본문)
# 아티팩트 호스트가 <!doctype><head></head><body>로 감싸므로 문서 껍데기를 걷어낸다.
set -euo pipefail
cd "$(dirname "$0")/.."
src=index.html
out=dist/artifact.html
mkdir -p dist
{
  awk '/<!--A1-->/{f=1;next} /<!--\/A1-->/{f=0} f' "$src"
  awk '/<!--A2-->/{f=1;next} /<!--\/A2-->/{f=0} f' "$src"
} > "$out"
printf 'build  %s -> %s (%s bytes)\n' "$src" "$out" "$(wc -c < "$out" | tr -d ' ')"
