import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import '../../components/custom_drawer/custom_drawer.dart';
import '../../stores/home_store.dart';
import 'components/ad_tile.dart';
import 'components/create_ad_button.dart';
import 'components/search_dialog.dart';
import 'components/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeStore homeStore = GetIt.I<HomeStore>();

//ScrollController precisa estar dentro de um stateful
  final ScrollController scrollController = ScrollController();

  openSearch(BuildContext context) async {
    //pode colocar qualquer widget no showDialog
    final search = await showDialog(
        context: context,
        builder: (_) => SearchDialog(
              currentSearch: homeStore.search,
            ));
    if (search != null) {
      homeStore.setSearch(search);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: Observer(builder: (_) {
            if (homeStore.search.isEmpty) {
              return Container();
            }
            //gesture detector para editar o texto ao clicar
            return GestureDetector(
              //constraints determinam o tamanho min e max que um widget pode ter
              //neste caso, colocar a largura máxima que o título pode ter
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return SizedBox(
                    width: constraints.biggest.width, // maior largura possível
                    child: Text(homeStore.search),
                  );
                },
              ),
              onTap: () => openSearch(context),
            );
          }),
          actions: [
            Observer(builder: (_) {
              //se não tiver pesquisa exibe botão de pesquisa

              if (homeStore.search.isEmpty) {
                return IconButton(
                  onPressed: () => openSearch(context),
                  icon: const Icon(Icons.search),
                );
              }
              //se tiver pesquisa, exibe botão para limpar pesquisa
              return IconButton(
                onPressed: () {
                  homeStore.setSearch('');
                },
                icon: const Icon(Icons.close),
              );
            })
          ],
        ),
        body: Column(
          children: [
            TopBar(),
            Expanded(
              child: Stack(
                children: [
                  Observer(
                    builder: (_) {
                      if (homeStore.error != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 100,
                              ),
                              Text(
                                'Ocorreu um erro! ${homeStore.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      //só mostra quando a lista estiver vazia
                      //ou seja, no primeiro carregamento, ou quando usar um filtro
                      if (homeStore.showProgress) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      }
                      if (homeStore.adList.isEmpty) {
                        return const EmptyCard(text: 'Nenhum anúncio encontrado :(');
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: homeStore.itemCount,
                        itemBuilder: (_, index) {
                          if (index < homeStore.adList.length) {
                            return AdTile(ad: homeStore.adList[index]);
                          }
                          //ao colocar todos os itens de uma página,
                          //carrega itens da próxima página
                          homeStore.loadingNextPage();
                          return const SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    //ele vai ficar abaixo da tela
                    //e quando der play na animação, vai subir
                    // -50 pq o botão tem 50 de altura, aí ele some por completo
                    bottom: -50,
                    left: 0,
                    right: 0, 
                    //conforme vai mudando a rolagem da tela, o botão vai se movimentar
                    //o scrollController é quem gerencia isso                  
                    child: CreateAdButton(scrollController: scrollController),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
