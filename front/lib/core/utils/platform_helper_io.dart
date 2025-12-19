// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show Platform;

/// Wrapper para Platform en plataformas nativas
class PlatformStub {
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  static bool get isMacOS => Platform.isMacOS;
}
