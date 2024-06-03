import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Furniture {
  String name;
  int price;
  String description;
  String image;
  Furniture({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  String toString() => 'Furniture(name: $name, price: $price, description: $description, image: $image)';

  Furniture copyWith({
    String? name,
    int? price,
    String? description,
    String? image,
  }) {
    return Furniture(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  factory Furniture.fromMap(Map<String, dynamic> map) {
    return Furniture(
      name: map['name'],
      price: map['price'],
      description: map['description'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Furniture.fromJson(String source) =>
      Furniture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Furniture other) {
    if (identical(this, other)) return true;

    return other.name == name && other.price == price && other.description == description && other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ description.hashCode ^ image.hashCode;
}