class User {
  String id;
  String role_id;
  String section_id;
  String username;
  String password;
  String name;
  String hotel;

  User(this.id, this.role_id, this.section_id, this.username, this.password, this.name,
      this.hotel);

  factory User.fromJson(Map<dynamic,dynamic> json, String key){
    return User(key, json["role_id"] as String, json["section_id"] as String, json["username"] as String, json["password"] as String, json["name"] as String, json["hotel"] as String);
  }
}