import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../helpers/location_service.dart';
import '../home/alarm_provider.dart';
import '../home/home_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = false;
  String? _locationError;

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = null;
    });

    final location = await LocationService().getCurrentLocation();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (location != null) {
      context.read<AlarmProvider>().setLocation(location);
      _goToHome();
    } else {
      setState(() {
        _locationError = 'Could not fetch location.\nPlease enable location permissions in Settings.';
      });
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),

              const Text(
                AppStrings.locationTitle,
                style: AppTextStyles.locationTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const Text(
                AppStrings.locationSubtitle,
                style: AppTextStyles.locationSubtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: screenHeight * 0.3,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/location_banner.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB8651B),
                            Color(0xFFD4831F),
                            Color(0xFF8B4513),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.white.withOpacity(0.4),
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Error
              if (_locationError != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _locationError!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _useCurrentLocation,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                      : const Icon(Icons.my_location_outlined,
                      color: AppColors.white, size: 18),
                  label: const Text(
                    AppStrings.useCurrentLocation,
                    style: AppTextStyles.buttonText,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _goToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(AppStrings.home, style: AppTextStyles.buttonText),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}