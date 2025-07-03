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

/// Object mapping for [RecurringExpenses]
/// Defines helper functions to help with bidirectional mapping
class RecurringExpenses extends Equatable {
  /// Constructor for [RecurringExpenses]
  /// Requires default values for non-nullable data
  const RecurringExpenses({
    this.recurringExpenseId, // PK
    this.houseId, // FK
    this.houseMemberId, // FK
    this.descriptionTemplate = '',
    this.amountTemplate = 0.0,
    this.frequency = '',
    this.startDate,
    this.endDate,
    this.nextDueDate,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory RecurringExpenses.converterSingle(Map<String, dynamic> data) {
    return RecurringExpenses.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory RecurringExpenses.fromJson(Map<String, dynamic> json) {
    return RecurringExpenses(
      recurringExpenseId: json[recurringExpenseIdConverter]?.toString() ?? '',
      houseId: json[houseIdConverter]?.toString() ?? '',
      houseMemberId: json[houseMemberIdConverter]?.toString() ?? '',
      descriptionTemplate: json[descriptionTemplateConverter]?.toString() ?? '',
      amountTemplate:
          double.tryParse(json[amountTemplateConverter]?.toString() ?? '') ??
              0.0,
      frequency: json[frequencyConverter]?.toString() ?? '',
      startDate: json[startDateConverter] != null
          ? DateTime.tryParse(json[startDateConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      endDate: json[endDateConverter] != null
          ? DateTime.tryParse(json[endDateConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      nextDueDate: json[nextDueDateConverter] != null
          ? DateTime.tryParse(json[nextDueDateConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      isActive: RecurringExpenses._parseBool(json[isActiveConverter]),
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
  static String get recurringExpenseIdConverter => 'recurring_expense_id';
  static String get houseIdConverter => 'house_id';
  static String get houseMemberIdConverter => 'house_member_id';
  static String get descriptionTemplateConverter => 'description_template';
  static String get amountTemplateConverter => 'amount_template';
  static String get frequencyConverter => 'frequency';
  static String get startDateConverter => 'start_date';
  static String get endDateConverter => 'end_date';
  static String get nextDueDateConverter => 'next_due_date';
  static String get isActiveConverter => 'is_active';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the RecurringExpenses
  static const empty = RecurringExpenses(
    houseId: '',
    houseMemberId: '',
    descriptionTemplate: '',
    amountTemplate: 0.0,
    frequency: '',
    isActive: false,
  );

  // Data for RecurringExpenses
  final String? recurringExpenseId; // PK
  final String? houseId; // FK
  final String? houseMemberId; // FK
  final String descriptionTemplate;
  final double amountTemplate;
  final String frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? nextDueDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        recurringExpenseId,
        houseId,
        houseMemberId,
        descriptionTemplate,
        amountTemplate,
        frequency,
        startDate,
        endDate,
        nextDueDate,
        isActive,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<RecurringExpenses> converter(List<Map<String, dynamic>> data) {
    return data.map(RecurringExpenses.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      recurringExpenseId: recurringExpenseId,
      houseId: houseId,
      houseMemberId: houseMemberId,
      descriptionTemplate: descriptionTemplate,
      amountTemplate: amountTemplate,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
      nextDueDate: nextDueDate,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? recurringExpenseId,
    String? houseId,
    String? houseMemberId,
    String? descriptionTemplate,
    double? amountTemplate,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextDueDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (recurringExpenseId != null)
        recurringExpenseIdConverter: recurringExpenseId,
      if (houseId != null) houseIdConverter: houseId,
      if (houseMemberId != null) houseMemberIdConverter: houseMemberId,
      if (descriptionTemplate != null)
        descriptionTemplateConverter: descriptionTemplate,
      if (amountTemplate != null) amountTemplateConverter: amountTemplate,
      if (frequency != null) frequencyConverter: frequency,
      if (startDate != null) startDateConverter: startDate,
      if (endDate != null) endDateConverter: endDate,
      if (nextDueDate != null) nextDueDateConverter: nextDueDate,
      if (isActive != null) isActiveConverter: isActive,
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
extension RecurringExpensesExtensions on RecurringExpenses {
  // Check if object is currently empty
  bool get isEmpty => this == RecurringExpenses.empty;
}
