import 'package:covid/constants.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final AssetImage image;
  final Alignment align;
  final bool isDark;
  final String message;

  ListItem({
    @required this.title,
    @required this.image,
    @required this.align,
    @required this.isDark,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
                      alignment: align,
                      children: <Widget>[
                         Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                          color: isDark ? kBoxDarkColor : kBoxLightColor,
                          borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onTap: (){if (message!=null) {
                         showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context)=>individualinfo(title, message, context));} 
                        }
                      ),
                      ),
                    CircleAvatar(radius: 40,backgroundImage: image,),
                   ],);
  }
   Widget individualinfo(String title, String message, BuildContext context)
  {
    return AlertDialog(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: kBoxesRadius),
                  backgroundColor: isDark ? Colors.blueGrey[900] : Colors.white,
                  title: Text(title),
                  content: Text(message,textAlign: TextAlign.justify,),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate('ok')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
  }
}