// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_azure_tts/flutter_azure_tts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:talkios/core/view/base/base_state.dart';

// class AzureView extends StatefulWidget {
//   const AzureView({Key? key}) : super(key: key);

//   @override
//   State<AzureView> createState() => _AzureViewState();
// }

// class _AzureViewState extends BaseState<AzureView> {
//   @override
//   void initState() {
//     super.initState();
//     _speak("These keys are used to access your Azure AI service API.");
//   }

//   _speak(String text) async {
//     try {
//       //Load configs
//       AzureTts.init(
//         subscriptionKey: "d2d2388a684242259c292c90405789bd",
//         region: "eastus",
//         withLogs: true,
//       );

//       // Get available voices
//       final voicesResponse = await AzureTts.getAvailableVoices();

//       final voice = voicesResponse.voices
//           .where(
//             (element) => element.displayName == "Emma",
//           )
//           .toList()
//           .first;

//       //Generate Audio for a text

//       TtsParams params = TtsParams(
//         voice: voice,
//         audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
//         rate: 1.0, // optional prosody rate (default is 1.0)
//         text: text,
//       );

//       final ttsResponse = await AzureTts.getTts(params);

//       //Get the audio bytes.
//       final audioBytes = ttsResponse.audio.buffer
//           .asByteData(); // you can save to a file for playback
//       print(
//           "Audio size: ${(audioBytes.lengthInBytes / (1024 * 1024)).toStringAsPrecision(2)} Mb");

//       String dir = (await getApplicationDocumentsDirectory()).path;
//       File file = File('$dir/audio.mp3');

//       // Dosyayı yaz ve hata kontrolü yap.
//       await file
//           .writeAsBytes(
//         audioBytes.buffer.asUint8List(),
//         flush: true,
//       )
//           .catchError((e) {
//         print("Dosya yazma hatası: $e");
//       });

//       // Dosyanın varlığını ve boyutunu kontrol et.
//       if (await file.exists()) {
//         print("Dosya bulundu: ${file.path}, boyut: ${await file.length()}");
//       } else {
//         print("Dosya bulunamadı: ${file.path}");
//         return;
//       }

//       AudioPlayer player = AudioPlayer();

//       // Dosyayı çal.
//       await player.play(DeviceFileSource(file.path)).then((value) {
//         print("Çalışıyor");
//       }).catchError((e) {
//         print("hata ${e.toString()}");
//       });
//     } catch (e) {
//       print("Bir şeyler ters gitti: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }
