import 'package:flutter_test/flutter_test.dart';
import 'package:province/province.dart';
import 'package:province/district.dart';
import 'package:province/ward.dart';
import 'package:province/addressInfo.dart';

void main() {
  group('Test AddressInfo', () {
    test('constructor', () {
      final province =
          Province(id: '01', name: 'Hà Nội', level: 'Thành phố Trung ương');
      final district = District(
          id: '021', name: 'Bắc Từ Liêm', level: 'Quận', provinceId: '01');
      final ward = Ward(
          id: '00601',
          name: 'Phường Đông Ngạc',
          level: 'Phường',
          districtId: '012',
          provinceId: '01');
      final addressInfoMap = {
        'province': province.toMap(),
        'district': district.toMap(),
        'ward': ward.toMap(),
        'street': 'Đông Ngạc',
      };

      expect(province.id, equals('01'));
      expect(province.name, equals('Hà Nội'));
      expect(district.name, equals('Bắc Từ Liêm'));
      expect(district.provinceId, equals('01'));
      expect(ward.level, equals('Phường'));
      expect(ward.districtId, equals('012'));

      final addressInfo = AddressInfo.fromMap(addressInfoMap);

      expect(addressInfo.province!.id, province.id);
      expect(addressInfo.province!.name, province.name);
      expect(addressInfo.province!.level, province.level);

      expect(addressInfo.district!.id, district.id);
      expect(addressInfo.district!.name, district.name);
      expect(addressInfo.district!.level, district.level);
      expect(addressInfo.district!.provinceId, district.provinceId);

      expect(addressInfo.ward!.id, ward.id);
      expect(addressInfo.ward!.name, ward.name);
      expect(addressInfo.ward!.level, ward.level);
      expect(addressInfo.ward!.districtId, ward.districtId);
      expect(addressInfo.ward!.provinceId, ward.provinceId);
    });

    test('fromMap', () {
      final addressInfoMap = {
        'province': {
          'id': '01',
          'name': 'Hà Nội',
          'level': 'Thành phố Trung ương'
        },
        'district': {
          'id': '021',
          'name': 'Bắc Từ Liêm',
          'level': 'Quận',
          'provinceId': '01'
        },
        'ward': {
          'id': '00601',
          'name': 'Phường Đông Ngạc',
          'level': 'Phường',
          'districtId': '021',
          'provinceId': '01'
        },
        'street': 'Đông Ngạc'
      };
      final addressInfo = AddressInfo.fromMap(addressInfoMap);
      expect(addressInfo.province!.id, equals('01'));
      expect(addressInfo.province!.name, equals('Hà Nội'));
      expect(addressInfo.district!.id, equals('021'));
      expect(addressInfo.district!.name, equals('Bắc Từ Liêm'));
      expect(addressInfo.ward!.id, equals('00601'));
      expect(addressInfo.ward!.name, equals('Phường Đông Ngạc'));
      expect(addressInfo.street, equals('Đông Ngạc'));
    });
  });
}
