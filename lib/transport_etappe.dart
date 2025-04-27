import 'etappe.dart';

class TransportEtappe extends Etappe {
  TransportEtappe({
    String title = 'no title',
    String type = 'transport',
    Map<String, dynamic> attributes = const {},
    List<dynamic> content = const [],
    Map<String, Etappe> etapes = const {},
  }) : super(title: title, type: type, attributes: attributes, content: content, etapes: etapes);

  factory TransportEtappe.fromJson(Map<String, dynamic> json) {
    return TransportEtappe(
      title: json['title'] as String? ?? 'no title',
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
      content: json['content'] as List<dynamic>? ?? [],
      etapes: (json['etapes'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, Etappe.fromJson(value as Map<String, dynamic>))) ?? {},
    );
  }
}