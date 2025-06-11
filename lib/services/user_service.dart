import 'package:hive/hive.dart';
import 'package:custom_crud/models/user_model.dart';

class UserService {
  static final UserService _singleton = UserService._internal();
  factory UserService() {
    return _singleton;
  }
  UserService._internal();

  final Box<User> _userBox = Hive.box<User>('user');

  Future<void> addUser(User user) async {
    await _userBox.add(user);
  }

  User? getUser(int index) {
    return _userBox.getAt(index);
  }

  Future<void> updateUser(int index, User user) async {
    await _userBox.putAt(index, user);
  }

  Future<void> deleteUser(int index) async {
    await _userBox.deleteAt(index);
  }

  List<User> getAllUsers() {
    return _userBox.values.toList();
  }
}
