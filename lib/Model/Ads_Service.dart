import 'dart:io';

class AdsHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1767524258844288/6694103303';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1767524258844288/6694103303';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
