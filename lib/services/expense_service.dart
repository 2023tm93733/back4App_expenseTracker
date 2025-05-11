import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/expense.dart';

/// Service class for managing Expense operations with the Back4App backend.
///
/// Provides methods to fetch, add, update, and delete Expense records using Parse.
class Back4AppService {
  /// Fetches all expenses from the backend, ordered by date (most recent first).
  ///
  /// Returns a list of [Expense] objects. Returns an empty list if the request fails.
  Future<List<Expense>> fetchExpenses() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Expense'))
      ..orderByDescending('date');
    final response = await query.query();
    if (response.success && response.results != null) {
      return (response.results! as List<ParseObject>)
          .map((e) => Expense.fromParse(e))
          .toList();
    }
    return [];
  }

  /// Adds a new expense to the backend.
  ///
  /// Sets the ACL to allow only the current user to read/write the expense.
  ///
  /// [exp]: The expense to add.
  /// Returns `true` if the operation succeeds, `false` otherwise.
  Future<bool> addExpense(Expense exp) async {
    final parseObj = exp.toParse();
    // 1) get the current user
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      // 2) build an ACL for that user only
      final acl =
          ParseACL()
            ..setReadAccess(userId: currentUser.objectId!, allowed: true)
            ..setWriteAccess(userId: currentUser.objectId!, allowed: true);
      parseObj.setACL(acl);
    }
    // 3) save
    final response = await parseObj.save();
    return response.success;
  }

  /// Updates an existing expense in the backend.
  ///
  /// [exp]: The expense to update. Must have a valid `id`.
  /// Returns `true` if the operation succeeds, `false` otherwise.
  Future<bool> updateExpense(Expense exp) async {
    final parseObj = exp.toParse()..objectId = exp.id;
    // no need to re-set ACL here; it’s preserved on the object
    final response = await parseObj.save();
    return response.success;
  }

  /// Deletes an expense from the backend by its ID.
  ///
  /// [id]: The ID of the expense to delete.
  /// Returns `true` if the operation succeeds, `false` otherwise.
  Future<bool> deleteExpense(String id) async {
    final obj = ParseObject('Expense')..objectId = id;
    final response = await obj.delete();
    return response.success;
  }
}
