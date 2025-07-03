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
//                Generated on: 2025-07-01 18:50:34 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

/// Object mapping for [ExpenseSpits]
/// Defines helper functions to help with bidirectional mapping
class ExpenseSpits extends Equatable {
  /// Constructor for [ExpenseSpits]
  /// Requires default values for non-nullable data
  const ExpenseSpits({
    this.expenseSplitId, // PK
    this.expenseId, // FK
    this.houseMemberId, // FK
    this.amountOwed = 0.0,
    this.isPaid = false,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory ExpenseSpits.converterSingle(Map<String, dynamic> data) {
    return ExpenseSpits.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory ExpenseSpits.fromJson(Map<String, dynamic> json) {
    return ExpenseSpits(
      expenseSplitId: json[expenseSplitIdConverter]?.toString() ?? '',
      expenseId: json[expenseIdConverter]?.toString() ?? '',
      houseMemberId: json[houseMemberIdConverter]?.toString() ?? '',
      amountOwed:
          double.tryParse(json[amountOwedConverter]?.toString() ?? '') ?? 0.0,
      isPaid: ExpenseSpits._parseBool(json[isPaidConverter]),
      paidAt: json[paidAtConverter] != null
          ? DateTime.tryParse(json[paidAtConverter].toString())?.toUtc() ??
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
  static String get expenseSplitIdConverter => 'expense_split_id';
  static String get expenseIdConverter => 'expense_id';
  static String get houseMemberIdConverter => 'house_member_id';
  static String get amountOwedConverter => 'amount_owed';
  static String get isPaidConverter => 'is_paid';
  static String get paidAtConverter => 'paid_at';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the ExpenseSpits
  static const empty = ExpenseSpits(
    expenseId: '',
    houseMemberId: '',
    amountOwed: 0.0,
    isPaid: false,
  );

  // Data for ExpenseSpits
  final String? expenseSplitId; // PK
  final String? expenseId; // FK
  final String? houseMemberId; // FK
  final double amountOwed;
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        expenseSplitId,
        expenseId,
        houseMemberId,
        amountOwed,
        isPaid,
        paidAt,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<ExpenseSpits> converter(List<Map<String, dynamic>> data) {
    return data.map(ExpenseSpits.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      expenseSplitId: expenseSplitId,
      expenseId: expenseId,
      houseMemberId: houseMemberId,
      amountOwed: amountOwed,
      isPaid: isPaid,
      paidAt: paidAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? expenseSplitId,
    String? expenseId,
    String? houseMemberId,
    double? amountOwed,
    bool? isPaid,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (expenseSplitId != null) expenseSplitIdConverter: expenseSplitId,
      if (expenseId != null) expenseIdConverter: expenseId,
      if (houseMemberId != null) houseMemberIdConverter: houseMemberId,
      if (amountOwed != null) amountOwedConverter: amountOwed,
      if (isPaid != null) isPaidConverter: isPaid,
      if (paidAt != null) paidAtConverter: paidAt,
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
extension ExpenseSpitsExtensions on ExpenseSpits {
  // Check if object is currently empty
  bool get isEmpty => this == ExpenseSpits.empty;
}
