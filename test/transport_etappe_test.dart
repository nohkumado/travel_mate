import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/etappe.dart';
import 'package:travel_mate/transport_etappe.dart';

void main() {
  group('TransportEtappe', () {
    test('constructor should initialize with type "transport"', () {
      final transportEtappe = TransportEtappe();
      expect(transportEtappe.type, 'transport');
    });

    test('fromJson should create a TransportEtappe object', () {
      final jsonMap = {'title': 'Train Journey', 'attributes': {'duration': '3 hours'}};
      final transportEtappe = TransportEtappe.fromJson(jsonMap);
      expect(transportEtappe is TransportEtappe, isTrue);
      expect(transportEtappe.title, 'Train Journey');
      expect(transportEtappe.attributes['duration'], '3 hours');
    });

    test('fromJson should handle nested etappes', () {
      final jsonMap = {
        'title': 'Travel Segment',
        'etapes': {
          'Connection': {'title': 'Change Train', 'type': 'simple'}
        }
      };
      final transportEtappe = TransportEtappe.fromJson(jsonMap);
      expect(transportEtappe.etapes['Connection'] is Etappe, isTrue);
      expect(transportEtappe.etapes['Connection']?.title, 'Change Train');
    });
  });
}