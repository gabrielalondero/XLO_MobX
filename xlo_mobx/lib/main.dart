import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/stores/category_store.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';
import 'package:xlo_mobx/stores/home_store.dart';
import 'screens/base/base_screen.dart';
import 'stores/page_store.dart';
import 'stores/user_menager_store.dart';

void main() async {
  await initializeParse();
  setupLocators();
  runApp(const MyApp());
}

void setupLocators() {
  //a ordem de colocar os GetIt importa
  //utilizando o GeIt para acessar a instância de qualquer lugar do app
  //registerSingleton registra uma única instância
  GetIt.I.registerSingleton(ConnectivityStore());
  GetIt.I.registerSingleton(PageStore());
  GetIt.I.registerSingleton(HomeStore());
  GetIt.I.registerSingleton(CategoryStore());
  GetIt.I.registerSingleton(UserManagerStore()); //intancia única do usuário
  GetIt.I<UserManagerStore>()
      .getCurrentUser(); //traz o usuário atual, mesmo quando fechar
  GetIt.I.registerSingleton(FavoriteStore());
}

Future<void> initializeParse() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    //appId
    'Gq46a0kEMSU7oXBPw7QeiwdoR8Nxog6D0QZEkuNu',
    //serverUrl (Parse API address)
    'https://parseapi.back4app.com/',
    clientKey: 'jrEhvaqkpwyJsZAKjVSph9QisVMXL24WjRE3bYjY',
    //autoSendSessionId - enviar a nossa identificação automaticamente para o parse quando
    // fizermos requisições
    autoSendSessionId: true,
    debug: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XLO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple,
        // appBarTheme: AppBarTheme(elevation: 0),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orange,
        ),
      ),
      //lista de quais linguas o app suporta
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: const BaseScreen(),
    );
  }
}
