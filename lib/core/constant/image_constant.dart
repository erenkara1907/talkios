String asset = 'assets/images/image_';

class ImageConstant {
  static ImageConstant? _instance;
  static ImageConstant get instance {
    _instance ??= ImageConstant._init();
    return _instance!;
  }

  ImageConstant._init();

  String cyanEllipse = '$asset' 'cyan_ellipse.png';
  String blueEllipse = '$asset' 'blue_ellipse.png';
  String premium = '$asset' 'premium.png';
  String yellowCat = '$asset' 'yellow_cat.png';
  String background = '$asset' 'background.png';
  String union = '$asset' 'union.png';
  String firstChat = '$asset' 'first_chat.png';
  String ellipseLeft = '$asset' 'ellipse_left.png';
  String ellipseRight = '$asset' 'ellipse_right.png';

  // Svg
  String mapLine = '$asset' 'map_line.svg';
  String talkios = '$asset' 'talkios.svg';
  String practice = '$asset' 'practice.svg';
  String deal = '$asset' 'deal.svg';
  String completeVocabulary = '$asset' 'complete_vocabulary.svg';
  String onboardOne = '$asset' 'onboard_one.svg';
  String onboardTwo = '$asset' 'onboard_two.svg';
  String onboardThree = '$asset' 'onboard_three.svg';
}
