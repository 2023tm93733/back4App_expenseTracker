import 'package:back4app_assignment/screens/login_screen.dart';
import 'package:back4app_assignment/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../widgets/app_banner.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

/// Screen for adding or editing an expense entry.
///
/// This screen presents a form for entering expense details such as name, amount,
/// category, and date. It supports both creating new expenses and editing existing ones.
class AddExpenseScreen extends StatefulWidget {
  /// Optional expense to edit. If null, a new expense will be created.
  final Expense? expense;
  const AddExpenseScreen({Key? key, this.expense}) : super(key: key);
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

/// State class for AddExpenseScreen, handling form input, submission, and UI logic.
class _AddExpenseScreenState extends State<AddExpenseScreen> {
  /// Form key for validation and submission.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the expense name input field.
  final _nameCtrl = TextEditingController();

  /// Controller for the expense amount input field.
  final _amountCtrl = TextEditingController();

  /// The currently selected date for the expense.
  DateTime _selectedDate = DateTime.now();

  /// The currently selected category for the expense.
  String _selectedCategory = 'Home';

  /// List of available expense categories.
  final List<String> _categories = [
    'Home',
    'Travel',
    'Misc',
    'Food',
    'Utilities',
    'Entertainment',
  ];

  /// Service for interacting with the Back4App backend.
  final Back4AppService _service = Back4AppService();

  @override
  /// Initializes the screen and pre-fills the form if editing an existing expense.
  void initState() {
    super.initState();
    if (widget.expense != null) {
      final e = widget.expense!;
      _nameCtrl.text = e.name;
      _amountCtrl.text = e.amount.toString();
      _selectedDate = e.date;
      _selectedCategory = e.category;
    }
  }

  /// Logs the user out and navigates to the login screen.
  void _logout() async {
    await AuthService.logout();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  /// Submits the expense form.
  ///
  /// Validates the form, creates or updates the expense in the backend,
  /// and closes the screen on success.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    final creatorId = currentUser?.objectId ?? '';
    final exp = Expense(
      id: widget.expense?.id ?? '',
      name: _nameCtrl.text,
      amount: int.parse(_amountCtrl.text),
      category: _selectedCategory,
      date: _selectedDate,
      createdBy: creatorId,
    );
    final success =
        widget.expense == null
            ? await _service.addExpense(exp)
            : await _service.updateExpense(exp);
    if (success) Navigator.of(context).pop(true);
  }

  @override
  /// Builds the AddExpenseScreen UI, including form fields and action buttons.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBanner(
            title: 'Add / Edit Expense',
            action: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ),
          Expanded(
            child: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Back button and title row
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const Spacer(),
                            Text(
                              widget.expense == null
                                  ? 'Add Expense'
                                  : 'Edit Expense',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Name field
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (v) => v!.isEmpty ? 'Enter a name' : null,
                        ),
                        const SizedBox(height: 12),
                        // Amount field
                        TextFormField(
                          controller: _amountCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Enter amount';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Enter a valid integer amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // Category dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items:
                              _categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (v) => setState(() => _selectedCategory = v!),
                        ),
                        const SizedBox(height: 12),
                        // Date row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Date: ${_selectedDate.toLocal().toIso8601String().split('T')[0]}',
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null)
                                  setState(() => _selectedDate = picked);
                              },
                              child: const Text('Select Date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Save button (full width)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
