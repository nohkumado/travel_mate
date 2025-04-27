import 'start_etappe.dart';
import 'transport_etappe.dart';

class Etappe {
  final String title;
  final String type;
  final Map<String, dynamic> attributes; // Dates will be strings initially
  final List<dynamic> content;
  final Map<String, Etappe> etapes;

  Etappe({
    this.title = 'no title',
    this.type = 'simple',
    this.attributes = const {},
    this.content = const [],
    this.etapes = const {},
  });

  @override
  String toString() {
    String result = 'Etappe $title ($type): ';
    attributes.forEach((key, value) {
      result += '$key: $value, ';
    });
    result += 'Content: $content, Etapes: $etapes';
    return result;
  }

  String getTitle() {
    return title;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'attributes': attributes,
      'content': content,
      'etapes': etapes.map((key, etappe) => MapEntry(key, etappe.toJson())),
    };
  }

  factory Etappe.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? 'simple';
    final Map<String, dynamic>? jsonAttributes = json['attributes'] as Map<String, dynamic>?;
    final List<dynamic>? jsonContent = json['content'] as List<dynamic>?;
    final Map<String, dynamic>? jsonEtapes = json['etapes'] as Map<String, dynamic>?;

    Map<String, Etappe> parsedEtapes = {};
    if (jsonEtapes != null) {
      jsonEtapes.forEach((key, etappeJson) {
        if (etappeJson is Map<String, dynamic>) {
          parsedEtapes[key] = _createEtappeFromType(etappeJson);
        }
      });
    }

    return Etappe(
      title: json['title'] as String? ?? 'no title',
      type: type,
      attributes: jsonAttributes ?? {},
      content: jsonContent ?? [],
      etapes: parsedEtapes,
    );
  }

  // Helper method to create specific Etappe subtypes based on the 'type'
  static Etappe _createEtappeFromType(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? 'simple';
    switch (type) {
      case 'start':
        return StartEtappe.fromJson(json);
      case 'transport':
        return TransportEtappe.fromJson(json);
      default:
        return Etappe.fromJson(json);
    }
  }

// toHtml() will be a Flutter widget
}