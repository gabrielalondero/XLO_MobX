import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/components/error_box.dart';
import 'package:xlo_mobx/screens/myads/myads_screen.dart';
import 'package:xlo_mobx/stores/page_store.dart';
import '../../components/custom_drawer/custom_drawer.dart';
import '../../models/ad.dart';
import '../../stores/create_store.dart';
import 'components/category_field.dart';
import 'components/cep_field.dart';
import 'components/hide_phone_field.dart';
import 'components/images_field.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key, this.ad});

  final Ad? ad;

  @override
  State<CreateScreen> createState() => _CreateScreenState(ad);
}

class _CreateScreenState extends State<CreateScreen> {
  //passando o ad de edição para a createStore
  //se não for edição, ele é null, e então é passado um novo objeto Ad()
  _CreateScreenState(Ad? ad)
      : editing = ad != null,
        createStore = CreateStore(ad ?? Ad());

  final CreateStore createStore;
  bool editing;

  @override
  void initState() {
    super.initState();
    //reação when, só é feita uma vez, portanto não precisa dar Dispose()
    //quando o obsevable for diferente de nulo, faz a reação (que é uma função)
    when(
      (_) => createStore.savedAd,
      () {
        if (editing) {
          Navigator.of(context).pop(true);
        } else {
          GetIt.I<PageStore>().setPage(0);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MyAdsScreen(initialPage: 1)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.grey,
      fontSize: 18,
    );

    const contentPadding = EdgeInsets.fromLTRB(16, 10, 12, 10);
    return Scaffold(
      //se estiver editando não exibe o drawer
      drawer: editing ? null : const CustomDrawer(),
      appBar: AppBar(
        title: Text(editing ? 'Editar Anúncio' : 'Criar Anúncio'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              clipBehavior:
                  Clip.antiAlias, //para cortar o cantainer do ImagesField(),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              child: Observer(builder: (_) {
                if (createStore.loading) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        Text(
                          'Salvando anúncio',
                          style: TextStyle(fontSize: 18, color: Colors.purple),
                        ),
                        SizedBox(height: 16),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImagesField(createStore: createStore),
                      Observer(builder: (_) {
                        return TextFormField(
                          initialValue: createStore.title,
                          onChanged: createStore.setTtitle,
                          decoration: InputDecoration(
                            labelText: 'Título *',
                            labelStyle: labelStyle,
                            contentPadding: contentPadding,
                            errorText: createStore.titleError,
                          ),
                        );
                      }),
                      Observer(builder: (_) {
                        return TextFormField(
                          initialValue: createStore.description,
                          onChanged: createStore.setDescription,
                          decoration: InputDecoration(
                            labelText: 'Descrição *',
                            labelStyle: labelStyle,
                            contentPadding: contentPadding,
                            errorText: createStore.descriptionError,
                          ),
                          maxLines: null, //para não ter limite de linhas
                        );
                      }),
                      CategoryField(createStore: createStore),
                      CepField(createStore: createStore),
                      Observer(builder: (_) {
                        return TextFormField(
                          initialValue: createStore.priceText,
                          onChanged: createStore.setPrice,
                          decoration: InputDecoration(
                            labelText: 'Preço *',
                            labelStyle: labelStyle,
                            contentPadding: contentPadding,
                            prefixText: 'R\$ ',
                            errorText: createStore.priceError,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(),
                          ],
                        );
                      }),
                      HidePhoneField(createStore: createStore),
                      ErrorBox(message: createStore.error),
                      Observer(builder: (_) {
                        return SizedBox(
                          height: 50,
                          //se o elevated button estiver desabilitado, quem vai receer o tap será o gesture detector
                          child: GestureDetector(
                            onTap: createStore.invalidSendPressed,
                            child: ElevatedButton(
                              onPressed:
                                  createStore.sendPressed as void Function()?,
                              style: ElevatedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.orange,
                                disabledBackgroundColor:
                                    Colors.orange.withAlpha(120),
                              ),
                              child: const Text(
                                'Enviar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
