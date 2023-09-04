import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/model/menu_card_model.dart';

import '../card/menu_card.dart';

class BottomMenu extends BaseStateless {
  final List<MenuCardModel> models;
  final void Function() onTap;
  const BottomMenu({
    super.key,
    required this.models,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context: context, value: 0.065),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: models.length,
        itemBuilder: (context, index) {
          MenuCardModel model = models[index];
          return MenuCard(
            model: model,
            onTap: onTap,
          );
        },
      ),
    );
  }
}
