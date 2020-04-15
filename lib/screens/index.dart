import 'dart:async';
import 'dart:convert';
import 'package:covid/providers/data_changer.dart';
//import 'package:covid/providers/following.dart';
import 'dart:ui';
import 'package:covid/screens/preventive_measures.dart';
import 'package:covid/components/following_list.dart';
import 'package:covid/providers/following_data.dart';
import 'package:covid/screens/countries_screen.dart';
import 'package:covid/screens/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid/constants.dart';
import 'package:covid/components/data_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:covid/translator/language_changer.dart';
import 'package:xlive_switch/xlive_switch.dart';

class Home extends StatefulWidget {
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
  List followinglist;
  
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

  Future getCountriesData() async {
    http.Response response = await http.get(affectedCountriesAPI);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      setState(() {
        countries = jsonDecode(response.body);
        numberOfCountries = countries.length;
      });
    } else {
      print('Server Error:${response.statusCode}');
    }
  }

  Future getNepalData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/countries/Nepal');
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

 /*Future getFollowData(follow) async {
    http.Response response = await  http.get('https://corona.lmao.ninja/countries/'+follow);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      Map<String, dynamic> country = jsonDecode(response.body);
      setState(() {
          followinglist.add(Following(
                      cases: country['cases'],
                      country: country['country'],
                      critical: country['critical'],
                      deaths: country['deaths'],
                      recovered: country['recovered'],
                      todayCases: country['todayCases'],
                      todayDeaths: country['todayDeaths'],
                      isFollowed: country['isFollowed'],
                      flag: NetworkImage(country['countryInfo']['flag'])));    
      });
    }
  }*/

  
  @override
  void initState() {
    getData();
    getCountriesData();
    getNepalData();
    Timer.periodic(Duration(hours: 3), (Timer t) => getCountriesData());
    Timer.periodic(Duration(hours: 3), (Timer t) => getData());
    Timer.periodic(Duration(hours: 3), (Timer t) => getNepalData());
    super.initState();
  }
  /*@override
  void didChangeDependencies() {
    myfollow= Provider.of<FollowingData>(context).names;
    if(followinglist!=null)
      followinglist.forEach((country){
      myfollow.forEach((f){
      if(f!=country.country)
        getFollowData(f);
     });
      });

    super.didChangeDependencies();
  }*/
  
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    final data = Provider.of<DataChanger>(context);
    bool isGlobal = data.isglobal;
    followinglist = Provider.of<FollowingData>(context).names;
    //print(followinglist);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
              child: ListView(
                children: [
                  draweritem(AppLocalizations.of(context).translate('home'),
                      FontAwesomeIcons.home, () {
                    Navigator.pop(context);
                  }),
                  SizedBox(height: 10),
                  draweritem(
                    AppLocalizations.of(context).translate('allCountries'),
                    FontAwesomeIcons.city,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Countries(
                            countriesList: countries,
                            isDark: isDarkTheme,
                            followed: followinglist,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  draweritem(
                    AppLocalizations.of(context).translate('symptoms'),
                    FontAwesomeIcons.fileMedical,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Symptoms(isDarkTheme)),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  draweritem(
                    AppLocalizations.of(context)
                        .translate('preventiveMeasures'),
                    FontAwesomeIcons.bookReader,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PreventiveMeasures(isDarkTheme)),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  draweritem(
                      AppLocalizations.of(context).translate('changeTheme'),
                      FontAwesomeIcons.themeisle, () {
                    showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) => themeChange);
                  }),
                  SizedBox(height: 10),
                  draweritem(
                      AppLocalizations.of(context).translate('changeLanguage'),
                      FontAwesomeIcons.language, () {
                    showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) => langChange);
                  }),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: 
                ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isDarkTheme ? kBoxDarkColor : kBoxLightColor,
                          borderRadius: kBoxesRadius,
                        ),
                        child: ListTile(
                          leading: Text(
                            AppLocalizations.of(context)
                                .translate('nepalReport'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            AppLocalizations.of(context)
                                .translate('globalReport'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                      SizedBox(
                        height: 10,
                      ),
                      if (isGlobal) globaldata,
                      if (!isGlobal) nepaldata,
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Symptoms(isDarkTheme)),
                            );
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PreventiveMeasures(isDarkTheme)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('followedCountries'),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
        getCountriesData();
        getNepalData();
      });
    });

    return completer.future;
  }

  Widget draweritem(String title, IconData icon, Function onTap) {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isDarkTheme ? kBoxDarkColor : kBoxLightColor,
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

  Widget get themeChange {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    return AlertDialog(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: kBoxesRadius),
      backgroundColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
      title: Text(AppLocalizations.of(context).translate('themeSelectTitle')),
      content:
          Text(AppLocalizations.of(context).translate('themeSelectContent')),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(FontAwesomeIcons.lightbulb, color: Colors.blueGrey, size: 20),
            Consumer<ThemeChanger>(
              builder: (context, notifier, child) => XlivSwitch(
                activeColor: Colors.blueGrey,
                unActiveColor: Colors.cyan,
                onChanged: (value) {
                  notifier.setTheme();
                },
                value: notifier.darkTheme,
              ),
            ),
            Icon(FontAwesomeIcons.moon, color: Colors.blueGrey, size: 20)
          ],
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('ok')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget get langChange {
    final theme = Provider.of<ThemeChanger>(context);
    bool isDarkTheme = theme.darkTheme;
    return AlertDialog(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: kBoxesRadius),
      backgroundColor: isDarkTheme ? Colors.blueGrey[900] : Colors.white,
      title:
          Text(AppLocalizations.of(context).translate('changeLanguageTitle')),
      content:
          Text(AppLocalizations.of(context).translate('changeLanguageContent')),
      actions: <Widget>[
        Row(
          children: <Widget>[
            Text('English'),
            Consumer<LanguageChanger>(
              builder: (context, notifier, child) => XlivSwitch(
                activeColor: Colors.greenAccent,
                unActiveColor: Colors.cyan,
                value: notifier.isNepali,
                onChanged: (value) {
                  notifier.setLang();
                },
              ),
            ),
            Text('नेपाली'),
          ],
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('ok')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
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
                icon:
                    Icon(FontAwesomeIcons.globe, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Countries(
                        countriesList: countries,
                        isDark: isDarkTheme,
                        followed: followinglist,
                      ),
                    ),
                  );
                },
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
                icon:
                    Icon(FontAwesomeIcons.check, color: Colors.white, size: 20),
              ),
          ] 
          ),
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
                icon:
                    Icon(FontAwesomeIcons.check, color: Colors.white, size: 20),
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
