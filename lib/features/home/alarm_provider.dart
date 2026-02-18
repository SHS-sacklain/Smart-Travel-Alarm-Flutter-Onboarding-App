import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'alarm_model.dart';

class AlarmProvider extends ChangeNotifier {
  late Box<AlarmModel> _box;
  String _selectedLocation = '';

  List<AlarmModel> get alarms {
    return _box.values.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  String get selectedLocation => _selectedLocation;

  Future<void> init() async {
    _box = Hive.box<AlarmModel>('alarms');
  }

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> addAlarm(DateTime dateTime) async {
    final alarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: dateTime,
      isEnabled: true,
    );
    await _box.put(alarm.id, alarm);
    notifyListeners();
  }

  Future<void> toggleAlarm(AlarmModel alarm) async {
    alarm.isEnabled = !alarm.isEnabled;
    await alarm.save();
    notifyListeners();
  }

  Future<void> deleteAlarm(AlarmModel alarm) async {
    await alarm.delete();
    notifyListeners();
  }
}