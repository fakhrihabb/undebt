import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/widgets/button_3d.dart';

/// Debt input screen - add debts during onboarding with dark theme
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
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
                    'Don\'t worry, you can add more later!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textOnDark.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Debt Name
                  TextFormField(
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
                  const SizedBox(height: 16),
                  
                  // Debt Type
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: AppColors.surfaceDark,
                    decoration: InputDecoration(
                      labelText: 'Debt Type',
                      labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
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
                  const SizedBox(height: 16),
                  
                  // Current Balance
                  TextFormField(
                    controller: _balanceController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Current Balance',
                      labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                      prefixText: '\$',
                      prefixStyle: const TextStyle(color: Colors.white),
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
                  const SizedBox(height: 16),
                  
                  // APR
                  TextFormField(
                    controller: _aprController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Interest Rate (APR)',
                      labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                      suffixText: '%',
                      suffixStyle: const TextStyle(color: Colors.white),
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
                  const SizedBox(height: 16),
                  
                  // Minimum Payment
                  TextFormField(
                    controller: _minimumPaymentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Minimum Monthly Payment',
                      labelStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.7)),
                      prefixText: '\$',
                      prefixStyle: const TextStyle(color: Colors.white),
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
                  const SizedBox(height: 32),
                  
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
}
