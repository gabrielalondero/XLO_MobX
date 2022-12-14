import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/stores/user_menager_store.dart';

import '../../screens/login/login_screen.dart';
import '../../stores/page_store.dart';

class CustomDrawerHeader extends StatelessWidget {
  CustomDrawerHeader({super.key});

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pop(); //fechando o drawer antes de ir para outra página

        if (userManagerStore.isLoggedIn) {
          GetIt.I<PageStore>().setPage(4); //pagina MinhaConta
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      },
      child: Container(
        color: Colors.purple,
        height: 95,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer(builder: (_){
                    return Text(
                    userManagerStore.isLoggedIn
                        ? userManagerStore.user!.name!
                        : 'Acesse sua conta agora!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                  }),
                  Observer(builder: (_){
                    return Text(
                    userManagerStore.isLoggedIn
                        ? userManagerStore.user!.email!
                        : 'Clique aqui',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
