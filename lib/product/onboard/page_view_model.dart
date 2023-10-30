import 'package:flutter/material.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/constant/image_constant.dart';
import 'package:talkios/product/onboard/page_info_model.dart';

class PageViewModel extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  List<PageInfo> pages = [
    PageInfo(
      backgroundColor: ColorConstant.instance.softOrange,
      imagePath: ImageConstant.instance.onboardOne,
      title: 'Determine your level',
      subtitle:
          'Not sure where to start? Evaluate your language proficiency in seconds with Talkios AI and kick off your personalized learning journey.',
    ),
    PageInfo(
      backgroundColor: ColorConstant.instance.softPurple,
      imagePath: ImageConstant.instance.onboardTwo,
      title: 'Start talking to AI',
      subtitle:
          'Practicing spoken English has never been this easy. Send voice messages, receive immediate feedback, and enhance your language skills in a natural conversation environment',
    ),
    PageInfo(
      backgroundColor: const Color.fromRGBO(251, 233, 146, 1),
      imagePath: ImageConstant.instance.onboardThree,
      title: 'Collect stars to see your progress',
      subtitle:
          'Collect stars to visualize your learning progress. Each star represents an improvement in your English speaking ability.',
    ),
    // Diğer sayfalarınızı da bu şekilde ekleyebilirsiniz.
  ];
}
