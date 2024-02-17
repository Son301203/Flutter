// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_application_1/district.dart';
import 'package:flutter_application_1/province.dart';
import 'package:flutter_application_1/ward.dart';

class AddressInfo {
  final Province? province;
  final District? district;
  final Ward? ward;
  final String? street;
  AddressInfo({
    this.province,
    this.district,
    this.ward,
    this.street,
  });

  AddressInfo copyWith({
    Province? province,
    District? district,
    Ward? ward,
    String? street,
  }) {
    return AddressInfo(
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      street: street ?? this.street,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'province': province?.toMap(),
      'district': district?.toMap(),
      'ward': ward?.toMap(),
      'street': street,
    };
  }

  factory AddressInfo.fromMap(Map<String, dynamic> map) {
    return AddressInfo(
      province: map['province'] != null ? Province.fromMap(map['province'] as Map<String,dynamic>) : null,
      district: map['district'] != null ? District.fromMap(map['district'] as Map<String,dynamic>) : null,
      ward: map['ward'] != null ? Ward.fromMap(map['ward'] as Map<String,dynamic>) : null,
      street: map['street'] != null ? map['street'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressInfo.fromJson(String source) => AddressInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressInfo(province: $province, district: $district, ward: $ward, street: $street)';
  }

  @override
  bool operator ==(covariant AddressInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.province == province &&
      other.district == district &&
      other.ward == ward &&
      other.street == street;
  }

  @override
  int get hashCode {
    return province.hashCode ^
      district.hashCode ^
      ward.hashCode ^
      street.hashCode;
  }
}
