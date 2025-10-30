// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get exitDialogTitle => 'Voulez-vous quitter l\'application ?';

  @override
  String get adLabel => 'Publicité';

  @override
  String get cancel => 'Annuler';

  @override
  String get exit => 'Quitter';

  @override
  String get adLoading => 'Chargement de la publicité…';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Métadonnées audio — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Enregistrer sous';

  @override
  String get tooltipNoChanges => 'Aucune modification';

  @override
  String get tooltipReload => 'Recharger';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Couverture sélectionnée : $fileName';
  }

  @override
  String get btnClose => 'Fermer';

  @override
  String saveDone(Object displayName) {
    return 'Enregistré : $displayName';
  }

  @override
  String get saveCancelled => 'Enregistrement annulé';

  @override
  String saveFailed(Object error) {
    return 'Échec de l’enregistrement : $error';
  }

  @override
  String get hintNone => '(Aucun)';

  @override
  String get metaLabelTitle => 'Titre';

  @override
  String get metaLabelArtist => 'Artiste';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genre';

  @override
  String get metaLabelYear => 'Année';

  @override
  String get metaLabelTrack => 'Piste';

  @override
  String get metaLabelDisc => 'Disque';

  @override
  String get chooseActionTitle => 'Quelle action souhaitez-vous exécuter ?';

  @override
  String get chooseActionBody =>
      'L’option choisie sera exécutée immédiatement.';

  @override
  String get actionEditOverlay => 'Ajuster la taille et la position';

  @override
  String get actionLoadSubtitles => 'Charger les sous-titres';

  @override
  String get overlayPermissionNeeded =>
      'L’autorisation de superposition est requise. Veuillez l’autoriser dans les paramètres.';

  @override
  String get overlayWindowDenied =>
      'L’autorisation de fenêtre de superposition a été refusée.';

  @override
  String get overlaySampleShort => 'Pour les textes courts';

  @override
  String get overlaySampleLong => 'Pour les textes longs';

  @override
  String get fontPickerTitle => 'Sélectionner la taille de police';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonChange => 'Modifier';

  @override
  String get commonSettings => 'Paramètres';

  @override
  String paletteFontLabel(Object size) {
    return 'Taille de police $size';
  }

  @override
  String get paletteLockCenterX => 'Verrouiller le centre X';

  @override
  String get calibFixHint =>
      'Supprimer le décalage (verrouiller la superposition)';

  @override
  String get calibMergeHint => 'Fusionner (enregistrer dans la file Δ)';

  @override
  String get calibFix => 'Supprimer le décalage';

  @override
  String get calibMerge => 'Fusionner';

  @override
  String get saveApplyDelta => 'Appliquer la correction puis enregistrer';

  @override
  String get hudCenterSuffix => '(centre X verrouillé)';

  @override
  String get webBack => 'Précédent';

  @override
  String get webForward => 'Suivant';

  @override
  String get webReload => 'Recharger';

  @override
  String get webClose => 'Fermer';

  @override
  String get webAddressHint => 'Saisir ou coller l’adresse';

  @override
  String get emptyLyrics => 'Aucune parole reçue.';

  @override
  String get overlayHintDoubleTap =>
      '* Touchez deux fois pour fermer la superposition.';

  @override
  String get overlayHintSwipe => '* Balayez pour changer de page.';

  @override
  String get menuPrivacy => 'Confidentialité';

  @override
  String get menuPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get menuPrivacyOptions => 'Options de confidentialité publicitaire';

  @override
  String get menuPrivacyOptionsSub =>
      'Modifier votre consentement aux annonces personnalisées';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Non requis dans la région/la session actuelle';

  @override
  String get openUrlFailed => 'Impossible d’ouvrir l’URL';

  @override
  String get privacyClosed =>
      'L’écran des options de confidentialité a été fermé';

  @override
  String get privacyNotAvailable =>
      'Le formulaire de confidentialité est indisponible';

  @override
  String get privacyExplainer =>
      'Cette application utilise un SDK publicitaire pour diffuser des annonces et fournit un écran de consentement dans les régions où il est requis.';

  @override
  String get privacyOptionsRequiredLabel =>
      'Options de confidentialité (requis)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Options de confidentialité (non requis)';

  @override
  String get privacyOptionsUpdated => 'Options de confidentialité mises à jour';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Les options de confidentialité ne sont pas requises dans votre région';

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceGuideTitle => 'Avis open source';

  @override
  String get errorTitle => 'Erreur';

  @override
  String readFileFailed(Object error) {
    return 'Échec de lecture du fichier : $error';
  }

  @override
  String get privacySettingsTitle =>
      'Paramètres de confidentialité et publicités';

  @override
  String get consentSectionTitle => 'Consentement (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Requis';

  @override
  String get openPrivacyOptionsButton =>
      'Ouvrir les options de confidentialité';

  @override
  String get consentRegionalNote =>
      'Les utilisateurs de l’EEE/Royaume-Uni/Suisse peuvent gérer leur consentement ici. Les modifications s’appliquent aux requêtes d’annonces suivantes.';

  @override
  String get adsPersonalizationTitle =>
      'Personnalisation des annonces et données régionales';

  @override
  String get npaTitle => 'Toujours des annonces non personnalisées (NPA)';

  @override
  String get npaSubtitle => 'Toujours demander des annonces non personnalisées';

  @override
  String get rdpTitle =>
      'Traitement restreint des données aux États-Unis (RDP)';

  @override
  String get rdpSubtitle =>
      'Conformité aux lois des États-Unis : ajouter rdp=1 aux extras';

  @override
  String get childFlagsSectionTitle => 'Indicateurs enfant/mineur';

  @override
  String get coppaTitle => 'Service destiné aux enfants (COPPA)';

  @override
  String get coppaSubtitle => 'Marquer comme destiné aux enfants';

  @override
  String get uacTitle => 'Âge inférieur au consentement (UAC)';

  @override
  String get uacSubtitle => 'Marquer comme inférieur à l’âge de consentement';

  @override
  String get coppaNote =>
      'COPPA/UAC sont des paramètres globaux d’AdMob et s’appliquent immédiatement aux annonces chargées par la suite.';

  @override
  String get policySectionTitle => 'Politique de confidentialité';

  @override
  String get viewInAppButton => 'Afficher dans l’application';

  @override
  String get openStorePolicyButton => 'Ouvrir la politique sur la boutique';

  @override
  String get policySectionNote =>
      'Fournissez à la fois l’URL de la politique sur la boutique et un écran de politique dans l’application.';

  @override
  String get inAppPolicyTitle => 'Politique de confidentialité';

  @override
  String get inAppPolicyFallback =>
      'Fournissez ici votre politique de confidentialité intégrée à l’application.';

  @override
  String get crossBorderTitle => 'Avis de transfert de données transfrontière';

  @override
  String get viewFullPolicy => 'Voir la politique complète';

  @override
  String get crossBorderFullText =>
      '• Cette application utilise des services tiers (p. ex., Google AdMob) pour diffuser et mesurer la publicité. Par conséquent, vos données personnelles peuvent être transférées hors de votre pays.\n\n— Destinataire et contact\n  · Destinataire : Google LLC et ses sociétés affiliées (fournisseur d’AdMob)\n  · Service/Rôle : Diffusion d’annonces, fourniture de fonctions publicitaires/de mesure, traitement des journaux associés\n  · Site Web : admob.google.com\n  · Remarque : Sur iOS, l’utilisation de l’identifiant publicitaire (IDFA) dépend des règles de la plateforme et de l’état du consentement de l’utilisateur.\n\n— Pays de destination\n  · États-Unis et pays où Google ou ses affiliés disposent de capacités de traitement des données (p. ex., Europe, Asie)\n\n— Moment et méthode du transfert\n  · Moment : Au lancement de l’application et lorsque des requêtes/affichages/clics/mesures publicitaires se produisent, selon les besoins\n  · Méthode : Transmission réseau avec chiffrement en transit (HTTPS/TLS)\n  · Mesures de protection : Traitement conforme aux cadres internationaux applicables et aux garanties contractuelles (p. ex., décisions d’adéquation, clauses contractuelles types)\n\n— Finalités et catégories de données\n  · Finalités : Diffusion d’annonces, respect des choix de personnalisation, mesure des performances, analyses statistiques, amélioration de la qualité/stabilité du service\n  · Exemples de données : Identifiants publicitaires (AAID/IDFA), version/paramètres de l’application, informations de base sur l’appareil/le réseau, identifiants de type cookie, journaux d’utilisation (y compris interactions publicitaires et erreurs/plantages), région (niveau ville/pays), etc.\n\n— Durée de conservation\n  · Conservées jusqu’à l’atteinte des finalités ou pendant la période requise par la loi applicable, puis supprimées ou désidentifiées\n\n— Droit de refus et de retrait du consentement\n  · Vous pouvez choisir les annonces non personnalisées (NPA) dans les « options de confidentialité » de l’application. Dans les régions telles que l’EEE/R.-U./Suisse, l’écran de consentement CMP/UMP permet de choisir entre annonces personnalisées/non personnalisées et de réinitialiser le choix.\n\n— Contact\n  · E-mail : g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Avertissement d’édition des métadonnées';

  @override
  String get metadataRiskBody =>
      'Certains formats autres que MP3 peuvent limiter l’insertion de balises/pochettes ou présenter des différences de compatibilité selon le lecteur, ce qui peut entraîner l’échec de l’édition.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 utilisent iTunes atoms, Ogg/Opus utilisent Vorbis Comment (bloc PICTURE), FLAC utilise Vorbis Comment/PICTURE et WAV utilise LIST-INFO.';

  @override
  String get doNotShowAgain => 'Ne plus afficher';

  @override
  String get continueLabel => 'Continuer';

  @override
  String paletteWidthFactor(String percent) {
    return 'Largeur $percent %';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Hauteur $percent %';
  }
}
