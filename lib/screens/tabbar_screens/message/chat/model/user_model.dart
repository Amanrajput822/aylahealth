class UserData {
  String name, profile, email;

  UserData({required this.name, required this.email, required this.profile});

  factory UserData.fromJson(var json) {
    return UserData(
        name: json["name"], email: json["email"], profile: json["profile"]);
  }
}
