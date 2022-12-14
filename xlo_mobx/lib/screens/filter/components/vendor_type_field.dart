import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components/section_title.dart';
import '../../../stores/filter_store.dart';

class VendorTypeField extends StatelessWidget {
  const VendorTypeField({super.key, required this.filterStore});

  final FilterStore filterStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(title: 'Tipo de anunciante'),
        Observer(builder: (_) {
          //quebrar a linha
          return Wrap(
            runSpacing: 4,
            children: [
              GestureDetector(
                onTap: () {
                  //se particular já está habilitado 
                  if (filterStore.isTypeParticular) {
                    //se professional também está habilitado
                    if(filterStore.isTypeProfessional){
                      //desabilita particular, pois uma das opções está habilitada
                      filterStore.resetVendorType(vendorTypeParticular);
                    }else{
                      //habilita somente o prefessional
                      //o selectVendorType habilita só um e desabilita o outro
                      filterStore.selectVendorType(vendorTypeProfessional);
                    }                             
                  } else {
                    //se ele não está habilitado
                    //habilita o particular(não vai selecionar apenas habilitar)
                    filterStore.setVendorType(vendorTypeParticular);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: filterStore.isTypeParticular
                          ? Colors.purple
                          : Colors.transparent,
                      border: Border.all(
                        color: filterStore.isTypeParticular
                            ? Colors.purple
                            : Colors.grey,
                      )),
                  child: Text(
                    'Particular',
                    style: TextStyle(
                      color: filterStore.isTypeParticular
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  //se professional já está habilitado 
                  if (filterStore.isTypeProfessional) {
                    //se particular também está habilitado
                    if(filterStore.isTypeParticular){
                      //desabilita professional, pois uma das opções está habilitada
                      filterStore.resetVendorType(vendorTypeProfessional);
                    }else{
                      //habilita somente o prefessional
                      //o selectVendorType habilita só um e desabilita o outro
                      filterStore.selectVendorType(vendorTypeParticular);
                    }                             
                  } else {
                    //se ele não está habilitado
                    //habilita o professional
                    filterStore.setVendorType(vendorTypeProfessional);
                  }
                },
                child: Container(                 
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: filterStore.isTypeProfessional
                          ? Colors.purple
                          : Colors.transparent,
                      border: Border.all(
                        color: filterStore.isTypeProfessional
                            ? Colors.purple
                            : Colors.grey,
                      )),
                  child: Text(
                    'Profissional',
                    style: TextStyle(
                      color: filterStore.isTypeProfessional
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
