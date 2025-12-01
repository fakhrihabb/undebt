import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';

/// Debt input screen - add debts during onboarding
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
      appBar: AppBar(
        title: const Text('Add Your Debts'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Let\'s add your first debt',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Don\'t worry, you can add more later!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Debt Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Debt Name',
                    hintText: 'e.g., Chase Credit Card',
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
                  decoration: const InputDecoration(
                    labelText: 'Debt Type',
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
                  decoration: const InputDecoration(
                    labelText: 'Current Balance',
                    prefixText: '\$',
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
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate (APR)',
                    suffixText: '%',
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
                  decoration: const InputDecoration(
                    labelText: 'Minimum Monthly Payment',
                    prefixText: '\$',
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
                
                // Save Button
                ElevatedButton(
                  onPressed: _saveDebt,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add Debt & Continue'),
                ),
                const SizedBox(height: 12),
                
                // Skip Button
                TextButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
