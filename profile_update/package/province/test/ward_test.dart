import 'package:province/ward.dart';
import 'package:flutter_test/flutter_test.dart';

void  main(){
  Ward? ward;

  group('Test Ward', () {
    test('constructor', () {
      ward = Ward(
        id: "00601",
        name: "Phường Đông Ngạc",
        level: "Phường",
        districtId: "021",
        provinceId: "01",
      );
      expect(ward?.id, equals('00601'));
      expect(ward?.name, equals('Phường Đông Ngạc'));
      expect(ward?.level, equals('Phường'));
      expect(ward?.districtId, equals('021'));
      expect(ward?.provinceId, equals('01'));
    });

    test('fromMap', () {
      final ward = {
        'id': '00601',
        'name': 'Phường Đông Ngạc',
        'level': 'Phường',
        'districtId': '021',
        'provinceId': '01',
      };

      final ward_fromMap = Ward.fromMap(ward);
      expect(ward_fromMap.id, equals('00601'));
      expect(ward_fromMap.name, equals('Phường Đông Ngạc'));
      expect(ward_fromMap.level, equals('Phường'));
      expect(ward_fromMap.districtId, equals('021'));
      expect(ward_fromMap.provinceId, equals('01'));
    });

    test('toMap', () {
      final ward = Ward(
        id: "00601",
        name: "Phường Đông Ngạc",
        level: "Phường",
        districtId: "021",
        provinceId: "01",
      );
      final ward_toMap = ward.toMap();
      expect(ward_toMap['id'], equals('00601'));
      expect(ward_toMap['name'], equals('Phường Đông Ngạc'));
      expect(ward_toMap['level'], equals('Phường'));
      expect(ward_toMap['districtId'], equals('021'));
      expect(ward_toMap['provinceId'], equals('01'));
    });
  });
}