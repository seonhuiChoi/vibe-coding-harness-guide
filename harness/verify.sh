#!/usr/bin/env bash
# 검증 하네스 — 게시 전에 통과해야 하는 14개 검사. 성공은 조용히, 실패는 시끄럽게.
cd "$(dirname "$0")/.." || exit 1
SRC=index.html
OUT=dist/artifact.html
PASS=0; FAIL=0
ok(){ PASS=$((PASS+1)); printf '  \033[32mPASS\033[0m  %s\n' "$1"; }
no(){ FAIL=$((FAIL+1)); printf '  \033[31mFAIL\033[0m  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }
echo "harness/verify.sh"

if [ -f "$SRC" ] && [ "$(grep -cE '<!--/?A[12]-->' "$SRC")" -eq 4 ]
then ok "01 소스와 빌드 마커(A1/A2) 존재"; else no "01 소스와 빌드 마커(A1/A2) 존재"; fi

bash harness/build.sh >/dev/null 2>&1
if [ -f "$OUT" ] && [ "$(wc -c < "$OUT")" -gt 1000 ]
then ok "02 게시본 빌드 동기화"; else no "02 게시본 빌드 동기화"; fi

n=$(grep -cE '<!doctype|<html|</html>|<head>|</head>|<body|</body>' "$OUT")
if [ "$n" -eq 0 ]; then ok "03 게시본에 문서 껍데기 없음"; else no "03 게시본에 문서 껍데기 없음" "$n 곳"; fi

if head -c 8192 "$OUT" | grep -q '<title>[^<]\+</title>'
then ok "04 title 태그가 앞 8KB 안에"; else no "04 title 태그가 앞 8KB 안에"; fi

bad=""
for t in section div table ul ol pre figure nav main aside; do
  o=$(grep -o "<$t[ >]" "$SRC" | wc -l); c=$(grep -o "</$t>" "$SRC" | wc -l)
  [ "$o" -ne "$c" ] && bad="$bad $t($o/$c)"
done
if [ -z "$bad" ]; then ok "05 태그 균형"; else no "05 태그 균형" "불일치:$bad"; fi

lit=$(perl -CSD -ne '
  $tok=1 if /^(:root|\s+:root|\@media)/; $tok=0 if /^\}/ && $tok; next if $tok;
  next if /--[a-z-]+\s*:/; next if /var\(--/; next if /--term|\.term/;
  print "$.:$_" if /(?:^|[;{ ])(?:color|background|background-color|border[a-z-]*color|fill|stroke)\s*:[^;}]*(#[0-9a-fA-F]{3,8}|rgba?\()/;
' "$SRC")
if [ -z "$lit" ]; then ok "06 색상은 토큰에서만"; else no "06 색상은 토큰에서만" "$(echo "$lit" | head -3 | tr '\n' ' ')"; fi

toks(){ awk -v s="$1" 'index($0,s){f=1;next} f&&/^ *\}/{exit} f' "$SRC" | grep -o '\-\-[a-z0-9-]*:' | sort -u; }
L=$(toks ':root{'); D1=$(toks ':root:not([data-theme="light"])'); D2=$(toks ':root[data-theme="dark"]')
nd=$(echo "$D1" | grep -c .)
if [ -n "$L" ] && [ "$nd" -gt 10 ] && [ "$D1" = "$D2" ] && [ -z "$(comm -13 <(echo "$L") <(echo "$D1"))" ]
then ok "07 세 테마 블록 + 다크 토큰 $nd개가 라이트와 일치"
else no "07 세 테마 블록 + 다크 토큰 집합 일치" "light=$(echo "$L"|grep -c .) sysdark=$nd dark=$(echo "$D2"|grep -c .)"; fi

ids=$(grep -o 'id="[^"]*"' "$SRC" | sed 's/id="//;s/"//' | sort -u)
refs=$(grep -oE '(href="#|data-go=")[a-zA-Z0-9_-]+' "$SRC" | sed 's/.*"#\?//' | sort -u)
miss=$(comm -23 <(echo "$refs") <(echo "$ids") | grep -v '^$')
if [ -z "$miss" ]; then ok "08 내부 링크 타겟 전부 존재"; else no "08 내부 링크 타겟 전부 존재" "없는 id: $miss"; fi

t=$(grep -c '<table>' "$SRC"); w=$(grep -c '<div class="tbl-wrap">' "$SRC")
if [ "$t" -eq "$w" ]; then ok "09 표 $t개 전부 가로 스크롤 컨테이너 안"; else no "09 표가 스크롤 컨테이너 밖" "table=$t wrap=$w"; fi

cp=$(grep -c 'class="copy"' "$SRC"); pr=$(grep -c '^<pre>' "$SRC")
if [ "$cp" -le "$pr" ]; then ok "10 복사 버튼 $cp개 모두 코드 블록 보유"; else no "10 복사 버튼에 코드 블록 없음" "copy=$cp pre=$pr"; fi

s=$(grep -c 'class="step"' "$SRC"); dt=$(grep -c 'data-title="' "$SRC")
if [ "$s" -eq "$dt" ]; then ok "11 단계 $s개 전부 data-title 보유"; else no "11 data-title 누락" "step=$s title=$dt"; fi

outside=$(awk '/<!--A1-->/{a=1} /<!--\/A1-->/{a=0} /<!--A2-->/{a=1} /<!--\/A2-->/{a=0} !a && /<style>|<script>/{print NR}' "$SRC")
if [ -z "$outside" ]; then ok "12 style/script가 마커 구간 안에만"; else no "12 style/script가 마커 밖" "줄 $outside"; fi

# CSP는 "로드되는" 리소스만 막는다. <a href>는 바깥으로 나가는 링크라 대상이 아니다.
ext=$(grep -oE '(<link[^>]+href|[[:space:]]src|url\()="?https?://[^")]+' "$SRC" | grep -vE 'fonts\.(googleapis|gstatic)\.com')
if [ -z "$ext" ]; then ok "13 로드되는 외부 리소스는 Google Fonts뿐"; else no "13 허용되지 않은 외부 리소스" "$(echo "$ext" | head -3)"; fi

if grep -qE '^body\{[^}]*background:var\(--' "$SRC"
then ok "14 body 배경을 토큰으로 명시"; else no "14 body 배경 미지정"; fi

echo
printf '  %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
