import 'package:talkios/core/enum/store_enum.dart';

class StoreConfig {
  final StoreEnum store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({required StoreEnum store, required String apiKey}) {
    _instance ??= StoreConfig._interval(store, apiKey);
    return _instance!;
  }

  StoreConfig._interval(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => _instance!.store == StoreEnum.appleStore;
  static bool isForGooglePlay() => _instance!.store == StoreEnum.googlePlay;
  static bool isForAmazonAppStore() =>
      _instance!.store == StoreEnum.amazonAppStore;
}
