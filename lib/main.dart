import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/provider/data_provider.dart';
import 'package:talkios/core/util/provider/time_provider.dart';
import 'package:talkios/core/util/provider/tinder_card_provider.dart';
import 'package:talkios/core/view/theme/theme.dart';
import 'package:talkios/product/auth/login/login_view_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/home/view/home_view.dart';
import 'package:talkios/product/profile/profile_view_model.dart';

import 'core/util/provider/speech_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager().init();
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (context) => SpeechProvider()),
      ChangeNotifierProvider(create: (context) => RegisterViewModel()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => TimeProvider()),
      ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => TinderCardProvider()),
      ChangeNotifierProvider(create: (context) => ConversationRoomViewModel()),
      ChangeNotifierProvider(create: (context) => CacheManager()),
      ChangeNotifierProvider(create: (context) => DataProvider()),
      ChangeNotifierProvider(create: (context) => SpeechProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CacheManager cacheManager =
        Provider.of<CacheManager>(context, listen: false);

    bool hasToken =
        (cacheManager.getString(PreferencesKeys.TOKEN.toString()) != null &&
            cacheManager.getString(PreferencesKeys.TOKEN.toString()) != "");
    return MaterialApp(
      title: 'Talkios',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: hasToken ? HomeView() : const WelcomeView(),
    );
  }
}
