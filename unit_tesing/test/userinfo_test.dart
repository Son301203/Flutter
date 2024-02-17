import 'package:flutter_application_1/userinfo.dart';
import 'package:flutter_application_1/addressinfo.dart';
import 'package:flutter_application_1/province.dart';
import 'package:flutter_application_1/district.dart';
import 'package:flutter_application_1/ward.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  UserInfo? user;
  group('UserInfo Tests', () {
    test('fromMap', () {
      final userInfoMap = {
        'name': 'Son',
        'email': 'sondz909@gmail.com',
        'phoneNumber': '0328510096',
        'birthDate': '30/12/2003',
        'address': {
          'province': {'id': '29', 'name': 'Ha Noi', 'level': 'Thanh Pho'},
          'district': {
            'id': '21',
            'name': 'Bac Tu Liem',
            'level': 'Quan',
            'provinceId': '29'
          },
          'ward': {
            'id': '10',
            'name': 'Duc Thang',
            'level': 'Phuong',
            'districtId': '21',
            'provinceId': '29'
          },
          'street': 'Pho Vien'
        }
      };

      final userInfo = UserInfo.fromMap(userInfoMap);

      expect(userInfo.name, 'Son');
      expect(userInfo.email, 'sondz909@gmail.com');
      expect(userInfo.phoneNumber, '0328510096');
      expect(userInfo.birthDate, '30/12/2003');
      expect(userInfo.address, isA<AddressInfo>());
      expect(userInfo.address!.province!.name, 'Ha Noi');
      expect(userInfo.address!.district!.name, 'Bac Tu Liem');
      expect(userInfo.address!.ward!.name, 'Duc Thang');
      expect(userInfo.address!.street, 'Pho Vien');
    });

    test('constructor', () {
      user = UserInfo(
        name: "Son",
        email: "trinhson301203@gmail.com",
        phoneNumber: "0328510096",
        birthDate: "30/12/2003",
      );

      final address = AddressInfo(
          province: Province(id: '29', name: 'Ha Noi', level: 'Thanh Pho'),
          district: District(id: '01', name: 'Bac Tu Liem', level: 'Quan', provinceID: '29'),
          ward: Ward(id: '01', name: 'Phuong Co Nhue 2', level: 'Phuong', districtID: '01', provinceID: '29'),
          street: "Duc Thang"
      );

      expect(user?.name, equals('Son'));
      expect(user?.email, equals('trinhson301203@gmail.com'));
      expect(user?.phoneNumber, equals('0328510096'));
      expect(user?.birthDate, equals('30/12/2003'));


      expect(address.province?.id, equals('29'));
      expect(address.province?.name, equals('Ha Noi'));
      expect(address.province?.level, equals('Thanh Pho'));
      expect(address.street, equals('Duc Thang'));


    });
  });
}
