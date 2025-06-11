import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'services/user_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crud')),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<User>('user').listenable(),
          builder: (context, Box<User> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text('No user in this box'),
              );
            }
            return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  final user = box.getAt(index);
                  return ListTile(
                    title: Text(user!.name),
                    subtitle: Text('Age:${user.age}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(user, index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _userService.deleteUser(index),
                        ),
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final user = User(
                name: nameController.text,
                age: int.parse(ageController.text),
              );
              _userService.addUser(user);
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(User user, int index) {
    final nameController = TextEditingController(text: user.name);
    final ageController = TextEditingController(text: user.age.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedUser = User(
                name: nameController.text,
                age: int.parse(ageController.text),
              );
              _userService.updateUser(index, updatedUser);
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
