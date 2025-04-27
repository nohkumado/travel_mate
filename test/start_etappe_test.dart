import 'package:flutter_test/flutter_test.dart';
import 'package:travel_mate/etappe.dart';
import 'package:travel_mate/start_etappe.dart';

void main() {
  group('StartEtappe', () {
    test('constructor should initialize with type "start"', () {
      final startEtappe = StartEtappe();
      expect(startEtappe.type, 'start');
    });

    test('fromJson should create a StartEtappe object', () {
      final jsonMap = {'title': 'Departure', 'attributes': {'time': '9:00'}};
      final startEtappe = StartEtappe.fromJson(jsonMap);
      expect(startEtappe is StartEtappe, isTrue);
      expect(startEtappe.title, 'Departure');
      expect(startEtappe.attributes['time'], '9:00');
    });

    test('fromJson should handle nested etappes', () {
      final jsonMap = {
        'title': 'Start Day',
        'etapes': {
          'First Step': {'title': 'Step 1', 'type': 'simple'}
        }
      };
      final startEtappe = StartEtappe.fromJson(jsonMap);
      expect(startEtappe.etapes['First Step'] is Etappe, isTrue);
      expect(startEtappe.etapes['First Step']?.title, 'Step 1');
    });
  });
}