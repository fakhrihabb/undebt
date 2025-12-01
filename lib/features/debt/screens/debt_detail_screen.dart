import 'package:flutter/material.dart';

class DebtDetailScreen extends StatelessWidget {
  final String debtId;
  
  const DebtDetailScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debt Details')),
      body: Center(child: Text('Details for debt: $debtId - Coming Soon')),
    );
  }
}
