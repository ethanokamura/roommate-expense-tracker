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

/// Object mapping for [Users]
/// Defines helper functions to help with bidirectional mapping
class Users extends Equatable {
  /// Constructor for [Users]
  /// Requires default values for non-nullable data
  const Users({
    this.userId, // PK
    this.displayName = '',
    this.email = '',
    this.createdAt,
    this.updatedAt,
  });

  // Helper function that converts a single SQL object to our dart object
  factory Users.converterSingle(Map<String, dynamic> data) {
    return Users.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json[userIdConverter]?.toString() ?? '',
      displayName: json[displayNameConverter]?.toString() ?? '',
      email: json[emailConverter]?.toString() ?? '',
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
  static String get userIdConverter => 'user_id';
  static String get displayNameConverter => 'display_name';
  static String get emailConverter => 'email';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';

  // Defines the empty state for the Users
  static const empty = Users(
    email: '',
  );

  // Data for Users
  final String? userId; // PK
  final String displayName;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        userId,
        displayName,
        email,
        createdAt,
        updatedAt,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<Users> converter(List<Map<String, dynamic>> data) {
    return data.map(Users.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      displayName: displayName,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? userId,
    String? displayName,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (userId != null) userIdConverter: userId,
      if (displayName != null) displayNameConverter: displayName,
      if (email != null) emailConverter: email,
      if (createdAt != null) createdAtConverter: createdAt,
      if (updatedAt != null) updatedAtConverter: updatedAt,
    };
  }
}

// Extensions to the object allowing a public getters
extension UsersExtensions on Users {
  // Check if object is currently empty
  bool get isEmpty => this == Users.empty;
}
