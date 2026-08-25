# 바이브 코딩 하네스 가이드

바이브 코딩을 처음 접하는 사람이 **순서대로 따라가며** 배우는 학습 사이트.
클로드(Claude) 사용을 전제로 하고, 2026년의 **하네스 엔지니어링**을 하나의 트랙으로 다룹니다.

[![Verify and deploy](https://github.com/seonhuiChoi/vibe-coding-harness-guide/actions/workflows/deploy.yml/badge.svg)](https://github.com/seonhuiChoi/vibe-coding-harness-guide/actions/workflows/deploy.yml)

**→ https://seonhuichoi.github.io/vibe-coding-harness-guide/**

`main` 에 push하면 `harness/verify.sh` 14개 검사를 통과한 경우에만 자동 배포됩니다.
검사가 하나라도 실패하면 배포 잡 자체가 실행되지 않습니다.
로컬에서는 `index.html` 을 더블클릭하면 바로 열립니다.

## 커리큘럼 — 4트랙 15단계 + 부록 3

| 트랙 | 단계 | 내용 |
|---|---|---|
| **1 · 기초**<br>일단 만들어본다 | 00–03 | 개념과 유래 · 준비물 · 설치 없이 첫 결과물 · 클로드 코드 설치 |
| **2 · 실전**<br>잘 시킨다 | 04–07 | 첫 프로젝트 · 프롬프트 5원칙 · 플랜 모드 · 컨텍스트 관리 |
| **3 · 하네스**<br>실수를 구조로 막는다 | 08–12 | 하네스 사고법 · 가이드 층(CLAUDE.md) · 센서 층(검증 루프) · 가드레일 층(훅·권한) · 확장 층(스킬·서브에이전트·MCP) |
| **4 · 운영**<br>세상에 내보낸다 | 13–14 | 보안 점검 · 깃과 배포 |
| **부록** | A·B·C | 치트시트 · 내 하네스 설계도 · 자료실 |

설계 의도: 초보자에게 설정부터 시키지 않습니다. 트랙 1–2에서 **실패를 먼저 겪게** 하고,
트랙 3에서 그 실패마다 대응하는 장치를 붙입니다. 공식 문서의 "신호가 오면 그때 추가한다" 원칙과 같습니다.

## 사이트 기능

- 한 번에 한 단계만 표시 (해시 라우팅) + 이전/다음 페이저
- 트랙별 게이지와 전체 진도 계기 바 — 체크리스트는 `localStorage`에 저장
- 프롬프트/터미널/설정파일 카드 복사 버튼 41개
- 하네스 제어 루프 · 서브에이전트 컨텍스트 격리 인라인 SVG 도해 2점 (테마 대응)
- 라이트·다크 3상태 테마 (시스템 기본 / 명시 라이트 / 명시 다크)
- 모바일 드로어 네비게이션

## 이 저장소 자체가 하네스 예제입니다

부록 B에서 설명하는 구조를 실제로 쓰고 있습니다.

| 파일 | 층 | 역할 |
|---|---|---|
| `CLAUDE.md` | 가이드 | 색상은 토큰으로만, 표는 스크롤 컨테이너에, 생성물 편집 금지 |
| `harness/verify.sh` | 센서 | 14개 자동 검사. 통과 없이 게시하지 않음 |
| `harness/protect.sh` | 가드레일 | `dist/artifact.html` 직접 편집 차단 (`PreToolUse`) |
| `harness/on-edit.sh` | 자동화 | 편집할 때마다 빌드 + 검증 (`PostToolUse`) |
| `harness/build.sh` | 빌드 | `index.html` → `dist/artifact.html` |
| `.claude/settings.json` | — | 훅 등록 |

검사 항목: 빌드 마커·동기화, 게시본 문서 껍데기 제거, title 위치, 태그 균형,
색상이 전부 토큰에서 오는지, 세 테마 블록의 토큰 집합 일치, 내부 링크 타겟 존재,
표의 스크롤 컨테이너 포함, 복사 버튼과 코드 블록 대응, `data-title` 누락,
`style`/`script` 위치, 로드되는 외부 리소스, `body` 배경 명시.

```bash
bash harness/build.sh && bash harness/verify.sh
```

## 파일

- `index.html` — **단일 소스. 여기만 편집합니다.** 더블클릭하면 브라우저에서 바로 열립니다.
- `dist/artifact.html` — 게시용 생성물. `<!--A1-->`/`<!--A2-->` 마커 구간만 뽑아 문서 껍데기를 제거한 것.

## 자료 출처

2026년 8월 기준. 설치 명령·워크플로·프롬프트 예시·확장 기능은 클로드 코드 공식 문서
(빠른 시작 / 모범 사례 / Extend Claude Code / 훅 가이드)를 근거로 했고,
하네스 엔지니어링은 Martin Fowler, Addy Osmani, Faros.ai의 문헌을 정리했습니다.
한국어 도서·영상은 검색으로 수집해 부록 C에 출처를 표기했습니다.

앤트로픽과 무관한 비공식 학습 자료입니다.
