import 'homescreen.dart';
import 'package:localstore/localstore.dart';

class SampleItemServices{
  Future loadItem() async {
      var db = Localstore.getInstance(useSupportDir: true);
      var mapItems = await db.collection('items').get();
      if(mapItems != null && mapItems.isNotEmpty) {
        var items = List<SampleItem>.from(
          mapItems.entries.map((e) => SampleItem.fromMap(e.value))
        );
          return items;
      }
      for(var i = 0;  i < 10; i++)SampleItem(name: 'Item $i');
  }

  Future addItem(SampleItem item) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('items').doc(item.id).set(item.toMap());
  }
  Future removeItem(String id) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('items').doc(id).delete();

  }
  Future updateItem(SampleItem item) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db
      .collection('items')
      .doc(item.id)
      .set(item.toMap(), SetOptions(merge: true));
  }
}