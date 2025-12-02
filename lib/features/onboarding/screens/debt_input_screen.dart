import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/widgets/button_3d.dart';

/// Debt input screen - add debts during onboarding with helpful guidance
class DebtInputScreen extends StatefulWidget {
  const DebtInputScreen({super.key});

  @override
  State<DebtInputScreen> createState() => _DebtInputScreenState();
}

class _DebtInputScreenState extends State<DebtInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _aprController = TextEditingController();
  final _minimumPaymentController = TextEditingController();
  
  String _selectedType = 'Credit Card';
  int? _dueDate;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _aprController.dispose();
    _minimumPaymentController.dispose();
    super.dispose();
  }

  void _saveDebt() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save debt to database
      // For now, just navigate to dashboard
      context.go('/dashboard');
    }
  }

  void _showHelpDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: AppColors.textOnDark.withValues(alpha: 0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Add Your Debts', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundDark,
              AppColors.primaryBlue.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Let\'s add your first debt',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Don\'t worry, you can add more later! We just need a few details to get started.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textOnDark.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Debt Name with help
                  _buildFieldWithHelp(
                    label: 'Debt Name',
                    helpTitle: 'What is Debt Name?',
                    helpContent: 'Give your debt a nickname so you can easily identify it. For example: "Chase Visa", "Car Loan", or "Student Loan".',
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Debt Name',
                        labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                        hintText: 'e.g., Chase Credit Card',
                        hintStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Debt Type
                  Text(
                    'Debt Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: AppColors.surfaceDark,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceDark,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                      DropdownMenuItem(value: 'Personal Loan', child: Text('Personal Loan')),
                      DropdownMenuItem(value: 'Auto Loan', child: Text('Auto Loan')),
                      DropdownMenuItem(value: 'Student Loan', child: Text('Student Loan')),
                      DropdownMenuItem(value: 'Medical Debt', child: Text('Medical Debt')),
                      DropdownMenuItem(value: 'Mortgage', child: Text('Mortgage')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Current Balance with help
                  _buildFieldWithHelp(
                    label: 'Current Balance',
                    helpTitle: 'What is Current Balance?',
                    helpContent: 'This is how much you currently owe. You can find this on your latest statement or by logging into your account online.\n\nExample: If your credit card statement shows you owe \$2,500, enter 2500.',
                    child: TextFormField(
                      controller: _balanceController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Current Balance',
                        labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                        prefixText: '\$',
                        prefixStyle: const TextStyle(color: Colors.white),
                        hintText: 'e.g., 2500',
                        hintStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the balance';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // APR with help
                  _buildFieldWithHelp(
                    label: 'Interest Rate (APR)',
                    helpTitle: 'What is APR?',
                    helpContent: 'APR stands for Annual Percentage Rate - it\'s the yearly interest rate you\'re charged on this debt.\n\nWhere to find it:\n• Credit cards: On your statement or online account\n• Loans: On your loan agreement or monthly statement\n\nExample: If your credit card charges 18.99% interest, enter 18.99',
                    child: TextFormField(
                      controller: _aprController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Interest Rate (APR)',
                        labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                        suffixText: '%',
                        suffixStyle: const TextStyle(color: Colors.white),
                        hintText: 'e.g., 18.99',
                        hintStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the APR';
                        }
                        final apr = double.tryParse(value);
                        if (apr == null || apr < 0 || apr > 50) {
                          return 'Please enter a valid APR (0-50%)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Minimum Payment with help
                  _buildFieldWithHelp(
                    label: 'Minimum Monthly Payment',
                    helpTitle: 'What is Minimum Payment?',
                    helpContent: 'This is the smallest amount you\'re required to pay each month to keep your account in good standing.\n\nWhere to find it:\n• Look for "Minimum Payment Due" on your statement\n• Check your online account\n• Call your lender if unsure\n\nExample: If your statement says "Minimum Payment: \$75", enter 75',
                    child: TextFormField(
                      controller: _minimumPaymentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Minimum Monthly Payment',
                        labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                        prefixText: '\$',
                        prefixStyle: const TextStyle(color: Colors.white),
                        hintText: 'e.g., 75',
                        hintStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the minimum payment';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Help tip
                  Card3D(
                    backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.lightBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tip: All this info is on your latest statement or online account!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textOnDark.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Save Button with 3D effect
                  Button3D(
                    onPressed: _saveDebt,
                    gradient: AppColors.primaryGradient,
                    child: const Text('Add Debt & Continue'),
                  ),
                  const SizedBox(height: 12),
                  
                  // Skip Button
                  TextButton(
                    onPressed: () => context.go('/dashboard'),
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color: AppColors.textOnDark.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWithHelp({
    required String label,
    required String helpTitle,
    required String helpContent,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showHelpDialog(helpTitle, helpContent),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: AppColors.skyBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
