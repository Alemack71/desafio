import 'package:flutter/material.dart';

class IaResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String response = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Resposta da IA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            response,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}