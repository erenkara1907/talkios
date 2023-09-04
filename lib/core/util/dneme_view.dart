import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/speech_provider.dart';

class DenemeView extends StatelessWidget {
  const DenemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Speech to Text')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<SpeechProvider>(context, listen: false)
                    .getPermissionAndStartListening(context);
              },
              onLongPress: () {
                Provider.of<SpeechProvider>(context, listen: false)
                    .startListening();
              },
              onLongPressEnd: (details) {
                Provider.of<SpeechProvider>(context, listen: false)
                    .stopListening();
              },
              child: Container(
                color: Colors.blue,
                child: const Text('Press & Hold to Speak'),
              ),
            ),
            Consumer<SpeechProvider>(
              builder: (context, speechProvider, child) => TextField(
                controller:
                    TextEditingController(text: speechProvider.lastWords),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
