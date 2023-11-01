// ignore_for_file: unused_field, prefer_final_fields, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/premium/premium_model.dart';
import 'package:talkios/product/premium/premium_view_model.dart';

import '../../core/config/revenuecat/singletons_data.dart';
import '../../core/constant/revenuecat_constants.dart';

class PremiumView extends StatefulWidget {
  final Offering offering;
  const PremiumView({
    Key? key,
    required this.offering,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _PremiumViewState createState() => _PremiumViewState();
}

class _PremiumViewState extends BaseState<PremiumView> {
  PageController _pageController = PageController();
  @override
  void initState() {
    _pageController.addListener(() {
      Provider.of<PremiumViewModel>(context, listen: false)
          .setCurrentPage(_pageController.page!.round());
    });
    super.initState();
  }

  void purchase(BuildContext context, Package packageToPurchase) async {
    PremiumViewModel state = context.read<PremiumViewModel>();
    try {
      state.isTap = !state.isTap;

      // Satın alma işlemi başlatılıyor
      CustomerInfo customerInfo = await Purchases.purchasePackage(
        packageToPurchase,
      );

      // Satın alma işlemi başarılı
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementId];
      appData.entitlementIsActive = entitlement?.isActive ?? false;
      state.isTap = !state.isTap;

      // Satın alma işlemi başarılıysa UI'da göstermek istediğiniz değişiklikleri burada yapabilirsiniz
      print('Satın alma işlemi başarılı.');
      await state.updatePurchase(context);
    } catch (e) {
      state.isTap = !state.isTap;

      if (e is PlatformException) {
        if (e.code == 'purchase_cancelled') {
          // Kullanıcı satın alma işlemini iptal etti
          print('Satın alma işlemi kullanıcı tarafından iptal edildi.');
        } else if (e.code == 'purchase_error') {
          // Satın alma işlemi sırasında bir hata oluştu
          print('Satın alma işlemi sırasında bir hata oluştu: ${e.message}');
        } else {
          // Diğer hatalar
          print('Bilinmeyen bir hata oluştu: ${e.message}');
        }
      } else {
        // Belirlenemeyen bir hata
        print('Bilinmeyen bir hata oluştu: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumViewModel>(
      builder: (ctx, state, child) {
        return AbsorbPointer(
          absorbing: state.isTap,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: state.pages.length,
                itemBuilder: (context, index) {
                  return SinglePremium(
                    model: state.pages[index],
                  );
                },
              ),
              Positioned(
                top: 52.0,
                left: 20.0,
                child: Material(
                  type: MaterialType.transparency,
                  shadowColor: Colors.transparent,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    disabledColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      back();
                    },
                    icon: Icon(icon.arrowBack),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height(0.25)),
                  child: buildPageIndicators(state.pages.length),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height(0.22)),
                  child: Text(
                    "For other offers",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color.background,
                      fontSize: 10.0,
                      fontFamily: font.light,
                    ),
                  ),
                ),
              ),
              spacer(height: 26.0),
              Positioned(
                bottom: 50.0,
                right: 50.0,
                left: 50.0,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(
                      horizontal: state.isTap ? 50.0 : 0.0),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: width(1.0),
                    height: height(0.06),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(66.0),
                        ),
                        backgroundColor: color.dark100,
                      ),
                      onPressed: () async {
                        if (state.currentPage == 0) {
                          purchase(
                            context,
                            widget.offering.availablePackages[0],
                          );
                        } else if (state.currentPage == 1) {
                          purchase(
                            context,
                            widget.offering.availablePackages[1],
                          );
                        } else {
                          purchase(
                            context,
                            widget.offering.availablePackages[2],
                          );
                        }
                      },
                      child: state.isTap
                          ? AnimatedOpacity(
                              opacity: state.isTap ? 0.8 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: CircularProgressIndicator(
                                color: color.background,
                                strokeWidth: 1.0,
                              ),
                            )
                          : AnimatedOpacity(
                              opacity: !state.isTap ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                state.currentPage == 0
                                    ? "${widget.offering.availablePackages[0].storeProduct.priceString} per a month"
                                    : state.currentPage == 1
                                        ? "${widget.offering.availablePackages[1].storeProduct.priceString} per a yearly"
                                        : "${widget.offering.availablePackages[2].storeProduct.priceString} per a 3 month",
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: color.background,
                                  fontSize: 14.0,
                                  fontFamily: font.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPageIndicators(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Selector<PremiumViewModel, int>(
          builder: (ctx, currentPage, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: currentPage == index ? 30.0 : 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: index == context.read<PremiumViewModel>().currentPage
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

class SinglePremium extends BaseStateless {
  final PremiumModel model;
  const SinglePremium({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 89.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            spacer(height: height(context: context, value: 0.2)),
            Text(
              "Talkios AI",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color.background,
                    fontSize: 36.0,
                    fontFamily: font.bold,
                  ),
            ),
            spacer(height: 5.0),
            Text(
              model.title,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color.yellow,
                    fontSize: 36.0,
                    fontFamily: font.bold,
                  ),
            ),
            spacer(height: 24.0),
            SizedBox(
              width: 153.0,
              height: 134.0,
              child: Image.asset(
                model.image,
                fit: BoxFit.fill,
              ),
            ),
            spacer(height: 26.0),
            Text(
              model.subTitle,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.background,
                    fontSize: 16.0,
                    fontFamily: font.regular,
                  ),
              textAlign: TextAlign.center,
            ),
            spacer(height: 30.0),
            advantage(context, text: model.advantageOne),
            spacer(height: 15.0),
            advantage(context, text: model.advantageTwo),
            spacer(height: 15.0),
            advantage(context, text: model.advantageThree),
          ],
        ),
      ),
    );
  }

  Row advantage(BuildContext context, {required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Icon(
            Icons.arrow_forward_ios,
            color: color.background,
            size: 12.0,
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            text,
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: color.background,
                  fontSize: 12.0,
                  fontFamily: font.regular,
                ),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
