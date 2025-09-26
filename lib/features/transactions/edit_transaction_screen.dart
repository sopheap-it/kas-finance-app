import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/budget_provider.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/budget_model.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dialog.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction; // null for add, not null for edit
  final TransactionType? initialType; // preset type from quick action
  final bool lockTypeSelection; // hide type selector when preset

  const EditTransactionScreen({
    super.key,
    this.transaction,
    this.initialType,
    this.lockTypeSelection = false,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  CategoryModel? _selectedCategory;
  BudgetModel? _selectedBudget;
  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;
  bool _isLoading = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    // Defer provider reads to after first frame to avoid notify during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _initializeForm() {
    if (_isEditing) {
      final transaction = widget.transaction!;
      _amountController.text = transaction.amount.toString();
      _titleController.text = transaction.title;
      _descriptionController.text = transaction.description ?? '';
      _selectedDate = transaction.date;
      _selectedType = transaction.type;
    } else if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    await Future.wait([
      provider.loadCategories(),
      budgetProvider.loadBudgets(
        userId: Provider.of<AuthProvider>(context, listen: false).isGuestMode
            ? 'guest'
            : Provider.of<AuthProvider>(context, listen: false).user?.id,
      ),
    ]);

    if (_isEditing) {
      // Set the category from the transaction
      final category = provider.getCategoryById(widget.transaction!.categoryId);
      if (category != null) {
        setState(() {
          _selectedCategory = category;
        });
      }
    } else {
      // Auto-select first category of the correct type
      final categories = provider.categories
          .where((c) => c.type == _selectedType.name)
          .toList();
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategory = categories.first;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _selectedType = type;
      _selectedCategory = null; // Reset category when type changes
    });
    _loadCategories(); // Reload categories for the new type
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      AppDialog.showInfo(
        context,
        title: 'Missing Category',
        message: 'Please select a category for this transaction.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final budgetProvider = Provider.of<BudgetProvider>(
        context,
        listen: false,
      );

      final transaction = _isEditing
          ? widget.transaction!.copyWith(
              amount: double.parse(_amountController.text),
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              categoryId: _selectedCategory!.id,
              type: _selectedType,
              date: _selectedDate,
            )
          : TransactionModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              userId: authProvider.isGuestMode
                  ? 'guest'
                  : authProvider.user!.id,
              amount: double.parse(_amountController.text),
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              categoryId: _selectedCategory!.id,
              type: _selectedType,
              date: _selectedDate,
            );

      final success = _isEditing
          ? await transactionProvider.updateTransaction(transaction)
          : await transactionProvider.addTransaction(transaction);

      if (success && mounted) {
        // Update budget spending after transaction change
        await budgetProvider.updateBudgetSpending(
          transactionProvider.allTransactions,
        );

        // Show budget association message if selected
        if (_selectedBudget != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Transaction added to event: ${_selectedBudget!.name}',
              ),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Transaction updated successfully'
                  : 'Transaction added successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Failed to update transaction'
                  : 'Failed to add transaction',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Selection (only for new transactions and when not locked by quick action)
              if (!_isEditing && !widget.lockTypeSelection) ...[
                Text(
                  'Transaction Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        TransactionType.income,
                        'Income',
                        Icons.add_circle_outline,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton(
                        TransactionType.expense,
                        'Expense',
                        Icons.remove_circle_outline,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Amount Field
              Text(
                'Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Title Field
              Text(
                'Title',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter transaction title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category Selection
              Text(
                'Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  final categories = provider.categories
                      .where((c) => c.type == _selectedType.name)
                      .toList();

                  if (categories.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text('No categories available'),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CategoryModel>(
                        value: _selectedCategory,
                        hint: const Text('Select a category'),
                        isExpanded: true,
                        items: categories.map((category) {
                          return DropdownMenuItem<CategoryModel>(
                            value: category,
                            child: Row(
                              children: [
                                Icon(
                                  _getIconData(category.iconName),
                                  color: category.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(category.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (CategoryModel? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Event Selection (only for expenses)
              if (_selectedType == TransactionType.expense) ...[
                Text(
                  'Event (Optional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<BudgetProvider>(
                  builder: (context, budgetProvider, child) {
                    final activeBudgets = budgetProvider.activeBudgets;

                    if (activeBudgets.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Text('No active events available'),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<BudgetModel>(
                          value: _selectedBudget,
                          hint: const Text('Select an event (optional)'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<BudgetModel>(
                              value: null,
                              child: Text('No event'),
                            ),
                            ...activeBudgets.map((budget) {
                              return DropdownMenuItem<BudgetModel>(
                                value: budget,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.event,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            budget.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$${budget.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (BudgetModel? newValue) {
                            setState(() {
                              _selectedBudget = newValue;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Date Selection
              Text(
                'Date',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(_selectedDate),
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description Field
              Text(
                'Description (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter description (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              AppButton(
                text: _isEditing ? 'Update Transaction' : 'Add Transaction',
                onPressed: _isLoading ? null : _saveTransaction,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    TransactionType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () => _onTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'school':
        return Icons.school;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'flight':
        return Icons.flight;
      case 'savings':
        return Icons.savings;
      case 'business':
        return Icons.business;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.category;
    }
  }
}
