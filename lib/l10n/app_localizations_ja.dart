// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get exitDialogTitle => 'アプリを終了しますか？';

  @override
  String get adLabel => '広告';

  @override
  String get cancel => 'キャンセル';

  @override
  String get exit => '終了';

  @override
  String get adLoading => '広告を読み込み中...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'オーディオメタデータ — $fileName';
  }

  @override
  String get tooltipSaveAs => '名前を付けて保存';

  @override
  String get tooltipNoChanges => '変更はありません';

  @override
  String get tooltipReload => '再読み込み';

  @override
  String bannerCoverSelected(Object fileName) {
    return '選択したカバー: $fileName';
  }

  @override
  String get btnClose => '閉じる';

  @override
  String saveDone(Object displayName) {
    return '保存完了: $displayName';
  }

  @override
  String get saveCancelled => '保存がキャンセルされました';

  @override
  String saveFailed(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get hintNone => '(なし)';

  @override
  String get metaLabelTitle => 'タイトル';

  @override
  String get metaLabelArtist => 'アーティスト';

  @override
  String get metaLabelAlbum => 'アルバム';

  @override
  String get metaLabelGenre => 'ジャンル';

  @override
  String get metaLabelYear => '年';

  @override
  String get metaLabelTrack => 'トラック';

  @override
  String get metaLabelDisc => 'ディスク';

  @override
  String get chooseActionTitle => 'どの操作を実行しますか？';

  @override
  String get chooseActionBody => 'どちらかを選択すると直ちに実行されます。';

  @override
  String get actionEditOverlay => 'サイズと位置を設定';

  @override
  String get actionLoadSubtitles => '字幕を読み込む';

  @override
  String get overlayPermissionNeeded => 'オーバーレイ権限が必要です。設定で許可してください。';

  @override
  String get overlayWindowDenied => 'オーバーレイウィンドウの権限が拒否されました。';

  @override
  String get overlaySampleShort => '短いテキストの場合';

  @override
  String get overlaySampleLong => '長いテキストの場合';

  @override
  String get fontPickerTitle => 'フォントサイズを選択';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => '保存';

  @override
  String get commonChange => '変更';

  @override
  String get commonSettings => '設定';

  @override
  String paletteFontLabel(Object size) {
    return 'フォント $size';
  }

  @override
  String get paletteLockCenterX => 'X 軸中央を固定';

  @override
  String get calibFixHint => 'ずれを解消（オーバーレイ固定）';

  @override
  String get calibMergeHint => '重ね合わせ（Δ キューに保存）';

  @override
  String get calibFix => 'ずれを解消';

  @override
  String get calibMerge => '重ね合わせ';

  @override
  String get saveApplyDelta => '補正値を適用して保存';

  @override
  String get hudCenterSuffix => '（X 中央固定）';

  @override
  String get webBack => '戻る';

  @override
  String get webForward => '進む';

  @override
  String get webReload => '再読み込み';

  @override
  String get webClose => '閉じる';

  @override
  String get webAddressHint => 'アドレスを入力または貼り付け';

  @override
  String get emptyLyrics => '歌詞を取得できませんでした。';

  @override
  String get overlayHintDoubleTap => '※ ダブルタップでオーバーレイを終了します。';

  @override
  String get overlayHintSwipe => '※ スワイプしてページを切り替えます。';

  @override
  String get menuPrivacy => 'プライバシー';

  @override
  String get menuPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get menuPrivacyOptions => '広告のプライバシーオプション';

  @override
  String get menuPrivacyOptionsSub => 'パーソナライズド広告の同意状態を変更します';

  @override
  String get menuPrivacyOptionsNotRequired => '現在の地域/セッションでは表示は不要です';

  @override
  String get openUrlFailed => 'URL を開けません';

  @override
  String get privacyClosed => 'プライバシーオプション画面を閉じました';

  @override
  String get privacyNotAvailable => 'プライバシーフォームを利用できません';

  @override
  String get privacyExplainer =>
      'このアプリは広告配信のために広告 SDK を使用し、同意が必要な地域では同意管理画面を提供します。';

  @override
  String get privacyOptionsRequiredLabel => 'プライバシーオプション（必須）';

  @override
  String get privacyOptionsNotRequiredLabel => 'プライバシーオプション（不要）';

  @override
  String get privacyOptionsUpdated => 'プライバシーオプションを更新しました';

  @override
  String get privacyOptionsNotRequiredSnack => '現在の地域ではプライバシーオプションの表示は不要です';

  @override
  String get openSource => 'オープンソース';

  @override
  String get openSourceGuideTitle => 'オープンソースのご案内';

  @override
  String get errorTitle => 'エラー';

  @override
  String readFileFailed(Object error) {
    return 'ファイルを読み取れませんでした: $error';
  }

  @override
  String get privacySettingsTitle => 'プライバシーと広告の設定';

  @override
  String get consentSectionTitle => '同意（CMP/UMP）';

  @override
  String get entryRequiredChip => '表示が必要';

  @override
  String get openPrivacyOptionsButton => 'プライバシーオプションを開く';

  @override
  String get consentRegionalNote =>
      'EEA/UK/CH のユーザーはここで同意を管理できます。変更は以降の広告リクエストから反映されます。';

  @override
  String get adsPersonalizationTitle => '広告のパーソナライズと地域データ';

  @override
  String get npaTitle => '常に非パーソナライズド広告（NPA）';

  @override
  String get npaSubtitle => '常に NPA をリクエストします';

  @override
  String get rdpTitle => 'US Restricted Data Processing（RDP）';

  @override
  String get rdpSubtitle => '米州法対応: extras に rdp=1 を付与';

  @override
  String get childFlagsSectionTitle => '子供/未成年タグ';

  @override
  String get coppaTitle => '子供向けサービス（COPPA）';

  @override
  String get coppaSubtitle => '子供向けサービスのタグ';

  @override
  String get uacTitle => '年齢同意未満（UAC）';

  @override
  String get uacSubtitle => '未成年（年齢同意未満）のタグ';

  @override
  String get coppaNote =>
      'COPPA/UAC は AdMob のグローバル設定で即時に反映され、以降に読み込まれる広告から適用されます。';

  @override
  String get policySectionTitle => 'プライバシーポリシー';

  @override
  String get viewInAppButton => 'アプリ内で表示';

  @override
  String get openStorePolicyButton => 'ストアのポリシーを開く';

  @override
  String get policySectionNote => 'ストアのポリシー URL とアプリ内のポリシー画面の両方を提供してください。';

  @override
  String get inAppPolicyTitle => 'プライバシーポリシー';

  @override
  String get inAppPolicyFallback => 'ここにアプリ内ポリシーを提供してください。';

  @override
  String get crossBorderTitle => '越境データ移転に関する通知';

  @override
  String get viewFullPolicy => 'ポリシー全文を見る';

  @override
  String get crossBorderFullText =>
      '• 本アプリは広告の配信および効果測定のために第三者サービス（例: Google AdMob）を利用しており、その結果、個人データが国外へ移転される場合があります。\n\n— 受領者・連絡先\n  · 受領者: Google LLC およびその関連会社（AdMob 提供主体）\n  · サービス/役割: 広告配信、広告/測定機能の提供、関連ログの処理\n  · ウェブサイト: admob.google.com\n  · 備考: iOS における広告識別子（IDFA）の利用は、プラットフォームのポリシーおよびユーザーの同意状況に依存します。\n\n— 移転先の国/地域\n  · 米国ならびに Google または関連会社がデータ処理能力を有する国/地域（例: 欧州、アジア など）\n\n— 移転の時期・方法\n  · 時期: アプリ起動時、ならびに広告リクエスト/表示/クリック/測定が発生するタイミング\n  · 方法: ネットワーク伝送（転送区間の暗号化: HTTPS/TLS）\n  · 保護措置: 適用される国際的な移転枠組みおよび契約上の保護措置（例: 適法性認定、標準契約条項）に基づき処理\n\n— 目的・項目\n  · 目的: 広告配信、パーソナライズ選択の反映、パフォーマンス測定、統計分析、サービス品質/安定性の改善\n  · 項目例: 広告識別子（AAID/IDFA）、アプリのバージョン/設定、デバイス/ネットワークの基本情報、Cookie 類似の識別子、利用ログ（広告とのやり取りやエラー/クラッシュを含む）、地域（市/国レベル）など\n\n— 保管期間\n  · 目的達成まで、または適用法令で定められた期間保管し、その後は削除または非識別化\n\n— 同意の拒否・撤回\n  · アプリの「プライバシー設定」で非パーソナライズド広告（NPA）を選択できます。EEE/英国/スイス等の地域では、CMP/UMP の同意画面からパーソナライズ/非パーソナライズの選択や再設定が可能です。\n\n— お問い合わせ\n  · Eメール: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'メタデータ編集の注意';

  @override
  String get metadataRiskBody =>
      'MP3 以外の一部フォーマットでは、タグ／カバーの埋め込みが制限されていたり、プレーヤーごとに互換性が異なるため、編集に失敗する場合があります。';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 は iTunes atoms、Ogg/Opus は Vorbis Comment（PICTURE ブロック）、FLAC は Vorbis Comment/PICTURE、WAV は LIST-INFO を使用します。';

  @override
  String get doNotShowAgain => '今後表示しない';

  @override
  String get continueLabel => '続行';

  @override
  String paletteWidthFactor(String percent) {
    return '幅 $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return '高さ $percent%';
  }
}
