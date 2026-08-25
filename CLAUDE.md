# 바이브 코딩 학습 사이트 — 프로젝트 규칙

## 빌드
- 단일 소스는 `index.html` 하나다. **여기만 편집한다.**
- `dist/artifact.html`은 생성물이다. 절대 직접 편집하지 않는다.
- 편집 후에는 반드시: `bash harness/build.sh && bash harness/verify.sh`

## 절대 규칙
- IMPORTANT: 색상 값(hex/rgb)은 `:root` 토큰 블록 안에서만 쓴다. 컴포넌트 규칙은 `var(--토큰)`만 쓴다.
- 새 토큰을 추가하면 라이트(`:root`), 시스템 다크(`prefers-color-scheme`), 명시 다크(`[data-theme="dark"]`) 세 곳 전부에 정의한다.
- 표·코드처럼 넓은 콘텐츠는 `overflow-x:auto` 컨테이너 안에 넣는다. 본문이 가로로 밀리면 안 된다.
- 외부 호스트는 Google Fonts만 허용한다. (아티팩트 CSP)
- `<!doctype>` / `<html>` / `<head>` / `<body>`는 `<!--A1-->`·`<!--A2-->` 마커 밖에만 둔다.

## 검증
`harness/verify.sh`가 14개 검사를 돈다. 통과 없이 게시하지 않는다.
검사에 걸리면 검사를 고치지 말고 원인을 고친다.
