import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt([int length = 16]) {
  final rand = Random.secure();
  final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
  return base64Url.encode(bytes);
}

String hashPassword(String password, String salt) {
  final salted = utf8.encode(password + salt);
  final digest = sha256.convert(salted);
  return digest.toString();
}
