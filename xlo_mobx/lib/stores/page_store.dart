import 'package:mobx/mobx.dart';
part 'page_store.g.dart';

class PageStore = _PageStore with _$PageStore;

abstract class _PageStore with Store {
  @observable 
  int page = 0;

  //sempre que for setar/alterar um observable, faça por meio e uma action
  @action 
  void setPage(int value) => page = value;
}