import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'edit_transaction_screen.dart';

class AddTransactionScreen extends StatelessWidget {
  final TransactionType type;

  const AddTransactionScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return EditTransactionScreen(
      transaction: null, // null means it's a new transaction
      initialType: type, // preselect type from quick action
      lockTypeSelection: true, // no need to select again
    );
  }
}
