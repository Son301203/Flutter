import 'package:province/province.dart';
import 'package:province/district.dart';
import 'package:province/ward.dart';

class AddressInfo {
  Province? province;
  District? district;
  Ward? ward;
  String? street;

  AddressInfo({this.province, this.district, this.ward, this.street});

  Map<String, dynamic> toMap() {
    return {
      'province': this.province,
      'district': this.district,
      'ward': this.ward,
      'street': this.street,
    };
  }

  factory AddressInfo.fromMap(Map<String, dynamic> map) {
    return AddressInfo(
      province: map['province'] != null
          ? Province.fromMap(map['province'] as Map<String, dynamic>)
          : null,
      district: map['district'] != null
          ? District.fromMap(map['district'] as Map<String, dynamic>)
          : null,
      ward: map['ward'] != null
          ? Ward.fromMap(map['ward'] as Map<String, dynamic>)
          : null,
      street: map['street'] != null ? map['street'] as String : null,
    );
  }
}
