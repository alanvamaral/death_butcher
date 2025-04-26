class FreezerForm {
  var _name = Name('');

  void setName(String newName) => _name = Name(newName);
  Name get name => _name;

  var _location = Location('');
  void setLocation(String newLocation) => _location = Location(newLocation);
  Location get location => _location;

  String? validate(String value) {
    String? validate = _name.validate(value);
    if (validate != null) {
      return validate;
    }
    validate = _location.validate(value);
    if (validate != null) {
      return validate;
    }
    return null;
  }
}

class Name {
  Name(this.value);
  final String value;

  String? validate(String value) {
    String errors = '';

    if (value.isEmpty) {
      errors = 'Por favor, insira o nome';
    }

    if (errors.isEmpty) return null;

    return errors;
  }

  @override
  String toString() => 'Name(value: $value)';
}

class Location {
  Location(this.value);
  final String value;

  String? validate(String value) {
    String errors = '';

    if (value.isEmpty) {
      errors = 'Por favor, insira a localização';
    }

    if (errors.isEmpty) return null;

    return errors;
  }

  @override
  String toString() => 'Location(value: $value)';
}
