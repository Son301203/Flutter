import 'package:province/district.dart';
import 'package:flutter_test/flutter_test.dart';

void  main(){
  District? district;

  group('Test District', () {
    test('constructor', () {
      district = District(
        id: "021",
        name: "Bắc Từ Liêm",
        level: "Quận",
        provinceId: "01",
      );
      expect(district?.id, equals('021'));
      expect(district?.name, equals('Bắc Từ Liêm'));
      expect(district?.level, equals('Quận'));
      expect(district?.provinceId, equals('01'));
    });

    test('fromMap', () {
      final district = {
        'id': '021',
        'name': 'Bắc Từ Liêm',
        'level': 'Quận',
        'provinceId': '01',
      };

      final district_fromMap = District.fromMap(district);
      expect(district_fromMap.id, equals('021'));
      expect(district_fromMap.name, equals('Bắc Từ Liêm'));
      expect(district_fromMap.level, equals('Quận'));
      expect(district_fromMap.provinceId, equals('01'));
    });

    test('toMap', () {
      final province = District(
        id: "021",
        name: "Bắc Từ Liêm",
        level: "Quận",
        provinceId: "01",
      );
      final district_toMap = province.toMap();
      expect(district_toMap['id'], equals('021'));
      expect(district_toMap['name'], equals('Bắc Từ Liêm'));
      expect(district_toMap['level'], equals('Quận'));
      expect(district_toMap['provinceId'], equals('01'));
    });
  });
}