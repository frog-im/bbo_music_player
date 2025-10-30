<h1>Bbo Music Player — Lyrics Overlay & Tag Editor</h1>

<p>
오디오 파일의 <b>메타데이터(태그) 복사·수정</b>과 <b>가사(두 줄) 오버레이</b>를 제공하는 Flutter 앱 예제입니다.
광고(AdMob), UMP 동의 흐름, Android 오버레이, 파일 선택/저장(SAF), FFmpegKit 기반 태그 조작이 포함되어 있습니다.
</p>

<hr/>

<h2 id="features">주요 기능</h2>
<ul>
  <li><b>동의 흐름 + 광고 안전 로드:</b> UMP(EEA/UK/CH)의 동의 상태를 앱 시작 시 동기화하고, 동의 결과를 반영한 뒤 GMA SDK를 초기화합니다. 동의 옵션은 설정 시트에서 재진입 가능. <sup>[1][2]</sup></li>
  <li><b>배너/전면 광고:</b> 상·하단 320×50 배너, 전면 광고(표시-대기 Future 공유) 오케스트레이션.</li>
  <li><b>Android 가사 오버레이:</b> 드래그 가능, 더블탭 종료, 두 줄 페이지뷰. 위치/폰트 크기 SharedPreferences 저장. <sup>[3]</sup></li>
  <li><b>iOS 대체 UI:</b> WebView 상단 주소창 + 하단 가사 오버레이(광고 제거 버전) 샘플.</li>
  <li><b>파일 선택 & SAF 저장:</b> <code>file_picker</code>로 오디오/이미지 선택 → FFmpegKit의 SAF 헬퍼로 안전 저장(사용자 지정 위치/파일명). <sup>[4]</sup></li>
  <li><b>FFmpegKit 기반 메타데이터 조작:</b> <i>재인코딩 없이(copy)</i> 컨테이너에 맞는 코덱 조합에서만 태그/커버를 반영.<br/>
      – MP3(ID3v2.3), MP4/M4A(iTunes atoms), Ogg/Opus(Vorbis Comment + <code>METADATA_BLOCK_PICTURE</code>), FLAC(Vorbis Comment/PICTURE), WAV(LIST-INFO) 등 컨테이너별 메타 체계를 따릅니다. <sup>[5]</sup></li>
  <li><b>현지화(i18n):</b> ARB + <code>AppLocalizations</code> 구조. 국가별 정책 링크 자동 매핑(언어/스크립트/국가 코드 조합).</li>
  <li><b>실용적 UX:</b> 위험 형식(메타 조작 실패 가능성)이 감지되면 스낵바·다이얼로그로 사용자 경고.</li>
</ul>

<hr/>

<h2 id="arch">구성 개요</h2>

<pre><code>lib/
├─ main.dart                     # 진입점: UMP 동기화 → GMA 초기화 → 앱 실행
├─ privacy/privacy_gate.dart     # UMP/지역 판정/광고 요청 파라미터 관리
├─ music/
│  ├─ admob/
│  │   ├─ ad_orchestrator.dart           # 전면 광고 프리로드/표시-대기
│  │   └─ main_admob_top__bottom.dart    # 상/하단 배너
│  └─ appUI/
│      ├─ appUI.dart                      # 메인 카드 UI + 파일 선택/가사·편집 진입
│      ├─ myPick.dart                     # 파일 선택 유틸(file_picker)
│      └─ subtitles/
│          ├─ androidUser/androidUI_subtitles.dart  # 안드로이드 오버레이 앱
│          ├─ ios_user/subtitles_ios.dart           # iOS 대체 UI(WebView + overlay)
│          └─ lyrics_overlay.dart                   # 오버레이 인터페이스
├─ l10n/ (ARB, AppLocalizations)
└─ open-source/ffmpeg/WHERE-TO-GET-SOURCE.txt       # FFmpegKit 고지 파일(예)
</code></pre>

<hr/>

<h2 id="consent">개인정보/동의 & 광고 로드</h2>
<ul>
  <li>앱 시작 시 <code>PRivacy.instance.INit()</code>로 지역 판정/동의 상태를 동기화합니다.</li>
  <li>선택적으로 <code>WAITReadyForAds(timeout: 3s)</code>로 짧게 대기 후, <code>MobileAds.initialize()</code>를 수행합니다. <sup>[1][2]</sup></li>
  <li>설정 시트에 <i>개인정보 옵션</i> 항목을 두어 UMP 폼 재호출 가능.</li>
  <li>광고 요청은 항상 <code>PRivacy.instance.ADRequest()</code>를 사용(동의/제한 처리 반영).</li>
</ul>

<hr/>

<h2 id="ads">광고(AdMob)</h2>
<h3>배너</h3>
<ul>
  <li>상·하단 320×50 배너(테스트 단위 ID 사용). 배너 위젯 크기는 <code>AdSize</code> 이상으로 유지.</li>
</ul>

<h3>전면</h3>
<ul>
  <li><code>ADOrchestrator</code>가 전면 광고를 미리 로드하고, <b>표시→닫힘/실패까지 완전 대기</b>하는 Future를 공유합니다. 연속 중복 호출 방지.</li>
</ul>

<blockquote>
참고: Google Mobile Ads Flutter 플러그인과 UMP의 Flutter 가이드(동의 표기/옵트아웃 등) 요구사항을 준수하세요. <sup>[1][2]</sup>
</blockquote>

<hr/>

<h2 id="overlay">가사 오버레이(Android)</h2>
<ul>
  <li><code>flutter_overlay_window</code> 기반. <code>SYSTEM_ALERT_WINDOW</code> 및 오버레이 권한 확인/요청 후 표시합니다. <sup>[3]</sup></li>
  <li>더블탭 종료, 두 줄 페이지뷰, 폰트 크기/좌표 SharedPreferences 저장.</li>
  <li>“오차 보정” 플로우: 미니 오버레이를 잠깐 띄워 실제 위치 차이를 측정→오프셋 반영.</li>
</ul>

<hr/>

<h2 id="files">파일 선택/저장 & SAF</h2>
<ul>
  <li><code>file_picker</code>로 오디오/이미지 선택. Android의 경우 MIME 기반 선택→확장자 2차 필터링.</li>
  <li>저장 시 FFmpegKit의 <code>selectDocumentForWrite()</code> 및 SAF 파라미터(<code>getSafParameterForWrite</code>)를 사용하여 사용자가 지정한 경로로 안전 저장합니다. <sup>[4]</sup></li>
</ul>

<hr/>

<h2 id="ffmpeg">FFmpegKit & 메타데이터 조작</h2>
<p>
본 프로젝트는 <b>copy-only(재인코딩 없음)</b> 방식을 채택합니다. 즉, <b>입력 코덱 ↔ 출력 컨테이너 조합</b>이 호환 가능할 때만 태그/커버를 씁니다. 호환되지 않으면 사용자에게 안내하고 중단합니다.
</p>

<h3>대표 호환 예</h3>
<ul>
  <li><b>MP3 컨테이너 ↔ MP3 비트스트림</b>(ID3v2.3) — 커버는 <code>attached_pic</code>(mjpeg) 맵핑</li>
  <li><b>MP4/M4A 컨테이너 ↔ AAC/ALAC</b>(iTunes atoms)</li>
  <li><b>Ogg/Opus 컨테이너 ↔ Opus/Vorbis</b>(Vorbis Comment + <code>METADATA_BLOCK_PICTURE</code>)</li>
  <li><b>FLAC</b>(Vorbis Comment/PICTURE)</li>
  <li><b>WAV</b>(LIST-INFO; 가사는 일반적으로 <code>ICMT/comment</code>로 저장)</li>
</ul>

<p>
<i>일부 컨테이너(예: WAV)나 리더앱 조합에서는 가사/커버 호환성이 낮을 수 있으므로, 앱은 “메타데이터 조작이 불안정한 형식”에 대해 스낵바/다이얼로그로 경고합니다.</i>
</p>

<hr/>

<h2 id="i18n">현지화(i18n)</h2>
<ul>
  <li>ARB 기반 <code>AppLocalizations</code> 구조. <code>@@locale</code> 및 placeholder/설명 메타 사용.</li>
  <li>정책 문서 링크는 <code>Locale</code>의 <code>language</code>/<code>script</code>/<code>country</code> 후보를 우선순위 매핑하여 폴더 경로를 자동 선택합니다.</li>
</ul>

<hr/>

<h2 id="permissions">권한</h2>
<ul>
  <li><b>Android</b>: SYSTEM_ALERT_WINDOW(오버레이), 외부 저장소 접근(SAF는 사용자 선택 UI 제공), 알림(필요 시).</li>
  <li><b>iOS</b>: WebView 사용(오버레이 대신 대체 UI).</li>
</ul>

<hr/>

<h2 id="build">빌드/런</h2>
<ol>
  <li>Flutter 3.x, Dart 최신 안정 채널 권장.</li>
  <li>패키지 의존성: <code>google_mobile_ads</code>, <code>flutter_overlay_window</code>(Android), <code>file_picker</code>, <code>shared_preferences</code>, <code>webview_flutter</code>(iOS UI), <code>url_launcher</code>, FFmpegKit 계열 패키지.</li>
  <li>광고 단위 ID는 <b>반드시 본인 앱의 정식 단위</b>로 교체 후 배포.</li>
</ol>

<hr/>

<h2 id="troubleshooting">Troubleshooting</h2>
<ul>
  <li><b>광고가 안 뜸</b>: UMP 동의 상태 확인(테스트 기기에서는 폼 강제 노출), 동의 결과 반영 후 <code>MobileAds.initialize()</code> 호출 순서 점검. <sup>[1][2]</sup></li>
  <li><b>오버레이 미표시</b>: SYSTEM_ALERT_WINDOW/오버레이 권한 확인, 일부 OEM 전원/버블 옵션 점검. <sup>[3]</sup></li>
  <li><b>메타데이터 미반영</b>: 입력 코덱↔출력 컨테이너가 copy-only 호환이 맞는지 점검, WAV/일부 플레이어 호환성 이슈는 제한적.</li>
  <li><b>SAF 저장 실패</b>: 저장 위치/이름을 다시 선택, FFmpegKit SAF 파라미터 변환 실패 로그 확인. <sup>[4]</sup></li>
</ul>

<hr/>

<h2 id="license">라이선스/고지</h2>
<ul>
  <li>FFmpeg/FFmpegKit 관련 고지 및 소스 획득 경로 안내를 앱 내 <code>open-source/ffmpeg/WHERE-TO-GET-SOURCE.txt</code> 등으로 제공합니다. 배포 시 FFmpeg/코덱 라이선스/링킹 지침을 준수하십시오. <sup>[5]</sup></li>
</ul>

<hr/>

<h2>참고</h2>
<ol>
  <li id="r1">EU/EEA 사용자 동의 관련(Flutter) — Google AdMob 문서: “User consent in the European Economic Area (EEA)” 및 Flutter 구현 가이드(동의 수집, consent mode 등). <a href="https://developers.google.com/admob/flutter/privacy">developers.google.com/admob/flutter/privacy</a></li>
  <li id="r2">User Messaging Platform(UMP) SDK — Android/일반 가이드(동의 폼, 상태 질의, 옵션 재호출 등). <a href="https://developers.google.com/admob/android/privacy">developers.google.com/admob/android/privacy</a></li>
  <li id="r3">Android 오버레이(Flutter) — <code>flutter_overlay_window</code> 패키지(오버레이 권한/표시, 드래그/정렬 옵션 등). <a href="https://pub.dev/packages/flutter_overlay_window">pub.dev/packages/flutter_overlay_window</a></li>
  <li id="r4">SAF(저장/열기) 헬퍼 — FFmpegKit의 SAF 파라미터 변환/문서 선택 API(선택 다이얼로그를 통해 쓰기 경로/이름 지정). 예: <code>selectDocumentForWrite</code>, <code>getSafParameterForWrite</code>. <a href="https://pub.dev/documentation/ffmpeg_kit_flutter_new_gpl/latest/">pub.dev/documentation/ffmpeg_kit_flutter_new_gpl</a></li>
  <li id="r5">컨테이너별 메타데이터 개념(FFmpeg/일반): MP3(ID3), MP4/M4A(iTunes atoms), Ogg/Opus(Vorbis Comment + PICTURE), FLAC(Vorbis Comment/PICTURE), WAV(LIST-INFO) — FFmpeg/코덱 일반 규약 및 FFmpegKit 예제/문서 참조. <a href="https://pub.dev/documentation/ffmpeg_kit_audio_flutter/latest/">pub.dev/documentation/ffmpeg_kit_audio_flutter</a></li>
</ol>
