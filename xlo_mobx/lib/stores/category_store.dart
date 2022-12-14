import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/repositories/category_repository.dart';
import 'connectivity_store.dart';
part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _CategoryStore() {
    autorun((_) async {
      //toda vez que a conexão mudar, ele vai rodar novamente
      //se estiver conectado, vai buscar as categorias
      if (connectivityStore.connected) {
        await _loadCategories();
      }
    });
  }

  ObservableList<Category> categoryList = ObservableList<Category>();

  @computed
  List<Category> get allCategoryList => List.from(categoryList) // copia a lista
    ..insert(
        0, Category(id: '*', description: 'Todas')); //insere categoria 'todas'

  @action
  void setCategories(List<Category> categories) {
    categoryList.clear();
    categoryList.addAll(//adiciona na lista todas as categorias vindas do Parse
        categories);
  }

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  Future<void> _loadCategories() async {
    try {
      error = null;
      final List<Category> categories = await CategoryRepository().getList();
      setCategories(categories);
    } catch (e) {
      setError(e.toString());
    }
  }
}
