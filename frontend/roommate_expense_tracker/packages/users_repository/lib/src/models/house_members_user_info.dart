class HouseMembersUserInfo {
  final String userId;
  final String? photoUrl;
  final String? paymentMethod;
  final String? paymentLink;

  HouseMembersUserInfo({
    required this.userId,
    this.photoUrl,
    this.paymentMethod,
    this.paymentLink,
  });

  factory HouseMembersUserInfo.fromJson(Map<String, dynamic> json) {
    return HouseMembersUserInfo(
      userId: json['user_id'],
      photoUrl: json['photo_url'],
      paymentMethod: json['payment_method'],
      paymentLink: json['payment_link'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'photo_url': photoUrl,
        'payment_method': paymentMethod,
        'payment_link': paymentLink,
      };
}
