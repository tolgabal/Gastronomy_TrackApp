class Role {
  String id;
  String role_name;
  int hotpre;
  int coldpre;
  int disinf;
  int soak;
  int candr;
  int receiving;
  int disinf_list;
  int candr_list;
  int hotpre_list;
  int coldpre_list;
  int receiving_firms;
  int personnel;
  int buffedtimes;
  int roleconfig;
  int reports;
  int devices;
  int updateuser;
  String hotel;

  Role(
      this.id,
      this.role_name,
      this.hotpre,
      this.coldpre,
      this.disinf,
      this.soak,
      this.candr,
      this.receiving,
      this.disinf_list,
      this.candr_list,
      this.hotpre_list,
      this.coldpre_list,
      this.receiving_firms,
      this.personnel,
      this.buffedtimes,
      this.roleconfig,
      this.reports,
      this.devices,
      this.updateuser,
      this.hotel);

  factory Role.fromJson(Map<dynamic,dynamic> json, String key){
    return Role(key, json["role_name"] as String, json["hotpre"] as int, json["coldpre"] as int, json["disinf"] as int, json["soak"] as int, json["candr"] as int, json["receiving"] as int, json["disinf_list"] as int, json["candr_list"] as int, json["hotpre_list"] as int, json["coldpre_list"] as int, json["receiving_firms"] as int, json["personnel"] as int, json["buffedtimes"] as int, json["roleconfig"] as int, json["reports"] as int, json["devices"] as int, json["updateuser"] as int, json["hotel"] as String);
  }
}