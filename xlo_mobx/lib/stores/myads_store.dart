import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/repositories/ad_repository.dart';
import 'package:xlo_mobx/stores/user_menager_store.dart';

import '../models/ad.dart';
part 'myads_store.g.dart';

class MyAdsStore = _MyAdsStore with _$MyAdsStore;

abstract class _MyAdsStore with Store {
  _MyAdsStore() {
    _getMyAds();
  }

  @observable
  List<Ad> allAds = [];

//retorna ads ativos
  @computed
  List<Ad> get activeAds =>
      allAds.where((ad) => ad.status == AdStatus.active).toList();

  //retorna ads pendentes
  @computed
  List<Ad> get pendingAds =>
      allAds.where((ad) => ad.status == AdStatus.pending).toList();

  //retorna ads vendidos
  @computed
  List<Ad> get soldAds =>
      allAds.where((ad) => ad.status == AdStatus.sold).toList();

  Future<void> _getMyAds() async {
    final user = GetIt.I<UserManagerStore>().user;
    try {
      loading = true;
      allAds = await AdRepository().getMyAds(user!);
      loading = false;
    } catch (e) {}
  }

  @observable
  bool loading = false;

  void refresh() => _getMyAds();

  @action
  Future<void> soldAd(Ad ad) async{
    loading = true;
    await AdRepository().sold(ad);
    refresh();
  }

  @action
  Future<void> deleteAd(Ad ad) async{
    loading = true;
    await AdRepository().delete(ad);
    refresh();
  }
}
