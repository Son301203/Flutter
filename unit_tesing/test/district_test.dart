import 'package:flutter_application_1/district.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  District? district;

  group('Test Ward', () {
    test('constructor', () {
      district = District(
        id: "00617",
        name: "Phuong Co Nhue 2",
        level: "Phuong",
        provinceID: "01",
      );

      expect(district?.id, equals('00617'));
      expect(district?.name, equals('Phuong Co Nhue 2'));
      expect(district?.level, equals('Phuong'));
      expect(district?.provinceID, equals('01'));
    });

    test('toMap', () {
      final district = District(
        id: "00617",
        name: "Phuong Co Nhue 2",
        level: "Phuong",
        provinceID: "01",
      );
      final districtToMap = district.toMap();
      expect(districtToMap['id'], equals('00617'));
      expect(districtToMap['name'], equals('Phuong Co Nhue 2'));
      expect(districtToMap['level'], equals('Phuong'));
      expect(districtToMap['provinceID'], equals('01'));
    });
    test('fromMap', () {
      // ignore: non_constant_identifier_names
      final WardFromMap = {
        'id': "00617",
        'name': "Phuong Co Nhue 2",
        'level': "Phuong",
        'provinceID': "01",
      };
      final districtFromMap = District.fromMap(WardFromMap);
      expect(districtFromMap.id, equals('00617'));
      expect(districtFromMap.name, equals('Phuong Co Nhue 2'));
      expect(districtFromMap.level, equals('Phuong'));
      expect(districtFromMap.provinceID, equals('01'));
    });
  });
}