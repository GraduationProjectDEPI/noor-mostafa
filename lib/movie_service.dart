import 'main.dart';

class MovieService {
  Future<List<String>?> loadCategories() async {
    try {
      final result = await cloud.from('Movie').select('category');
      return result.map((value) => value['category'].toString()).toList();
      //[{category: horror},]
      print(result);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
