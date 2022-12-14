import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/components/custom_button/custom_button.dart';
import 'package:xlo_mobx/screens/signup/components/field_title.dart';
import 'package:flutter/services.dart';
import 'package:xlo_mobx/stores/signup_store.dart';

import '../../components/error_box.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpStore signUpStore = SignUpStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            //para aparecer a sombra do card, pois o SingleChildScrollView cortou
            padding: const EdgeInsets.only(bottom: 16, top: 10),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Observer(builder: (_){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ErrorBox(
                          message: signUpStore.error,
                        ),
                      );
                    }),
                    const FieldTitle(
                      title: 'Apelido',
                      subtitle: 'Como aparecerá em seus anúncios',
                    ),
                    Observer(builder: (_) {
                      return TextField(
                        enabled: !signUpStore
                            .loading, //fica habilitado somente quando não está carregando
                        onChanged: signUpStore.setName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          isDense: true, //deixa mais baixo o input
                          hintText: 'Exemplo: João S.',
                          errorText: signUpStore.nameError,
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    const FieldTitle(
                      title: 'E-mail',
                      subtitle: 'Enviaremos um e-mail de confirmação',
                    ),
                    Observer(builder: (_) {
                      return TextField(
                        enabled: !signUpStore.loading,
                        onChanged: signUpStore.setEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          isDense: true, //deixa mais baixo o input
                          hintText: 'Exemplo: joao@gmail.com',
                          errorText: signUpStore.emailError,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false, //tira a autocorreção da digitação
                      );
                    }),
                    const SizedBox(height: 16),
                    const FieldTitle(
                      title: 'Celular',
                      subtitle: 'Proteja sua conta',
                    ),
                    Observer(builder: (_) {
                      return TextField(
                        enabled: !signUpStore.loading,
                        onChanged: signUpStore.setPhone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          isDense: true, //deixa mais baixo o input
                          hintText: '(00) 00000-0000',
                          errorText: signUpStore.phoneError,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, //deixa digitar somente digitos (sem caracteres especiais)
                          TelefoneInputFormatter(), //formata para a forma de telefone BR
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    const FieldTitle(
                      title: 'Senha',
                      subtitle: 'Use letras, números e caracteres especiais',
                    ),
                    Observer(builder: (_) {
                      return TextField(
                        enabled: !signUpStore.loading,
                        onChanged: signUpStore.setPass1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          isDense: true, //deixa mais baixo o input
                          errorText: signUpStore.pass1Error,
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                      );
                    }),
                    const SizedBox(height: 16),
                    const FieldTitle(
                      title: 'Confirmar senha',
                      subtitle: 'Repita a senha',
                    ),
                    Observer(builder: (_) {
                      return TextField(
                        enabled: !signUpStore.loading,
                        onChanged: signUpStore.setPass2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          isDense: true, //deixa mais baixo o input
                          errorText: signUpStore.pass2Error,
                        ),
                        obscureText: true,
                      );
                    }),
                    Observer(builder: (_) {
                      return CustomButton(
                        widget: signUpStore.loading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                            : const Text(
                                'CADASTRAR',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed:
                            signUpStore.signUpPressed as void Function()?,
                      );
                    }),
                    const Divider(color: Colors.black45),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'Já tem uma conta? ',
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: Navigator.of(context)
                                .pop, //volta para a página anterior
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.purple,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
