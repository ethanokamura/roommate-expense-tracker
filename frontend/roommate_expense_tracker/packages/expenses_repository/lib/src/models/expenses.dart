import 'package:app_core/app_core.dart';

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                           PERFECT LINE LLC                             //
//                                                                        //
//           THIS FILE IS AUTO-GENERATED. DO NOT EDIT MANUALLY.           //
//                                                                        //
//  Any changes to this file will be overwritten the next time the code   //
//  is regenerated. If you need to modify behavior, update the source     //
//                         template instead.                              //
//                                                                        //
//                Generated on: 2025-07-18 03:23:05 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

/// Object mapping for [Expenses]
/// Defines helper functions to help with bidirectional mapping
class Expenses extends Equatable {
  /// Constructor for [Expenses]
  /// Requires default values for non-nullable data
  const Expenses({
    this.expenseId, // PK
    this.houseId, // FK
    this.houseMemberId, // FK
    this.title = '',
    this.description = '',
    this.splits = const {},
    this.totalAmount = 0.0,
    this.expenseDate,
    this.category = '',
    this.isSettled = false,
    this.settledAt,
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory Expenses.converterSingle(Map<String, dynamic> data) {
    return Expenses.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory Expenses.fromJson(Map<String, dynamic> json) {
    return Expenses(
      expenseId: json[expenseIdConverter]?.toString() ?? '',
      houseId: json[houseIdConverter]?.toString() ?? '',
      houseMemberId: json[houseMemberIdConverter]?.toString() ?? '',
      title: json[titleConverter]?.toString() ?? '',
      description: json[descriptionConverter]?.toString() ?? '',
      splits: json[splitsConverter] as Map<String, dynamic>? ?? const {},
      totalAmount:
          double.tryParse(json[totalAmountConverter]?.toString() ?? '') ?? 0.0,
      expenseDate: json[expenseDateConverter] != null
          ? DateTime.tryParse(json[expenseDateConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      category: json[categoryConverter]?.toString() ?? '',
      isSettled: Expenses._parseBool(json[isSettledConverter]),
      settledAt: json[settledAtConverter] != null
          ? DateTime.tryParse(json[settledAtConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      updatedAt: json[updatedAtConverter] != null
          ? DateTime.tryParse(json[updatedAtConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
    );
  }

  // JSON string equivalent for our data
  static String get expenseIdConverter => 'expense_id';
  static String get houseIdConverter => 'house_id';
  static String get houseMemberIdConverter => 'house_member_id';
  static String get titleConverter => 'title';
  static String get descriptionConverter => 'description';
  static String get splitsConverter => 'splits';
  static String get totalAmountConverter => 'total_amount';
  static String get expenseDateConverter => 'expense_date';
  static String get categoryConverter => 'category';
  static String get isSettledConverter => 'is_settled';
  static String get settledAtConverter => 'settled_at';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the Expenses
  static const empty = Expenses(
    houseId: '',
    houseMemberId: '',
    title: '',
    splits: const {},
    totalAmount: 0.0,
    isSettled: false,
  );

  // Data for Expenses
  final String? expenseId; // PK
  final String? houseId; // FK
  final String? houseMemberId; // FK
  final String title;
  final String description;
  final Map<String, dynamic> splits;
  final double totalAmount;
  final DateTime? expenseDate;
  final String category;
  final bool isSettled;
  final DateTime? settledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        expenseId,
        houseId,
        houseMemberId,
        title,
        description,
        splits,
        totalAmount,
        expenseDate,
        category,
        isSettled,
        settledAt,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<Expenses> converter(List<Map<String, dynamic>> data) {
    return data.map(Expenses.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      expenseId: expenseId,
      houseId: houseId,
      houseMemberId: houseMemberId,
      title: title,
      description: description,
      splits: splits,
      totalAmount: totalAmount,
      expenseDate: expenseDate,
      category: category,
      isSettled: isSettled,
      settledAt: settledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? expenseId,
    String? houseId,
    String? houseMemberId,
    String? title,
    String? description,
    Map<String, dynamic>? splits,
    double? totalAmount,
    DateTime? expenseDate,
    String? category,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (expenseId != null) expenseIdConverter: expenseId,
      if (houseId != null) houseIdConverter: houseId,
      if (houseMemberId != null) houseMemberIdConverter: houseMemberId,
      if (title != null) titleConverter: title,
      if (description != null) descriptionConverter: description,
      if (splits != null) splitsConverter: splits,
      if (totalAmount != null) totalAmountConverter: totalAmount,
      if (expenseDate != null) expenseDateConverter: expenseDate,
      if (category != null) categoryConverter: category,
      if (isSettled != null) isSettledConverter: isSettled,
      if (settledAt != null) settledAtConverter: settledAt,
      if (createdAt != null) createdAtConverter: createdAt,
      if (updatedAt != null) updatedAtConverter: updatedAt,
    };
  }

  // Helper function to safely parse boolean values, handling various input types
  static bool _parseBool(dynamic value) {
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value != 0;
    }
    return false;
  }
}

// Extensions to the object allowing a public getters
extension ExpensesExtensions on Expenses {
  // Check if object is currently empty
  bool get isEmpty => this == Expenses.empty;
}
