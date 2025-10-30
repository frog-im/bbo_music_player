// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get exitDialogTitle => 'Desideri uscire dall\'app?';

  @override
  String get adLabel => 'Annuncio';

  @override
  String get cancel => 'Annulla';

  @override
  String get exit => 'Esci';

  @override
  String get adLoading => 'Caricamento annuncio...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Metadati audio — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Salva con nome';

  @override
  String get tooltipNoChanges => 'Nessuna modifica';

  @override
  String get tooltipReload => 'Ricarica';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Copertina selezionata: $fileName';
  }

  @override
  String get btnClose => 'Chiudi';

  @override
  String saveDone(Object displayName) {
    return 'Salvato: $displayName';
  }

  @override
  String get saveCancelled => 'Salvataggio annullato';

  @override
  String saveFailed(Object error) {
    return 'Salvataggio non riuscito: $error';
  }

  @override
  String get hintNone => '(Nessuno)';

  @override
  String get metaLabelTitle => 'Titolo';

  @override
  String get metaLabelArtist => 'Artista';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genere';

  @override
  String get metaLabelYear => 'Anno';

  @override
  String get metaLabelTrack => 'Traccia';

  @override
  String get metaLabelDisc => 'Disco';

  @override
  String get chooseActionTitle => 'Quale azione desideri eseguire?';

  @override
  String get chooseActionBody => 'La scelta verrà eseguita immediatamente.';

  @override
  String get actionEditOverlay => 'Imposta dimensione e posizione';

  @override
  String get actionLoadSubtitles => 'Carica sottotitoli';

  @override
  String get overlayPermissionNeeded =>
      'È necessario il permesso di overlay. Consenti dalle Impostazioni.';

  @override
  String get overlayWindowDenied => 'Permesso finestra overlay negato.';

  @override
  String get overlaySampleShort => 'Per testo breve';

  @override
  String get overlaySampleLong => 'Per testo lungo';

  @override
  String get fontPickerTitle => 'Seleziona dimensione carattere';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonChange => 'Modifica';

  @override
  String get commonSettings => 'Impostazioni';

  @override
  String paletteFontLabel(Object size) {
    return 'Dimensione carattere $size';
  }

  @override
  String get paletteLockCenterX => 'Blocca centro X';

  @override
  String get calibFixHint => 'Rimuovi offset (blocca overlay)';

  @override
  String get calibMergeHint => 'Unisci (salva nella coda Δ)';

  @override
  String get calibFix => 'Rimuovi offset';

  @override
  String get calibMerge => 'Unisci';

  @override
  String get saveApplyDelta => 'Applica correzione e salva';

  @override
  String get hudCenterSuffix => '(centro X bloccato)';

  @override
  String get webBack => 'Indietro';

  @override
  String get webForward => 'Avanti';

  @override
  String get webReload => 'Ricarica';

  @override
  String get webClose => 'Chiudi';

  @override
  String get webAddressHint => 'Inserisci o incolla l\'indirizzo';

  @override
  String get emptyLyrics => 'Testo dei brani non ricevuto.';

  @override
  String get overlayHintDoubleTap =>
      '* Tocca due volte per chiudere l\'overlay.';

  @override
  String get overlayHintSwipe => '* Scorri per cambiare pagina.';

  @override
  String get menuPrivacy => 'Privacy';

  @override
  String get menuPrivacyPolicy => 'Informativa sulla privacy';

  @override
  String get menuPrivacyOptions => 'Opzioni privacy annunci';

  @override
  String get menuPrivacyOptionsSub =>
      'Modifica lo stato del consenso per gli annunci personalizzati';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Non richiesto per l\'area/sessione corrente';

  @override
  String get openUrlFailed => 'Impossibile aprire l\'URL';

  @override
  String get privacyClosed => 'Schermata delle opzioni privacy chiusa';

  @override
  String get privacyNotAvailable => 'Modulo privacy non disponibile';

  @override
  String get privacyExplainer =>
      'Questa app utilizza un SDK pubblicitario per mostrare annunci e fornisce una schermata di consenso nelle regioni in cui è richiesto.';

  @override
  String get privacyOptionsRequiredLabel => 'Opzioni privacy (obbligatorie)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Opzioni privacy (non obbligatorie)';

  @override
  String get privacyOptionsUpdated => 'Opzioni privacy aggiornate';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Nella tua regione le opzioni privacy non sono richieste';

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceGuideTitle => 'Informativa open source';

  @override
  String get errorTitle => 'Errore';

  @override
  String readFileFailed(Object error) {
    return 'Impossibile leggere il file: $error';
  }

  @override
  String get privacySettingsTitle => 'Impostazioni privacy e annunci';

  @override
  String get consentSectionTitle => 'Consenso (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Richiesto';

  @override
  String get openPrivacyOptionsButton => 'Apri opzioni privacy';

  @override
  String get consentRegionalNote =>
      'Gli utenti EEA/UK/CH possono gestire qui il consenso. Le modifiche si applicano dalle richieste di annuncio successive.';

  @override
  String get adsPersonalizationTitle =>
      'Personalizzazione annunci e dati regionali';

  @override
  String get npaTitle => 'Sempre annunci non personalizzati (NPA)';

  @override
  String get npaSubtitle => 'Richiedi sempre NPA';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Conformità alle leggi statali USA: aggiungi rdp=1 negli extras';

  @override
  String get childFlagsSectionTitle => 'Tag bambino/minorenne';

  @override
  String get coppaTitle => 'Servizi rivolti ai minori (COPPA)';

  @override
  String get coppaSubtitle => 'Tag per servizi rivolti ai minori';

  @override
  String get uacTitle => 'Età inferiore al consenso (UAC)';

  @override
  String get uacSubtitle => 'Tag minorenne (età inferiore al consenso)';

  @override
  String get coppaNote =>
      'COPPA/UAC è una configurazione globale di AdMob, ha effetto immediato e si applica agli annunci caricati successivamente.';

  @override
  String get policySectionTitle => 'Informativa sulla privacy';

  @override
  String get viewInAppButton => 'Vedi in-app';

  @override
  String get openStorePolicyButton => 'Apri informativa su Store';

  @override
  String get policySectionNote =>
      'Fornisci sia l\'URL dell\'informativa sullo Store sia la schermata dell\'informativa in-app.';

  @override
  String get inAppPolicyTitle => 'Informativa sulla privacy';

  @override
  String get inAppPolicyFallback => 'Fornisci qui l\'informativa in-app.';

  @override
  String get crossBorderTitle =>
      'Informativa sul trasferimento transfrontaliero dei dati';

  @override
  String get viewFullPolicy => 'Vedi informativa completa';

  @override
  String get crossBorderFullText =>
      '• Questa app utilizza servizi di terze parti (es. Google AdMob) per l’erogazione e la misurazione degli annunci; di conseguenza, i tuoi dati personali possono essere trasferiti al di fuori del tuo paese.\n\n— Destinatario e contatto\n  · Destinatario: Google LLC e società affiliate (fornitore di AdMob)\n  · Servizio/Ruolo: Erogazione degli annunci, fornitura di funzioni pubblicitarie/di misurazione, trattamento dei log correlati\n  · Sito web: admob.google.com\n  · Nota: Su iOS, l’uso dell’identificatore pubblicitario (IDFA) dipende dalle politiche della piattaforma e dallo stato del consenso dell’utente.\n\n— Paesi di destinazione\n  · Stati Uniti e paesi in cui Google o le sue affiliate dispongono di capacità di trattamento dei dati (es. Europa, Asia)\n\n— Momento e metodo del trasferimento\n  · Momento: All’avvio dell’app e quando avvengono richieste/visualizzazioni/click/misure degli annunci, secondo necessità\n  · Metodo: Trasmissione di rete con crittografia in transito (HTTPS/TLS)\n  · Garanzie: Trattamento in conformità ai quadri internazionali applicabili e alle tutele contrattuali (es. decisioni di adeguatezza, Clausole Contrattuali Standard)\n\n— Finalità e categorie di dati\n  · Finalità: Erogazione degli annunci, rispetto delle scelte di personalizzazione, misurazione delle prestazioni, analisi statistiche, miglioramento della qualità/stabilità del servizio\n  · Esempi di dati: Identificatori pubblicitari (AAID/IDFA), versione/impostazioni dell’app, informazioni di base su dispositivo/rete, identificatori simili ai cookie, registri d’uso (incluse interazioni con gli annunci ed errori/arresti anomali), area (livello città/Paese), ecc.\n\n— Periodo di conservazione\n  · Conservati fino al raggiungimento delle finalità o per il periodo richiesto dalla legge applicabile, quindi eliminati o resi non identificabili\n\n— Diritto di rifiuto e di revoca del consenso\n  · Nelle “Opzioni sulla privacy” dell’app puoi scegliere Annunci non personalizzati (NPA). Nelle regioni come SEE/Regno Unito/Svizzera, la schermata di consenso CMP/UMP consente di scegliere tra annunci personalizzati/non personalizzati e di reimpostare la scelta.\n\n— Contatto\n  · E-mail: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Avviso sulla modifica dei metadati';

  @override
  String get metadataRiskBody =>
      'Alcuni formati diversi da MP3 possono limitare l’inserimento di tag/copertine o avere compatibilità diversa a seconda del lettore, con possibili errori di modifica.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 usano iTunes atoms, Ogg/Opus usano Vorbis Comment (blocco PICTURE), FLAC usa Vorbis Comment/PICTURE e WAV usa LIST-INFO.';

  @override
  String get doNotShowAgain => 'Non mostrare più';

  @override
  String get continueLabel => 'Continua';

  @override
  String paletteWidthFactor(String percent) {
    return 'Larghezza $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Altezza $percent%';
  }
}
