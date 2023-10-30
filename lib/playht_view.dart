import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/playht_provider.dart';

class PlayHTView extends StatefulWidget {
  const PlayHTView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _PlayHTViewState createState() => _PlayHTViewState();
}

class _PlayHTViewState extends State<PlayHTView> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Audio Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                  labelText: 'Enter text to generate audio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String textToGenerate = _textController.text;
                if (textToGenerate.isNotEmpty) {
                  // Metin girildiğinde, audioProvider aracılığıyla audio oluşturma işlemi başlatılır.
                  Provider.of<PlayHTProvider>(context, listen: false)
                      .generateAudio(textToGenerate);
                }
              },
              child: const Text('Generate Audio'),
            ),
            Consumer<PlayHTProvider>(
              builder: (context, audioProvider, child) {
                if (audioProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else if (audioProvider.url != null) {
                  // URL mevcut olduğunda, kullanıcıya gösterilebilir veya başka işlemler yapılabilir.
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text('Audio URL: ${audioProvider.url}'),
                    ],
                  );
                } else {
                  // Yüklenmiyor ve URL yoksa, sadece bir Placeholder gösterilebilir veya hiçbir şey göstermeyebilirsiniz.
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
