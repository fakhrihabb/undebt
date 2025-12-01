import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String debtId;
  
  const PaymentScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Payment')),
      body: Center(child: Text('Payment for debt: $debtId - Coming Soon')),
    );
  }
}
