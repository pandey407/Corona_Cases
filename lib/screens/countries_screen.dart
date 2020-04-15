import 'package:covid/extensions/string_extension.dart';
import 'package:covid/providers/following_data.dart';
import 'package:covid/translator/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';
import 'package:provider/provider.dart';
import 'package:covid/providers/following.dart';

bool isSearching = false;

class Countries extends StatefulWidget {
  Countries({this.countriesList, this.isDark, this.followed});
  final List countriesList;
  final bool isDark;
  final List followed;

  // assign countriesList to a mutable variable so that I can edit it when changing states
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  List filteredCountries = [];
  List myfollowed = [];
  final searchInputController = TextEditingController();
  void findCountry(value) {
    filteredCountries = widget.countriesList
        .where(
          (country) =>
              (country['country'].toLowerCase()).contains(value.toLowerCase()),
        )
        .toList();
    // assign filteredCountries to a list of all the countries containing the entered query
  }

// toggle appbar icon
  GestureDetector toggleAppBarIcon() {
    GestureDetector displayedIcon;
    if (isSearching) {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.cancel,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
            filteredCountries = widget.countriesList;
            // reassign filteredCountries to the initial value when the searchbar is collapsed
          });
        },
      );
    } else {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.search,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
      );
    }
    return displayedIcon;
  }

  @override
  void initState() {
    super.initState();
    myfollowed = widget.followed;
    filteredCountries = widget.countriesList;
    filteredCountries.forEach((country) {
      country['isFollowed'] = false;
      myfollowed.forEach((followed) {
        if (followed.toUpperCase() == country['country'].toUpperCase()) {
          country['isFollowed'] = true;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    filteredCountries = widget.countriesList;
    myfollowed = widget.followed;
    List<Following> followingcountries =
        Provider.of<FollowingData>(context).followings;
    print(followingcountries.length);
    List<Following> toadd = [];
    WidgetsBinding.instance.addPostFrameCallback((_){
      if (followingcountries.length == 0) {
      filteredCountries.forEach((country) {
        if (country['isFollowed']) {
          var newFollow = Following(
              cases: country['cases'],
              country: country['country'],
              critical: country['critical'],
              deaths: country['deaths'],
              recovered: country['recovered'],
              todayCases: country['todayCases'],
              todayDeaths: country['todayDeaths'],
              isFollowed: country['isFollowed'],
              flag: NetworkImage(country['countryInfo']['flag']));
          //print(country['country']);
          toadd.add(newFollow);
        }
        //else{toadd.add(newFollow);}
      });
      //print(toadd.length);
      toadd.forEach((f) async{
        if (!followingcountries.contains(f)) {
          await Provider.of<FollowingData>(context, listen: false).follow(f);
        }
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: widget.isDark ? kBoxDarkColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: searchInputController,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search',
                        ),
                        onChanged: (value) {
                          setState(() {
                            value == ''
                                ? filteredCountries = widget.countriesList
                                : findCountry(
                                    (value.toLowerCase()).capitalize());
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : Text(AppLocalizations.of(context).translate('allCountries')),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: toggleAppBarIcon(),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                var country = filteredCountries[index];
                return CountryDetails(
                  isDark: widget.isDark,
                  country: country,
                  toggle: () {
                    setState(() {
                      country['isFollowed'] = !country['isFollowed'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CountryDetails extends StatelessWidget {
  CountryDetails(
      {@required this.country, @required this.toggle, @required this.isDark});

  final Map country;
  final Function toggle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    List<Following> followingcountries =
        Provider.of<FollowingData>(context).followings;
    /**/
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? kBoxDarkColor : kBoxLightColor,
        borderRadius: kBoxesRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image(
                image: NetworkImage(country['countryInfo']['flag']),
                height: 20,
                width: 25,
              ),
              Flexible(
                child: Text(
                  country['country'].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: !country['isFollowed']
                    ? Icon(Icons.add)
                    : Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                onPressed: () {
                  if (!country['isFollowed']) {
                    var newFollow = Following(
                        cases: country['cases'],
                        country: country['country'],
                        critical: country['critical'],
                        deaths: country['deaths'],
                        recovered: country['recovered'],
                        todayCases: country['todayCases'],
                        todayDeaths: country['todayDeaths'],
                        isFollowed: country['isFollowed'],
                        flag: NetworkImage(country['countryInfo']['flag']));
                    toggle();
                    Provider.of<FollowingData>(context, listen: false)
                        .follow(newFollow);
                  } else {
                    toggle();
                    //Provider.of<FollowingData>(context, listen: false).unfollow(following)
                    followingcountries.forEach((following) {
                      //if(country['country'].toUpperCase()==following.country.toUpperCase())
                      Provider.of<FollowingData>(context, listen: false)
                          .unfollow(following);
                    });
                  }
                },
              )
            ],
          ),
          SizedBox(height: 5),
          Divider(color: Colors.blueGrey[200], thickness: .5),
          SizedBox(height: 15),
          singlerow('cases', context),
          SizedBox(
            height: 5,
          ),
          singlerow('deaths', context),
          SizedBox(
            height: 5,
          ),
          singlerow('recovered', context),
          SizedBox(
            height: 5,
          ),
          singlerow('todayCases', context),
          SizedBox(
            height: 5,
          ),
          singlerow('todayDeaths', context),
          SizedBox(
            height: 5,
          ),
          singlerow('critical', context),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget singlerow(String key, BuildContext context) {
    return Row(
      children: <Widget>[
        Text(AppLocalizations.of(context).translate(key) + ':',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text('${country[key]}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
