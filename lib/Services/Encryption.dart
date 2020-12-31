import 'package:encrypt/encrypt.dart';

class Encryption {
  final key = Key.fromUtf8("<YOUR 32 CHARS ENCRYPTION KEY HERE>");
  final iv = IV.fromUtf8("YOUR 16 CHAR IV KEY HERE");
  String encrypt(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(text, iv: iv).base64;
  }

  String decrypt(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
  }
}
