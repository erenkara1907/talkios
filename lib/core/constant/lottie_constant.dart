String asset = 'assets/lotties/lottie_';

class LottieConstant {
  static LottieConstant? _instance;
  static LottieConstant get instance {
    _instance ??= LottieConstant._init();
    return _instance!;
  }

  LottieConstant._init();

  String loadingMessage = "$asset" "loading_message.json";
  String emptyState = "$asset" "empty_state.json";
}
