// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/screens/create/create_screen.dart';

import '../../../stores/myads_store.dart';
import '../../ad/ad_screen.dart';

class ActiveTile extends StatelessWidget {
  ActiveTile({super.key, required this.ad, required this.myAdsStore});

  final Ad ad;
  final MyAdsStore myAdsStore;

  final List<MenuChoice> choices = [
    MenuChoice(index: 0, title: 'Editar', iconData: Icons.edit),
    MenuChoice(index: 1, title: 'Já vendi', iconData: Icons.thumb_up),
    MenuChoice(index: 2, title: 'Excluir', iconData: Icons.delete),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AdScreen(ad: ad)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                //colocando a imagem em cache para não precisar ficar carregando toda hora
                child: CachedNetworkImage(
                  imageUrl: ad.images!.isEmpty
                      ? 'https://cdn-icons-png.flaticon.com/512/1695/1695213.png'
                      : ad.images!.first,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ad.title!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ad.price!.formattedMoney(),
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '${ad.views} visitas',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              )),
              PopupMenuButton<MenuChoice>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.purple,
                ),
                itemBuilder: (_) {
                  //pega a lista de escolhas, e para cada uma delas retorna um PopupMenuItem
                  return choices
                      .map(
                        (choice) => PopupMenuItem<MenuChoice>(
                          child: InkWell(
                            onTap: () {
                              //tira a telinha de opções
                              Navigator.of(context).pop();

                              switch (choice.index) {
                                case 0:
                                  editAd(context);
                                  break;
                                case 1:
                                  soldAd(context);
                                  break;
                                case 2:
                                  deleteAd(context);
                                  break;
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  choice.iconData,
                                  size: 20,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  choice.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editAd(BuildContext context) async {
    final success = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateScreen(ad: ad)),
    );
    if (success != null && success) {
      //se atualizou um anúncio, recarrega os anúncios
      myAdsStore.refresh();
    }
  }

  Future<void> soldAd(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vendido'),
        content: Text('Confirmar a venda de ${ad.title}?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              myAdsStore.soldAd(ad);
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAd(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir'),
        content: Text('Confirmar a exclusão de ${ad.title}?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              myAdsStore.deleteAd(ad);
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  
}

//é cada uma das opções que vão aparecer como ícones para escolher
class MenuChoice {
  MenuChoice({
    required this.index,
    required this.title,
    required this.iconData,
  });

  final int index;
  final String title;
  final IconData iconData;
}
