import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/screens/category/category_screen.dart';

import '../../../stores/home_store.dart';
import '../../filter/filter_screen.dart';
import 'bar_button.dart';

class TopBar extends StatelessWidget {
  TopBar({super.key});

  final HomeStore homeStore = GetIt.I<HomeStore>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Observer(builder: (_){
          return BarButton(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey[400]!),
          )),
          label: homeStore.category?.description ?? 'Categorias',
          onTap: () async {
            final category = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => CategoryScreen(
                        showAll: true,
                        selected: homeStore.category,
                      )),
            );
            //se foi selecionada alguma categoria
            if (category != null) {
              homeStore.setCategory(category);
            }
          },
        );
        }),
        BarButton(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey[400]!),
            left: BorderSide(color: Colors.grey[400]!),
          )),
          label: 'Filtros',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FilterScreen()),
            );
          },
        ),
      ],
    );
  }
}
