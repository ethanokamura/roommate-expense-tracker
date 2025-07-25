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

/// Object mapping for [HouseMembers]
/// Defines helper functions to help with bidirectional mapping
class HouseMembers extends Equatable {
  /// Constructor for [HouseMembers]
  /// Requires default values for non-nullable data
  const HouseMembers({
    this.houseMemberId, // PK
    this.userId, // FK
    this.houseId, // FK
    this.isAdmin = false,
    this.createdAt,
    this.updatedAt,
    this.nickname = '',
    this.isActive = false,
  });

  HouseMembers copyWith({
    String? houseMemberId,
    String? userId,
    String? houseId,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? nickname,
    bool? isActive,
  }) {
    return HouseMembers(
      houseMemberId: houseMemberId ?? this.houseMemberId,
      userId: userId ?? this.userId,
      houseId: houseId ?? this.houseId,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nickname: nickname ?? this.nickname,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper function that converts a single SQL object to our dart object
  factory HouseMembers.converterSingle(Map<String, dynamic> data) {
    return HouseMembers.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory HouseMembers.fromJson(Map<String, dynamic> json) {
    return HouseMembers(
      houseMemberId: json[houseMemberIdConverter]?.toString() ?? '',
      userId: json[userIdConverter]?.toString() ?? '',
      houseId: json[houseIdConverter]?.toString() ?? '',
      isAdmin: HouseMembers._parseBool(json[isAdminConverter]),
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      updatedAt: json[updatedAtConverter] != null
          ? DateTime.tryParse(json[updatedAtConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      nickname: json[nicknameConverter]?.toString() ?? '',
      isActive: HouseMembers._parseBool(json[isActiveConverter]),
    );
  }

  // JSON string equivalent for our data
  static String get houseMemberIdConverter => 'house_member_id';
  static String get userIdConverter => 'user_id';
  static String get houseIdConverter => 'house_id';
  static String get isAdminConverter => 'is_admin';
  static String get createdAtConverter => 'created_at';
  static String get updatedAtConverter => 'updated_at';
  static String get nicknameConverter => 'nickname';
  static String get isActiveConverter => 'is_active';

  // Defines the empty state for the HouseMembers
  static const empty = HouseMembers(
    userId: '',
    houseId: '',
    isAdmin: false,
    isActive: false,
  );

  // Data for HouseMembers
  final String? houseMemberId; // PK
  final String? userId; // FK
  final String? houseId; // FK
  final bool isAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String nickname;
  final bool isActive;

  // Defines object properties
  @override
  List<Object?> get props => [
        houseMemberId,
        userId,
        houseId,
        isAdmin,
        createdAt,
        updatedAt,
        nickname,
        isActive,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<HouseMembers> converter(List<Map<String, dynamic>> data) {
    return data.map(HouseMembers.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      houseMemberId: houseMemberId,
      userId: userId,
      houseId: houseId,
      isAdmin: isAdmin,
      createdAt: createdAt?.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
      nickname: nickname,
      isActive: isActive,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? houseMemberId,
    String? userId,
    String? houseId,
    bool? isAdmin,
    String? createdAt,
    String? updatedAt,
    String? nickname,
    bool? isActive,
  }) {
    return {
      if (houseMemberId != null) houseMemberIdConverter: houseMemberId,
      if (userId != null) userIdConverter: userId,
      if (houseId != null) houseIdConverter: houseId,
      if (isAdmin != null) isAdminConverter: isAdmin,
      if (createdAt != null) createdAtConverter: createdAt,
      if (updatedAt != null) updatedAtConverter: updatedAt,
      if (nickname != null) nicknameConverter: nickname,
      if (isActive != null) isActiveConverter: isActive,
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
extension HouseMembersExtensions on HouseMembers {
  // Check if object is currently empty
  bool get isEmpty => this == HouseMembers.empty;
}
