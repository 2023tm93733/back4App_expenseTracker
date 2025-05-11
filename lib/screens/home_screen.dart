// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_banner.dart';
import 'add_expense_screen.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart'; // add intl to pubspec.yaml

/// The main screen that displays the user's expenses and allows CRUD operations.
///
/// This screen shows a list of expenses, provides options to add, edit, or delete expenses,
/// and includes actions for logging out and changing the password.
class HomeScreen extends StatefulWidget {
  /// Constructs a [HomeScreen].
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// State class for [HomeScreen].
///
/// Handles fetching, displaying, and updating the list of expenses.
class _HomeScreenState extends State<HomeScreen> {
  /// Service for interacting with the backend (Back4App).
  final _service = Back4AppService();

  List<Expense> _allExpenses = [];
  List<Expense> _filteredExpenses = [];

  late Future<void> _futureLoad;

  final List<String> _categories = [
    'All',
    'Home',
    'Travel',
    'Misc',
    'Food',
    'Utilities',
    'Entertainment',
  ];
  String _selectedCategory = 'All';

  double get _totalAmount =>
      _filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

  @override
  void initState() {
    super.initState();
    _futureLoad = _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _service.fetchExpenses();
    setState(() {
      _allExpenses = expenses;
      _applyCategoryFilter(_selectedCategory);
    });
  }

  void _applyCategoryFilter(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredExpenses = List.from(_allExpenses);
    } else {
      _filteredExpenses =
          _allExpenses.where((e) => e.category == category).toList();
    }
  }

  void _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _changePassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  String _fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // original banner with only title + icons
          AppBanner(
            title: 'Your Expenses',
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.lock_reset, color: Colors.white),
                  tooltip: 'Change Password',
                  onPressed: _changePassword,
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: _logout,
                ),
              ],
            ),
          ),

          // Total + Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Card(
              color: Colors.deepPurple.shade50,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items:
                          _categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _applyCategoryFilter(val);
                          });
                        }
                      },
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.deepPurple,
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black87),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expense list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 80),
              child: FutureBuilder<void>(
                future: _futureLoad,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (_filteredExpenses.isEmpty) {
                    return const Center(child: Text('No expenses to show.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredExpenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final e = _filteredExpenses[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      e.category,
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _fmtDate(e.date),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${e.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.deepPurple,
                                      size: 22,
                                    ),
                                    onPressed: () async {
                                      final updated = await Navigator.of(
                                        context,
                                      ).push<bool>(
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  AddExpenseScreen(expense: e),
                                        ),
                                      );
                                      if (updated == true) {
                                        await _loadExpenses();
                                      }
                                    },
                                    tooltip: 'Edit',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 22,
                                    ),
                                    onPressed: () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
                                              title: const Text(
                                                'Delete Expense',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this expense?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (ok == true) {
                                        await _service.deleteExpense(e.id);
                                        await _loadExpenses();
                                      }
                                    },
                                    tooltip: 'Delete',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          if (added == true) {
            await _loadExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
