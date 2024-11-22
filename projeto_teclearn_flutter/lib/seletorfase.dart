import 'package:flutter/material.dart';
import 'main.dart';

class SeletorFase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Fases'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Escolha a Fase',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: Text('Fase 1'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // lógica para outras fases
              },
              child: Text('Fase 2 (Indisponível)'),
            ),
          ],
        ),
      ),
    );
  }
}