import 'package:covid/constants.dart';
import 'package:covid/providers/following.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:flutter/material.dart';

class Country extends StatelessWidget {
  final Following country;
  final bool isDark;
  Country({@required this.isDark, @required this.country});
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text(country.country),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[allcases(context),todaycases(context),],),
    );
  }
   Container allcases(BuildContext context) {
      return Container(
        margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDark ? kBoxDarkColor : kBoxLightColor,
              borderRadius: kBoxesRadius,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('overall'),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: .5, color: Colors.blueGrey[200]),
                SizedBox(height: 15),
                singlerow('cases', context,'${country.cases}'),
                SizedBox(height: 5,),
                singlerow('deaths', context,'${country.deaths}'),
                SizedBox(height: 5,),
                singlerow('recovered', context,'${country.recovered}'),
                SizedBox(height: 5,),
                singlerow('critical', context,'${country.critical}'),
                SizedBox(height: 5,),
              ],
            ),
      );
  }

     Container todaycases(BuildContext context) {
      return Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDark ? kBoxDarkColor : kBoxLightColor,
              borderRadius: kBoxesRadius,
            ),
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).translate('last24'),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: .5, color: Colors.blueGrey[200]),
                SizedBox(height: 15),
                singlerow('cases', context,'${country.todayCases}'),
                SizedBox(height: 5,),
                singlerow('deaths', context,'${country.todayDeaths}'),
                SizedBox(height: 5,),
              ],
            ),
      );
    }

    Widget singlerow(String key, BuildContext context, String dataget)
  {
    return Row(
    children:<Widget>[
            Text(AppLocalizations.of(context).translate(key)+':',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            SizedBox(width:10),
            Text(dataget,style: TextStyle(fontSize: 18)),
          ],);
  }
}
