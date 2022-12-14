import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/stores/home_store.dart';
part 'filter_store.g.dart';

enum OrderBy { date, price }

//binários
// << significa deslocar o 1
const vendorTypeParticular = 1 << 0; //um deslocado em zero - 0001
const vendorTypeProfessional = 1 << 1; //um deslocado em um - 0010
//conforme vai adicionando mais constantes, coloca o número do deslocamento maior
//const exemplo = 1 << 2; 0100
//const exemplo2 = 1 << 3; 1000

//operação com OU binário, se tiver pelo menos um 1 na coluna, vai sair 1
//OBS.: a operação binária é feita coluna por coluna
//0001 | 0010 = 0011

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  _FilterStore({
    this.orderBy = OrderBy.date,
    this.minPrice,
    this.maxPrice,
    this.vendorType = vendorTypeParticular,
  });

  @observable
  OrderBy orderBy;

  @action
  void setOrderBy(OrderBy value) => orderBy = value;

  @observable
  int? minPrice;

  @action
  void setMinPrice(int? value) => minPrice = value;

  @observable
  int? maxPrice;

  @action
  void setMaxPrice(int? value) => maxPrice = value;

  @computed
  String? get priceError =>
      maxPrice != null && minPrice != null && maxPrice! < minPrice!
          ? 'Faixa de preço inválida'
          : null;

  @observable
  int vendorType;

  @action
//o selectVendorType habilita só um e desabilita o outro
  void selectVendorType(int value) => vendorType = value;

//para permancer as opções selecionadas e possa selecionar outra opção
//setVendorType habilita a opção que passar para ele
//pois, com o operador OU, pega o que já tem habilitado no vendorType
//e adiciona o 1 que foi clicado agora (type) na posição referente ao tipo de vendedor
//Ex.: 0001 | 0010 = 0011 - particular e profissional estão habilitados
  void setVendorType(int type) => vendorType = vendorType | type;

//resetVendorType desabilita a opção que passar para ele
//pois, com o operador E, só sai 1 se tiver dois 1 na mesma coluna.
//o ~ antes do type, indica que estamos negando o valor dele, portanto
//ao clicar uma opção que já estava habilitada, o tipe vem como 1 na posição referente ao
//tipo de vendedor, e ao negá-lo, vira zero.
//ao efetuar a operação &, todos as colunas onde o vendorType tem o 1 e o type tem 0, vão sair 0
//Ex.: 0011 & 0001 = 0001  profissional foi desabilitado e particular ficou habilitado
  void resetVendorType(int type) => vendorType = vendorType & ~type;

  @computed
  //verifica se é particular, com o operador &, os valores da mesma coluna devem ser 1 para sair 1
  bool get isTypeParticular => (vendorType & vendorTypeParticular) != 0;
  //verifica se é profissional
  bool get isTypeProfessional => (vendorType & vendorTypeProfessional) != 0;

  @computed
  bool get isFormValid => priceError == null;

  void save() {
    GetIt.I<HomeStore>().setFilter(this as FilterStore);
  }

  FilterStore clone() {
    //nova insTãncia do FilterStore com os mesmos dados
    return FilterStore(
      orderBy: orderBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      vendorType: vendorType,
    );
  }
}
