import 'dart:math';

class RandomKey {

  String key = "";

  RandomKey() {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

    this.key = getRandomString(100);
  }

}