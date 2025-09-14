import 'package:flutter/material.dart';
import '../../../models/budget_model.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback? onTap;

  const BudgetCard({super.key, required this.budget, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = budget.spentPercentage / 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              _buildAmountText(theme),
              const SizedBox(height: 8),
              _buildProgressBar(theme, progress),
              const SizedBox(height: 8),
              _buildPercentageText(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            budget.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildStatusBadge(theme),
      ],
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    Color statusColor;
    String statusText;

    if (budget.isOverBudget) {
      statusColor = Colors.red;
      statusText = 'Over Budget';
    } else if (budget.isNearLimit) {
      statusColor = Colors.orange;
      statusText = 'Near Limit';
    } else {
      statusColor = Colors.green;
      statusText = 'On Track';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAmountText(ThemeData theme) {
    return Text(
      '\$${budget.spent.toStringAsFixed(2)} of \$${budget.amount.toStringAsFixed(2)}',
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    Color progressColor;
    if (budget.isOverBudget) {
      progressColor = Colors.red;
    } else if (budget.isNearLimit) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return LinearProgressIndicator(
      value: progress > 1.0 ? 1.0 : progress,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
    );
  }

  Widget _buildPercentageText(ThemeData theme) {
    return Text(
      '${budget.spentPercentage.toStringAsFixed(1)}% used',
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
