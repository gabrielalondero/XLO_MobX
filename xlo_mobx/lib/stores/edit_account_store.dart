import 'package:flutter/animation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';
import 'package:xlo_mobx/stores/user_menager_store.dart';
part 'edit_account_store.g.dart';

class EditAccountStore = _EditAccountStore with _$EditAccountStore;

abstract class _EditAccountStore with Store {
  _EditAccountStore() {
    user = userManagerStore.user as User;
    userType = user.type;
    name = user.name;
    phone = user.phone;
  }

  late User user;

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  @observable
  UserType? userType;

  @action
  void setUserType(int value) => userType = UserType.values[value];

  @observable
  String? name;

  @action
  void setName(String value) => name = value;

  @computed
  bool get nameValid => name != null && name!.length >= 6;
  String? get nameError {
    if (name == null || nameValid) {
      return null;
    } else if (name!.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'Nome muito curto';
    }
  }

  @observable
  String? phone;

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone != null && phone!.length >= 14;
  String? get phoneError {
    if (phone == null || phoneValid) {
      return null;
    } else if (phone!.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'Celular inválido';
    }
  }

  @observable
  String pass1 = '';

  @action
  void setPass1(String value) => pass1 = value;

  @computed
  bool get pass1Valid => pass1.length >= 6 || pass1.isEmpty;
  String? get pass1Error => pass1Valid ? null : 'Senha muito curta';

  @observable
  String pass2 = '';

  @action
  void setPass2(String value) => pass2 = value;

  @computed
  bool get passValid => pass1 == pass2 && pass1Valid;
  String? get passError {
    if (pass1 != pass2 && pass2.isNotEmpty) {
      return 'Senhas não coincidem';
    }
    return null;
  }

  @computed
  bool get isFormValid => nameValid && phoneValid && passValid;

  @observable
  bool loading = false;

  @computed
  VoidCallback? get savePressed => (isFormValid && !loading) ? _save : null;

  @observable
  String? error;

  @action
  Future<void> _save() async {
    error = null;
    loading = true;

    user.name = name;
    user.phone = phone;
    user.type = userType!;

    if (pass1.isNotEmpty) {
      user.password = pass1;
    } else {
      user.password = null;
    }
    try {
      await UserRepository().save(user);
      userManagerStore.setUser(user);
    } catch (e) {
      error = e.toString();
    }
    loading = false;
  }


  void logout() => userManagerStore.logout();
}

