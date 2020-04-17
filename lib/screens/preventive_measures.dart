import 'package:covid/bloc_navigation_bloc/navigation_bloc.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:covid/components/medical.dart';
import 'package:provider/provider.dart';

class PreventiveMeasures extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final isDark = theme.darkTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text(AppLocalizations.of(context).translate('preventiveMeasures')),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: preventivemeasures(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget preventivemeasures(BuildContext context, bool isDark) {
    return ListView(
      children: <Widget>[
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('washHands'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/handwash.png'),
          message: AppLocalizations.of(context).translate('washHands_m'),
        ),
        ListItem(
            isDark: isDark,
            title: AppLocalizations.of(context).translate('socialDistance'),
            align: Alignment.centerRight,
            image: AssetImage('assets/images/distance.png'),
            message:
                AppLocalizations.of(context).translate('socialDistance_m')),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('handshakes'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/handshake.png'),
          message: AppLocalizations.of(context).translate('handshakes_m'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('wearMasks'),
          align: Alignment.centerRight,
          image: AssetImage('assets/images/mask.png'),
          message: AppLocalizations.of(context).translate('wearMasks_m'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('avoidGathering'),
          align: Alignment.centerLeft,
          image: AssetImage('assets/images/social.png'),
          message: AppLocalizations.of(context).translate('avoidGathering_m'),
        ),
        ListItem(
          isDark: isDark,
          title: AppLocalizations.of(context).translate('medicalAssistance'),
          align: Alignment.centerRight,
          image: AssetImage('assets/images/medical.png'),
          message:
              AppLocalizations.of(context).translate('medicalAssistance_m'),
        ),
      ],
    );
  }
}
