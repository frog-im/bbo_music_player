// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get exitDialogTitle => 'Möchten Sie die App beenden?';

  @override
  String get adLabel => 'Werbung';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get exit => 'Beenden';

  @override
  String get adLoading => 'Werbung wird geladen...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Audio-Metadaten — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Speichern unter';

  @override
  String get tooltipNoChanges => 'Keine Änderungen';

  @override
  String get tooltipReload => 'Neu laden';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Cover ausgewählt: $fileName';
  }

  @override
  String get btnClose => 'Schließen';

  @override
  String saveDone(Object displayName) {
    return 'Gespeichert: $displayName';
  }

  @override
  String get saveCancelled => 'Speichern abgebrochen';

  @override
  String saveFailed(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get hintNone => '(Keine)';

  @override
  String get metaLabelTitle => 'Titel';

  @override
  String get metaLabelArtist => 'Künstler';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genre';

  @override
  String get metaLabelYear => 'Jahr';

  @override
  String get metaLabelTrack => 'Track';

  @override
  String get metaLabelDisc => 'Disc';

  @override
  String get chooseActionTitle => 'Welche Aktion möchten Sie ausführen?';

  @override
  String get chooseActionBody =>
      'Die ausgewählte Option wird sofort ausgeführt.';

  @override
  String get actionEditOverlay => 'Größe und Position einstellen';

  @override
  String get actionLoadSubtitles => 'Untertitel laden';

  @override
  String get overlayPermissionNeeded =>
      'Overlay-Berechtigung erforderlich. Bitte in den Einstellungen erlauben.';

  @override
  String get overlayWindowDenied =>
      'Overlay-Fenster-Berechtigung wurde verweigert.';

  @override
  String get overlaySampleShort => 'Für kurzen Text';

  @override
  String get overlaySampleLong => 'Für langen Text';

  @override
  String get fontPickerTitle => 'Schriftgröße auswählen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonChange => 'Ändern';

  @override
  String get commonSettings => 'Einstellungen';

  @override
  String paletteFontLabel(Object size) {
    return 'Schriftgröße $size';
  }

  @override
  String get paletteLockCenterX => 'X-Achse mittig fixieren';

  @override
  String get calibFixHint => 'Versatz entfernen (Overlay fixieren)';

  @override
  String get calibMergeHint => 'Zusammenführen (in Δ-Warteschlange speichern)';

  @override
  String get calibFix => 'Versatz entfernen';

  @override
  String get calibMerge => 'Zusammenführen';

  @override
  String get saveApplyDelta => 'Korrektur anwenden und speichern';

  @override
  String get hudCenterSuffix => '(X-Zentrum fixiert)';

  @override
  String get webBack => 'Zurück';

  @override
  String get webForward => 'Vor';

  @override
  String get webReload => 'Neu laden';

  @override
  String get webClose => 'Schließen';

  @override
  String get webAddressHint => 'Adresse eingeben oder einfügen';

  @override
  String get emptyLyrics => 'Keine Songtexte empfangen.';

  @override
  String get overlayHintDoubleTap =>
      '* Doppeltippen, um das Overlay zu schließen.';

  @override
  String get overlayHintSwipe => '* Zum Seitenwechsel wischen.';

  @override
  String get menuPrivacy => 'Datenschutz';

  @override
  String get menuPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get menuPrivacyOptions => 'Datenschutzoptionen für Werbung';

  @override
  String get menuPrivacyOptionsSub =>
      'Einwilligung für personalisierte Werbung ändern';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'In der aktuellen Region/Sitzung nicht erforderlich';

  @override
  String get openUrlFailed => 'URL kann nicht geöffnet werden';

  @override
  String get privacyClosed => 'Datenschutzoptionen wurden geschlossen';

  @override
  String get privacyNotAvailable => 'Datenschutzformular ist nicht verfügbar';

  @override
  String get privacyExplainer =>
      'Diese App verwendet ein Werbe-SDK und stellt in Regionen mit Einwilligungspflicht einen Einwilligungsbildschirm bereit.';

  @override
  String get privacyOptionsRequiredLabel =>
      'Datenschutzoptionen (erforderlich)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Datenschutzoptionen (nicht erforderlich)';

  @override
  String get privacyOptionsUpdated => 'Datenschutzoptionen aktualisiert';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'In Ihrer Region sind Datenschutzoptionen nicht erforderlich';

  @override
  String get openSource => 'Open Source';

  @override
  String get openSourceGuideTitle => 'Open-Source-Hinweis';

  @override
  String get errorTitle => 'Fehler';

  @override
  String readFileFailed(Object error) {
    return 'Datei konnte nicht gelesen werden: $error';
  }

  @override
  String get privacySettingsTitle => 'Datenschutz- und Werbeeinstellungen';

  @override
  String get consentSectionTitle => 'Einwilligung (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Erforderlich';

  @override
  String get openPrivacyOptionsButton => 'Datenschutzoptionen öffnen';

  @override
  String get consentRegionalNote =>
      'Nutzer in EWR/UK/CH können ihre Einwilligung hier verwalten. Änderungen gelten für nachfolgende Werbeanfragen.';

  @override
  String get adsPersonalizationTitle =>
      'Personalisierung von Werbung und regionale Daten';

  @override
  String get npaTitle => 'Immer nicht personalisierte Werbung (NPA)';

  @override
  String get npaSubtitle => 'Fordert stets nicht personalisierte Werbung an';

  @override
  String get rdpTitle => 'US-eingeschränkte Datenverarbeitung (RDP)';

  @override
  String get rdpSubtitle =>
      'Konformität mit US-Bundesstaatengesetzen: rdp=1 in den Extras anhängen';

  @override
  String get childFlagsSectionTitle =>
      'Kennzeichnungen: Kinder/unter Einwilligungsalter';

  @override
  String get coppaTitle => 'Kindergerichteter Dienst (COPPA)';

  @override
  String get coppaSubtitle => 'Als kindergerichtet kennzeichnen';

  @override
  String get uacTitle => 'Unter dem gesetzlichen Einwilligungsalter (UAC)';

  @override
  String get uacSubtitle => 'Als unter dem Einwilligungsalter kennzeichnen';

  @override
  String get coppaNote =>
      'COPPA/UAC sind globale AdMob-Einstellungen und gelten sofort für anschließend geladene Anzeigen.';

  @override
  String get policySectionTitle => 'Datenschutzerklärung';

  @override
  String get viewInAppButton => 'In der App anzeigen';

  @override
  String get openStorePolicyButton => 'Store-Datenschutzerklärung öffnen';

  @override
  String get policySectionNote =>
      'Sowohl die Store-URL der Datenschutzerklärung als auch die In-App-Ansicht bereitstellen.';

  @override
  String get inAppPolicyTitle => 'Datenschutzerklärung';

  @override
  String get inAppPolicyFallback =>
      'Hier Ihre In-App-Datenschutzerklärung bereitstellen.';

  @override
  String get crossBorderTitle =>
      'Hinweis zur grenzüberschreitenden Datenübermittlung';

  @override
  String get viewFullPolicy => 'Gesamte Richtlinie anzeigen';

  @override
  String get crossBorderFullText =>
      '• Diese App verwendet Dienste von Drittanbietern (z. B. Google AdMob) zur Bereitstellung und Messung von Werbung. Dadurch können personenbezogene Daten in Länder außerhalb Ihres Wohnsitzstaates übermittelt werden.\n\n— Empfänger und Kontakt\n  · Empfänger: Google LLC und verbundene Unternehmen (Anbieter von AdMob)\n  · Dienst/Rolle: Auslieferung von Werbung, Bereitstellung von Werbe-/Messfunktionen, Verarbeitung zugehöriger Protokolle\n  · Website: admob.google.com\n  · Hinweis: Unter iOS hängt die Nutzung der Werbe-ID (IDFA) von den Plattformrichtlinien und dem Einwilligungsstatus der Nutzer ab.\n\n— Empfängerländer\n  · Die Vereinigten Staaten sowie Länder, in denen Google oder verbundene Unternehmen über Datenverarbeitungskapazitäten verfügen (z. B. Europa, Asien)\n\n— Zeitpunkt und Verfahren der Übermittlung\n  · Zeitpunkt: Beim Start der App sowie bei Anzeigenanfragen/-einblendungen/-klicks/-messungen nach Bedarf\n  · Verfahren: Netzwerkübertragung mit Verschlüsselung während der Übertragung (HTTPS/TLS)\n  · Schutzmaßnahmen: Verarbeitung gemäß anwendbaren internationalen Transferrahmen und vertraglichen Schutzmechanismen (z. B. Angemessenheitsbeschlüsse, Standardvertragsklauseln)\n\n— Zwecke und Datenkategorien\n  · Zwecke: Auslieferung von Werbung, Berücksichtigung der Personalisierungswahl, Leistungs-/Erfolgsmessung, statistische Analysen, Verbesserung der Dienstqualität/-stabilität\n  · Beispieldaten: Werbe-Kennungen (AAID/IDFA), App-Version/Einstellungen, grundlegende Geräte-/Netzwerkinformationen, Cookie-ähnliche Kennungen, Nutzungsprotokolle (einschließlich Anzeigeninteraktionen sowie Fehler/Abstürze), Region (Stadt-/Länderebene) usw.\n\n— Aufbewahrungsdauer\n  · Speicherung bis zur Zweckerreichung oder für den gesetzlich vorgeschriebenen Zeitraum; anschließend Löschung oder Anonymisierung/Pseudonymisierung\n\n— Widerspruchs- und Widerrufsrecht\n  · In den „Datenschutzoptionen“ der App können Sie Nicht-personalisierte Anzeigen (NPA) wählen. In Regionen wie EWR/VK/CH können Sie über den CMP/UMP-Einwilligungsbildschirm personalisierte/nicht-personalisierte Anzeigen wählen und Ihre Auswahl zurücksetzen.\n\n— Kontakt\n  · E-Mail: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Warnung zur Metadatenbearbeitung';

  @override
  String get metadataRiskBody =>
      'Bei einigen Formaten außer MP3 kann das Einbetten von Tags/Covern eingeschränkt sein oder die Kompatibilität je nach Player variieren, wodurch die Bearbeitung fehlschlagen kann.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 verwenden iTunes atoms, Ogg/Opus verwenden Vorbis Comment (PICTURE-Block), FLAC verwendet Vorbis Comment/PICTURE und WAV verwendet LIST-INFO.';

  @override
  String get doNotShowAgain => 'Nicht mehr anzeigen';

  @override
  String get continueLabel => 'Weiter';

  @override
  String paletteWidthFactor(String percent) {
    return 'Breite $percent %';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Höhe $percent %';
  }
}
