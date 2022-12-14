import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/stores/myads_store.dart';

import 'components/active_tile.dart';
import 'components/pending_tile.dart';
import 'components/sold_tile.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({
    super.key,
    this.initialPage = 0, //se não passar nada, default = 0
  });

  final int initialPage;

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final MyAdsStore myAdsStore = MyAdsStore();

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 3, //quantas tabs
      initialIndex: widget.initialPage, //tela inicial, default = 0
      vsync:
          this, //classe precisa ser stateful e ter o 'with SingleTickerProviderStateMixin'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meus Anúncios'),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.orange,
            tabs: const [
              Tab(child: Text('ATIVOS')),
              Tab(child: Text('PENDENTES')),
              Tab(child: Text('VENDIDOS')),
            ],
          ),
        ),
        body: Observer(
          builder: (_) {
            if (myAdsStore.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            }
            return TabBarView(
              //precisa ter o mesmo controller da tabBar
              controller: tabController,
              //um filho pra cada tabBar
              children: [
                Observer(builder: (_) {
                  if (myAdsStore.activeAds.isEmpty) {
                    return const EmptyCard(text: 'Voce não possui nenhum anúncio ativo!');
                  }
                  return ListView.builder(
                    itemCount: myAdsStore.activeAds.length,
                    itemBuilder: (_, index) {
                      return ActiveTile(
                          ad: myAdsStore.activeAds[index],
                          myAdsStore: myAdsStore);
                    },
                  );
                }),
                Observer(builder: (_) {
                  if (myAdsStore.pendingAds.isEmpty) {
                    return const EmptyCard(text: 'Voce não possui nenhum anúncio pendente!');
                  }
                  return ListView.builder(
                    itemCount: myAdsStore.pendingAds.length,
                    itemBuilder: (_, index) {
                      return PendingTile(ad: myAdsStore.pendingAds[index]);
                    },
                  );
                }),
                Observer(builder: (_) {
                  if (myAdsStore.soldAds.isEmpty) {
                    return const EmptyCard(text: 'Voce não possui nenhum anúncio vendido!');
                  }
                  return ListView.builder(
                    itemCount: myAdsStore.soldAds.length,
                    itemBuilder: (_, index) {
                      return SoldTile(
                        ad: myAdsStore.soldAds[index],
                        myAdsStore: myAdsStore,
                      );
                    },
                  );
                }),
              ],
            );
          },
        ));
  }
}
