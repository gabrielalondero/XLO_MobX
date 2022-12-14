import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';

import 'user_menager_store.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String? email;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid =>
      email != null &&
      email!.isEmailValid(); //chamando a função criada da classe String
  String? get emailError =>
      email == null || emailValid ? null : 'E-mail inválido';

  @observable
  String? password;

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password != null && password!.length >= 4;
  String? get passwordError =>
      password == null || passwordValid ? null : 'Senha inválida';

  @computed
  Function? get loginPressed =>
      emailValid && passwordValid && !loading ? _login : null;

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> _login() async {
    error = null;
    loading = true;
    try {
      final user =
          await UserRepository().loginWithEmail(email, password); //fez o login
      GetIt.I<UserManagerStore>()
          .setUser(user); //salvou o usuário no UserManagerStore
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
