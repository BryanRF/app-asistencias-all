/// Stub para Platform cuando no está disponible (web)
/// Este archivo se usa cuando dart:io no está disponible
class PlatformStub {
  static bool get isWindows => false;
  static bool get isLinux => false;
  static bool get isMacOS => false;
}
