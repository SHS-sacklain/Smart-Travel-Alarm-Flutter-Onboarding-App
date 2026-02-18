import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../common_widgets/alarm_card.dart';
import '../../helpers/notification_service.dart';
import 'alarm_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _lastKnownLocation = '';

  @override
  void initState() {
    super.initState();
    final location = context.read<AlarmProvider>().selectedLocation;
    _locationController.text = location;
    _lastKnownLocation = location;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocation = context.read<AlarmProvider>().selectedLocation;
    if (newLocation != _lastKnownLocation &&
        newLocation != _locationController.text) {
      _lastKnownLocation = newLocation;
      _locationController.text = newLocation;
      _locationController.selection = TextSelection.fromPosition(
        TextPosition(offset: _locationController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _showAddAlarmDialog() async {
    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set Alarm',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: ctx,
                      initialTime: selectedTime,
                      builder: (c, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            surface: AppColors.cardBackground,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (time != null) setDialogState(() => selectedTime = time);
                  },
                  child: _pickerRow(
                    icon: Icons.access_time,
                    label: selectedTime.format(ctx),
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (c, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            surface: AppColors.cardBackground,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (date != null) setDialogState(() => selectedDate = date);
                  },
                  child: _pickerRow(
                    icon: Icons.calendar_today,
                    label:
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel',
                            style: TextStyle(color: AppColors.subtitle)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final alarmDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          if (alarmDateTime.isBefore(DateTime.now())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a future time'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          await context
                              .read<AlarmProvider>()
                              .addAlarm(alarmDateTime);

                          await NotificationService().scheduleNotification(
                            id: alarmDateTime.millisecondsSinceEpoch ~/ 1000,
                            scheduledTime: alarmDateTime,
                            title: '⏰ Travel Alarm',
                            body: 'Time to go! Your alarm is ringing.',
                          );

                          if (mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alarm set successfully!'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Set Alarm',
                            style: TextStyle(color: AppColors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pickerRow({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.alarmCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: AppColors.hintText),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AlarmProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        const Text(
                          AppStrings.selectedLocation,
                          style: AppTextStyles.selectedLocationLabel,
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _locationController,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: AppStrings.addYourLocation,
                              hintStyle: AppTextStyles.hintText,
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: AppColors.hintText,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (val) {

                              _lastKnownLocation = val;
                              provider.setLocation(val);
                            },
                          ),
                        ),
                        const SizedBox(height: 28),

                        const Text(
                          AppStrings.alarms,
                          style: AppTextStyles.selectedLocationLabel,
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: provider.alarms.isEmpty
                              ? _buildEmptyAlarms()
                              : ListView.builder(
                            itemCount: provider.alarms.length,
                            itemBuilder: (context, index) {
                              final alarm = provider.alarms[index];
                              return AlarmCard(
                                alarm: alarm,
                                onToggle: () =>
                                    provider.toggleAlarm(alarm),
                                onDelete: () =>
                                    _confirmDelete(alarm, provider),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAlarmDialog,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  Widget _buildTopBar() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$hour:$minute',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Row(
            children: [
              Icon(Icons.wifi, color: AppColors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.signal_cellular_4_bar, color: AppColors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: AppColors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAlarms() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off_outlined, color: AppColors.hintText, size: 56),
          SizedBox(height: 16),
          Text(
            'No alarms yet',
            style: TextStyle(
                color: AppColors.hintText,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            'Tap + to add your first alarm',
            style: TextStyle(color: AppColors.hintText, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(alarm, AlarmProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Alarm',
            style: TextStyle(color: AppColors.white)),
        content: const Text('Are you sure you want to delete this alarm?',
            style: TextStyle(color: AppColors.subtitle)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
            const Text('Cancel', style: TextStyle(color: AppColors.subtitle)),
          ),
          TextButton(
            onPressed: () async {
              await NotificationService().cancelNotification(
                alarm.dateTime.millisecondsSinceEpoch ~/ 1000,
              );
              await provider.deleteAlarm(alarm);
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}