class Section {
  String id;
  String section_name;
  String hotel;

  Section(this.id, this.section_name, this.hotel);

  factory Section.fromJson(Map<dynamic,dynamic> json, String key){
    return Section(key, json["section_name"] as String, json["hotel"] as String);
  }
}