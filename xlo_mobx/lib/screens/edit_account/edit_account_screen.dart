import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:xlo_mobx/stores/edit_account_store.dart';
import 'package:xlo_mobx/stores/page_store.dart';

import '../../components/error_box.dart';

class EditAccountScreen extends StatelessWidget {
  EditAccountScreen({super.key});

  final EditAccountStore editAccountStore = EditAccountStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Observer(builder: (_){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ErrorBox(
                          message: editAccountStore.error,
                        ),
                      );
                    }),
                  Observer(builder: (_) {
                     //ignora o toque na região quando o ignoring é true
                    return IgnorePointer(
                        //quando estiver carregando, ignora o toque
                        ignoring: editAccountStore.loading ? true : false,
                      child: LayoutBuilder(builder: (_, constraints) {                      
                        return ToggleSwitch(
                            minWidth: constraints.biggest.width / 2.01,
                            labels: const ['Particular', 'Profissional'],
                            cornerRadius: 20,
                            activeBgColor: const [Colors.purple],
                            inactiveBgColor: Colors.grey,
                            activeFgColor: Colors.white,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: editAccountStore.userType!.index,
                            onToggle: (i) {
                              if (i != null) {
                                editAccountStore.setUserType(i);
                              }
                            });
                      }),
                    );
                  }),
                  const SizedBox(height: 13),
                  Observer(builder: (_) {
                    return TextFormField(
                      initialValue: editAccountStore.name,
                      onChanged: editAccountStore.setName,
                      enabled: !editAccountStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Nome*',
                        errorText: editAccountStore.nameError,
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Observer(builder: (_) {
                    return TextFormField(
                      initialValue: editAccountStore.phone,
                      onChanged: editAccountStore.setPhone,
                      enabled: !editAccountStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Telefone*',
                        errorText: editAccountStore.phoneError,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  Observer(builder: (_) {
                    return TextFormField(
                      onChanged: editAccountStore.setPass1,
                      enabled: !editAccountStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Nova senha',
                        errorText: editAccountStore.pass1Error,
                      ),
                      obscureText: true,
                    );
                  }),
                  const SizedBox(height: 10),
                  Observer(builder: (_) {
                    return TextFormField(
                      onChanged: editAccountStore.setPass2,
                      enabled: !editAccountStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Confirmar nova senha',
                        errorText: editAccountStore.passError,
                      ),
                      obscureText: true,
                    );
                  }),
                  const SizedBox(height: 13),
                  Observer(builder: (_) {
                    return SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: editAccountStore.savePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 0,
                          disabledBackgroundColor: Colors.orange.withAlpha(120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: editAccountStore.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'Salvar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: (){
                        editAccountStore.logout();
                        GetIt.I<PageStore>().setPage(0);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),                         
                        ),
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
