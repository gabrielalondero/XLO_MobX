import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/stores/myads_store.dart';

import '../../../models/ad.dart';

class SoldTile extends StatelessWidget {
  const SoldTile({super.key, required this.ad, required this.myAdsStore});

  final Ad ad;
  final MyAdsStore myAdsStore;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    deleteAd(context);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.purple,
                ),
              ],
            )
          ],
        ),
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
