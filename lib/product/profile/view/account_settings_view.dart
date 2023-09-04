import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/account_button.dart';
import 'package:talkios/product/profile/profile_view_model.dart';

class AccountSettingsView extends BaseStateless {
  final String pageTitle;
  const AccountSettingsView({
    super.key,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        accountSettings(context),
      ],
    );
  }

  Padding accountSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacer(height: 56.0),
          header(context),
          spacer(height: 26.0),
          buttons(),
        ],
      ),
    );
  }

  Column buttons() {
    return Column(
      children: [
        AccountButton(
          label: "Skill Level",
          onPressed: () {},
          text: "Intermediate",
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Session Length",
          onPressed: () {},
          text: "5 minutes",
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Listening Exercise",
          isAvailableCheckbox: true,
          onPressed: () {},
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Sound Effects",
          isAvailableCheckbox: true,
          onPressed: () {},
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Vibration",
          isAvailableCheckbox: true,
          onPressed: () {},
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Native Language",
          onPressed: () {},
          text: "English(American)",
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Notifications",
          isAvailableCheckbox: true,
          onPressed: () {},
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Practice Reminders",
          isAvailableCheckbox: true,
          onPressed: () {},
        ),
        spacer(height: 10.0),
        AccountButton(
          label: "Time of Reminders",
          onPressed: () {},
          text: "11:00",
        ),
      ],
    );
  }

  Row header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () {
              context
                  .read<ProfileViewModel>()
                  .handleButtonPressed(context, -1, pageTitle);
              HapticFeedback.heavyImpact();
              back(context);
            },
            icon: Icon(icon.arrowBack),
          ),
        ),
        Hero(
          tag: 'textHero1',
          child: Text(
            pageTitle,
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark100,
                  fontSize: 16.0,
                  fontFamily: font.semiBold,
                ),
          ),
        ),
        const SizedBox(width: 24.0),
      ],
    );
  }
}
