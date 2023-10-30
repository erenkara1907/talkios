class AppData {
  static final AppData _appData = AppData._interval();

  bool entitlementIsActive = false;
  String appUserId = "";

  factory AppData() {
    return _appData;
  }

  AppData._interval();
}

final appData = AppData();
