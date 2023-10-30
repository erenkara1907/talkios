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
  String loading = "$asset" "loading.json";
  String swipe = "$asset" "swipe.json";
  String networkError = "$asset" "network_error.json";
  String pronunciationLoading = "$asset" "pronunciation_loading.json";
  String voiceRecording = "$asset" "voice_recording.json";
  String recording = "$asset" "recording.json";
  String recordingBlack = "$asset" "recording_black.json";
}
