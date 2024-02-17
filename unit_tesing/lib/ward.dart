// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ward {
  String? id;
  String? name;
  String? level;
  String? districtID;
  String? provinceID;

  Ward({
    this.id,
    this.name,
    this.level,
    this.districtID,
    this.provinceID,
  });

  Ward copyWith({
    String? id,
    String? name,
    String? level,
    String? districtID,
    String? provinceID,

  }) {
    return Ward(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      districtID: districtID ?? this.districtID,
      provinceID: provinceID ?? this.provinceID,

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'districtID': districtID,
      'provinceID': provinceID,

    };
  }

  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      districtID: map['districtID'] != null ? map['districtID'] as String : null,
      provinceID: map['provinceID'] != null ? map['provinceID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ward.fromJson(String source) => Ward.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ward(id: $id, name: $name, level: $level, districtID: $districtID, provinceID: $provinceID)';

  @override
  bool operator ==(covariant Ward other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.level == level &&
      other.districtID == provinceID &&
      other.provinceID == provinceID;
  }

  @override
  int get hashCode => id.hashCode 
    ^ name.hashCode
    ^ level.hashCode
    ^ districtID.hashCode
    ^ provinceID.hashCode;

}

void main() {

}
