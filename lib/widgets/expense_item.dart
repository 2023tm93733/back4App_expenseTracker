import 'package:flutter/material.dart';
import '../models/expense.dart';

/// A widget that displays a single expense in a Card with ListTile.
///
/// Shows the expense name, category, amount, and date, along with edit and delete actions.
class ExpenseItem extends StatelessWidget {
  /// The expense data to display.
  final Expense expense;

  /// Callback function triggered when the edit button is pressed.
  final VoidCallback onEdit;

  /// Callback function triggered when the delete button is pressed.
  final VoidCallback onDelete;

  /// Creates an [ExpenseItem] widget.
  ///
  /// [expense]: The expense data to display.
  /// [onEdit]: Callback for the edit action.
  /// [onDelete]: Callback for the delete action.
  const ExpenseItem({
    Key? key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  /// Builds the UI for the expense item, including name, category, amount, date, and action buttons.
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(expense.name),
        isThreeLine: true,
        subtitle: Text(
          '${expense.category} • ₹${expense.amount.toStringAsFixed(2)}\n${expense.date.toLocal().toIso8601String().split('T')[0]}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
