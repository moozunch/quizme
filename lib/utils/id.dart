import 'dart:math';

import '../core/constants.dart';

/// Generates a numeric quiz code of [length] digits.
/// Allows leading zeros to keep the length consistent.
String generateQuizCode({int length = kQuizCodeLength}) {
  final r = Random();
  final buf = StringBuffer();
  for (var i = 0; i < length; i++) {
    buf.write(r.nextInt(10)); // 0-9
  }
  return buf.toString();
}
