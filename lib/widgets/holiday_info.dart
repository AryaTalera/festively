import 'package:festively/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:festively/constants.dart';
import 'package:url_launcher/url_launcher.dart';

holidayInfo({
  required BuildContext context,
  required String holidayName,
}) {
  dynamic text = const CircularProgressIndicator();
  dynamic image = const Image(
    image: AssetImage(
      'assets/image_placeholder.gif',
    ),
    height: 200,
    width: double.infinity,
    fit: BoxFit.cover,
  );
  String buttonText = 'Loading...';
  String buttonURL = '';

  void getHolidayInfo(setModalState) async {
    String title = holidayName;
    Uri url = Uri.https(
      'kgsearch.googleapis.com',
      '/v1/entities:search',
      {
        'key': googleAPIKey,
        'limit': '1',
        'query': holidayName,
      },
    );
    var data = await getAPIData(url);
    try {
      image = Image(
        image: NetworkImage(
          data['itemListElement'][0]['result']['image']['contentUrl'],
        ),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
      buttonURL =
          data['itemListElement'][0]['result']['detailedDescription']['url'];
      buttonText = 'Wikipedia';
      title = buttonURL.split('/').last;
    } catch (e) {
      buttonText = 'No Wikipedia Page';
      url = Uri.https(
        'en.wikipedia.org',
        '/w/api.php',
        {
          'action': 'query',
          'prop': 'pageimages',
          'format': 'json',
          'piprop': 'original',
          'titles': holidayName,
          'formatversion': '2',
        },
      );
      data = await getAPIData(url);
      try {
        image = Image(
          image: NetworkImage(
            data['query']['pages'][0]['original']['source'],
          ),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } catch (e) {
        image = Container(
          alignment: Alignment.center,
          color: Colors.grey,
          height: 200,
          width: double.infinity,
          child: const Text('No Image Available'),
        );
      }
    }

    url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      {
        'action': 'query',
        'prop': 'extracts',
        'format': 'json',
        'exintro': '',
        'explaintext': '',
        'titles': title,
        'formatversion': '2',
      },
    );
    data = await getAPIData(url);

    try {
      text = Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 75),
          child: Text(
            data['query']['pages'][0]['extract'],
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Lexend Deca',
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 20,
          ),
        ),
      );
    } catch (e) {
      text = const Text(
        'No description available',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    setModalState(() {});
  }

  void launchURL() async {
    if (!await launch(buttonURL)) throw 'Could not launch $buttonURL';
  }

  return showBarModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          getHolidayInfo(setModalState);
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: launchURL,
              icon: const Icon(Icons.language),
              label: Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: image,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    holidayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  text,
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
