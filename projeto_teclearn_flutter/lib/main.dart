import 'package:flutter/material.dart';
import 'dart:math';
import 'telalogin.dart';
import 'seletorfase.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLogin(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

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
          const SnackBar(
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
        title: const Text('Game Over'),
        content: const Text('Você perdeu todas as vidas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Parabéns!'),
        content: const Text('Você completou o quiz com sucesso.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: const Text('Reiniciar'),
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
          title: const Text('Quiz com Vidas'),
        ),
        body: const Center(
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
         backgroundColor: const Color.fromARGB(255, 37, 91, 153),
        title: const Text('LdP I | Fase 1',
        style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SeletorFase()),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 48, 92, 117),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 30,
        ),
        const SizedBox(width: 8),
          Text(
            'Vidas: $lives',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            question['question'] as String,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
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
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isOptionSelected ? nextQuestion : null,
            child: const Text('Próxima Pergunta'),
          ),
        ],
      ),
    );
  }
}