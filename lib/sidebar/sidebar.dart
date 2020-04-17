import 'dart:async';
import 'dart:convert';

import 'package:covid/providers/following_data.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:covid/translator/language_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xlive_switch/xlive_switch.dart';
import '../bloc_navigation_bloc/navigation_bloc.dart';
import '../constants.dart';
import '../sidebar/menu_item.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSideBarOpenedStreamController;
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenedSink;
  List countriesList = [];
  final _animationDuration = const Duration(milliseconds: 500);
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSideBarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSideBarOpenedStreamController.stream;
    isSideBarOpenedSink = isSideBarOpenedStreamController.sink;
    getCountriesData();
    Timer.periodic(Duration(hours: 3), (Timer t) => getCountriesData());
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSideBarOpenedStreamController.close();
    isSideBarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isSideBarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  Future getCountriesData() async {
    http.Response response = await http.get(affectedCountriesAPI);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      setState(() {
        countriesList = jsonDecode(response.body);
      });
    } else {
      print('Server Error:${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    final isDark = theme.darkTheme;
    List<String> followed = Provider.of<FollowingData>(context).names;
    print(followed);
    return StreamBuilder<bool>(
        initialData: false,
        stream: isSideBarOpenedStream,
        builder: (context, snapshot) {
          return AnimatedPositioned(
            duration: _animationDuration,
            top: 0,
            bottom: 0,
            left: snapshot.data ? 0 : -screenWidth,
            right: snapshot.data ? 0 : screenWidth - 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: isDark ? drawerBoxDarkColor : drawerBoxLightColor,
                    child: ListView(
                      children: [
                        MenuItem(
                          title: AppLocalizations.of(context).translate('home'),
                          icon: FontAwesomeIcons.home,
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(HomePageClickEvent());
                          },
                          isDark: isDark,
                        ),
                        SizedBox(height: 10),
                        MenuItem(
                            title: AppLocalizations.of(context)
                                .translate('allCountries'),
                            icon: FontAwesomeIcons.city,
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  AllCountriesClickEvent(
                                      countriesList: countriesList,
                                      followed: followed,
                                      isDark: isDark));
                            },
                            isDark: isDark),
                        SizedBox(height: 10),
                        MenuItem(
                          title: AppLocalizations.of(context)
                              .translate('symptoms'),
                          icon: FontAwesomeIcons.fileMedical,
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(SymptomsClickEvent());
                          },
                          isDark: isDark,
                        ),
                        SizedBox(height: 10),
                        MenuItem(
                          title: AppLocalizations.of(context)
                              .translate('preventiveMeasures'),
                          icon: FontAwesomeIcons.bookReader,
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(PreventiveMeasuresClickEvent());
                          },
                          isDark: isDark,
                        ),
                        SizedBox(height: 10),
                        MenuItem(
                          title: AppLocalizations.of(context)
                              .translate('changeTheme'),
                          icon: FontAwesomeIcons.themeisle,
                          onTap: () {
                            showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) => themeChange);
                          },
                          isDark: isDark,
                        ),
                        SizedBox(height: 10),
                        MenuItem(
                          title: AppLocalizations.of(context)
                              .translate('changeLanguage'),
                          icon: FontAwesomeIcons.language,
                          onTap: () {
                            showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) => langChange);
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -1),
                  child: GestureDetector(
                    onTap: () {
                      onIconPressed();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(isDark),
                      child: Container(
                        width: 35,
                        height: 110,
                        color:
                            isDark ? drawerBoxDarkColor : drawerBoxLightColor,
                        alignment: Alignment.center,
                        child: AnimatedIcon(
                          icon: AnimatedIcons.menu_home,
                          progress: _animationController.view,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
}

class CustomMenuClipper extends CustomClipper<Path> {
  final bool isDark;

  CustomMenuClipper(this.isDark);

  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = isDark ? myBoxDarkColor : myBoxLightColor;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
