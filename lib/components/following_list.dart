import 'package:covid/screens/single_country.dart';
import 'package:flutter/material.dart';
import 'package:covid/providers/following_data.dart';
import 'package:provider/provider.dart';
import 'country_following_box.dart';

class FollowingList extends StatelessWidget {
  final bool isDark;
  FollowingList(this.isDark);
  @override
  Widget build(BuildContext context) {
    final followingData = Provider.of<FollowingData>(context);
    var followings= followingData.followings;
      return Column(
        children: followings.map((following) {
          print(followings.length);
          return CountryMonitoringBox(
            countryFlag: following.flag,
            isDark: isDark,
            country: following.country,
            numberOfCases: following.cases,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Country(
                    country: following,
                    isDark: isDark,
                  ),
                ),
              );
            },
            toDelete: () {
              followingData.unfollow(following);},
          );
        }).toList(),
      );
    }
  }

