import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'movie_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final categories = <String>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategories();
  }

  Future<void> showCategories() async {
    final result = await MovieService().loadCategories();
    if (result != null) {
      categories.value = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final result = await AuthService().logout();
              Get.snackbar('Result', result ? 'you logout' : 'Error');
              if (result) Get.off(LoginPage());
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(categories[index]),
            trailing: Icon(Icons.arrow_circle_right),
          ),
        ),
      ),
    );
  }
}
