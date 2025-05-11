import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Expense {
  final String id;
  final String name;
  final int amount;
  final String category;
  final DateTime date;
  final String createdBy;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.createdBy,
  });

  /// Converts the current `Expense` object into a `ParseObject` representation.
  ///
  /// This method maps the properties of the `Expense` model to a `ParseObject`
  /// with the class name 'Expense'. It sets the following fields:
  /// - `name`: The name of the expense (String).
  /// - `amount`: The amount of the expense (int).
  /// - `category`: The category of the expense (String).
  /// - `date`: The date of the expense (DateTime).
  /// - `createdBy`: A reference to the user who created the expense, represented
  ///   as a `ParseObject` with the class name '_User' and the `objectId` set to
  ///   the `createdBy` property of the `Expense` object.
  ///
  /// If the `id` property of the `Expense` object is not empty, it sets the
  /// `objectId` of the `ParseObject` to the value of `id`.
  ///
  /// Returns:
  /// A `ParseObject` representing the current `Expense` object.
  ParseObject toParse() {
    final obj =
        ParseObject('Expense')
          ..set<String>('name', name)
          ..set<int>('amount', amount)
          ..set<String>('category', category)
          ..set<DateTime>('date', date)
          ..set('createdBy', ParseObject('_User')..objectId = createdBy);
    if (id.isNotEmpty) obj.objectId = id;
    return obj;
  }

  /// Creates an `Expense` object from a `ParseObject`.
  ///
  /// This method extracts data from a `ParseObject` and maps it to an `Expense` instance.
  ///
  /// - The `createdBy` field is extracted from the `ParseUser` pointer and its `objectId`.
  ///   If the `ParseUser` is null, it defaults to `'unknown'`.
  /// - The `id` field is set to the `objectId` of the `ParseObject`, defaulting to an empty string if null.
  /// - The `name` field is retrieved from the `name` key, defaulting to an empty string if null.
  /// - The `amount` field is retrieved from the `amount` key, defaulting to `0` if null.
  /// - The `category` field is retrieved from the `category` key, defaulting to `'Misc'` if null.
  /// - The `date` field is retrieved from the `date` key, defaulting to the current date and time if null.
  ///
  /// Returns an `Expense` instance populated with the extracted data.
  static Expense fromParse(ParseObject obj) {
    // extract the Pointer<_User> and grab its objectId
    final creator = obj.get<ParseUser>('createdBy')?.objectId ?? 'unknown';

    return Expense(
      id: obj.objectId ?? '',
      name: obj.get<String>('name') ?? '',
      amount: obj.get<int>('amount') ?? 0,
      category: obj.get<String>('category') ?? 'Misc',
      date: obj.get<DateTime>('date') ?? DateTime.now(),
      createdBy: creator,
    );
  }
}
