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
//                Generated on: 2025-07-01 17:04:52 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

/// Object mapping for [Houses]
/// Defines helper functions to help with bidirectional mapping
class Houses extends Equatable {
  /// Constructor for [Houses]
  /// Requires default values for non-nullable data
  const Houses({
    this.houseId, // PK
    this.name = '',
    this.inviteCode = '',
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory Houses.converterSingle(Map<String, dynamic> data) {
    return Houses.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory Houses.fromJson(Map<String, dynamic> json) {
    return Houses(
      houseId: json[houseIdConverter]?.toString() ?? '',
      name: json[nameConverter]?.toString() ?? '',
      inviteCode: json[inviteCodeConverter]?.toString() ?? '',
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
  static String get houseIdConverter => 'house_id';
  static String get nameConverter => 'name';
  static String get inviteCodeConverter => 'invite_code';
  static String get userIdConverter => 'user_id';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the Houses
  static const empty = Houses(
    name: '',
    inviteCode: '',
  );

  // Data for Houses
  final String? houseId; // PK
  final String name;
  final String inviteCode;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        houseId,
        name,
        inviteCode,
        userId,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<Houses> converter(List<Map<String, dynamic>> data) {
    return data.map(Houses.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      houseId: houseId,
      name: name,
      inviteCode: inviteCode,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? houseId,
    String? name,
    String? inviteCode,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (houseId != null) houseIdConverter: houseId,
      if (name != null) nameConverter: name,
      if (inviteCode != null) inviteCodeConverter: inviteCode,
      if (userId != null) userIdConverter: userId,
      if (createdAt != null) createdAtConverter: createdAt,
      if (updatedAt != null) updatedAtConverter: updatedAt,
    };
  }

  // helper function for inserting data into a given SQL table
  static Map<String, dynamic> insert({
    String? houseId,
    String? name,
    String? inviteCode,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      _generateMap(
        houseId: houseId,
        name: name,
        inviteCode: inviteCode,
        userId: userId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // helper function for updating data for a given SQL table
  static Map<String, dynamic> update({
    String? houseId,
    String? name,
    String? inviteCode,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      _generateMap(
        houseId: houseId,
        name: name,
        inviteCode: inviteCode,
        userId: userId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// Extensions to the object allowing a public getters
extension HousesExtensions on Houses {
  // Check if object is currently empty
  bool get isEmpty => this == Houses.empty;
}
