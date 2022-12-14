import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';

import '../models/user.dart';
part 'user_menager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {

  @observable 
  User? user;

  @action 
  void setUser(User? value) => user = value;

  @computed 
  bool get isLoggedIn => user != null;


  Future<void> getCurrentUser() async{
    final user = await UserRepository().currentUser();
    setUser(user);
  }

  Future<void> logout() async{
    await UserRepository().logout();
    setUser(null);
  }

  
}