import 'package:mongo_dart/mongo_dart.dart';

import '../models/mango_db_user.dart';

class MongoDatabase {
  static const MONGO_CONN_URL = "<MONGO_URI>";
  static const User_COLLECTION = "users";
  static Db? db;
  static DbCollection? userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db!.open();
    userCollection = db!.collection(User_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>?> getDocuments() async {
    try {
      final users = await userCollection!.find().toList();
      return users;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insert(User user) async {
    await userCollection!.insert(user.toMap());
  }

  // static update(User user) async {
  //   var u = await userCollection!.findOne({"_id": user.id});
  //   u["name"] = user.name;
  //   u["age"] = user.age;
  //   u["phone"] = user.phone;
  //   await userCollection.save(u);
  // }

  static delete(User user) async {
    await userCollection!.remove(where.id(user.id));
  }
}
