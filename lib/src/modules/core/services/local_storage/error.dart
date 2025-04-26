import 'dart:convert';

class LocalStorageException implements Exception {
  LocalStorageException(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;

  String toJson() {
    return jsonEncode({'error': message});
  }

  @override
  String toString() =>
      'LocalStorageException(message: $message, stackTrace: $stackTrace)';
}
