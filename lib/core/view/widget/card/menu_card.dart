import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/model/menu_card_model.dart';

class MenuCard extends BaseStateless {
  final MenuCardModel model;
  final void Function() onTap;
  const MenuCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          onTap: onTap,
          child: Chip(
            elevation: 1,
            backgroundColor: color.background,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            avatar: SvgPicture.asset(model.svgIcon),
            shadowColor: color.dark60,
            label: Text(
              model.text,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.dark100,
                    fontSize: 16.0,
                    fontFamily: font.regular,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
