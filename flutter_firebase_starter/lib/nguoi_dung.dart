import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NguoiDung {
  String name;
  int age;
  String email;
  NguoiDung({
    required this.name,
    required this.age,
    required this.email,
  });

  @override
  String toString() => 'NguoiDung(name: $name, age: $age, email: $email)';

  NguoiDung copyWith({
    String? name,
    int? age,
    String? email,
  }) {
    return NguoiDung(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'email': email,
    };
  }

  factory NguoiDung.fromMap(Map<String, dynamic> map) {
    return NguoiDung(
      name: map['name'],
      age: map['age'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NguoiDung.fromJson(String source) =>
      NguoiDung.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant NguoiDung other) {
    if (identical(this, other)) return true;

    return other.name == name && other.age == age && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ email.hashCode;
}