
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/tables_keys.dart';
import '../models/user.dart';


//onde formos usar esta classe, sempre vamos instanciar um novo UserRepository, pois ele não guardará nenhum estado
//importante ressaltar que tudo referente ao parse deve ficar aqui, pois
//caso mude para outro banco, será mais fácil trocar
class UserRepository {
  Future<User> signUp(User user) async {
    // ParseUser(username - mas vamos usar o email, password,emailAddress )
    final parseUser = ParseUser(user.email, user.password, user.email);

    //setando os valores nas colunas
    parseUser.set<String?>(keyUserName, user.name);
    parseUser.set<String?>(keyUserPhone, user.phone);
    parseUser.set(keyUserType,
        user.type.index); //pega o index, 0 - particular e 1 - profissional

    final response =
        await parseUser.signUp(); //criando o usuário no parseServer

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

  Future<User> loginWithEmail(String? email, String? password) async {
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();
    if (response.success) {
      //retorna todos os dados do usuário
      return mapParseToUser(response.result);
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

  Future<User?> currentUser() async {
    final parseUser = await ParseUser.currentUser()
        as ParseUser?; //pega o último usuário logado
    //verifica se o login não expirou
    if (parseUser != null) {
      final response =
          await ParseUser.getCurrentUserFromServer(parseUser.sessionToken!);
      if (response != null && response.success) {
        //se não expirou o token
        return mapParseToUser(response.result);
      } else {
        //se expirou o token
        await parseUser.logout();
      }
    }
    return null;
  }

  //salvando alterações
  Future<void> save(User user) async {
    final parseUser = await ParseUser.currentUser() as ParseUser;
    if (parseUser != null) {
      parseUser.set<String>(keyUserName, user.name!);
      parseUser.set<String>(keyUserPhone, user.phone!);
      parseUser.set<int>(keyUserType, user.type.index);

      if (user.password != null) {
        parseUser.password = user.password;
      }

      final response = await parseUser.save();
      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }

      if (user.password != null) {
        await parseUser.logout();
        try {
          final loginResponseUser =
              await loginWithEmail(user.email, user.password);
        } catch (e) {
          return Future.error(e);
        }
      }
    }
  }

  Future<void> logout() async {
    final ParseUser currentUser = await ParseUser.currentUser();
    await currentUser.logout();
  }

//lendo todos os parâmetros do parseUser e colocando no User, para poder usá-los em todo o app
  User mapParseToUser(ParseUser parseUser) {
    return User(
      id: parseUser.objectId,
      name: parseUser.get(keyUserName),
      email: parseUser.get(keyUserEmail),
      phone: parseUser.get(keyUserPhone),
      type: UserType
          .values[parseUser.get(keyUserType)], //Transforma o userType no enum
      createdAt: parseUser.get(keyUserCreatedAt),
    );
  }
}
