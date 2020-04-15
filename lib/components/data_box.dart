import 'package:covid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DataBox extends StatelessWidget {
  final String title;
  final Icon icon;
  final Color color;
  final int number;
  final Function onPressed;
  final bool isDark;

  DataBox({
    @required this.title,
    @required this.number,
    @required this.icon,
    @required this.isDark,
    @required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: kBoxesRadius,
            color: isDark ? kBoxDarkColor : kBoxLightColor,
          ),
          child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: color,
                        child: icon,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                    title,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)
                  ),
                ],
                  ),
                   Divider(thickness: .4, color: Colors.blueGrey[200]),
                SizedBox(height: 10),
                      number == null
                          ? SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: color,
                                  ),
                                );
                              },
                            )
                          : Center(child: Text(
                              '$number',
                              style:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                            ),),
                ],
              ),
          ),
    );
  }
}
