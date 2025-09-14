import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../providers/transaction_provider.dart';
import '../../../core/core.dart';

class TransactionDetailsModal extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsModal({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          _buildHandle(theme),
          _buildHeader(context, theme),
          Expanded(child: _buildContent(context, theme, currencyFormatter)),
        ],
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Transaction Details', style: theme.textTheme.headlineSmall),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    NumberFormat formatter,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAmountDisplay(theme, formatter),
          const SizedBox(height: 32),
          ..._buildDetailsList(theme),
          const Spacer(),
          _buildActionButtons(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(ThemeData theme, NumberFormat formatter) {
    return Center(
      child: Text(
        '${transaction.type == TransactionType.income ? '+' : '-'}${formatter.format(transaction.amount)}',
        style: theme.textTheme.displayMedium?.copyWith(
          color: transaction.type == TransactionType.income
              ? Colors.green
              : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildDetailsList(ThemeData theme) {
    final details = [
      ('Title', transaction.title),
      (
        'Type',
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
      ),
      ('Date', DateFormat('MMMM dd, yyyy').format(transaction.date)),
      ('Time', DateFormat('HH:mm').format(transaction.date)),
    ];

    if (transaction.description?.isNotEmpty == true) {
      details.add(('Description', transaction.description!));
    }

    return details
        .map((detail) => _buildDetailRow(detail.$1, detail.$2))
        .toList();
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _editTransaction(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _editTransaction(BuildContext context) {
    // TODO: Implement edit transaction
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit transaction coming soon')),
    );
  }

  void _showDeleteDialog(BuildContext context) async {
    final result = await AppDialog.showConfirmation(
      context,
      title: 'Delete Transaction',
      message:
          'Are you sure you want to delete this transaction? This action cannot be undone.',
      confirmText: 'Delete',
      isDangerous: true,
    );

    if (result == true && context.mounted) {
      _deleteTransaction(context);
    }
  }

  void _deleteTransaction(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.deleteTransaction(transaction.id);

    Navigator.pop(context); // Close modal
    context.showSuccessSnackBar('Transaction deleted');
  }
}
