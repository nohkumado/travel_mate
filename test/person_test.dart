import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/person.dart';

void main() {
  group('Person', () {
    test('constructor should initialize attributes from incoming data (single entry)', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'name', 'value': 'Alice'}
        ]
      });
      expect(person.attributes['name']?.value, 'Alice');
    });

    test('constructor should initialize attributes from incoming data (multiple entries)', () {
      Person person = Person(incoming: {
        'entry': [
          {'type': 'name', 'value': 'Bob'},
          {'type': 'email', 'value': 'bob@example.com'}
        ]
      });
      expect(person.attributes['name']?.value, 'Bob');
      expect(person.attributes['email']?.value, 'bob@example.com');
      person = Person(incoming: {
        'entry': [
          {'type': 'name', 'value': 'Bob Morane', 'acl': 'public'},
          {'type': 'mail', 'value': 'bob@example.com', 'acl': 'public'},
          {'type': 'nick', 'value':'bob','acl':'public'},
          {'type': 'adress','value':'10,rue somewhere,NZ-67270,Someplace,France','acl':'protected'},
          {'type': 'phone','value':'+33,388,01,23,45','acl':'private'},
          {'type': 'mobile','value':'+33,678,950,123','acl':'private'},
          {'type': 'passport','value':'http://host.dom.org/scans/passBob.jpg','acl':'private'},
          {'type': 'driverlicence','value':'http://host.dom.org/scans/permisBob.jpg','acl':'private'}
        ]
      });
      expect(person.attributes['driverlicence']?.value, 'http://host.dom.org/scans/permisBob.jpg');
      expect(person.attributes['driverlicence']?.acl, 'private');


    });

    test('constructor should handle @attributes nesting', () {
      final person = Person(incoming: {
        'entry': [
          {'@attributes': {'type': 'age', 'value': '30'}}
        ]
      });
      expect(person.attributes['age']?.value, '30');
    });

    test('name() should return the name if present', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'name', 'value': 'Charlie'}
        ]
      });
      expect(person.name(), 'Charlie');
    });

    test('name() should return "nobody" if name attribute is missing', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'email', 'value': 'no-name@example.com'}
        ]
      });
      expect(person.name(), 'nobody');
    });

    test('get() should return the Entry object if present', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'city', 'value': 'Schwindratzheim'}
        ]
      });
      final entry = person.get('city');
      expect(entry, isNotNull);
      expect(entry?.value, 'Schwindratzheim');
    });

    test('get() should return null if Entry is missing', () {
      final person = Person();
      expect(person.get('country'), isNull);
    });

    test('getValue() should return the value if Entry is present', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'occupation', 'value': 'Developer'}
        ]
      });
      expect(person.getValue('occupation'), 'Developer');
    });

    test('getValue() should return empty string if Entry is missing', () {
      final person = Person();
      expect(person.getValue('hobby'), '');
    });

    test('toJson() should return a map representing the attributes', () {
      final person = Person(incoming: {
        'entry': [
          {'type': 'phone', 'value': '0123456789'}
        ]
      });
      final jsonMap = person.toJson();
      expect(jsonMap['attributes'], isNotNull);
      expect(jsonMap['attributes']['phone'], {'type': 'phone', 'value': '0123456789', 'acl': 'public'}); // Default ACL
    });

    test('fromJson() should create a Person object from a map', () {
      final jsonMap = {
        'attributes': {
          'name': {'type': 'name', 'value': 'David', 'acl': 'public'},
          'age': {'type': 'age', 'value': '25', 'acl': 'public'},
        }
      };
      final person = Person.fromJson(jsonMap);
      expect(person.name(), 'David');
      expect(person.getValue('age'), '25');
    });

    test('two Person objects with the same attributes should be equal', () {
      final person1 = Person(incoming: {
        'entry': [
          {'type': 'email', 'value': 'test@example.com'}
        ]
      });
      final person2 = Person(incoming: {
        'entry': [
          {'type': 'email', 'value': 'test@example.com'}
        ]
      });
      expect(person1, person2);
    });

    test('two Person objects with different attributes should not be equal', () {
      final person1 = Person(incoming: {
        'entry': [
          {'type': 'city', 'value': 'Paris'}
        ]
      });
      final person2 = Person(incoming: {
        'entry': [
          {'type': 'city', 'value': 'London'}
        ]
      });
      expect(person1, isNot(person2));
    });
  });
}
