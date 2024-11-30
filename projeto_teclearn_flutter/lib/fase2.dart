import 'package:flutter/material.dart';
import 'seletorfase.dart';
import 'dart:math';

class Fase2Page extends StatefulWidget {
  @override
  _Fase2PageState createState() => _Fase2PageState();
}

class _Fase2PageState extends State<Fase2Page> {
  int currentQuestionIndex = 0;
  int lives = 5;
  bool isOptionSelected = false;
  bool isAnswerCorrect = false;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Qual comando do Git é usado para criar um novo branch?',
      'options': ['git merge', 'git branch', 'git commit', 'git pull'],
      'correctAnswer': 'git branch',
    },
    {
      'question': 'Qual linguagem de programação é conhecida por sua forte tipagem e foco em segurança para desenvolvimento backend?',
      'options': ['Python', 'JavaScript', 'Java', 'Ruby'],
      'correctAnswer': 'Java',
    },
    {
      'question': 'Qual linguagem é amplamente usada para criar consultas em bancos de dados relacionais?',
      'options': ['Python', 'SQL', 'HTML', 'C++'],
      'correctAnswer': 'SQL',
    },
    {
      'question': 'Qual conceito em programação orientada a objetos permite que uma classe herde as características de outra classe?',
      'options': ['Polimorfismo', 'Herança', 'Encapsulamento', 'Abstração'],
      'correctAnswer': 'Herança',
    },
    {
      'question': 'Qual estrutura de dados utiliza o conceito LIFO (Last In, First Out)?',
      'options': ['Lista', 'Fila', 'Árvore', 'Pilha'],
      'correctAnswer': 'Pilha',
    },
  ];

  late List<Map<String, Object>> questionQueue;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void shuffleOptions() {
    final currentOptions = questionQueue[currentQuestionIndex]['options'] as List<String>;
    currentOptions.shuffle(Random());
  }

  void handleAnswer(String selectedAnswer) {
    final correctAnswer = questionQueue[currentQuestionIndex]['correctAnswer'] as String;

    setState(() {
      isOptionSelected = true;
      isAnswerCorrect = (selectedAnswer == correctAnswer);

      if (!isAnswerCorrect) {
        lives--;
        if (lives == 0) {
          _showGameOverDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Você errou!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (!isAnswerCorrect) {
        final incorrectQuestion = questionQueue.removeAt(currentQuestionIndex);
        questionQueue.add(incorrectQuestion);
      } else {
        questionQueue.removeAt(currentQuestionIndex);
      }

      if (questionQueue.isEmpty) {
        _showWinDialog();
      } else {
        currentQuestionIndex = 0;
        isOptionSelected = false;
        isAnswerCorrect = false;
        shuffleOptions();
      }
    });
  }

  void resetGame() {
    setState(() {
      currentQuestionIndex = 0;
      lives = 5;
      isOptionSelected = false;
      isAnswerCorrect = false;
      questionQueue = List.from(questions);
      shuffleOptions();
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Você perdeu todas as vidas na Fase 2.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SeletorFase()),
              );
            },
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Parabéns!'),
        content: Text('Você completou a Fase 2 com sucesso.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SeletorFase()),
              );
            },
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questionQueue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Fase 2')),
        body: Center(child: Text('Carregando...', style: TextStyle(fontSize: 20))),
      );
    }

    final question = questionQueue[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Fase 2'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeletorFase()));
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Vidas: $lives',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            question['question'] as String,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ...(question['options'] as List<String>).map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: ElevatedButton(
                onPressed: isOptionSelected ? null : () => handleAnswer(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOptionSelected && option == question['correctAnswer']
                      ? Colors.green
                      : isOptionSelected && option != question['correctAnswer']
                      ? Colors.red
                      : null,
                ),
                child: Text(option),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isOptionSelected ? nextQuestion : null,
            child: Text('Próxima Pergunta'),
          ),
        ],
      ),
    );
  }
}
