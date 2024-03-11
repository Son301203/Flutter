class District {
  String? id;
  String? name;
  String? level;
  String? provinceId;

  District({this.id, this.name, this.level, this.provinceId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'level': this.level,
      'provinceId': this.provinceId,
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      provinceId: map['provinceId'] != null
          ? map['provinceId'] as String
          : null,
    );
  }
}