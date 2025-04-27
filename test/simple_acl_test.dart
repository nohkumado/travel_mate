import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/simple_acl.dart';

void main() {
  group('SimpleAcl', () {
    test('constructor should initialize name and access', () {
      final acl = SimpleAcl(name: 'admin', access: 'full');
      expect(acl.name, 'admin');
      expect(acl.access, 'full');
    });

    test('toString method should return correct format', () {
      final acl = SimpleAcl(name: 'user', access: 'read');
      expect(acl.toString(), 'user:read');
    });

    test('getName should return the name', () {
      final acl = SimpleAcl(name: 'guest', access: 'none');
      expect(acl.getName(), 'guest');
    });

    test('getAccess should return the access', () {
      final acl = SimpleAcl(name: 'editor', access: 'write');
      expect(acl.getAccess(), 'write');
    });

    test('toJson should return a map with correct keys and values', () {
      final acl = SimpleAcl(name: 'tester', access: 'debug');
      final jsonMap = acl.toJson();
      expect(jsonMap['name'], 'tester');
      expect(jsonMap['access'], 'debug');
    });

    test('fromJson should create a SimpleAcl object from a map', () {
      final jsonMap = {'name': 'viewer', 'access': 'view'};
      final acl = SimpleAcl.fromJson(jsonMap);
      expect(acl.name, 'viewer');
      expect(acl.access, 'view');
    });

    test('two SimpleAcl objects with the same properties should be equal', () {
      final acl1 = SimpleAcl(name: 'same', access: 'level');
      final acl2 = SimpleAcl(name: 'same', access: 'level');
      expect(acl1, acl2);
    });

    test('two SimpleAcl objects with different properties should not be equal', () {
      final acl1 = SimpleAcl(name: 'diff1', access: 'level1');
      final acl2 = SimpleAcl(name: 'diff2', access: 'level1');
      expect(acl1, isNot(acl2));
    });
  });
}