import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'action.dart';
import 'app_state.dart';

// ignore: prefer_function_declarations_over_variables
ThunkAction<AppState> fetchTime = (Store<AppState> store) async {

  List<dynamic> locations;

  try {
    Response response = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/'));
    locations = jsonDecode(response.body);
  }catch(e){
    print('caught error: $e');
    return;
  }

  String time;
  String location = locations[Random().nextInt(locations.length)] as String;
  try {
    Response response = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/$location'));
    Map data = jsonDecode(response.body);

    String dateTime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);

    DateTime date = DateTime.parse(dateTime);
    date = date.add(Duration(hours: int.parse(offset)));
    time = DateFormat.jm().format(date);
  }catch(e){
    print('caught error: $e');
    time = "could not fetch time data";
    return;
  }

  List<String> val = location.split("/");
  location = "${val[1]}, ${val[0]}";
  print(locations);
  store.dispatch(FetchTimeAction(location, time));

};