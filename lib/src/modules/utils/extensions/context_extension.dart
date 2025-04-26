import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Map<Type, dynamic> get argsMap {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is Map<Type, dynamic>) {
      return args;
    } else {
      throw Exception(
          'Expected arguments as Map<Type, dynamic>, but got: $args');
    }
  }

  T arg<T extends Object>() {
    final value = argsMap[T];
    if (value == null) {
      throw Exception('Argument of type $T not found in arguments map');
    }
    return value as T;
  }
}
