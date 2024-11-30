import 'package:flutter/material.dart';
import 'dart:math';
import 'telalogin.dart';
import 'seletorfase.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLogin(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int lives = 5;
  bool isOptionSelected = false;
  bool isAnswerCorrect = false;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Qual é a extensão padrão de arquivos JavaScript?',
      'options': ['html', 'json', 'js', 'css'],
      'correctAnswer': 'js',
    },
    {
      'question': 'Qual dos seguintes é um exemplo de sistema de controle de versão?',
      'options': ['Jenkins', 'Docker', 'Git', 'Kubernetes'],
      'correctAnswer': 'Git',
    },
    {
      'question': 'Qual a variável para inteiros?',
      'options': ['float', 'int', 'double', 'char'],
      'correctAnswer': 'int',
    },
    {
      'question': 'Em Python, como você imprime algo na tela?',
      'options': ['echo()', 'System.out.println()', 'console.log()', 'print()'],
      'correctAnswer': 'print()',
    },
    {
      'question': 'Em HTML, qual elemento é usado para criar um link?',
      'options': ['<link>', '<a>', '<href>', '<url>'],
      'correctAnswer': '<a>',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Você errou a pergunta!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

        lives--;
        if (lives == 0) {
          _showGameOverDialog();
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
        if (currentQuestionIndex >= questionQueue.length) {
          currentQuestionIndex = 0;
        }
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
        content: Text('Você perdeu todas as vidas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: Text('Reiniciar'),
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
        content: Text('Você completou o quiz com sucesso.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questionQueue.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz com Vidas'),
        ),
        body: Center(
          child: Text(
            'Carregando...',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    final question = questionQueue[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz com Vidas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SeletorFase()),
            );
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
                onPressed: isOptionSelected
                    ? null
                    : () {
                  handleAnswer(option);
                },
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