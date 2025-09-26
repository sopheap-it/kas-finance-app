import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/category_model.dart';
import '../../core/widgets/app_dialog.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income Categories'),
            Tab(text: 'Expense Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCategoryList('income'), _buildCategoryList('expense')],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryList(String type) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories
            .where((c) => c.type == type)
            .toList();

        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type} categories yet',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first category',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconData(category.iconName),
            color: category.color,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Type: ${category.type}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditCategoryDialog(category);
            } else if (value == 'delete') {
              _showDeleteCategoryDialog(category);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final currentType = _tabController.index == 0 ? 'income' : 'expense';
    _showCategoryDialog(
      title: 'Add ${currentType} Category',
      category: null,
      type: currentType,
    );
  }

  void _showEditCategoryDialog(CategoryModel category) {
    _showCategoryDialog(
      title: 'Edit Category',
      category: category,
      type: category.type,
    );
  }

  void _showCategoryDialog({
    required String title,
    CategoryModel? category,
    required String type,
  }) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(
      text: category?.iconName ?? '',
    );
    Color selectedColor = category?.color ?? Colors.blue;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(
                    labelText: 'Icon Name (e.g., home, work)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Color', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                            Colors.teal,
                            Colors.pink,
                            Colors.amber,
                          ]
                          .map(
                            (color) => GestureDetector(
                              onTap: () =>
                                  setState(() => selectedColor = color),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(
                                          color: Colors.black,
                                          width: 3,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _saveCategory(
                nameController.text,
                iconController.text,
                selectedColor,
                type,
                category,
              ),
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCategory(
    String name,
    String iconName,
    Color color,
    String type,
    CategoryModel? existingCategory,
  ) async {
    if (name.trim().isEmpty) {
      AppDialog.showInfo(
        context,
        title: 'Invalid Input',
        message: 'Please enter a category name.',
      );
      return;
    }

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    try {
      if (existingCategory == null) {
        // Add new category
        final newCategory = CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.trim(),
          iconName: iconName.trim().isEmpty ? 'category' : iconName.trim(),
          color: color,
          type: type,
        );
        await provider.addCategory(newCategory);
      } else {
        // Update existing category
        final updatedCategory = existingCategory.copyWith(
          name: name.trim(),
          iconName: iconName.trim().isEmpty ? 'category' : iconName.trim(),
          color: color,
        );
        await provider.updateCategory(updatedCategory);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              existingCategory == null
                  ? 'Category added successfully'
                  : 'Category updated successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppDialog.showInfo(
          context,
          title: 'Error',
          message: 'Failed to save category: $e',
        );
      }
    }
  }

  void _showDeleteCategoryDialog(CategoryModel category) {
    AppDialog.showInfo(
      context,
      title: 'Delete Category',
      message:
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
    );
    // TODO: Implement confirmation dialog
    _deleteCategory(category);
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    try {
      await provider.deleteCategory(category.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppDialog.showInfo(
          context,
          title: 'Error',
          message: 'Failed to delete category: $e',
        );
      }
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'salary':
        return Icons.account_balance_wallet;
      case 'business':
        return Icons.business;
      case 'investment':
        return Icons.trending_up;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }
}
