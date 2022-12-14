import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/repositories/ad_repository.dart';
import 'package:xlo_mobx/stores/filter_store.dart';
import '../models/ad.dart';
import '../models/category.dart';
import 'connectivity_store.dart';
part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _HomeStore() {
    autorun((_) async {
      //quando qualquer um destes observables abaixo mudar,
      //o autorun vai rodar e buscar uma nova lista(caso use um filtro)
      //ou adicionar mais itens na lista, quando o page mudar, quando a conexão mudar
      connectivityStore.connected;
      try {
        setLoading(true);
        final newAds = await AdRepository().getHomeAdList(
          filter: filter,
          search: search,
          category: category,
          page: page,
        );
        addNewAds(newAds);
        setError(null);
        setLoading(false);
      } catch (e) {
        setError(e.toString());
      }
    });
  }

  ObservableList<Ad> adList = ObservableList<Ad>();

  @observable
  String search = '';

  @action
  void setSearch(String value) {
    search = value;
    resetPage();
  }

  @observable
  Category? category;

  @action
  void setCategory(Category value) {
    category = value;
    resetPage();
  }

  @observable
  FilterStore filter = FilterStore();
//o observer não vê que os dados dentro da instância FilterStore() mudaram
//então cria-se um clone, ai ele entenderá que mudou
  FilterStore get clonedFilter => filter.clone();

//depois setamos o clone caso cliquemos no botão de filtrar, senão, as alterações são descartadas
  @action
  void setFilter(FilterStore value) {
    filter = value;
    resetPage();
  }

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

//paginação (fictícia, pois será uma lista)
  @observable
  int page = 0;

  @observable
  bool lastPage = false;

  //quando chegar no último item da,lista, carregas a proxima página
  //cada página vêm 20
  @action
  void loadingNextPage() {
    page++;
  }

  @action
  void addNewAds(List<Ad> newAds) {
    //se for menor que o número de itens por página, significa que acabou
    if (newAds.length < 10) {
      lastPage = true;
    }
    adList.addAll(newAds);
  }

  @computed
  //o +1 é o item de carregamento no fim da lista
  //se estiver na útima lista, não terá
  int get itemCount => lastPage ? adList.length : adList.length + 1;

//toda vez que usar algum filtro, reseta a página e a lista
  void resetPage() {
    page = 0;
    adList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && adList.isEmpty;
}
