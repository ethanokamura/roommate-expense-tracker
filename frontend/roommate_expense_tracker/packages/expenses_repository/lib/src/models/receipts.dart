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

/// Object mapping for [Receipts]
/// Defines helper functions to help with bidirectional mapping
class Receipts extends Equatable {
  /// Constructor for [Receipts]
  /// Requires default values for non-nullable data
  const Receipts({
    this.receiptId, // PK
    this.expenseId, // FK
    this.imageUrl = '',
    this.userId, // FK
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory Receipts.converterSingle(Map<String, dynamic> data) {
    return Receipts.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory Receipts.fromJson(Map<String, dynamic> json) {
    return Receipts(
      receiptId: json[receiptIdConverter]?.toString() ?? '',
      expenseId: json[expenseIdConverter]?.toString() ?? '',
      imageUrl: json[imageUrlConverter]?.toString() ?? '',
      userId: json[userIdConverter]?.toString() ?? '',
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
  static String get receiptIdConverter => 'receipt_id';
  static String get expenseIdConverter => 'expense_id';
  static String get imageUrlConverter => 'image_url';
  static String get userIdConverter => 'user_id';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the Receipts
  static const empty = Receipts(
    expenseId: '',
    imageUrl: '',
    userId: '',
  );

  // Data for Receipts
  final String? receiptId; // PK
  final String? expenseId; // FK
  final String imageUrl;
  final String? userId; // FK
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        receiptId,
        expenseId,
        imageUrl,
        userId,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<Receipts> converter(List<Map<String, dynamic>> data) {
    return data.map(Receipts.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      receiptId: receiptId,
      expenseId: expenseId,
      imageUrl: imageUrl,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? receiptId,
    String? expenseId,
    String? imageUrl,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (receiptId != null) receiptIdConverter: receiptId,
      if (expenseId != null) expenseIdConverter: expenseId,
      if (imageUrl != null) imageUrlConverter: imageUrl,
      if (userId != null) userIdConverter: userId,
      if (createdAt != null) createdAtConverter: createdAt,
      if (updatedAt != null) updatedAtConverter: updatedAt,
    };
  }
}

// Extensions to the object allowing a public getters
extension ReceiptsExtensions on Receipts {
  // Check if object is currently empty
  bool get isEmpty => this == Receipts.empty;
}
