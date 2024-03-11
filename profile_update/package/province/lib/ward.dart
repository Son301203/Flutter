class Ward {
  String? id;
  String? name;
  String? level;
  String? districtId;
  String? provinceId;

  Ward({this.id, this.name, this.level, this.districtId, this.provinceId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'level': this.level,
      'districtId': this.districtId,
      'provinceId': this.provinceId,
    };
  }

  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      districtId: map['districtId'] != null ? map['districtId'] as String : null,
      provinceId: map['provinceId'] != null
          ? map['provinceId'] as String
          : null,
    );
  }

}