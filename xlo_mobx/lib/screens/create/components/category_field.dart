import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/category/category_screen.dart';
import 'package:xlo_mobx/stores/create_store.dart';

class CategoryField extends StatelessWidget {
  const CategoryField({super.key, required this.createStore});

  final CreateStore createStore;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          ListTile(
            title: createStore.category == null
                ? const Text(
                    'Categoria *',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )
                : const Text(
                    'Categoria *',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      fontSize: 13.5,
                    ),
                  ),
            subtitle: createStore.category == null
                ? null
                : Text(
                    createStore.category!.description,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              //abre a tela CategoryScreen por meio do showDialog
              //CategoryScreen retorna a categoria selecionada quando é fechada
              final category = await showDialog(
                context: context,
                builder: (_) => CategoryScreen(
                  showAll: false, //não exibir a categoria 'todas'
                  selected: createStore
                      .category, //seleciona se já estiver selecionado
                ),
              );
              if (category != null) {
                //setta a categoria selecionada
                createStore.setCategory(category);
              }
            },
          ),
          createStore.categoryError != null
              ? Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.red),
                    ),
                  ),
                  child: Text(
                    createStore.categoryError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[500]!,
                      ),
                    ),
                  ),
                )
        ],
      );
    });
  }
}
