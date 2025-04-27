import 'entry.dart'; // Assuming entry.dart is in the same directory

class Person {
  final Map<String, Entry> attributes;

  Person({Map<String, dynamic>? incoming}) : attributes = _parseIncoming(incoming);

  static Map<String, Entry> _parseIncoming(Map<String, dynamic>? incoming) {
    final Map<String, Entry> parsedAttributes = {};
    if (incoming != null) {
      List<dynamic> entries = incoming.containsKey('entry')
          ? incoming['entry'] as List<dynamic>
          : [incoming]; // Handle both single and array 'entry'

      for (final entryData in entries) {
        if (entryData is Map<String, dynamic>) {
          Map<String, dynamic> actualEntryData = entryData;
          if (entryData.length == 1 && entryData.containsKey('@attributes')) {
            actualEntryData = entryData['@attributes'] as Map<String, dynamic>;
          }
          final newEntry = Entry.fromJson(actualEntryData);
          parsedAttributes[newEntry.type] = newEntry;
        }
      }
    }
    return parsedAttributes;
  }

  @override
  String toString() {
    return '${name()}: ${attributes.toString()}';
  }

  String name() {
    return attributes.containsKey('name') ? attributes['name']!.value : 'nobody';
  }

  Entry? get(String entry) {
    return attributes[entry];
  }

  String getValue(String entry) {
    return attributes.containsKey(entry) ? attributes[entry]!.value : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonAttributes = {};
    attributes.forEach((key, entry) {
      jsonAttributes[key] = entry.toJson();
    });
    return {
      'attributes': jsonAttributes,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? jsonAttributes =
    json['attributes'] as Map<String, dynamic>?;
    final Map<String, dynamic> incoming = {};
    if (jsonAttributes != null) {
      jsonAttributes.forEach((key, entryJson) {
        incoming[key] = entryJson;
      });
    }
    return Person(incoming: {'entry': incoming.values.toList()}); // Reformat for _parseIncoming
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Person &&
              runtimeType == other.runtimeType &&
              _mapEquals(attributes, other.attributes); // Custom map comparison

  @override
  int get hashCode => attributes.hashCode;
}

// Helper function for map equality
bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (K key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) {
      return false;
    }
  }
  return true;
}