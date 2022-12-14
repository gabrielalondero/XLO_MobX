import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/ad.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    //se está pendente, não exibe os botões
    if(ad.status == AdStatus.pending){
      return Container();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            height: 39,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              color: Colors.orange,
            ),
            child: Row(
              children: [
                //se não pediu para ocultar o celular aparece o botão ligar,
                //senão aparece so o botão do chat
                if(!ad.hidePhone)
                    Expanded(
                    child: GestureDetector(
                      onTap: () {
                        //limpando qualque digito que não seja número
                        final phone = ad.user!.phone!.replaceAll(RegExp('[^0-9]'), '');
                        launchUrl(Uri.parse('tel:$phone'));
                    },
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.black45),
                          ),
                        ),
                        child: const Text(
                          'Ligar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: const Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 249, 249, 1),
                border: Border(
                  top: BorderSide(color: Colors.grey[400]!),
                )),
            height: 38,
            child: Text(
              '${ad.user!.name}  (anunciante)',
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
