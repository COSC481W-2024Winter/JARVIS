import 'package:localstore/localstore.dart';

class LocalStorageService {
  final Localstore _store = Localstore.instance;

  Future<void> saveData(String key, dynamic data) async {
    await _store.collection('data').doc(key).set(data);
  }

  Future<dynamic> getData(String key) async {
    final document = await _store.collection('data').doc(key).get();
    if (document != null) {
      return document;
    }
    return null;
  }

  Future<void> removeData(String key) async {
    await _store.collection('data').doc(key).delete();
  }

  Future<void> clearAllData() async {
    await _store.collection('data').delete();
  }
}
