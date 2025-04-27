class Entry {
  final String type;
  final String value;
  final String acl;

  Entry({this.type = 'none', this.value = '', this.acl = 'public'});

  @override
  String toString() {
    return 'E[$type]: $value, $acl';
  }

  String getType() {
    return type;
  }

  String getValue() {
    return value;
  }

  String getAcl() {
    return acl;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'acl': acl,
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      type: json['type'] as String? ?? 'none',
      value: json['value'] as String? ?? '',
      acl: json['acl'] as String? ?? 'public',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Entry &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              value == other.value &&
              acl == other.acl;

  @override
  int get hashCode => type.hashCode ^ value.hashCode ^ acl.hashCode;
}