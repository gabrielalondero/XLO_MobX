import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobx/mobx.dart';
part 'connectivity_store.g.dart';

class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    _setupListener();
  }

  void _setupListener() {
    //criando instância personalizada do InternetConnectionChecker
    //para modificar o intervalo de tempo das checagens
    final internetConnectionChecker = InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 5),
    );
    //ouvindo quando o status muda
    internetConnectionChecker.onStatusChange.listen((event) {
      //conectado == true, disconectado == false
      Future.delayed(const Duration(microseconds: 50)).then(
          (value) => setConnected(event == InternetConnectionStatus.connected));
    });
  }

  @observable
  bool connected = true;

  @action
  void setConnected(bool value) => connected = value;
}
