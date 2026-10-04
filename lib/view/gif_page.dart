import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  final Map<String, dynamic> gifData;

  const GifPage(this.gifData, {super.key});

  @override
  Widget build(BuildContext context) {
    final url = gifData['images']?['original']?['url'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/app_icon.png', height: 32),
        centerTitle: true,
      ),
      body: Center(
        child: url == null
            ? const Text('Animação indisponível.')
            : InteractiveViewer(
                child: Image.network(url, fit: BoxFit.contain),
              ),
      ),
    );
  }
}
