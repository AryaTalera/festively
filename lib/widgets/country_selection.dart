import 'package:flutter/material.dart';
import 'package:festively/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryDialog extends StatefulWidget {
  final SharedPreferences prefs;
  const CountryDialog({required this.prefs, Key? key}) : super(key: key);

  @override
  _CountryDialogState createState() => _CountryDialogState();
}

class _CountryDialogState extends State<CountryDialog> {
  TextEditingController textFieldController = TextEditingController();
  ScrollController listViewController = ScrollController();
  List<Widget> filteredCountries = [];
  List<String> selectedCountries = [];
  bool cancel = false;

  void getSelectedCountries() {
    List<String>? temp = widget.prefs.getStringList('selectedCountries');
    selectedCountries = temp ?? [];
  }

  void saveSelectedCountries(cancel) {
    cancel
        ? null
        : widget.prefs.setStringList('selectedCountries', selectedCountries);
  }

  @override
  void initState() {
    super.initState();
    getSelectedCountries();
    filteredCountries = getFilteredCountries('');
  }

  @override
  void dispose() {
    saveSelectedCountries(cancel);
    super.dispose();
  }

  List<Widget> getFilteredCountries(String query) {
    int i = 0;
    List<Widget> toReturn = [];
    for (String countryKey in countryAPIMap.keys) {
      if (query.isEmpty ||
          countryKey.toLowerCase().contains(query.toLowerCase())) {
        if (selectedCountries.contains(countryKey)) {
          toReturn.insert(i, countryTile(countryKey, true, query));
          i++;
        } else {
          toReturn.add(countryTile(countryKey, false, query));
        }
      }
    }
    return toReturn;
  }

  SizedBox countryTile(String countryKey, bool selected, String query) {
    return SizedBox(
      height: 50,
      child: ListTile(
        title: Text(countryKey),
        leading: Image(
          image: AssetImage("assets/$countryKey.png"),
          fit: BoxFit.fill,
          height: 30,
          width: 45,
        ),
        trailing: selected
            ? const Icon(
                Icons.remove,
                color: Colors.red,
              )
            : const Icon(
                Icons.add,
                color: Colors.green,
              ),
        onTap: () {
          setState(() {
            if (selectedCountries.contains(countryKey)) {
              selectedCountries.remove(countryKey);
            } else {
              selectedCountries.add(countryKey);
            }
            filteredCountries = getFilteredCountries(query);
            listViewController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Select Country(s)'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          textFieldController.clear();
                          filteredCountries = getFilteredCountries('');
                          listViewController.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        });
                      },
                    ),
                    hintText: 'Search for Countries',
                  ),
                  onChanged: (query) {
                    setState(() {
                      filteredCountries = getFilteredCountries(query);
                      listViewController.jumpTo(0);
                    });
                  },
                ),
                Expanded(
                  child: ListView(
                    controller: listViewController,
                    physics: const BouncingScrollPhysics(),
                    children: filteredCountries,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                cancel = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(selectedCountries),
            ),
          ],
        ),
      ),
    );
  }
}
