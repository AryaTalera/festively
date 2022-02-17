import 'package:festively/constants.dart';
import 'package:festively/widgets/country_selection.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:festively/widgets/holiday_info.dart';

Future<dynamic> getAPIData(Uri url) async {
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    String data = response.body;

    return jsonDecode(data);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  List<String> selectedCountries = [];
  SplayTreeMap<String, List<dynamic>> holidays =
      SplayTreeMap<String, List<dynamic>>();
  SplayTreeMap<DateTime, List<dynamic>> holidaysByDate =
      SplayTreeMap<DateTime, List<dynamic>>();
  List<Widget> holidayTiles = [];
  TextEditingController textFieldController = TextEditingController();
  bool isLoading = false;

  Future<void> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? temp = prefs.getStringList('selectedCountries');
    selectedCountries = temp ?? [];
  }

  void getHolidays() async {
    setState(
      () {
        isLoading = true;
      },
    );
    holidays.clear();
    if (selectedCountries.isEmpty) {
      return null;
    } else {
      for (String country in selectedCountries) {
        Uri url = Uri.https(
          'www.googleapis.com',
          '/calendar/v3/calendars/en.${countryAPIMap[country]}#holiday@group.v.calendar.google.com/events',
          {
            'key': googleAPIKey,
          },
        );

        var data = await getAPIData(url);
        for (int i = 0; i < data['items'].length; i++) {
          String holidayName = data['items'][i]['summary'];
          if (holidays.containsKey(holidayName)) {
            if (holidays[holidayName]![1].contains(country) == false) {
              holidays[holidayName]![1].add(country);
            }
          } else {
            DateTime date = DateTime.parse(data['items'][i]['start']['date']);
            holidays[holidayName] = [
              date,
              [country]
            ];
          }
        }
      }
    }
    holidays.forEach(
      (key, value) {
        holidaysByDate[value[0]] = [key, value[1]];
      },
    );

    setState(
      () {
        getHolidayTiles('');
        isLoading = false;
      },
    );
  }

  void getHolidayTiles(query) async {
    AdaptiveThemeMode? theme = await AdaptiveTheme.getThemeMode();
    holidayTiles = [];
    holidaysByDate.forEach(
      (key, value) {
        if (value[0].toLowerCase().contains(query.toLowerCase())) {
          String holidayName = value[0];
          DateTime date = key;
          List<String> countries = value[1];
          holidayTiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  tileColor: theme == AdaptiveThemeMode.dark
                      ? const Color(0xFF80CBC4)
                      : Colors.grey[200],
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AdaptiveTheme.of(context).theme.cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('MMM')
                                        .format(date)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: AdaptiveTheme.of(context)
                                          .theme
                                          .scaffoldBackgroundColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('y').format(date),
                                    style: TextStyle(
                                      color: AdaptiveTheme.of(context)
                                          .theme
                                          .scaffoldBackgroundColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                              color: AdaptiveTheme.of(context)
                                  .theme
                                  .scaffoldBackgroundColor,
                              thickness: 2,
                            ),
                            SizedBox(
                              width: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AdaptiveTheme.of(context)
                                          .theme
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('E').format(date).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AdaptiveTheme.of(context)
                                          .theme
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        countries.join(', '),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme == AdaptiveThemeMode.dark
                              ? AdaptiveTheme.of(context)
                                  .theme
                                  .scaffoldBackgroundColor
                              : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        holidayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme == AdaptiveThemeMode.dark
                              ? AdaptiveTheme.of(context)
                                  .theme
                                  .scaffoldBackgroundColor
                              : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      setState(() {});
                      holidayInfo(context: context, holidayName: holidayName);
                    },
                  )),
            ),
          );
        }
      },
    );
    holidayTiles = holidayTiles;
  }

  void setUp() async {
    await getSharedPrefs();
    if (selectedCountries.isEmpty) {
      holidayTiles = [
        const Center(
          child: Text(
            'No Countries Selected',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
      ];
      setState(() {});
    } else {
      getHolidays();
    }
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<String>? temp = await showDialog(
            context: context,
            builder: (context) => CountryDialog(prefs: prefs),
          );
          if ((temp != null) && (temp != selectedCountries)) {
            selectedCountries = temp;
            if (selectedCountries.isEmpty) {
              holidayTiles = [
                const Expanded(
                    child: Text(
                  'No Countries Selected',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ))
              ];
            } else {
              getHolidays();
            }
          }
        },
        tooltip: 'Add Countries',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.event),
        title: const Text('Festively'),
        actions: [
          IconButton(
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
              setState(() {
                getHolidayTiles('');
              });
            },
            tooltip: 'Toggle theme',
            icon: const Icon(Icons.dark_mode),
          ),
        ],
        bottom: isLoading
            ? PreferredSize(
                child: LinearProgressIndicator(
                  backgroundColor: AdaptiveTheme.of(context)
                      .theme
                      .appBarTheme
                      .backgroundColor,
                  color: Colors.white,
                ),
                preferredSize: const Size.fromHeight(10),
              )
            : PreferredSize(
                child: Container(),
                preferredSize: const Size.fromHeight(0),
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textFieldController,
                  onChanged: (query) {
                    setState(() {
                      getHolidayTiles(query);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          textFieldController.clear();
                          getHolidayTiles('');
                        });
                      },
                    ),
                    hintText: 'Search Holidays',
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: holidayTiles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
