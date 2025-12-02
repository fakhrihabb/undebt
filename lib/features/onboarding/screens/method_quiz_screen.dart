import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/constants/app_constants.dart';

/// Method selection quiz to recommend snowball vs avalanche
class MethodQuizScreen extends StatefulWidget {
  const MethodQuizScreen({super.key});

  @override
  State<MethodQuizScreen> createState() => _MethodQuizScreenState();
}

class _MethodQuizScreenState extends State<MethodQuizScreen> {
  int _currentQuestion = 0;
  final Map<int, int> _answers = {};
  
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'How many debts do you currently have?',
      options: [
        QuizOption('1-2 debts', 0),
        QuizOption('3-4 debts', 1),
        QuizOption('5+ debts', 2),
      ],
    ),
    QuizQuestion(
      question: 'What\'s the interest rate spread on your debts?',
      options: [
        QuizOption('All similar rates (within 5%)', 0),
        QuizOption('Some variation (5-10% difference)', 1),
        QuizOption('Wide range (10%+ difference)', 2),
      ],
    ),
    QuizQuestion(
      question: 'What motivates you more?',
      options: [
        QuizOption('Quick wins and visible progress', 0),
        QuizOption('Saving money on interest', 2),
        QuizOption('A balanced approach', 1),
      ],
    ),
    QuizQuestion(
      question: 'Have you tried paying off debt before?',
      options: [
        QuizOption('No, this is my first time', 0),
        QuizOption('Yes, but I gave up', 0),
        QuizOption('Yes, and I stayed consistent', 2),
      ],
    ),
    QuizQuestion(
      question: 'How urgent is becoming debt-free?',
      options: [
        QuizOption('Very urgent - I need motivation', 0),
        QuizOption('Important - I want to optimize', 2),
        QuizOption('Moderate - I\'m flexible', 1),
      ],
    ),
  ];

  void _answerQuestion(int score) {
    setState(() {
      _answers[_currentQuestion] = score;
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
      } else {
        _showResults();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _showResults() {
    final totalScore = _answers.values.fold(0, (sum, score) => sum + score);
    final avgScore = totalScore / _questions.length;

    String recommendedMethod;
    String explanation;
    int confidence;

    if (avgScore <= 0.8) {
      recommendedMethod = AppConstants.methodSnowball;
      explanation = 'The Snowball method is perfect for you! '
          'You\'ll pay off your smallest debts first, giving you quick wins '
          'and psychological momentum to stay motivated.';
      confidence = 85;
    } else if (avgScore >= 1.5) {
      recommendedMethod = AppConstants.methodAvalanche;
      explanation = 'The Avalanche method is ideal for you! '
          'You\'ll tackle your highest-interest debts first, '
          'saving you the most money over time.';
      confidence = 80;
    } else {
      recommendedMethod = AppConstants.methodHybrid;
      explanation = 'The Hybrid method balances both approaches! '
          'You\'ll target high-interest debts (>20% APR) first, '
          'then use the snowball method for the rest.';
      confidence = 75;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ResultsSheet(
        method: recommendedMethod,
        explanation: explanation,
        confidence: confidence,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Method'),
        leading: _currentQuestion > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousQuestion,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.backgroundLight,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ).animate(key: ValueKey(_currentQuestion)).fadeIn(),
              
              const SizedBox(height: 16),
              
              // Question Counter
              Text(
                'Question ${_currentQuestion + 1} of ${_questions.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ).animate(key: ValueKey(_currentQuestion)).fadeIn(),
              
              const SizedBox(height: 32),
              
              // Question
              Text(
                question.question,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ).animate(key: ValueKey(_currentQuestion))
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 32),
              
              // Options
              ...question.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = _answers[_currentQuestion] == option.score;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _OptionCard(
                    text: option.text,
                    isSelected: isSelected,
                    onTap: () => _answerQuestion(option.score),
                  ).animate(key: ValueKey('$_currentQuestion-$index'))
                      .fadeIn(delay: (index * 100).ms)
                      .slideX(begin: -0.2, end: 0),
                );
              }),
              
              const Spacer(),
              
              // Skip Button
              TextButton(
                onPressed: () {
                  // Default to snowball and skip quiz
                  context.go('/debt-input');
                },
                child: const Text('Skip quiz and choose manually'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;

  QuizQuestion({required this.question, required this.options});
}

class QuizOption {
  final String text;
  final int score;

  QuizOption(this.text, this.score);
}

class _OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.success.withOpacity(0.1)
              : AppColors.surfaceLight,
          border: Border.all(
            color: isSelected ? AppColors.success : AppColors.primaryBlue.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppColors.success : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.success,
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultsSheet extends StatelessWidget {
  final String method;
  final String explanation;
  final int confidence;

  const _ResultsSheet({
    required this.method,
    required this.explanation,
    required this.confidence,
  });

  String get methodName {
    switch (method) {
      case AppConstants.methodSnowball:
        return 'Debt Snowball';
      case AppConstants.methodAvalanche:
        return 'Debt Avalanche';
      case AppConstants.methodHybrid:
        return 'Hybrid Method';
      default:
        return 'Unknown';
    }
  }

  IconData get methodIcon {
    switch (method) {
      case AppConstants.methodSnowball:
        return Icons.ac_unit;
      case AppConstants.methodAvalanche:
        return Icons.trending_down;
      case AppConstants.methodHybrid:
        return Icons.balance;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.rewardGold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              methodIcon,
              size: 48,
              color: AppColors.rewardGold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'We recommend:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            methodName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Confidence
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                '$confidence% match',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Explanation
          Text(
            explanation,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Continue Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/debt-input');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              backgroundColor: AppColors.rewardGold,
            ),
            child: const Text('Continue with this method'),
          ),
          
          const SizedBox(height: 12),
          
          // Choose Different
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Show method selection screen
            },
            child: const Text('Choose a different method'),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
