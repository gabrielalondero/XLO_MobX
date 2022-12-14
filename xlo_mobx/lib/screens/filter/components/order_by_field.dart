import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components/section_title.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

class OrderByField extends StatelessWidget {
  const OrderByField({super.key, required this.filterStore});

  final FilterStore filterStore;

  @override
  Widget build(BuildContext context) {
    Widget buildOption(String title, OrderBy opition) {
      return GestureDetector(
        onTap: () => filterStore.setOrderBy(opition),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: filterStore.orderBy == opition
                  ? Colors.purple
                  : Colors.transparent,
              border: Border.all(
                color: filterStore.orderBy == opition
                    ? Colors.purple
                    : Colors.grey,
              )),
          child: Text(
            title,
            style: TextStyle(
              color:
                  filterStore.orderBy == opition ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Ordenar por'),
        Observer(builder: (_) {
          return Row(
            children: [
              buildOption('Data', OrderBy.date),
              const SizedBox(width: 12),
              buildOption('Preço', OrderBy.price),
            ],
          );
        }),
      ],
    );
  }
}
