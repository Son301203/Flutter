import 'package:flutter_test/flutter_test.dart';
import 'package:province/userInfo.dart';
import 'package:province/addressInfo.dart';
import 'package:province/province.dart';
import 'package:province/district.dart';
import 'package:province/ward.dart';

void main() {
  group('Test UserInfo', () {
    test('constructor', () {
      final userInfo = UserInfo(
        name: 'Phương',
        email: '2121050295@student.humg.edu.vn',
        phoneNumber: '0945195287',
        birthDate: DateTime(2003, 01, 05),
      );

      final address = AddressInfo(
        province:
            Province(id: '01', name: 'Hà Nội', level: 'Thành phố Trung ương'),
        district: District(
            id: '021', name: 'Bắc Từ Liêm', level: 'Quận', provinceId: '01'),
        ward: Ward(
            id: '00601',
            name: 'Phường Đông Ngạc',
            level: 'Phường',
            districtId: '012',
            provinceId: '01'),
        street: 'Đông Ngạc',
      );

      expect(userInfo.name, equals('Phương'));
      expect(userInfo.email, equals('2121050295@student.humg.edu.vn'));
      expect(userInfo.phoneNumber, equals('0945195287'));
      expect(userInfo.birthDate, equals(DateTime(2003, 01, 05)));
      expect(address.province?.id, equals('01'));
      expect(address.province?.name, equals('Hà Nội'));
      expect(address.district?.id, equals('021'));
      expect(address.district?.name, equals('Bắc Từ Liêm'));
      expect(address.ward?.id, equals('00601'));
      expect(address.ward?.name, equals('Phường Đông Ngạc'));
      expect(address.street, equals('Đông Ngạc'));
    });

    test('fromMap', ()
    {
      final userInfoMap = {
        'name': 'Phương',
        'email': '2121050295@student.humg.edu.vn',
        'phoneNumber': '0945195287',
        'birthDate': DateTime(2003, 01, 05),
        'address': {
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
            'districtId': '012',
            'provinceId': '01'
          },
          'street': 'Đông Ngạc',
        }
      };
      final userInfo = UserInfo.fromMap(userInfoMap);

      expect(userInfo.name, 'Phương');
      expect(userInfo.email, '2121050295@student.humg.edu.vn');
      expect(userInfo.phoneNumber, '0945195287');
      expect(userInfo.birthDate, DateTime(2003, 01, 05));
      expect(userInfo.address, isA<AddressInfo>());
      expect(userInfo.address!.province!.name, 'Hà Nội');
      expect(userInfo.address!.district!.name, 'Bắc Từ Liêm');
      expect(userInfo.address!.ward!.name, 'Phường Đông Ngạc');
      expect(userInfo.address!.street, 'Đông Ngạc');
    });
  });
}
