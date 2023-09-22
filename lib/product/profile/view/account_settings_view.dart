import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/account_button.dart';
import 'package:talkios/product/profile/model/profile_model.dart';
import 'package:talkios/product/profile/profile_view_model.dart';

class AccountSettingsView extends BaseStateless {
  final String pageTitle;
  final ProfileModel profileModel;
  const AccountSettingsView({
    super.key,
    required this.pageTitle,
    required this.profileModel,
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
          buttons(context),
        ],
      ),
    );
  }

  Consumer buttons(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, state, child) {
        return Column(
          children: [
            AccountButton(
              label: "Skill Level",
              onPressed: () => context.read<ProfileViewModel>().showLevelPicker(
                    context,
                    "Level",
                    profileModel,
                  ),
              text: state.skillLevel.isNotEmpty
                  ? state.skillLevel
                  : profileModel
                      .data!.user!.learnLanguages![0].proficiencyLevel!.scale,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Session Length",
              onPressed: () => context.read<ProfileViewModel>().showLevelPicker(
                    context,
                    "Time",
                    profileModel,
                  ),
              text: state.sessionLength.isNotEmpty
                  ? state.sessionLength
                  : "${profileModel.data!.user!.userDetail!.sessionLength} minutes",
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Listening Exercise",
              isAvailableCheckbox: true,
              onPressed: () => state.listenExercise(),
              checkValue: state.isListenExercise,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Sound Effects",
              isAvailableCheckbox: true,
              onPressed: () => state.soundEffect(),
              checkValue: state.isSoundEffect,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Vibration",
              isAvailableCheckbox: true,
              onPressed: () => state.vibration(),
              checkValue: state.isVibration,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Native Language",
              onPressed: () => context.read<ProfileViewModel>().showLevelPicker(
                    context,
                    "Language",
                    profileModel,
                  ),
              text: state.language.isNotEmpty
                  ? state.language
                  : profileModel.data!.user!.nativeLanguage!.title,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Notifications",
              isAvailableCheckbox: true,
              onPressed: () => state.notification(),
              checkValue: state.isNotification,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Practice Reminders",
              isAvailableCheckbox: true,
              onPressed: () => state.reminder(),
              checkValue: state.isReminder,
            ),
            spacer(height: 10.0),
            AccountButton(
              label: "Time of Reminders",
              onPressed: () => context.read<ProfileViewModel>().showLevelPicker(
                    context,
                    "Practice",
                    profileModel,
                  ),
              text: state.practice.isNotEmpty
                  ? state.practice
                  : profileModel.data!.user!.userDetail!.timeOfReminder,
            ),
          ],
        );
      },
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
              context.read<ProfileViewModel>().handleButtonPressed(
                    context,
                    -1,
                    pageTitle,
                    profileModel: profileModel,
                  );
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
