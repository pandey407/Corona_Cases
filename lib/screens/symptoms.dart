import 'package:covid/bloc_navigation_bloc/navigation_bloc.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:covid/components/medical.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:provider/provider.dart';

class Symptoms extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final isDark = theme.darkTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate('symptoms'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: symptoms(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget symptoms(BuildContext context, bool isDark) {
    return ListView(
      children: <Widget>[
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('highFever'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/fever.png'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('dryCough'),
          align: Alignment.centerRight,
          image: AssetImage('assets/images/cough.png'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('soreThroat'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/sore.png'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('shortBreath'),
          align: Alignment.centerRight,
          image: AssetImage('assets/images/breath.png'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('fatigue'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/fatigue.png'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('headAche'),
          align: Alignment.centerRight,
          image: AssetImage('assets/images/headache.png'),
        ),
      ],
    );
  }
}
