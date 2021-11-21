class Cache {
  Map<String, dynamic> cache = new Map<String, dynamic>();

  late Duration duration;
  late Session session;

  Cache(Duration duration) {
    this.duration = duration;
    this.session = new Session(this.duration);
  }

  get(String key) {
    try {
      if(!session.isValid()) refreshSession();

      if(cache['-$key'] == null) return null;

      return cache['-$key'];
    } catch(_) {
      print('_');
      return null;
    }
  }

  isSet(String key) {
    try {
      return cache.containsKey('-$key');
    } catch(_) {
      return false;
    }
  }

  save(String key, var value) {
    cache['-$key'] = value;
  }

  refreshSession() {
    if(!session.isValid()) return;
    cache.clear();
    this.session = new Session(this.duration);
  }
}

class Session {

  final Duration maxAge;
  final DateTime iat = DateTime.now();

  Session (this.maxAge);

  isValid() {
    DateTime tmp = iat.add(this.maxAge);
    return tmp.isAfter(iat);
  }

}