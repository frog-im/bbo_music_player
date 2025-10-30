/*
// lib/privacy/privacy_settings_screen.dart
// 사용 전 pubspec.yaml에 추가:
// dependencies:
//   url_launcher: ^6.3.0

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../privacy/privacy_gate.dart';

class PRivacySettingsScreen extends StatefulWidget {
  const PRivacySettingsScreen({super.key});

  @override
  State<PRivacySettingsScreen> createState() => _PRivacySettingsScreenState();
}

class _PRivacySettingsScreenState extends State<PRivacySettingsScreen> {
  bool _npa = false;
  bool _rdp = false;
  bool _coppa = false;
  bool _uac = false;

  bool _entryRequired = false;
  bool _loading = true;

  // 스토어 정책 URL(배포용으로 교체)
  static const String _kStorePolicyUrl = 'https://example.com/privacy-policy';

  @override
  void initState() {
    super.initState();
    _LOadInitial();
  }

  Future<void> _LOadInitial() async {
    // 현재 PRivacy 내부 상태 반영
    _npa   = PRivacy.instance.GEtnpaAlways();
    _rdp   = PRivacy.instance.GEtsUsRestrictedProcessing();
    _coppa = PRivacy.instance.GEtsChildDirected();
    _uac   = PRivacy.instance.GEtsUnderAgeOfConsent();
    _entryRequired = PRivacy.instance.GEtsPrivacyEntryRequired();
    if (mounted) setState(() => _loading = false);
  }

  // UMP 동의 폼
  Future<void> _SHowUmp() async {
    await PRivacy.instance.SHowPrivacyOptionsForm();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy options updated')),
    );
    setState(() => _entryRequired = PRivacy.instance.GEtsPrivacyEntryRequired());
  }

  // 외부 URL 열기
  Future<void> LAunchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open: $url')),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // 인앱 정책 보기(자체 스크린)
  void OPenInAppPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _InAppPolicyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Ads Settings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // UMP
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined),
                      const SizedBox(width: 8),
                      Text('Consent (CMP/UMP)', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      if (_entryRequired)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('Entry required', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _SHowUmp,
                    icon: const Icon(Icons.tune),
                    label: const Text('Open Privacy Options'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EEA/UK/CH 사용자는 여기서 동의를 관리할 수 있습니다. '
                        '동의 변경은 이후 광고 요청부터 반영됩니다.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 광고 개인화/데이터 처리
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.ad_units_outlined),
                      const SizedBox(width: 8),
                      Text('Ads Personalization & Regional Data', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    title: const Text('Always Non-personalized Ads (NPA)'),
                    subtitle: const Text('항상 비개인화 광고를 요청합니다'),
                    value: _npa,
                    onChanged: (v) {
                      setState(() => _npa = v);
                      PRivacy.instance.SEtNpaAlways(v);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('US Restricted Data Processing (RDP)'),
                    subtitle: const Text('미국 주법 대응: rdp=1 extras 첨부'),
                    value: _rdp,
                    onChanged: (v) {
                      setState(() => _rdp = v);
                      PRivacy.instance.SEtUsRestrictedProcessing(v);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 아동/미성년 태깅
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.child_care_outlined),
                      const SizedBox(width: 8),
                      Text('Child / Under Age Flags', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    title: const Text('Child-Directed (COPPA)'),
                    subtitle: const Text('아동 대상 서비스 태그'),
                    value: _coppa,
                    onChanged: (v) {
                      setState(() => _coppa = v);
                      PRivacy.instance.SEtChildFlags(
                        childDirected: v,
                        underAgeOfConsent: _uac,
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Under Age of Consent (UAC)'),
                    subtitle: const Text('미성년(연령 동의 미만) 태그'),
                    value: _uac,
                    onChanged: (v) {
                      setState(() => _uac = v);
                      PRivacy.instance.SEtChildFlags(
                        childDirected: _coppa,
                        underAgeOfConsent: v,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'COPPA/UAC는 AdMob 전역 구성으로 즉시 반영되며, 이후 로드되는 광고부터 적용됩니다.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 개인정보처리방침: 인앱/스토어
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description_outlined),
                      const SizedBox(width: 8),
                      Text('Privacy Policy', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: OPenInAppPolicy,
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text('View In-App'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => LAunchExternalUrl(_kStorePolicyUrl),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open Store Policy'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '스토어(배포 채널)의 정책 URL과 인앱 정책 화면을 모두 제공하세요.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 인앱 정책 화면(예시): assets/privacy_policy.html 읽어서 표시
// pubspec.yaml에 아래 추가 필요:
// flutter:
//   assets:
//     - assets/privacy_policy.html
// ─────────────────────────────────────────────────────────────
class _InAppPolicyScreen extends StatelessWidget {
  const _InAppPolicyScreen();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/privacy_policy.html'),
      builder: (context, snap) {
        final body = snap.data ?? '<h3>Privacy Policy</h3><p>Provide your in-app policy here.</p>';
        return Scaffold(
          appBar: AppBar(title: const Text('Privacy Policy')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText.rich(
                // 간단 표시: HTML 파서는 생략하고 프리텍스트 출력
                TextSpan(text: _STripHtml(body)),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }

  // 아주 단순한 HTML 태그 제거(뷰어 대용). 필요시 proper HTML 위젯 사용.
  static String _STripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
*/
// 사용 전 pubspec.yaml에 추가:
// dependencies:
//   url_launcher: ^6.3.0

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../privacy/privacy_gate.dart';

// l10n

class PRivacySettingsScreen extends StatefulWidget {
  const PRivacySettingsScreen({super.key});

  @override
  State<PRivacySettingsScreen> createState() => _PRivacySettingsScreenState();
}

class _PRivacySettingsScreenState extends State<PRivacySettingsScreen> {
  bool _npa = false;
  bool _rdp = false;
  bool _coppa = false;
  bool _uac = false;

  bool _entryRequired = false;
  bool _loading = true;

  // 스토어 정책 URL(배포용으로 교체)
  static const String _kStorePolicyUrl = 'https://example.com/privacy-policy';

  @override
  void initState() {
    super.initState();
    _LOadInitial();
  }

  Future<void> _LOadInitial() async {
    // 현재 PRivacy 내부 상태 반영
    _npa   = PRivacy.instance.GEtnpaAlways();
    _rdp   = PRivacy.instance.GEtsUsRestrictedProcessing();
    _coppa = PRivacy.instance.GEtsChildDirected();
    _uac   = PRivacy.instance.GEtsUnderAgeOfConsent();
    _entryRequired = PRivacy.instance.GEtsPrivacyEntryRequired();
    if (mounted) setState(() => _loading = false);
  }

  // UMP 동의 폼
  Future<void> _SHowUmp() async {
    await PRivacy.instance.SHowPrivacyOptionsForm();
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.privacyOptionsUpdated)),
    );
    setState(() => _entryRequired = PRivacy.instance.GEtsPrivacyEntryRequired());
  }

  // 외부 URL 열기
  Future<void> LAunchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (!mounted) return;
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.openUrlFailed)),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // 인앱 정책 보기(자체 스크린)
  void OPenInAppPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _InAppPolicyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.privacySettingsTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // UMP
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined),
                      const SizedBox(width: 8),
                      Text(t.consentSectionTitle, style: theme.textTheme.titleMedium),
                      const Spacer(),
                      if (_entryRequired)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(t.entryRequiredChip, style: const TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _SHowUmp,
                    icon: const Icon(Icons.tune),
                    label: Text(t.openPrivacyOptionsButton),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.consentRegionalNote,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 광고 개인화/데이터 처리
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.ad_units_outlined),
                      const SizedBox(width: 8),
                      Text(t.adsPersonalizationTitle, style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    title: Text(t.npaTitle),
                    subtitle: Text(t.npaSubtitle),
                    value: _npa,
                    onChanged: (v) {
                      setState(() => _npa = v);
                      PRivacy.instance.SEtNpaAlways(v);
                    },
                  ),
                  SwitchListTile(
                    title: Text(t.rdpTitle),
                    subtitle: Text(t.rdpSubtitle),
                    value: _rdp,
                    onChanged: (v) {
                      setState(() => _rdp = v);
                      PRivacy.instance.SEtUsRestrictedProcessing(v);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 아동/미성년 태깅
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.child_care_outlined),
                      const SizedBox(width: 8),
                      Text(t.childFlagsSectionTitle, style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    title: Text(t.coppaTitle),
                    subtitle: Text(t.coppaSubtitle),
                    value: _coppa,
                    onChanged: (v) {
                      setState(() => _coppa = v);
                      PRivacy.instance.SEtChildFlags(
                        childDirected: v,
                        underAgeOfConsent: _uac,
                      );
                    },
                  ),
                  SwitchListTile(
                    title: Text(t.uacTitle),
                    subtitle: Text(t.uacSubtitle),
                    value: _uac,
                    onChanged: (v) {
                      setState(() => _uac = v);
                      PRivacy.instance.SEtChildFlags(
                        childDirected: _coppa,
                        underAgeOfConsent: v,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.coppaNote,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 개인정보처리방침: 인앱/스토어
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description_outlined),
                      const SizedBox(width: 8),
                      Text(t.policySectionTitle, style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: OPenInAppPolicy,
                          icon: const Icon(Icons.visibility_outlined),
                          label: Text(t.viewInAppButton),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => {LAunchExternalUrl(_kStorePolicyUrl),print('ssssssssssssssssssssssssssssssssssssssssssss눌림')},
                          icon: const Icon(Icons.open_in_new),
                          label: Text(t.openStorePolicyButton),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.policySectionNote,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 인앱 정책 화면(예시): assets/privacy_policy.html 읽어서 표시
// pubspec.yaml에 아래 추가 필요:
// flutter:
//   assets:
//     - assets/privacy_policy.html
// ─────────────────────────────────────────────────────────────
class _InAppPolicyScreen extends StatelessWidget {
  const _InAppPolicyScreen();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/privacy_policy.html'),
      builder: (context, snap) {
        final body = snap.data ?? '<h3>${t.inAppPolicyTitle}</h3><p>${t.inAppPolicyFallback}</p>';
        return Scaffold(
          appBar: AppBar(title: Text(t.inAppPolicyTitle)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText.rich(
                // 간단 표시: HTML 파서는 생략하고 프리텍스트 출력
                TextSpan(text: _STripHtml(body)),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }

  // 아주 단순한 HTML 태그 제거(뷰어 대용). 필요시 proper HTML 위젯 사용.
  static String _STripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
