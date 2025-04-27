import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/etappe.dart';
import 'package:travel_mate/start_etappe.dart';
import 'package:travel_mate/transport_etappe.dart';

void main() {
  group('Etappe', () {
    test('constructor should initialize with default values', () {
      final etappe = Etappe();
      expect(etappe.title, 'no title');
      expect(etappe.type, 'simple');
      expect(etappe.attributes, isEmpty);
      expect(etappe.content, isEmpty);
      expect(etappe.etapes, isEmpty);
    });

    test('constructor should initialize with provided values', () {
      final etappe = Etappe(title: 'Day Trip', type: 'adventure', attributes: {'location': 'Mountains'}, content: ['Hiking']);
      expect(etappe.title, 'Day Trip');
      expect(etappe.type, 'adventure');
      expect(etappe.attributes['location'], 'Mountains');
      expect(etappe.content, ['Hiking']);
      expect(etappe.etapes, isEmpty);
    });

    test('getTitle should return the title', () {
      final etappe = Etappe(title: 'City Tour');
      expect(etappe.getTitle(), 'City Tour');
    });

    test('toJson should convert Etappe object to a JSON map', () {
      final etappe = Etappe(title: 'Lunch Break', type: 'food', attributes: {'time': '12:00'}, content: ['Sandwich']);
      final jsonMap = etappe.toJson();
      expect(jsonMap['title'], 'Lunch Break');
      expect(jsonMap['type'], 'food');
      expect(jsonMap['attributes']['time'], '12:00');
      expect(jsonMap['content'], ['Sandwich']);
      expect(jsonMap['etapes'], {});
    });

    test('fromJson should create an Etappe object from a JSON map', () {
      final jsonMap = {'title': 'Arrival', 'type': 'simple', 'attributes': {'date': '2025-05-01'}, 'content': ['Check-in']};
      final etappe = Etappe.fromJson(jsonMap);
      expect(etappe.title, 'Arrival');
      expect(etappe.type, 'simple');
      expect(etappe.attributes['date'], '2025-05-01');
      expect(etappe.content, ['Check-in']);
      expect(etappe.etapes, isEmpty);
    });

    test('fromJson should handle nested etappes', () {
      final jsonMap = {
        'title': 'Main Day',
        'type': 'complex',
        'etapes': {
          'Morning': {'title': 'Breakfast', 'type': 'simple', 'attributes': {'time': '8:00'}, 'content': ['Coffee']},
          'Afternoon': {'title': 'Activity', 'type': 'fun', 'attributes': {'location': 'Park'}, 'content': ['Picnic']},
        },
      };
      final etappe = Etappe.fromJson(jsonMap);
      expect(etappe.etapes['Morning']?.title, 'Breakfast');
      expect(etappe.etapes['Afternoon']?.type, 'fun');
    });

    test('fromJson should create StartEtappe for type "start"', () {
      final jsonMap = {'title': 'Departure', 'type': 'start', 'attributes': {'time': '9:00'}};
      final etappe = Etappe.fromJson(jsonMap);
      expect(etappe is StartEtappe, isTrue);
      expect(etappe.title, 'Departure');
    });

    test('fromJson should create TransportEtappe for type "transport"', () {
      final jsonMap = {'title': 'Train Ride', 'type': 'transport', 'attributes': {'duration': '2 hours'}};
      final etappe = Etappe.fromJson(jsonMap);
      expect(etappe is TransportEtappe, isTrue);
      expect(etappe.title, 'Train Ride');
    });

    test('fromJson should create default Etappe for unknown type', () {
      final jsonMap = {'title': 'Unknown Event', 'type': 'unknown', 'attributes': {}};
      final etappe = Etappe.fromJson(jsonMap);
      expect(etappe is Etappe, isTrue);
      expect(etappe.type, 'unknown');
    });
  });
}