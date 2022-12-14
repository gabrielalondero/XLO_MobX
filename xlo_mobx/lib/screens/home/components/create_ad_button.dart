import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../../../stores/page_store.dart';

class CreateAdButton extends StatefulWidget {
  const CreateAdButton({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<CreateAdButton> createState() => _CreateAdButtonState();
}

class _CreateAdButtonState extends State<CreateAdButton>
//para o vsync funcionar:
    with
        SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> buttonAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // Tween - animação que tem inicio e fim
    //até 50 pois colocamos que o botao ficava -50 abaixo da tela
    //então ele no 0 é -50, e vai subir 66 para aparecer na tela e sobrar um espacinho
    buttonAnimation = Tween<double>(begin: 0, end: 66).animate(
      CurvedAnimation(
        parent: controller,
        //Interval(begin, end) - a animação roda no intervalo de 
        //porcentagem da duração total da animação
        //intervalo de 40% até 60% da duração total
        curve: const Interval(0.4, 0.6),
      ),
    );
    //toda vez que mudar a rolagem da tela a tela, chama uma função
    widget.scrollController.addListener(scrollChanged);
  }

  void scrollChanged() {
    final position = widget.scrollController.position;
    //se estiver avançando no scroll
    if (position.userScrollDirection == ScrollDirection.forward) {
      //vai dar play na animação
      controller.forward();
    } else {
      //se estiver indo ao contrário
      //vai reverter a animação
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: buttonAnimation,
      builder: (_, __) {
        //FractionallySizedBox - podemos settar a porcentagem da largura/altura
        return FractionallySizedBox(
          widthFactor: 0.6, //60% da largura da tela
          child: Container(
            height: 50,
            margin: EdgeInsets.only(
              //vai incrementando a margin conforme vai aparecendo na tela
              bottom: buttonAnimation.value,
            ),
            child: ElevatedButton(
              onPressed: () {
                GetIt.I<PageStore>().setPage(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    'Anunciar agora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
