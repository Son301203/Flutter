import 'package:flutter_application_1/addressinfo.dart';
import 'package:flutter_application_1/province.dart';
import 'package:flutter_application_1/district.dart';
import 'package:flutter_application_1/ward.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Address Information', () {
    test('fromMap', () {
      final addressMap = {
        'province': {'id': '29', 'name': 'Ha Noi', 'level': 'Thanh Pho'},
        'district': {
          'id': '1',
          'name': 'Bac Tu Liem',
          'level': 'Quan',
          'provinceId': '29'
        },
        'ward': {
          'id': '1',
          'name': 'Co Nhue',
          'level': 'Phuong',
          'districtId': '1',
          'provinceId': '29'
        },
        'street': 'Duc Thang'
      };
      final address = AddressInfo.fromMap(addressMap);
      expect(address.province!.id, equals('29'));
      expect(address.district!.id, equals('1'));
      expect(address.ward!.id, equals('1'));
      expect(address.street, equals('Duc Thang'));
    });

    test('constructor', () {
      final province = Province(id: '29', name: 'Ha Noi', level: 'Thanh Pho');
      final district = District(
          id: '1', name: 'Bac Tu Liem', level: 'Quan', provinceID: '29');
      final ward = Ward(
          id: 'Co Nhue',
          name: 'Co Nhue',
          level: 'Phuong',
          districtID: '1',
          provinceID: '29');

      final addressInfoMap = {
        'province': province.toMap(),
        'district': district.toMap(),
        'ward': ward.toMap(),
        'street': 'Duc Thang',
      };

      expect(province.id, equals('29'));
      expect(district.name, equals('Bac Tu Liem'));
      expect(ward.level, equals('Phuong'));
      expect(district.provinceID, equals('29'));

      final addressInfo = AddressInfo.fromMap(addressInfoMap);

      expect(addressInfo.province!.id, province.id);
      expect(addressInfo.province!.name, province.name);
      expect(addressInfo.province!.level, province.level);

      expect(addressInfo.district!.id, district.id);
      expect(addressInfo.district!.name, district.name);
      expect(addressInfo.district!.level, district.level);
      expect(addressInfo.district!.provinceID, district.provinceID);

      expect(addressInfo.ward!.id, ward.id);
      expect(addressInfo.ward!.name, ward.name);
      expect(addressInfo.ward!.level, ward.level);
      expect(addressInfo.ward!.districtID, ward.districtID);
      expect(addressInfo.ward!.provinceID, ward.provinceID);
    });
  });
}
