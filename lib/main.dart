import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/config/revenuecat/store_config.dart';
import 'package:talkios/core/constant/revenuecat_constants.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/enum/store_enum.dart';
import 'package:talkios/core/util/connectivity_service.dart';
import 'package:talkios/core/util/provider/chat_tools_provider.dart';
import 'package:talkios/core/util/provider/image/image_upload_view_model.dart';
import 'package:talkios/core/util/provider/scroll_provider.dart';
import 'package:talkios/core/util/provider/time_provider.dart';
import 'package:talkios/core/util/provider/translate_provider.dart';
import 'package:talkios/core/util/provider/vocabulary_state.dart';
import 'package:talkios/core/view/theme/theme.dart';
import 'package:talkios/product/auth/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:talkios/product/auth/forgot_password/viewmodel/reset_password_view_model.dart';
import 'package:talkios/product/auth/login/login_view_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';
import 'package:talkios/product/auth/verify/verify_token_view_model.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/conversation/viewmodel/bottom_menu_view_model.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/home/view/new_home_view.dart';
import 'package:talkios/product/onboard/page_view.dart';
import 'package:talkios/product/onboard/page_view_model.dart';
import 'package:talkios/product/premium/premium_view_model.dart';
import 'package:talkios/product/profile/profile_view_model.dart';
import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

import 'core/constant/config_constant.dart';
import 'core/util/provider/onesignal_service.dart';
import 'core/util/provider/sound/dubbing_provider.dart';
import 'core/util/provider/sound/speech_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheManager().init();
  await Firebase.initializeApp();

  // if (Platform.isIOS || Platform.isMacOS) {
  //   StoreConfig(store: StoreEnum.appleStore, apiKey: appleApiKey);
  // } else if (Platform.isAndroid) {
  //   StoreConfig(store: StoreEnum.googlePlay, apiKey: "appleApiKey");
  //   // const useAmazon = bool.fromEnvironment("amazon");
  //   // StoreConfig(
  //   //     store: useAmazon ? Store.amazonAppStore : Store.googlePlay,
  //   //     apiKey: appleApiKey);
  // }

  // await _configureSDK();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RegisterViewModel()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => TimeProvider()),
      ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => ConversationRoomViewModel()),
      ChangeNotifierProvider(create: (context) => CacheManager()),
      ChangeNotifierProvider(create: (context) => SpeechProvider()),
      ChangeNotifierProvider(create: (context) => DubbingProvider()),
      ChangeNotifierProvider(create: (context) => VocabularyViewModel()),
      ChangeNotifierProvider(create: (context) => ImageUploadViewModel()),
      ChangeNotifierProvider(create: (context) => ConnectivityService()),
      ChangeNotifierProvider(create: (context) => BottomMenuViewModel()),
      ChangeNotifierProvider(create: (context) => ForgotPasswordViewModel()),
      ChangeNotifierProvider(create: (context) => ResetPasswordViewModel()),
      ChangeNotifierProvider(create: (context) => VerifyTokenViewModel()),
      ChangeNotifierProvider(create: (context) => TranslateProvider()),
      ChangeNotifierProvider(create: (context) => ChatToolsProvider()),
      ChangeNotifierProvider(create: (context) => VocabularyState()),
      ChangeNotifierProvider(create: (context) => ScrollProvider()),
      ChangeNotifierProvider(create: (context) => PageViewModel()),
      ChangeNotifierProvider(create: (context) => PremiumViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  DateTime? appOpenTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      appOpenTime = DateTime.now();
    } else if (state == AppLifecycleState.paused) {
      if (appOpenTime != null) {
        // appOpenTime kontrolü ekledik.
        final duration = DateTime.now().difference(appOpenTime!);
        final durationInSeconds = duration.inSeconds;
        await OneSignalService.setUpOneSignal(
          isUsageDuration: true,
          usageDuration: durationInSeconds.toString(),
        );
        // Google Analytics'e süreyi gönder
        print("seecond : $durationInSeconds");
        analyticInstance.logEvent(
          name: 'daily_usage',
          parameters: {
            'duration_in_seconds': durationInSeconds,
          },
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CacheManager cacheManager =
        Provider.of<CacheManager>(context, listen: false);

    bool hasToken =
        (cacheManager.getString(PreferencesKeys.TOKEN.toString()) != null &&
            cacheManager.getString(PreferencesKeys.TOKEN.toString()) != "");

    bool isFirstLogin =
        (cacheManager.getBool(PreferencesKeys.IS_FIRST_LOGIN.toString()) !=
            null);
    return MaterialApp(
      title: 'Talkios',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: hasToken
          ? const HomeView()
          : isFirstLogin
              ? const WelcomeView()
              : const MyPageView(),
    );
  }
}

Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppStore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;
  }
  await Purchases.configure(configuration);
}
