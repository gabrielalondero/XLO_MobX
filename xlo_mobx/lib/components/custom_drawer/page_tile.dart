// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PageTile extends StatelessWidget {
  const PageTile({
    Key? key,
    required this.label,
    required this.iconData,
    required this.onTap,
    required this.highlighted,
  }) : super(key: key);

  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        //se highlighted for true, ou seja, se estivermos na página da sessão
        color: highlighted ? Colors.purple : Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: highlighted ? Colors.purple : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
