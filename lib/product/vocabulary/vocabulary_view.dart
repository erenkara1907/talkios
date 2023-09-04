import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/menu/header_menu.dart';

import '../../core/util/provider/tinder_card_provider.dart';

class VocabularyView extends BaseStateless {
  const VocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    var items = context.watch<TinderCardProvider>().items;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 56.0),
              const HeaderMenu(),
              SizedBox(
                width: width(context: context, value: 1.0),
                height: height(context: context, value: 0.60),
                child: CardSwiper(
                  cardsCount: items.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                    return Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(20.0),
                      color: color.background,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.background,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(19.0),
                              child: Container(
                                width: width(context: context, value: 1.0),
                                height: height(context: context, value: 0.40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://picsum.photos/200?seed=$index"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            spacer(height: 23.0),
                            Text(
                              "Cinema",
                              style:
                                  currentTextTheme(context).bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: color.dark100,
                                        fontSize: 20.0,
                                        fontFamily: font.regular,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              spacer(height: 55.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    vocabularyButton(
                      onPressed: () {},
                      icon: icon.sound,
                    ),
                    vocabularyButton(
                      onPressed: () {},
                      icon: icon.microphone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox vocabularyButton({
    required String icon,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 73.0,
      height: 73.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color.background,
            shape: CircleBorder(
              side: BorderSide(
                color: color.dark10,
                width: 1.0,
              ),
            )),
        onPressed: onPressed,
        child: Center(
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }

  Row header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        titleAndLevel(context),
        xp(context),
      ],
    );
  }

  Row xp(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon.star),
        spacer(width: 9.0),
        Text(
          "957",
          style: currentTextTheme(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color.dark100,
                fontSize: 18.0,
                fontFamily: font.semiBold,
              ),
        )
      ],
    );
  }

  Row titleAndLevel(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () {},
            icon: Icon(icon.arrowBack),
          ),
        ),
        spacer(width: 14.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Movie Theater",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color.dark100,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                  ),
            ),
            spacer(height: 1.0),
            Text(
              "Level 1",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.dark40,
                    fontSize: 12.0,
                    fontFamily: font.regular,
                  ),
            )
          ],
        )
      ],
    );
  }
}
