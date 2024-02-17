import 'package:flutter_application_1/ward.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Ward? ward;

  group('Test Ward', () {
    test('constructor', () {
      ward = Ward(
        id: "00617",
        name: "Phuong Co Nhue 2",
        level: "Phuong",
        districtID: "21",
        provinceID: "01",
      );

      expect(ward?.id, equals('00617'));
      expect(ward?.name, equals('Phuong Co Nhue 2'));
      expect(ward?.level, equals('Phuong'));
      expect(ward?.districtID, equals('21'));
      expect(ward?.provinceID, equals('01'));
    });

    test('toMap', () {
      final ward = Ward(
        id: "00617",
        name: "Phuong Co Nhue 2",
        level: "Phuong",
        districtID: "21",
        provinceID: "01",
      );
      final wardToMap = ward.toMap();
      expect(wardToMap['id'], equals('00617'));
      expect(wardToMap['name'], equals('Phuong Co Nhue 2'));
      expect(wardToMap['level'], equals('Phuong'));
      expect(wardToMap['districtID'], equals('21'));
      expect(wardToMap['provinceID'], equals('01'));
    });
    test('fromMap', () {
      // ignore: non_constant_identifier_names
      final WardFromMap = {
        'id': "00617",
        'name': "Phuong Co Nhue 2",
        'level': "Phuong",
        'districtID': "21",
        'provinceID': "01",
      };
      final ward = Ward.fromMap(WardFromMap);
      expect(ward.id, equals('00617'));
      expect(ward.name, equals('Phuong Co Nhue 2'));
      expect(ward.level, equals('Phuong'));
      expect(ward.districtID, equals('21'));
      expect(ward.provinceID, equals('01'));
    });
  });
}