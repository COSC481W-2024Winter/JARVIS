import 'package:localstore/localstore.dart';

class LocalStorageService {
  final _db = Localstore.instance;

  // The ID for the item we're storing
  final String _itemId = 'my_json_data';

  // Write JSON data to the localstore
  Future<void> writeJson(Map<String, dynamic> json) async {
    await _db.collection('my_collection').doc(_itemId).set(json);
  }

  // Read JSON data from the localstore
  Future<Map<String, dynamic>?> readJson() async {
    final doc = await _db.collection('my_collection').doc(_itemId).get();
    return doc;
  }
}
