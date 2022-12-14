import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/custom_drawer/custom_drawer.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';

import 'components/favorite_tile.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key, this.hideDrawer = false});

  final bool hideDrawer;
  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
      ),
      drawer: hideDrawer ? null : const CustomDrawer(),
      body: Observer(builder: (_){
        if(favoriteStore.favoriteList.isEmpty){
          return const EmptyCard(text: 'Nenhum anúncio favoritado');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: favoriteStore.favoriteList.length,
          itemBuilder: (_,index) => FavoriteTile(ad: favoriteStore.favoriteList[index]),
        );
      }),
    );
  }
}
