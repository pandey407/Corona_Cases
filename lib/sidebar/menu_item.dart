import 'package:flutter/material.dart';

import '../constants.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool isDark;

  const MenuItem({Key key, this.icon, this.title, this.onTap, this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? kBoxDarkColor : kBoxLightColor,
        borderRadius: kBoxesRadius,
      ),
      child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blue,
          ),
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: onTap),
    );
  }
}
