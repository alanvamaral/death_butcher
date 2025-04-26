import 'dart:convert';

enum MeatState { good, almostExpired, expired }

enum MeatType { beef, pork, chicken, fish, other }

class Meat {
  final int id;
  final String name;
  final MeatType type;
  final double quantity;
  final DateTime entryDate;
  final DateTime expirationDate;
  MeatState state;
  final int placedBy;
  final int placedIn;
  String? notes;

  Meat({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.entryDate,
    required this.expirationDate,
    this.state = MeatState.good,
    required this.placedBy,
    required this.placedIn,
    this.notes,
  }) {
    updateState();
  }

  void updateState() {
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;
    if (now.isAfter(expirationDate)) {
      state = MeatState.expired;
    } else if (difference <= 3) {
      state = MeatState.almostExpired;
    } else {
      state = MeatState.good;
    }
  }

  String getStateString() {
    switch (state) {
      case MeatState.good:
        return 'Bom';
      case MeatState.almostExpired:
        return 'Quase vencendo';
      case MeatState.expired:
        return 'Vencido';
    }
  }

  String getTypeString() {
    switch (type) {
      case MeatType.beef:
        return 'Bovina';
      case MeatType.chicken:
        return 'Frango';
      case MeatType.fish:
        return 'Peixe';
      case MeatType.pork:
        return 'Suína';
      case MeatType.other:
        return 'Outro';
    }
  }

  factory Meat.fromMap(Map<String, dynamic> map) {
    return Meat(
      id: map['id'],
      name: map['name'],
      type: MeatType.values
          .firstWhere((e) => e.toString() == 'MeatType.${map['type']}'),
      quantity: map['quantity'],
      entryDate: DateTime.parse(map['entryDate']),
      expirationDate: DateTime.parse(map['expirationDate']),
      state: MeatState.values
          .firstWhere((e) => e.toString() == 'MeatState.${map['state']}'),
      placedBy: map['placedBy'],
      placedIn: map['placedIn'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'entryDate': entryDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'state': state.toString().split('.').last,
      'placedBy': placedBy,
      'placedIn': placedIn,
      'notes': notes,
    };
  }

  String toJson() => json.encode(toMap());

  factory Meat.fromJson(String source) =>
      Meat.fromMap(json.decode(source) as Map<String, dynamic>);
}
