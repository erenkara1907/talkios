String asset = 'sounds/sound_';

class SoundConstant {
  static SoundConstant? _instance;
  static SoundConstant get instance {
    _instance ??= SoundConstant._init();
    return _instance!;
  }

  SoundConstant._init();

  // Mp3
  String chatBubble = '$asset' 'chat_bubble.mp3';

  // Wav
  String voiceButton = '$asset' 'voice_button.wav';
}
