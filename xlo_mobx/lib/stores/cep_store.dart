import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/repositories/cep_repository.dart';
part 'cep_store.g.dart';

class CepStore = _CepStore with _$CepStore;

abstract class _CepStore with Store {
  _CepStore(String inialCep) {
    autorun((_) {
      if (clearCep.length != 8) {
        _reset();
      } else {
        _searchCep();
      }
    });

    setCep(inialCep);
  }

  @observable
  String cep = '';

  @action
  void setCep(String value) => cep = value;

  @computed
  String get clearCep => cep.replaceAll(RegExp('[^0-9]'), '');

  @observable 
  Address? address;

  @observable
  String? error;

  @observable 
  bool loading = false;

  @action
  Future<void> _searchCep() async{
    loading = true;
    try{
      //obtendo o endereço
      address = await CepRepository().getAdressFromApi(clearCep);
      error = null;
    }catch(e){
      //caso encontre um erro
      error = e.toString();
      address = null;
    }
    loading = false;
  }

  @action 
  void _reset(){
    address = null;
    error = null;
  }
}
