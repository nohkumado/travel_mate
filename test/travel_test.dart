import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/etappe.dart';
import 'package:travel_mate/person.dart';
import 'package:travel_mate/simple_acl.dart';
import 'package:travel_mate/travel.dart';

void main() {
  group('Travel', () {
    test('constructor should initialize with default values', () {
      final travel = Travel();
      expect(travel.acls, isEmpty);
      expect(travel.participants, isEmpty);
      expect(travel.attributes, isEmpty);
      expect(travel.etapes, isEmpty);
      expect(travel.titre, 'untitled Travel');
    });

    test('addAcl should add a SimpleAcl to the acls map', () {
      final travel = Travel();
      final acl = SimpleAcl(name: 'admin', access: 'full');
      final updatedTravel = travel.addAcl(acl);
      expect(updatedTravel.acls['admin'], acl);
    });

    test('addPerson should add a Person to the participants map', () {
      final travel = Travel();
      final person = Person(incoming: {'entry': [{'type': 'name', 'value': 'Alice'}]});
      final updatedTravel = travel.addPerson(person);
      expect(updatedTravel.participants['Alice'], person);
    });

    test('toJson should convert Travel object to a JSON map', () {
      final travel = Travel(
        titre: 'My Trip',
        acls: {'public': SimpleAcl(name: 'public', access: 'read')},
        participants: {'Alice': Person(incoming: {'entry': [{'type': 'name', 'value': 'Alice'}]})},
        attributes: {'fromDate': '2025-05-01'},
        etapes: {}, // We'll test with etapes later
      );
      final jsonMap = travel.toJson();
      expect(jsonMap['titre'], 'My Trip');
      expect(jsonMap['acls']['public'], {'name': 'public', 'access': 'read'});
      expect(jsonMap['participants']['Alice']['attributes']['name'], {'type': 'name', 'value': 'Alice', 'acl': 'public'}); // Default ACL
      expect(jsonMap['attributes']['fromDate'], '2025-05-01');
      expect(jsonMap['etapes'], {});
    });

    test('fromJson should create a Travel object from a JSON map', () {
      final jsonMap = {
        'titre': 'Another Trip',
        'acls': {'private': {'name': 'private', 'access': 'full'}},
        'participants': {'Bob': {'attributes': {'name': {'type': 'name', 'value': 'Bob', 'acl': 'public'}}}},
        'attributes': {'toDate': '2025-05-10'},
        'etapes': {},
      };
      final travel = Travel.fromJson(jsonMap);
      expect(travel.titre, 'Another Trip');
      expect(travel.acls['private']?.access, 'full');
      expect(travel.participants['Bob']?.name(), 'Bob');
      expect(travel.attributes['toDate'], '2025-05-10');
      expect(travel.etapes, isEmpty);
    });

    test('listTravels should return a list of etape keys', () {
      final travel = Travel(etapes: {
        'Day 1': Etappe(title: 'Day 1', type: 'simple', attributes: {}, content: []),
        'Day 2': Etappe(title: 'Day 2', type: 'simple', attributes: {}, content: []),
      });
      expect(travel.listTravels(), ['Day 1', 'Day 2']);
    });

    test('title should return the titre', () {
      final travel = Travel(titre: 'A Great Journey');
      expect(travel.title(), 'A Great Journey');
    });

    test('id should return the id from attributes if present', () {
      final travel = Travel(attributes: {'id': 123});
      expect(travel.id(), 123);
    });

    test('id should return null if id attribute is missing or not an int', () {
      final travel1 = Travel(attributes: {});
      final travel2 = Travel(attributes: {'id': 'not an int'});
      expect(travel1.id(), null);
      expect(travel2.id(), null);
    });
  });
}