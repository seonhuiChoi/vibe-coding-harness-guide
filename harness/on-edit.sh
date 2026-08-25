#!/usr/bin/env bash
# 센서: index.html이 바뀌면 자동으로 다시 빌드하고 검증한다.
# 성공은 조용히, 실패는 시끄럽게 (실패 텍스트가 그대로 모델 컨텍스트로 돌아간다).
cd "$(dirname "$0")/.." || exit 0
[ -f index.html ] || exit 0
bash harness/build.sh >/dev/null 2>&1
if ! out=$(bash harness/verify.sh 2>&1); then
  printf '%s\n' "$out" >&2
  exit 2
fi
exit 0
