import 'package:app_core/app_core.dart';

/// Object mapping for [Credentials]
/// Defines helper functions to help with bidirectional mapping
class Credentials extends Equatable {
  /// Constructor for [Credentials]
  /// Requires default values for non-nullable data
  const Credentials({
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  // Helper function that converts a single SQL object to our dart object
  factory Credentials.converterSingle(Map<String, dynamic> data) {
    return Credentials.fromJson(data);
  }

  // Helper function that converts a JSON object to our dart object
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
      idToken: json[idTokenConverter]?.toString() ?? '',
      accessToken: json[accessTokenConverter]?.toString() ?? '',
      refreshToken: json[refreshTokenConverter]?.toString() ?? '',
      expiresIn: json[expiresInConverter]?.toString() ?? '',
      tokenType: json[tokenTypeConverter]?.toString() ?? '',
    );
  }

  // JSON string equivalent for our data
  static String get idTokenConverter => 'id_token';
  static String get accessTokenConverter => 'access_token';
  static String get refreshTokenConverter => 'refresh_token';
  static String get expiresInConverter => 'expires_in';
  static String get tokenTypeConverter => 'token_type';

  // Defines the empty state for the Credentials
  static const empty = Credentials(
    idToken: '',
    accessToken: '',
    refreshToken: '',
    expiresIn: '',
    tokenType: '',
  );

  // Data for Credentials
  final String idToken;
  final String accessToken;
  final String refreshToken;
  final String expiresIn;
  final String tokenType;

  // Defines object properties
  @override
  List<Object?> get props => [
        idToken,
        accessToken,
        refreshToken,
        expiresIn,
        tokenType,
      ];

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<Credentials> converter(List<Map<String, dynamic>> data) {
    return data.map(Credentials.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      idToken: idToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      tokenType: tokenType,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? idToken,
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? tokenType,
  }) {
    return {
      if (idToken != null) idTokenConverter: idToken,
      if (accessToken != null) accessTokenConverter: accessToken,
      if (refreshToken != null) refreshTokenConverter: refreshToken,
      if (expiresIn != null) expiresInConverter: expiresIn,
      if (tokenType != null) tokenTypeConverter: tokenType,
    };
  }
}

// Extensions to the object allowing a public getters
extension CredentialsExtensions on Credentials {
  // Check if object is currently empty
  bool get isEmpty => this == Credentials.empty;
}
