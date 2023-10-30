import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';

class PremiumView extends BaseStateless {
  const PremiumView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.purple,
      body: Column(
        children: [
          spacer(height: 56.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                iconSize: 32.0,
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  size: 32.0,
                ),
              ),
            ),
          ),
          spacer(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Text(
              "Premium users progress 2 times faster than average.",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.background,
                    fontSize: 16.0,
                    fontFamily: font.regular,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          spacer(height: 15.0),
          premiumText(context, "Go ", "faster"),
          spacer(height: 5.0),
          premiumText(context, "with ", "Premium"),
          const Expanded(child: SizedBox()),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                children: [
                  premiumCard(context),
                  spacer(width: 10.0),
                  premiumCard(context),
                  spacer(width: 10.0),
                  premiumCard(context),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Container premiumCard(BuildContext context) {
    return Container(
      width: width(context: context, value: 1.0) - 54.0,
      decoration: BoxDecoration(
        color: color.background,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Image.asset(icon.premium),
            ),
            spacer(height: 10.0),
            Text(
              "Basic Monthly",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: color.dark100,
                    fontFamily: font.bold,
                  ),
              textAlign: TextAlign.start,
            ),
            spacer(height: 10.0),
            Text(
              "✓  All Beauty Tools",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                    color: color.dark100,
                  ),
              textAlign: TextAlign.start,
            ),
            spacer(height: 5.0),
            Text(
              "✓  Weekly Updates",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                    color: color.dark100,
                  ),
              textAlign: TextAlign.start,
            ),
            spacer(height: 5.0),
            Text(
              "✓  No Watermark",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                    color: color.dark100,
                  ),
              textAlign: TextAlign.start,
            ),
            spacer(height: 5.0),
            Text(
              "✓  All Effects & Filters",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                    color: color.dark100,
                  ),
              textAlign: TextAlign.start,
            ),
            spacer(height: 15.0),
            Text(
              "Take control of your experience with the freedom of month-to-month! Explore premium benefits for a full month with our Basic Monthly plan and enjoy the flexibility. At just \$10, you can always cancel and restart whenever you like",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    fontFamily: font.semiBold,
                    color: color.dark100,
                  ),
              textAlign: TextAlign.center,
            ),
            spacer(height: 15.0),
            AppButton(
              widthValue: width(context: context, value: 1.0),
              heightValue: height(context: context, value: 0.06),
              text: "START NOW",
              borderRadius: 66.0,
              backgroundColor: color.yellow,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Padding premiumText(BuildContext context, String textOne, String textTwo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textOne,
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.background,
                  fontSize: 36.0,
                  fontFamily: font.bold,
                ),
          ),
          Text(
            textTwo,
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.yellow,
                  fontSize: 36.0,
                  fontFamily: font.bold,
                ),
          ),
        ],
      ),
    );
  }
}
