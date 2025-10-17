import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<bool> ensurePostNotificationsPermission() async {
  if (!Platform.isAndroid) return true; // iOS는 별도 흐름
  final s = await Permission.notification.status;
  if (s.isGranted) return true;

  // 처음 혹은 거부 상태: 요청
  final r = await Permission.notification.request();
  if (r.isGranted) return true;

  // 영구 거부 시: 설정 이동 안내
  if (r.isPermanentlyDenied) {
    await openAppSettings();
  }
  return false;
}
