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

  /// Future holding the list of expenses to be displayed.
  late Future<List<Expense>> _future;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  /// Loads the list of expenses from the backend and updates the state.
  void _loadExpenses() {
    _future = _service.fetchExpenses();
    setState(() {});
  }

  /// Logs out the current user and navigates to the login screen.
  void _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Navigates to the change password screen.
  void _changePassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  /// Formats a [DateTime] object into a human-readable string.
  ///
  /// Returns a date in the format 'dd MMM yyyy'.
  String _fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Banner at the top with actions for changing password and logout.
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FutureBuilder<List<Expense>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      // Show loading indicator while fetching data
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      // Show error message if fetching fails
                      return Center(child: Text('Error: ${snap.error}'));
                    }
                    final list = snap.data ?? [];
                    if (list.isEmpty) {
                      // Show message if there are no expenses
                      return const Center(child: Text('No expenses to show.'));
                    }
                    // List of expenses
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final e = list[i];
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
                                // Top Row: Name (left), Category (right)
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
                                        color: Colors.deepPurple.withOpacity(
                                          0.1,
                                        ),
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
                                // Bottom Row: Date (left), Amount (center), Edit/Delete (right)
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

                                    /// Edit expense button
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
                                                (_) => AddExpenseScreen(
                                                  expense: e,
                                                ),
                                          ),
                                        );
                                        if (updated == true) _loadExpenses();
                                      },
                                      tooltip: 'Edit',
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    /// Delete expense button
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
                                          _loadExpenses();
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
          ),
        ],
      ),

      /// Floating action button to add a new expense.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          if (added == true) _loadExpenses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
