import 'package:intl/intl.dart';

extension StringExtension on String { //estendendo a String
  bool isEmailValid(){ //colocando nova função na classe String
    final RegExp regex = RegExp(r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    return regex.hasMatch(this); //this é o objeto que tu chamou a função
  }
}


extension NumberExtension on num{ //estendendo o num
  String formattedMoney(){
    //formatando valor em real
    return NumberFormat('R\$ ###,##0.00' , 'pt-BR').format(this);
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate(){
    return DateFormat('dd/MM/yyyy HH:mm', 'pt-BR').format(this);
  }
}