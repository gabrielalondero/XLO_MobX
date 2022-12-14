import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../models/ad.dart';

class DescriptionPanel extends StatelessWidget {
  const DescriptionPanel({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: Text(
            'Descrição',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          //botão de mostrar mais
          child: ReadMoreText(
            ad.description!,
            //quando está fechado, exibe somente 3 linhas
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: '  - Ver descrição completa',
            trimExpandedText: '  - Ver menos',
            colorClickableText: Colors.purple,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            )
            
          ),
        ),
      ],
    );
  }
}
