class AppState {
  final String _location;
  final String _time;

  String get location => _location;
  String get time => _time;

  AppState(this._location, this._time);

  AppState.initialState() : _location = "", _time = "00:00";

}