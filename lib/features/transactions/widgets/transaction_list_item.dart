import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../models/category_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildLeadingIcon(theme),
        title: _buildTitle(theme),
        subtitle: _buildSubtitle(theme),
        trailing: _buildTrailing(theme, currencyFormatter),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLeadingIcon(ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: category?.color.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        transaction.type == TransactionType.income
            ? Icons.add_circle_outline
            : Icons.remove_circle_outline,
        color: category?.color ?? Colors.grey,
        size: 24,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      transaction.title,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category?.name ?? 'Unknown Category',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          DateFormat('MMM dd, yyyy • HH:mm').format(transaction.date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(ThemeData theme, NumberFormat formatter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${transaction.type == TransactionType.income ? '+' : '-'}${formatter.format(transaction.amount)}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: transaction.type == TransactionType.income
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
