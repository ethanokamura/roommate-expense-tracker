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

/// Object mapping for [Users]
/// Defines helper functions to help with bidirectional mapping
class Users extends Equatable {
  /// Constructor for [Users]
  /// Requires default values for non-nullable data
  const Users({
    this.userId, // PK
    this.displayName = '',
    this.email = '',
    this.photoUrl = '',
    this.paymentMethod = '',
    this.paymentLink = '',
    this.createdAt,
    this.updatedAt,
  });

  Users copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    String? paymentMethod,
    String? paymentLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Users(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentLink: paymentLink ?? this.paymentLink,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      photoUrl: json[photoUrlConverter]?.toString() ?? '',
      paymentMethod: json[paymentMethodConverter]?.toString() ?? '',
      paymentLink: json[paymentLinkConverter]?.toString() ?? '',
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
  static String get photoUrlConverter => 'photo_url';
  static String get paymentMethodConverter => 'payment_method';
  static String get paymentLinkConverter => 'payment_link';
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
  final String photoUrl;
  final String paymentMethod;
  final String paymentLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Defines object properties
  @override
  List<Object?> get props => [
        userId,
        displayName,
        email,
        photoUrl,
        paymentMethod,
        paymentLink,
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
      photoUrl: photoUrl,
      paymentMethod: paymentMethod,
      paymentLink: paymentLink,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    String? paymentMethod,
    String? paymentLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      if (userId != null) userIdConverter: userId,
      if (displayName != null) displayNameConverter: displayName,
      if (email != null) emailConverter: email,
      if (photoUrl != null) photoUrlConverter: photoUrl,
      if (paymentMethod != null) paymentMethodConverter: paymentMethod,
      if (paymentLink != null) paymentLinkConverter: paymentLink,
      if (createdAt != null) createdAtConverter: createdAt.toIso8601String(),
      if (updatedAt != null) updatedAtConverter: updatedAt.toIso8601String(),
    };
  }
}

// Extensions to the object allowing a public getters
extension UsersExtensions on Users {
  // Check if object is currently empty
  bool get isEmpty => this == Users.empty;
}
