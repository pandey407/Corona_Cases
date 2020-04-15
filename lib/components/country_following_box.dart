import 'package:covid/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:covid/translator/app_translations.dart';

class CountryMonitoringBox extends StatelessWidget {
  final String country;
  final int numberOfCases;
  final Function onPressed;
  final Function toDelete;
  final bool isDark;
  final NetworkImage countryFlag;
  CountryMonitoringBox({
    @required this.countryFlag,
    @required this.isDark,
    @required this.country,
    this.numberOfCases = 0,
    @required this.onPressed,
    @required this.toDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        final bool res = await showDialog(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: kBoxesRadius),
              backgroundColor: isDark ? Colors.blueGrey[900] : Colors.white,
              title: Text(AppLocalizations.of(context).translate('unfollow')),
              content: Text(
                AppLocalizations.of(context).translate('remove') +
                    country.toUpperCase() +
                    AppLocalizations.of(context).translate('fromList'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('no')),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('yes')),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            );
          },
        );
        return res;
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(country),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          toDelete();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? kBoxDarkColor : kBoxLightColor,
          borderRadius: kBoxesRadius,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: countryFlag,
          ),
          title: Text(
            country,
            style: TextStyle(fontSize: 22),
          ),
          trailing: Text(
            '$numberOfCases',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          onTap: onPressed,
        ),
      ),
      background: Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(FontAwesomeIcons.trash),
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: kBoxesRadius,
        ),
      ),
    );
  }
}
