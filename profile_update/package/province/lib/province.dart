class Province {
  String? id;
  String? name;
  String? level;
  Province({this.id, this.name, this.level});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'level': this.level,
    };
  }

  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
    );
  }
}
