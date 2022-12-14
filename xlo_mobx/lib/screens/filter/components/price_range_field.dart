import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components/price_field.dart';
import 'package:xlo_mobx/screens/filter/components/section_title.dart';

import '../../../stores/filter_store.dart';

class PriceRangeField extends StatelessWidget {
  const PriceRangeField({super.key, required this.filterStore});

  final FilterStore filterStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Preço'),
        Row(
          children: [
            PriceField(
              label: 'Min',
              onChanged: filterStore.setMinPrice,
              inicialValue: filterStore.minPrice,
            ),
            const SizedBox(width: 12),
            PriceField(
              label: 'Max',
              onChanged: filterStore.setMaxPrice,
              inicialValue: filterStore.maxPrice,
            ),
          ],
        ),
        Observer(builder: (_) {
          if (filterStore.priceError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                filterStore.priceError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            );
          }
          return Container();
        })
      ],
    );
  }
}
