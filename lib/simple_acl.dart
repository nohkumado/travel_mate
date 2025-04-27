class SimpleAcl {
  final String name;
  final String access;

  SimpleAcl({required this.name, required this.access});

  @override
  String toString() {
    return '$name:$access';
  }

  String getName() {
    return name;
  }

  String getAccess() {
    return access;
  }

  // Optional: A method to represent as JSON (for potential local storage/caching)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'access': access,
    };
  }

  // Optional: A method to create from JSON
  factory SimpleAcl.fromJson(Map<String, dynamic> json) {
    return SimpleAcl(
      name: json['name'] as String? ?? '',
      access: json['access'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SimpleAcl &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              access == other.access;

  @override
  int get hashCode => name.hashCode ^ access.hashCode;
}