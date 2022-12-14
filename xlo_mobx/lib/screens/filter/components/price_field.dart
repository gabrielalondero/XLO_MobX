import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatelessWidget {
  const PriceField({super.key, required this.label, required this.onChanged, this.inicialValue});

  final String label;
  final Function(int?) onChanged;
  final int? inicialValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        onChanged: (text){
          //paga o texto, tira os pontos e trasforma em int, e enviar para a função onChanged
          onChanged(int.tryParse(text.replaceAll('.', '')));
        },
        initialValue: inicialValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          prefixText: 'R\$ ',
          border: const OutlineInputBorder(),
          isDense: true
        ),
        style: const TextStyle(fontSize: 16),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          RealInputFormatter(),
        ],
      ),
    );
  }
}