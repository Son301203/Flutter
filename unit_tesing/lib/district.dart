// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class District {
  String? id;
  String? name;
  String? level;
  String? provinceID;
  District({
    this.id,
    this.name,
    this.level,
    this.provinceID
  });

  District copyWith({
    String? id,
    String? name,
    String? level,
    String? provinceID,
  }) {
    return District(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      provinceID: provinceID ?? this.provinceID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'provinceID': provinceID,
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      provinceID: map['provinceID'] != null ? map['provinceID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) => District.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'District(id: $id, name: $name, level: $level, provinceID: $provinceID)';
  }

  @override
  bool operator ==(covariant District other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.level == level &&
      other.provinceID == provinceID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      level.hashCode ^
      provinceID.hashCode;
  }

}
