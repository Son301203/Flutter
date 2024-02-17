import 'package:flutter_application_1/province.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  Province? province;

  group('Test Province', () {
    test('constructor', () {
      province = Province(
        id: '29',
        name: 'Ha Noi',
        level: 'Thanh Pho',
      );
      expect(province?.id, equals('29'));
      expect(province?.name, equals('Ha Noi'));
      expect(province?.level, equals('Thanh Pho'));
    });

    test('fromMap', () {
      final province = {
        'id': '29',
        'name': 'Ha Noi',
        'level': 'Thanh Pho',
      };

      final provinceFromMap = Province.fromMap(province);
      expect(provinceFromMap.id, equals('29'));
      expect(provinceFromMap.name, equals('Ha Noi'));
      expect(provinceFromMap.level, equals('Thanh Pho'));
    });

    test('toMap', () {
      // ignore: unused_local_variable
      final province = Province(
        id: "29",
        name: "Ha Noi",
        level: "Thanh Pho",
      );
      final provinceFromMap = province.toMap();
      expect(provinceFromMap['id'], equals('29'));
      expect(provinceFromMap['name'], equals('Ha Noi'));
      expect(provinceFromMap['level'], equals('Thanh Pho'));
    });
  });
}