import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  SearchDialog({super.key, required this.currentSearch})
  //inicia o controller com o valor já digitado em uma pesquisa anterior
      : controller = TextEditingController(text: currentSearch); 

  final TextEditingController controller;
  final String currentSearch;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 2,
          right: 2,
          child: Card(
            child: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                prefixIcon: IconButton(
                  onPressed: Navigator.of(context).pop,
                  color: Colors.grey[700],
                  icon: const Icon(Icons.arrow_back),
                ),
                suffixIcon: IconButton(
                  onPressed: controller.clear,
                  icon: const Icon(Icons.close),
                  color: Colors.grey[700],
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                Navigator.of(context).pop(text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
