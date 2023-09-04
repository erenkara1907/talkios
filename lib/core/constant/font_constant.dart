String font = 'assets/fonts/poppins/Poppins-';

class FontConstant {
  static FontConstant? _instance;
  static FontConstant get instance {
    _instance ??= FontConstant._init();
    return _instance!;
  }

  FontConstant._init();

  String extraBold = '$font' 'ExtraBold.ttf';
  String bold = '$font' 'Bold.ttf';
  String semiBold = '$font' 'SemiBold.ttf';
  String medium = '$font' 'Medium.ttf';
  String regular = '$font' 'Regular.ttf';
  String light = '$font' 'Light.ttf';
  String extraLight = '$font' 'ExtraLight.ttf';
  String thin = '$font' 'Thin.ttf';
}
