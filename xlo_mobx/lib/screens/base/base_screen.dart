import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/screens/account/accont_screnn.dart';
import 'package:xlo_mobx/screens/create/create_screen.dart';
import 'package:xlo_mobx/screens/favorites/favorites_screen.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';
import '../../stores/page_store.dart';
import '../home/home_screen.dart';
import '../offline/offline_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //para alterar as páginas, precisa ter acesso ao pege controller
  final PageController pageController = PageController();

  final PageStore pageStore = GetIt.I<PageStore>(); //pegando a instância criada no main pelo GetIt
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  @override
  void initState() {
    super.initState();
    reaction(
      //toda vez que muda de página, a reaction é acionada e ela faz o pageControler trocar de página
      (_) => pageStore.page, //observable
      (page) => pageController.jumpToPage(page), //reaction
    );

    autorun((_){
      //quando não estiver conectado com a internet
      if(!connectivityStore.connected){
        showDialog(context: context, builder: (_) => const OfflineScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //pageView permite alternar entre uma tela e outra
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          const HomeScreen(),
          const CreateScreen(),
          Container(color: Colors.yellow),
          FavoritesScreen(),
          const AccountScrenn(),
        ],
      ),
    );
  }
}
