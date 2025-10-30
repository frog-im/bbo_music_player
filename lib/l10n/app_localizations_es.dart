// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get exitDialogTitle => '¿Desea salir de la aplicación?';

  @override
  String get adLabel => 'Anuncio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exit => 'Salir';

  @override
  String get adLoading => 'Cargando anuncio...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Metadatos de audio — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Guardar como';

  @override
  String get tooltipNoChanges => 'No hay cambios';

  @override
  String get tooltipReload => 'Recargar';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Carátula seleccionada: $fileName';
  }

  @override
  String get btnClose => 'Cerrar';

  @override
  String saveDone(Object displayName) {
    return 'Guardado: $displayName';
  }

  @override
  String get saveCancelled => 'Guardado cancelado';

  @override
  String saveFailed(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get hintNone => '(Ninguno)';

  @override
  String get metaLabelTitle => 'Título';

  @override
  String get metaLabelArtist => 'Artista';

  @override
  String get metaLabelAlbum => 'Álbum';

  @override
  String get metaLabelGenre => 'Género';

  @override
  String get metaLabelYear => 'Año';

  @override
  String get metaLabelTrack => 'Pista';

  @override
  String get metaLabelDisc => 'Disco';

  @override
  String get chooseActionTitle => '¿Qué acción desea ejecutar?';

  @override
  String get chooseActionBody =>
      'Al elegir una opción, se ejecutará de inmediato.';

  @override
  String get actionEditOverlay => 'Ajustar tamaño y posición';

  @override
  String get actionLoadSubtitles => 'Cargar subtítulos';

  @override
  String get overlayPermissionNeeded =>
      'Se requiere permiso de superposición. Permita el acceso en Configuración.';

  @override
  String get overlayWindowDenied =>
      'Se denegó el permiso de ventana superpuesta.';

  @override
  String get overlaySampleShort => 'Para texto corto';

  @override
  String get overlaySampleLong => 'Para texto largo';

  @override
  String get fontPickerTitle => 'Seleccionar tamaño de fuente';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonOk => 'Aceptar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonChange => 'Cambiar';

  @override
  String get commonSettings => 'Configuración';

  @override
  String paletteFontLabel(Object size) {
    return 'Tamaño de fuente $size';
  }

  @override
  String get paletteLockCenterX => 'Bloquear centro en X';

  @override
  String get calibFixHint => 'Eliminar desfase (fijar superposición)';

  @override
  String get calibMergeHint => 'Unir (guardar en la cola Δ)';

  @override
  String get calibFix => 'Eliminar desfase';

  @override
  String get calibMerge => 'Unir';

  @override
  String get saveApplyDelta => 'Aplicar corrección y guardar';

  @override
  String get hudCenterSuffix => '(Centro en X bloqueado)';

  @override
  String get webBack => 'Atrás';

  @override
  String get webForward => 'Adelante';

  @override
  String get webReload => 'Recargar';

  @override
  String get webClose => 'Cerrar';

  @override
  String get webAddressHint => 'Introducir o pegar dirección';

  @override
  String get emptyLyrics => 'No se recibieron letras.';

  @override
  String get overlayHintDoubleTap =>
      '* Toque dos veces para cerrar la superposición.';

  @override
  String get overlayHintSwipe => '* Deslice para cambiar de página.';

  @override
  String get menuPrivacy => 'Privacidad';

  @override
  String get menuPrivacyPolicy => 'Política de privacidad';

  @override
  String get menuPrivacyOptions => 'Opciones de privacidad de anuncios';

  @override
  String get menuPrivacyOptionsSub =>
      'Cambiar el consentimiento para anuncios personalizados';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'No se requiere en la región/sesión actual';

  @override
  String get openUrlFailed => 'No se puede abrir la URL';

  @override
  String get privacyClosed => 'Se cerró la pantalla de opciones de privacidad';

  @override
  String get privacyNotAvailable =>
      'El formulario de privacidad no está disponible';

  @override
  String get privacyExplainer =>
      'Esta aplicación usa un SDK de anuncios y ofrece una pantalla de consentimiento en las regiones donde es obligatorio.';

  @override
  String get privacyOptionsRequiredLabel =>
      'Opciones de privacidad (obligatorio)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Opciones de privacidad (no obligatorio)';

  @override
  String get privacyOptionsUpdated => 'Opciones de privacidad actualizadas';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'En su región no se requieren opciones de privacidad';

  @override
  String get openSource => 'Código abierto';

  @override
  String get openSourceGuideTitle => 'Aviso de código abierto';

  @override
  String get errorTitle => 'Error';

  @override
  String readFileFailed(Object error) {
    return 'No se pudo leer el archivo: $error';
  }

  @override
  String get privacySettingsTitle => 'Configuración de privacidad y anuncios';

  @override
  String get consentSectionTitle => 'Consentimiento (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Requerido';

  @override
  String get openPrivacyOptionsButton => 'Abrir opciones de privacidad';

  @override
  String get consentRegionalNote =>
      'Los usuarios del EEE/UK/CH pueden gestionar su consentimiento aquí. Los cambios se aplican a las solicitudes de anuncios posteriores.';

  @override
  String get adsPersonalizationTitle =>
      'Personalización de anuncios y datos regionales';

  @override
  String get npaTitle => 'Siempre anuncios no personalizados (NPA)';

  @override
  String get npaSubtitle => 'Solicita siempre anuncios no personalizados';

  @override
  String get rdpTitle => 'Procesamiento de datos restringido en EE. UU. (RDP)';

  @override
  String get rdpSubtitle =>
      'Cumplimiento con leyes estatales de EE. UU.: adjuntar rdp=1 en los extras';

  @override
  String get childFlagsSectionTitle => 'Etiquetas: niños/menores de edad';

  @override
  String get coppaTitle => 'Servicio dirigido a niños (COPPA)';

  @override
  String get coppaSubtitle => 'Marcar como dirigido a niños';

  @override
  String get uacTitle => 'Menor de la edad de consentimiento (UAC)';

  @override
  String get uacSubtitle => 'Marcar como menor de la edad de consentimiento';

  @override
  String get coppaNote =>
      'COPPA/UAC son configuraciones globales de AdMob y se aplican de inmediato a los anuncios cargados posteriormente.';

  @override
  String get policySectionTitle => 'Política de privacidad';

  @override
  String get viewInAppButton => 'Ver en la aplicación';

  @override
  String get openStorePolicyButton => 'Abrir política de la tienda';

  @override
  String get policySectionNote =>
      'Proporcione tanto la URL de la política en la tienda como la vista dentro de la app.';

  @override
  String get inAppPolicyTitle => 'Política de privacidad';

  @override
  String get inAppPolicyFallback =>
      'Proporcione aquí su política de privacidad dentro de la app.';

  @override
  String get crossBorderTitle =>
      'Aviso de transferencia internacional de datos';

  @override
  String get viewFullPolicy => 'Ver política completa';

  @override
  String get crossBorderFullText =>
      '• Esta app utiliza servicios de terceros (p. ej., Google AdMob) para ofrecer y medir publicidad; en consecuencia, tus datos personales pueden transferirse fuera de tu país.\n\n— Destinatario y contacto\n  · Destinatario: Google LLC y sus filiales (proveedor de AdMob)\n  · Servicio/Rol: Publicación de anuncios, provisión de funciones de publicidad/medición, procesamiento de registros relacionados\n  · Sitio web: admob.google.com\n  · Nota: En iOS, el uso del identificador publicitario (IDFA) depende de la política de la plataforma y del estado de consentimiento del usuario.\n\n— Países de destino\n  · Estados Unidos y otros países donde Google o sus filiales cuentan con capacidad de procesamiento de datos (p. ej., Europa, Asia)\n\n— Momento y método de transferencia\n  · Momento: Al iniciar la app y cuando se realicen solicitudes/impresiones/clics/mediciones de anuncios, según corresponda\n  · Método: Transmisión por red con cifrado en tránsito (HTTPS/TLS)\n  · Salvaguardias: Tratamiento conforme a marcos internacionales aplicables y protecciones contractuales (p. ej., decisiones de adecuación, Cláusulas Contractuales Tipo)\n\n— Finalidades y categorías de datos\n  · Finalidades: Entrega de anuncios, respeto de la opción de personalización, medición del rendimiento, análisis estadístico, mejora de la calidad/estabilidad del servicio\n  · Ejemplos de datos: Identificadores publicitarios (AAID/IDFA), versión/ajustes de la app, información básica del dispositivo/red, identificadores similares a cookies, registros de uso (incluidas interacciones con anuncios y errores/fallos), región (nivel de ciudad/país), etc.\n\n— Periodo de conservación\n  · Se conservarán hasta cumplir las finalidades o durante el plazo exigido por la ley aplicable; posteriormente se eliminarán o se desidentificarán\n\n— Derecho de oposición y retirada del consentimiento\n  · En las “Opciones de privacidad” de la app puedes elegir Anuncios no personalizados (NPA). En regiones como EEE/Reino Unido/Suiza, la pantalla de consentimiento CMP/UMP permite elegir entre anuncios personalizados/no personalizados y restablecer la elección.\n\n— Contacto\n  · Correo: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Advertencia de edición de metadatos';

  @override
  String get metadataRiskBody =>
      'Algunos formatos distintos de MP3 pueden restringir la inserción de etiquetas/portadas o variar en compatibilidad según el reproductor, lo que puede provocar fallos de edición.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 usan iTunes atoms, Ogg/Opus usan Vorbis Comment (bloque PICTURE), FLAC usa Vorbis Comment/PICTURE y WAV usa LIST-INFO.';

  @override
  String get doNotShowAgain => 'No volver a mostrar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String paletteWidthFactor(String percent) {
    return 'Ancho $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Altura $percent%';
  }
}
