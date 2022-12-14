import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';
import 'package:xlo_mobx/stores/user_menager_store.dart';
import 'components/bottom_bar.dart';
import 'components/description_panel.dart';
import 'components/location_panel.dart';
import 'components/main_panel.dart';
import 'components/user_panel.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({required this.ad, Key? key}) : super(key: key);

  final Ad? ad;

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late PageController _pageController;

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
  }

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();
  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        title: const Text('Anúncio'),
        centerTitle: true,
        actions: [
          if (widget.ad!.status == AdStatus.active &&
              userManagerStore.isLoggedIn)
            Observer(builder: (_) {
              return IconButton(
                onPressed: () => favoriteStore.toggleFavorite(widget.ad!),
                icon: Icon(
                  //se na lista de favoritos já existir algum anúncio que tenha o id
                  //do anúncio que stamos acessando, ele retorna favorito preenchido
                  favoriteStore.favoriteList.any((a) => a.id == widget.ad!.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              );
            }),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0.5),
                    height: 280,
                    //rolar as fotos
                    child: PageView.builder(
                      pageSnapping: true,
                      padEnds: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemCount: widget.ad?.images?.length,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          child: CachedNetworkImage(
                            imageUrl: widget.ad?.images?[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  //pontos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(widget.ad?.images?.length, activePage)
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainPanel(ad: widget.ad!),
                        Divider(color: Colors.grey[500]),
                        DescriptionPanel(ad: widget.ad!),
                        Divider(color: Colors.grey[500]),
                        LocationPanel(ad: widget.ad!),
                        Divider(color: Colors.grey[500]),
                        UserPanel(ad: widget.ad!),
                        SizedBox(
                          height:
                              //se está pendente, não deixa espaçõ, pois não tem os botões
                              widget.ad!.status == AdStatus.pending ? 0 : 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          BottomBar(ad: widget.ad!),
        ],
      ),
    );
  }

  //os pontos que indicam as fotos
  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.orange : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    });
  }
}
