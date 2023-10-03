import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/connectivity_service.dart';
import 'package:talkios/core/util/provider/image/image_upload_view_model.dart';
import 'package:talkios/core/util/provider/time_provider.dart';
import 'package:talkios/core/view/theme/theme.dart';
import 'package:talkios/product/auth/login/login_view_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/conversation/viewmodel/bottom_menu_view_model.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/home/view/home_view.dart';
import 'package:talkios/product/profile/profile_view_model.dart';
import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

import 'core/constant/api_constant.dart';
import 'core/constant/config_constant.dart';
import 'core/util/provider/onesignal_service.dart';
import 'core/util/provider/sound/dubbing_provider.dart';
import 'core/util/provider/sound/speech_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OneSignalService.setUpOneSignal();
  await CacheManager().init();
  await Firebase.initializeApp();
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

  Future<void> sendUsageDurationToBackend(String usageDuration) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    print("girdi : $usageDuration");
    final response = await http.post(
      Uri.parse(ApiConstant.instance.playerId),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'usage_duration': usageDuration,
      },
    );

    print("response : ${response.body}");

    if (response.statusCode == 200) {
      print('Player ID başarıyla gönderildi.');
    } else {
      print('Player ID gönderilirken bir hata oluştu: ${response.body}');
    }
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
        print('Kullanım süresi: ${duration.inSeconds} saniye');
        await sendUsageDurationToBackend(durationInSeconds.toString());
        // Google Analytics'e süreyi gönder
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
    return MaterialApp(
      title: 'Talkios',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: hasToken ? HomeView() : const WelcomeView(),
    );
  }
}
