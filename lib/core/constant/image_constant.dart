String asset = 'assets/images/image_';

class ImageConstant {
  static ImageConstant? _instance;
  static ImageConstant get instance {
    _instance ??= ImageConstant._init();
    return _instance!;
  }

  ImageConstant._init();

  String cyanEllipse = '$asset' 'cyan_ellipse.png';
  String pinkEllipse = '$asset' 'pink_ellipse.png';
  String yellowEllipse = '$asset' 'yellow_ellipse.png';
  String premium = '$asset' 'premium.png';
  String yellowCat = '$asset' 'yellow_cat.png';
  String talkios = '$asset' 'talkios.png';
  String background = '$asset' 'background.png';
  String union = '$asset' 'union.png';
  String firstChat = '$asset' 'first_chat.png';

  // Svg
  String mapLine = '$asset' 'map_line.svg';
  String practice = '$asset' 'practice.svg';
}
