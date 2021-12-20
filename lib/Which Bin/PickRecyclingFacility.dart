import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cleaner_together/Utilities.dart';

class PickRecyclingFacility extends StatefulWidget {
  @override
  PickRecyclingFacilityState createState() => PickRecyclingFacilityState();
}

class PickRecyclingFacilityState extends State<PickRecyclingFacility> {

  final zipController = TextEditingController();
  FocusNode zipNode = new FocusNode();
  var zip = '';

  var possibleCenters = [];
  var possibleCenterIds = [];
  var selectedCenter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick Recycling Center',
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: <Widget>[
            Text(
              'After entering your zip code below, please select your recycling center from the list of centers near you. This allows you get get more accurate recycling information based on your location. Only applicable to US and Canada residents. \n\n *Provided through Earth 911.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              obscureText: false,
              controller: zipController,
              focusNode: zipNode,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme
                      .of(context)
                      .primaryColor, width: 3),
                ),
                labelText: 'Enter Zip Code',
                labelStyle: TextStyle(
                  color: zipNode.hasFocus ? Theme
                      .of(context)
                      .primaryColor : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(zipNode);
                });
              },
              onChanged: (String val) async {
                zip = val;
                fetchRecyclingCenters();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: possibleCenters.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  return Card(
                    child: TextButton(
                      child: Text(
                        possibleCenters[i],
                        style: TextStyle(fontSize: 18.0, color: Theme.of(context).shadowColor),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCenter = possibleCenterIds[i];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: selectedCenter != '',
              child: ButtonTheme(
                child: ElevatedButton(
                  child: Text(
                    'Confirm',
                      style: TextStyle(fontSize: 24.0, backgroundColor: Theme.of(context).backgroundColor, color: Colors.white)
                  ),
                  style: ElevatedButton.styleFrom(primary: Theme.of(context).backgroundColor),
                  onPressed: () {
                    Utilities.save('zip', zip);
                    Utilities.save('recyclingCenter', selectedCenter);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchRecyclingCenters() async {
    if (zip.length == 5) {
      possibleCenters = [];
      possibleCenterIds = [];
      final locationIn = 'http://api.earth911.com/earth911.getPostalData?api_key=783aa93e81e2003e&country=US&postal_code=$zip';
      final lr = json.decode((await http.get(Uri.parse(locationIn))).body);
      final centerInput = 'http://api.earth911.com/earth911.searchPrograms?api_key=783aa93e81e2003e&latitude=${lr['result']['latitude']}&longitude=${lr['result']['longitude']}&max_distance=25';
      final centerResults = json.decode((await http.get(Uri.parse(centerInput))).body);
      print(centerResults);
      setState(() {
        for (int i = 0; i < centerResults['num_results']; i++) {
          print(centerResults['result'][i]['curbside']);
          if (centerResults['result'][i]['curbside']) {
            print(centerResults['result'][i]['description']);
            possibleCenters.add(centerResults['result'][i]['description']);
            possibleCenterIds.add(centerResults['result'][i]['program_id']);
          }
        }
      });
    }
  }
}