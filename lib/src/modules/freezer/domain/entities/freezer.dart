import 'dart:convert';

class Freezer {
  int id;
  final String name;
  final String location;

  Freezer({
    required this.id,
    required this.name,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
    };
  }

  factory Freezer.fromMap(Map<String, dynamic> map) {
    return Freezer(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Freezer.fromJson(String source) =>
      Freezer.fromMap(json.decode(source) as Map<String, dynamic>);
}
