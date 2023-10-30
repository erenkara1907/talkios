// ignore_for_file: prefer_final_fields, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/onboard/page_info_model.dart';
import 'package:talkios/product/onboard/page_view_model.dart';

import '../../core/view/base/base_state.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends BaseState<MyPageView> {
  PageController _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(() {
      Provider.of<PageViewModel>(context, listen: false)
          .setCurrentPage(_pageController.page!.round());
    });

    super.initState();
  }

  void _goToNextPage() {
    if (_pageController.page != null &&
        _pageController.page! <
            context.read<PageViewModel>().pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              
              itemCount: viewModel.pages.length,
              itemBuilder: (context, index) {
                return SinglePage(
                  pageInfo: viewModel.pages[index],
                  currentIndex: index,
                  totalPages: viewModel.pages.length,
                  pageController: _pageController,
                );
              },
            ),
            spacer(height: height(0.1)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height(0.25)),
                child: buildPageIndicators(viewModel.pages.length),
              ),
            ),
            spacer(height: 26.0),
            Positioned(
              bottom: 50.0,
              right: 50.0,
              left: 50.0,
              child: Selector<PageViewModel, int>(
                builder: (ctx, currentPage, child) {
                  return AnimatedAlign(
                    duration: const Duration(seconds: 1),
                    alignment: currentPage == viewModel.pages.length - 1
                        ? Alignment.center
                        : Alignment.bottomRight,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: currentPage == viewModel.pages.length - 1
                          ? width(1.0)
                          : 52.0,
                      height: height(0.07),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: currentPage == viewModel.pages.length - 1
                              ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(66.0),
                                )
                              : const CircleBorder(),
                          backgroundColor: color.dark100,
                        ),
                        onPressed: () async {
                          if (currentPage == viewModel.pages.length - 1) {
                            await CacheManager().setBool(
                                PreferencesKeys.IS_FIRST_LOGIN.toString(),
                                true);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const WelcomeView()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            _goToNextPage();
                          }
                        },
                        child: currentPage == viewModel.pages.length - 1
                            ? Text(
                                "LET'S GET STARTED",
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: color.background,
                                  fontSize: 14.0,
                                  fontFamily: font.bold,
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                color: color.background,
                                size: 20.0,
                              ),
                      ),
                    ),
                  );
                },
                selector: (context, state) => state.currentPage,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPageIndicators(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Selector<PageViewModel, int>(
          builder: (ctx, currentPage, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: currentPage == index ? 30.0 : 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: index == context.read<PageViewModel>().currentPage
                    ? color.background.withOpacity(0.5)
                    : color.dark10,
                borderRadius: currentPage == index
                    ? BorderRadius.circular(20.0)
                    : BorderRadius.circular(50.0),
                // shape:
                //     currentPage == index ? BoxShape.rectangle : BoxShape.circle,
              ),
            );
          },
          selector: (context, state) => state.currentPage,
        ),
      ),
    );
  }
}

class SinglePage extends BaseStateless {
  final PageInfo pageInfo;
  final int currentIndex;
  final int totalPages;
  final PageController pageController;

  const SinglePage({
    super.key,
    required this.pageInfo,
    required this.currentIndex,
    required this.totalPages,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: pageInfo.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 279.0,
                height: 177.0,
                child: SvgPicture.asset(
                  pageInfo.imagePath,
                ),
              ), // Burada imagePath olarak assets klasörünüzdeki resim yolunu kullandım.
              spacer(height: height(context: context, value: 0.1)),
              Text(
                pageInfo.title,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color.dark100,
                    fontSize: 24.0,
                    fontFamily: font.semiBold),
                textAlign: TextAlign.center,
              ),
              spacer(height: 5.0),
              Text(
                pageInfo.subtitle,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark50,
                      fontSize: 14.0,
                      fontFamily: font.medium,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
