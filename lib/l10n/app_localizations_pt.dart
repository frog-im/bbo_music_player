// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get exitDialogTitle => 'Do you want to exit the app?';

  @override
  String get adLabel => 'Ad';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get adLoading => 'Loading ad...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Audio metadata — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Save as';

  @override
  String get tooltipNoChanges => 'No changes';

  @override
  String get tooltipReload => 'Reload';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Cover selected: $fileName';
  }

  @override
  String get btnClose => 'Close';

  @override
  String saveDone(Object displayName) {
    return 'Saved: $displayName';
  }

  @override
  String get saveCancelled => 'Save canceled';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get hintNone => '(None)';

  @override
  String get metaLabelTitle => 'Title';

  @override
  String get metaLabelArtist => 'Artist';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genre';

  @override
  String get metaLabelYear => 'Year';

  @override
  String get metaLabelTrack => 'Track';

  @override
  String get metaLabelDisc => 'Disc';

  @override
  String get chooseActionTitle => 'What would you like to do?';

  @override
  String get chooseActionBody => 'Selecting one will run it immediately.';

  @override
  String get actionEditOverlay => 'Adjust size and position';

  @override
  String get actionLoadSubtitles => 'Load subtitles';

  @override
  String get overlayPermissionNeeded =>
      'Overlay permission is required. Please allow it in Settings.';

  @override
  String get overlayWindowDenied => 'Overlay Window permission was denied.';

  @override
  String get overlaySampleShort => 'For short text';

  @override
  String get overlaySampleLong => 'For long text';

  @override
  String get fontPickerTitle => 'Select font size';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonChange => 'Change';

  @override
  String get commonSettings => 'Settings';

  @override
  String paletteFontLabel(Object size) {
    return 'Font $size';
  }

  @override
  String get paletteLockCenterX => 'Lock center X';

  @override
  String get calibFixHint => 'Remove offset (lock overlay)';

  @override
  String get calibMergeHint => 'Merge (save to Δ queue)';

  @override
  String get calibFix => 'Remove offset';

  @override
  String get calibMerge => 'Merge';

  @override
  String get saveApplyDelta => 'Apply correction then save';

  @override
  String get hudCenterSuffix => '(X center locked)';

  @override
  String get webBack => 'Back';

  @override
  String get webForward => 'Forward';

  @override
  String get webReload => 'Reload';

  @override
  String get webClose => 'Close';

  @override
  String get webAddressHint => 'Enter or paste address';

  @override
  String get emptyLyrics => 'No lyrics received.';

  @override
  String get overlayHintDoubleTap => '* Double tap to close the overlay.';

  @override
  String get overlayHintSwipe => '* Swipe to change pages.';

  @override
  String get menuPrivacy => 'Privacy';

  @override
  String get menuPrivacyPolicy => 'Privacy Policy';

  @override
  String get menuPrivacyOptions => 'Ad privacy options';

  @override
  String get menuPrivacyOptionsSub =>
      'Change your consent for personalized ads';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Not required in the current region/session';

  @override
  String get openUrlFailed => 'Cannot open URL';

  @override
  String get privacyClosed => 'Closed the privacy options screen';

  @override
  String get privacyNotAvailable => 'Privacy form is not available';

  @override
  String get privacyExplainer =>
      'This app uses an advertising SDK to serve ads and provides a consent screen in regions where consent is required.';

  @override
  String get privacyOptionsRequiredLabel => 'Privacy options (required)';

  @override
  String get privacyOptionsNotRequiredLabel => 'Privacy options (not required)';

  @override
  String get privacyOptionsUpdated => 'Privacy options updated';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Privacy options are not required in your region';

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceGuideTitle => 'Open source notice';

  @override
  String get errorTitle => 'Error';

  @override
  String readFileFailed(Object error) {
    return 'Failed to read file: $error';
  }

  @override
  String get privacySettingsTitle => 'Privacy & Ads Settings';

  @override
  String get consentSectionTitle => 'Consent (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Entry required';

  @override
  String get openPrivacyOptionsButton => 'Open privacy options';

  @override
  String get consentRegionalNote =>
      'Users in the EEA/UK/CH can manage consent here. Changes take effect on subsequent ad requests.';

  @override
  String get adsPersonalizationTitle => 'Ads personalization & regional data';

  @override
  String get npaTitle => 'Always non-personalized ads (NPA)';

  @override
  String get npaSubtitle => 'Always request non-personalized ads';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Compliance for U.S. state laws: attach rdp=1 extras';

  @override
  String get childFlagsSectionTitle => 'Child/under-age tags';

  @override
  String get coppaTitle => 'Child-directed service (COPPA)';

  @override
  String get coppaSubtitle => 'Tag as child-directed';

  @override
  String get uacTitle => 'Under the age of consent (UAC)';

  @override
  String get uacSubtitle => 'Tag as under the age of consent';

  @override
  String get coppaNote =>
      'COPPA/UAC are global AdMob settings and take effect immediately for subsequently loaded ads.';

  @override
  String get policySectionTitle => 'Privacy Policy';

  @override
  String get viewInAppButton => 'View in-app';

  @override
  String get openStorePolicyButton => 'Open store policy';

  @override
  String get policySectionNote =>
      'Provide both the store policy URL and the in-app policy screen.';

  @override
  String get inAppPolicyTitle => 'Privacy Policy';

  @override
  String get inAppPolicyFallback => 'Provide your in-app policy here.';

  @override
  String get crossBorderTitle => 'Cross-Border Data Transfer Notice';

  @override
  String get viewFullPolicy => 'View full policy';

  @override
  String get crossBorderFullText =>
      '• This app uses third-party services (e.g., Google AdMob) to provide and measure advertising. As a result, your personal data may be transferred outside your country.\n\n— Recipient(s) and contact\n  · Recipient: Google LLC and its affiliates (provider of AdMob)\n  · Service/Role: Ad serving, provision of ads/measurement features, processing of related logs\n  · Website: admob.google.com\n  · Note: On iOS, the use of the advertising identifier (IDFA) depends on platform policy and the user\'s consent status.\n\n— Destination countries\n  · The United States and countries where Google or its affiliates have data-processing capabilities (e.g., Europe, Asia, etc.)\n\n— Timing and method of transfer\n  · Timing: When the app launches and when ad requests/impressions/clicks/measurement occur as needed\n  · Method: Network transmission with in-transit encryption (HTTPS/TLS)\n  · Safeguards: Processed under applicable international transfer frameworks and contractual protections (e.g., adequacy decisions, Standard Contractual Clauses)\n\n— Purposes and data items\n  · Purposes: Ad delivery, honoring personalization choices, performance measurement, statistical analysis, improvement of service quality/stability\n  · Examples of data items: Advertising identifiers (AAID/IDFA), app version/settings, basic device/network information, cookie-like identifiers, usage logs (including ad interactions and errors/crashes), region (city/country level), etc.\n\n— Retention period\n  · Retained until the purposes are achieved or for the period required by applicable laws, then deleted or de-identified\n\n— Right to refuse or withdraw consent\n  · You can choose Non-Personalized Ads (NPA) in the app\'s “Privacy options.” In regions such as the EEA/UK/CH, the CMP/UMP consent screen allows choosing personalized/non-personalized ads and resetting choices.\n\n— Contact\n  · Email: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Metadata Editing Warning';

  @override
  String get metadataRiskBody =>
      'Some formats other than MP3 may restrict tag/cover embedding or differ in player compatibility, which can cause editing to fail.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 use iTunes atoms, Ogg/Opus use Vorbis Comment (PICTURE block), FLAC uses Vorbis Comment/PICTURE, and WAV uses LIST-INFO.';

  @override
  String get doNotShowAgain => 'Don\'t show again';

  @override
  String get continueLabel => 'Continue';

  @override
  String paletteWidthFactor(String percent) {
    return 'Width $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Height $percent%';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get exitDialogTitle => 'Deseja sair do aplicativo?';

  @override
  String get adLabel => 'Anúncio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exit => 'Sair';

  @override
  String get adLoading => 'Carregando anúncio...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Metadados de áudio — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Salvar como';

  @override
  String get tooltipNoChanges => 'Nenhuma alteração';

  @override
  String get tooltipReload => 'Recarregar';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Capa selecionada: $fileName';
  }

  @override
  String get btnClose => 'Fechar';

  @override
  String saveDone(Object displayName) {
    return 'Salvo: $displayName';
  }

  @override
  String get saveCancelled => 'Salvamento cancelado';

  @override
  String saveFailed(Object error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get hintNone => '(Nenhum)';

  @override
  String get metaLabelTitle => 'Título';

  @override
  String get metaLabelArtist => 'Artista';

  @override
  String get metaLabelAlbum => 'Álbum';

  @override
  String get metaLabelGenre => 'Gênero';

  @override
  String get metaLabelYear => 'Ano';

  @override
  String get metaLabelTrack => 'Faixa';

  @override
  String get metaLabelDisc => 'Disco';

  @override
  String get chooseActionTitle => 'Qual ação deseja executar?';

  @override
  String get chooseActionBody =>
      'Ao escolher uma das opções, ela será executada imediatamente.';

  @override
  String get actionEditOverlay => 'Definir tamanho e posição';

  @override
  String get actionLoadSubtitles => 'Carregar legendas';

  @override
  String get overlayPermissionNeeded =>
      'A permissão de sobreposição é necessária. Ative-a em Configurações.';

  @override
  String get overlayWindowDenied =>
      'A permissão de janela de sobreposição foi negada.';

  @override
  String get overlaySampleShort => 'Para texto curto';

  @override
  String get overlaySampleLong => 'Para texto longo';

  @override
  String get fontPickerTitle => 'Selecionar tamanho da fonte';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonChange => 'Alterar';

  @override
  String get commonSettings => 'Configurações';

  @override
  String paletteFontLabel(Object size) {
    return 'Tamanho da fonte $size';
  }

  @override
  String get paletteLockCenterX => 'Fixar centro em X';

  @override
  String get calibFixHint => 'Remover desvio (fixar sobreposição)';

  @override
  String get calibMergeHint => 'Mesclar (salvar na fila Δ)';

  @override
  String get calibFix => 'Remover desvio';

  @override
  String get calibMerge => 'Mesclar';

  @override
  String get saveApplyDelta => 'Aplicar correção e salvar';

  @override
  String get hudCenterSuffix => '(centro X fixado)';

  @override
  String get webBack => 'Voltar';

  @override
  String get webForward => 'Avançar';

  @override
  String get webReload => 'Recarregar';

  @override
  String get webClose => 'Fechar';

  @override
  String get webAddressHint => 'Digite ou cole o endereço';

  @override
  String get emptyLyrics => 'Nenhuma letra recebida.';

  @override
  String get overlayHintDoubleTap =>
      '* Toque duas vezes para fechar a sobreposição.';

  @override
  String get overlayHintSwipe => '* Deslize para trocar de página.';

  @override
  String get menuPrivacy => 'Privacidade';

  @override
  String get menuPrivacyPolicy => 'Política de Privacidade';

  @override
  String get menuPrivacyOptions => 'Opções de privacidade de anúncios';

  @override
  String get menuPrivacyOptionsSub =>
      'Altere o status de consentimento para anúncios personalizados';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Não é necessário exibir na região/sessão atual';

  @override
  String get openUrlFailed => 'Não foi possível abrir a URL';

  @override
  String get privacyClosed => 'A tela de opções de privacidade foi fechada';

  @override
  String get privacyNotAvailable =>
      'O formulário de privacidade não está disponível';

  @override
  String get privacyExplainer =>
      'Este app usa um SDK de anúncios para exibir publicidade e oferece uma tela de consentimento nas regiões em que isso é obrigatório.';

  @override
  String get privacyOptionsRequiredLabel =>
      'Opções de privacidade (obrigatório)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Opções de privacidade (não obrigatório)';

  @override
  String get privacyOptionsUpdated => 'Opções de privacidade atualizadas';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Na sua região não é necessário exibir opções de privacidade';

  @override
  String get openSource => 'Código aberto';

  @override
  String get openSourceGuideTitle => 'Aviso de código aberto';

  @override
  String get errorTitle => 'Erro';

  @override
  String readFileFailed(Object error) {
    return 'Falha ao ler o arquivo: $error';
  }

  @override
  String get privacySettingsTitle => 'Privacidade e configurações de anúncios';

  @override
  String get consentSectionTitle => 'Consentimento (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Exibição necessária';

  @override
  String get openPrivacyOptionsButton => 'Abrir opções de privacidade';

  @override
  String get consentRegionalNote =>
      'Usuários do EEE/Reino Unido/Suíça podem gerenciar o consentimento aqui. As alterações serão aplicadas nas próximas solicitações de anúncio.';

  @override
  String get adsPersonalizationTitle =>
      'Personalização de anúncios e dados regionais';

  @override
  String get npaTitle => 'Sempre anúncios não personalizados (NPA)';

  @override
  String get npaSubtitle => 'Sempre solicitar NPA';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Conformidade com leis estaduais dos EUA: adicionar rdp=1 em extras';

  @override
  String get childFlagsSectionTitle => 'Tags de criança/menor de idade';

  @override
  String get coppaTitle => 'Serviço voltado para crianças (COPPA)';

  @override
  String get coppaSubtitle => 'Tag de serviço voltado para crianças';

  @override
  String get uacTitle => 'Abaixo da idade de consentimento (UAC)';

  @override
  String get uacSubtitle => 'Tag de menor (abaixo da idade de consentimento)';

  @override
  String get coppaNote =>
      'COPPA/UAC é uma configuração global do AdMob, entra em vigor imediatamente e se aplica aos anúncios carregados a partir de então.';

  @override
  String get policySectionTitle => 'Política de Privacidade';

  @override
  String get viewInAppButton => 'Ver no app';

  @override
  String get openStorePolicyButton => 'Abrir política na loja';

  @override
  String get policySectionNote =>
      'Forneça a URL da política na loja e também a tela da política dentro do app.';

  @override
  String get inAppPolicyTitle => 'Política de Privacidade';

  @override
  String get inAppPolicyFallback => 'Forneça a política no app aqui.';

  @override
  String get crossBorderTitle =>
      'Aviso de transferência internacional de dados';

  @override
  String get viewFullPolicy => 'Ver política completa';

  @override
  String get crossBorderFullText =>
      '• Este app utiliza serviços de terceiros (por exemplo, Google AdMob) para exibir e mensurar anúncios; por isso, seus dados pessoais podem ser transferidos para fora do seu país.\n\n— Destinatário e contato\n  · Destinatário: Google LLC e suas afiliadas (provedor do AdMob)\n  · Serviço/Função: Exibição de anúncios, fornecimento de recursos de publicidade/mensuração, processamento de logs relacionados\n  · Site: admob.google.com\n  · Observação: No iOS, o uso do identificador de publicidade (IDFA) depende das políticas da plataforma e do status de consentimento do usuário.\n\n— Países de destino\n  · Estados Unidos e países onde o Google ou suas afiliadas possuam capacidade de processamento de dados (por exemplo, Europa, Ásia)\n\n— Momento e método da transferência\n  · Momento: Na inicialização do app e quando ocorrerem solicitações/exibições/cliques/mensuração de anúncios, conforme necessário\n  · Método: Transmissão em rede com criptografia em trânsito (HTTPS/TLS)\n  · Salvaguardas: Processamento conforme os marcos internacionais aplicáveis e proteções contratuais (por exemplo, decisões de adequação, Cláusulas Contratuais Padrão)\n\n— Finalidades e itens de dados\n  · Finalidades: Exibição de anúncios, respeito às escolhas de personalização, mensuração de desempenho, análises estatísticas, melhoria da qualidade/estabilidade do serviço\n  · Exemplos de dados: Identificadores de publicidade (AAID/IDFA), versão/configurações do app, informações básicas do dispositivo/rede, identificadores semelhantes a cookies, registros de uso (incluindo interações com anúncios e erros/falhas), região (nível cidade/país) etc.\n\n— Período de retenção\n  · Mantidos até o alcance das finalidades ou pelo período exigido pela legislação aplicável; depois, excluídos ou descaracterizados\n\n— Direito de recusar e retirar o consentimento\n  · Nas “Opções de privacidade” do app você pode escolher Anúncios não personalizados (NPA). Em regiões como EEE/Reino Unido/Suíça, a tela de consentimento CMP/UMP permite escolher entre anúncios personalizados/não personalizados e redefinir a escolha.\n\n— Contato\n  · E-mail: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Aviso de edição de metadados';

  @override
  String get metadataRiskBody =>
      'Alguns formatos além de MP3 podem restringir a inserção de tags/capas ou variar em compatibilidade entre players, o que pode causar falhas na edição.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 usam iTunes atoms, Ogg/Opus usam Vorbis Comment (bloco PICTURE), FLAC usa Vorbis Comment/PICTURE e WAV usa LIST-INFO.';

  @override
  String get doNotShowAgain => 'Não mostrar novamente';

  @override
  String get continueLabel => 'Continuar';

  @override
  String paletteWidthFactor(String percent) {
    return 'Largura $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Altura $percent%';
  }
}
