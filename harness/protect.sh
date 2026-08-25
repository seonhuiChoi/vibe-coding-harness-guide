#!/usr/bin/env bash
# 가드레일: 생성물 직접 편집 차단. CLAUDE.md의 "규칙"은 요청이고, 이 훅은 강제다.
INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
FILE_PATH="${FILE_PATH//\\//}"
case "$FILE_PATH" in
  */dist/artifact.html)
    echo "차단: dist/artifact.html은 생성물입니다. index.html을 고치고 harness/build.sh를 도세요." >&2
    exit 2 ;;
esac
exit 0
