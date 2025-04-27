import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/entry.dart';

void main() {
  group('Entry', () {
    test('constructor should initialize with default values if none provided', () {
      final entry = Entry();
      expect(entry.type, 'none');
      expect(entry.value, '');
      expect(entry.acl, 'public');
    });

    test('constructor should initialize with provided values', () {
      final entry = Entry(type: 'name', value: 'John Doe', acl: 'private');
      expect(entry.type, 'name');
      expect(entry.value, 'John Doe');
      expect(entry.acl, 'private');
    });

    test('toString method should return correct format', () {
      final entry = Entry(type: 'email', value: 'john.doe@example.com', acl: 'protected');
      expect(entry.toString(), 'E[email]: john.doe@example.com, protected');
    });

    test('getType should return the type', () {
      final entry = Entry(type: 'phone', value: '123-456-7890');
      expect(entry.getType(), 'phone');
    });

    test('getValue should return the value', () {
      final entry = Entry(value: 'Some important data');
      expect(entry.getValue(), 'Some important data');
    });

    test('getAcl should return the acl', () {
      final entry = Entry(acl: 'internal');
      expect(entry.getAcl(), 'internal');
    });

    test('toJson should return a map with correct keys and values', () {
      final entry = Entry(type: 'address', value: '123 Main St', acl: 'public');
      final jsonMap = entry.toJson();
      expect(jsonMap['type'], 'address');
      expect(jsonMap['value'], '123 Main St');
      expect(jsonMap['acl'], 'public');
    });

    test('fromJson should create an Entry object from a map', () {
      final jsonMap = {'type': 'city', 'value': 'Schwindratzheim', 'acl': 'public'};
      final entry = Entry.fromJson(jsonMap);
      expect(entry.type, 'city');
      expect(entry.value, 'Schwindratzheim');
      expect(entry.acl, 'public');
    });

    test('fromJson should use default values if keys are missing in the map', () {
      final jsonMap = {'value': 'Only value provided'};
      final entry = Entry.fromJson(jsonMap);
      expect(entry.type, 'none');
      expect(entry.value, 'Only value provided');
      expect(entry.acl, 'public');
    });

    test('two Entry objects with the same properties should be equal', () {
      final entry1 = Entry(type: 'note', value: 'Remember this', acl: 'private');
      final entry2 = Entry(type: 'note', value: 'Remember this', acl: 'private');
      expect(entry1, entry2);
    });

    test('two Entry objects with different properties should not be equal', () {
      final entry1 = Entry(type: 'age', value: '30');
      final entry2 = Entry(type: 'age', value: '31');
      expect(entry1, isNot(entry2));
    });
  });
}