import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/repositories/favorite_repository.dart';
import 'package:xlo_mobx/stores/user_menager_store.dart';
part 'favorite_store.g.dart';

class FavoriteStore = _FavoriteStore with _$FavoriteStore;

abstract class _FavoriteStore with Store {
  _FavoriteStore() {
    //quando carregar os os dados do usuário, carrega os dados dos favoritos
    reaction((_) => userManagerStore.isLoggedIn, (_) => _getFavoriteList());
    
  }

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  ObservableList<Ad> favoriteList = ObservableList<Ad>();

  @action
  Future<void> _getFavoriteList() async {
    try {
      favoriteList.clear();
      final favorites =
          await FavoriteRepository().getFavorites(userManagerStore.user!);
     favoriteList.addAll(favorites); //adiciona todos na lista
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> toggleFavorite(Ad ad) async {
    try {
      //se existe algum anúncio que já esteja favoritado
      //ou seja, que já esteja na ObservableList
      if (favoriteList.any((a) => a.id == ad.id)) {
        favoriteList.removeWhere((a) => a.id == ad.id); //remove da lista
        await FavoriteRepository().delete(ad, userManagerStore.user!);
      } else {
        favoriteList.add(ad);
        await FavoriteRepository().save(ad, userManagerStore.user!);
      }
    } catch (e) {
      print(e);
    }
  }
}
