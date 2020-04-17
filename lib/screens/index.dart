import 'dart:async';
import 'dart:convert';
import 'package:covid/bloc_navigation_bloc/navigation_bloc.dart';
import 'package:covid/providers/data_changer.dart';
import 'dart:ui';
import 'package:covid/components/following_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:covid/constants.dart';
import 'package:covid/components/data_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:xlive_switch/xlive_switch.dart';

class Home extends StatefulWidget with NavigationStates {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int totalCases;
  int deaths;
  int recovered;
  int nepalTotal;
  int nepalDeaths;
  int nepalRecovered;
  int nepalActive;
  int nepalTests;
  int numberOfCountries;
  List countries = [];
  List<String> followinglist = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future getData() async {
    http.Response response = await http.get(allCasesAPI);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        totalCases = data['cases'];
        deaths = data['deaths'];
        recovered = data['recovered'];
      });
    } else {
      print(response.statusCode);
    }
  }

  Future getNepalData() async {
    http.Response response = await http.get(nepalCasesAPI);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      Map<String, dynamic> nepalData = jsonDecode(response.body);
      setState(() {
        nepalTotal = nepalData['cases'];
        nepalDeaths = nepalData['deaths'];
        nepalRecovered = nepalData['recovered'];
        nepalActive = nepalData['active'];
        nepalTests = nepalData['tests'];
      });
    }
  }

  @override
  void initState() {
    getData();
    getNepalData();
    Timer.periodic(Duration(hours: 3), (Timer t) => getData());
    Timer.periodic(Duration(hours: 3), (Timer t) => getNepalData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    final data = Provider.of<DataChanger>(context);
    bool isGlobal = data.isglobal;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 15, right: 10, bottom: 10),
            child: ListView(
              children: <Widget>[
                // SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? kBoxDarkColor : kBoxLightColor,
                    borderRadius: kBoxesRadius,
                  ),
                  child: ListTile(
                    leading: Text(
                      AppLocalizations.of(context).translate('nepalReport'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      AppLocalizations.of(context).translate('globalReport'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    title: Consumer<DataChanger>(
                      builder: (context, notifier, child) => XlivSwitch(
                        unActiveColor: Colors.cyan,
                        activeColor: Colors.greenAccent,
                        onChanged: (value) {
                          notifier.setData();
                        },
                        value: notifier.isglobal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (isGlobal)
                  globaldata,
                if (!isGlobal)
                  nepaldata,
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? kBoxDarkColor : kBoxLightColor,
                    borderRadius: kBoxesRadius,
                  ),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.bookMedical,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('symptoms'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      BlocProvider.of<NavigationBloc>(context)
                          .add(SymptomsClickEvent());
                    },
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? kBoxDarkColor : kBoxLightColor,
                    borderRadius: kBoxesRadius,
                  ),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.bookReader,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate('preventiveMeasures'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      BlocProvider.of<NavigationBloc>(context)
                          .add(PreventiveMeasuresClickEvent());
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    AppLocalizations.of(context).translate('followedCountries'),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                FollowingList(isDarkTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds: 3)).then((_) {
      completer.complete();
      setState(() {
        getData();
        getNepalData();
      });
    });

    return completer.future;
  }

  Widget get globaldata {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkTheme ? myBoxDarkColor : myBoxLightColor,
        borderRadius: kBoxesRadius,
      ),
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('globalReport'),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Divider(thickness: 1, color: Colors.blueGrey[200]),
          SizedBox(height: 15),
          Wrap(children: <Widget>[
            DataBox(
              isDark: isDarkTheme,
              title: AppLocalizations.of(context).translate('cases'),
              number: totalCases,
              color: Colors.blue,
              icon: Icon(FontAwesomeIcons.globe, color: Colors.white, size: 20),
            ),
            DataBox(
                isDark: isDarkTheme,
                title: AppLocalizations.of(context).translate('deaths'),
                color: Colors.red,
                icon: Icon(FontAwesomeIcons.skullCrossbones,
                    color: Colors.white, size: 20),
                number: deaths),
            DataBox(
              isDark: isDarkTheme,
              title: AppLocalizations.of(context).translate('recovered'),
              number: recovered,
              color: Colors.green,
              icon: Icon(FontAwesomeIcons.check, color: Colors.white, size: 20),
            ),
          ]),
        ],
      ),
    );
  }

  Widget get nepaldata {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkTheme ? myBoxDarkColor : myBoxLightColor,
        borderRadius: kBoxesRadius,
      ),
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('nepalReport'),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Divider(thickness: 1, color: Colors.blueGrey[200]),
          SizedBox(height: 15),
          Wrap(
            children: <Widget>[
              DataBox(
                isDark: isDarkTheme,
                title: AppLocalizations.of(context).translate('cases'),
                number: nepalTotal,
                color: Colors.blue,
                icon:
                    Icon(FontAwesomeIcons.globe, color: Colors.white, size: 20),
              ),
              DataBox(
                isDark: isDarkTheme,
                title: AppLocalizations.of(context).translate('deaths'),
                color: Colors.red,
                icon: Icon(FontAwesomeIcons.skullCrossbones,
                    color: Colors.white, size: 20),
                number: nepalDeaths,
              ),
            ],
          ),
          DataBox(
            isDark: isDarkTheme,
            title: AppLocalizations.of(context).translate('recovered'),
            number: nepalRecovered,
            color: Colors.green,
            icon: Icon(FontAwesomeIcons.check, color: Colors.white, size: 20),
          ),
          DataBox(
            isDark: isDarkTheme,
            title: AppLocalizations.of(context).translate('active'),
            number: nepalActive,
            color: Colors.deepOrangeAccent,
            icon: Icon(FontAwesomeIcons.affiliatetheme,
                color: Colors.white, size: 20),
          ),
          DataBox(
            isDark: isDarkTheme,
            title: AppLocalizations.of(context).translate('tests'),
            color: Colors.lime,
            icon: Icon(FontAwesomeIcons.notesMedical,
                color: Colors.white, size: 20),
            number: nepalTests,
          ),
        ],
      ),
    );
  }
}
