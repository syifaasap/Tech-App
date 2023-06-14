import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? email;
  String? id;
  String? name;
  String? phone;

  UserModel({this.email, this.id, this.name, this.phone});

  UserModel.fromSnapshot(DataSnapshot snapsModel) {
    email = (snapsModel.value as dynamic)['email'];
    id = snapsModel.key;
    name = (snapsModel.value as dynamic)['name'];
    phone = (snapsModel.value as dynamic)['phone'];
  }
}
