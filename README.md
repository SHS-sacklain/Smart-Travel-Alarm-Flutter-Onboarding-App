# 🌍 Smart Travel Alarm — Flutter Onboarding App

A beautifully designed Flutter onboarding app with location access and alarm/notification features, built to match the provided Figma design.

---
## 🗂️ Project Structure

```
lib/
├── common_widgets/
│   └── alarm_card.dart           # Reusable alarm list item
├── constants/
│   ├── app_colors.dart           # Color palette from Figma
│   ├── app_text_styles.dart      # Typography styles
│   └── app_strings.dart          # All string constants + onboarding data
├── features/
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── location/
│   │   └── location_screen.dart
│   └── home/
│       ├── alarm_model.dart      # Hive model
│       ├── alarm_model.g.dart    # Generated adapter
│       ├── alarm_provider.dart   # ChangeNotifier state
│       └── home_screen.dart
├── helpers/
│   ├── location_service.dart     # Geolocator + Geocoding
│   └── notification_service.dart # flutter_local_notifications
└── main.dart

---
## 📦 Packages Used

Package 
provider
geolocator
geocoding
permission_handler
flutter_local_notifications
timezone
 hive + hive_flutter
smooth_page_indicator

## 🎨 Design

Figma: [Test-01 Design File](https://www.figma.com/design/FbHsUNPJ3tRWWdvh32cmh0/Test-01-%7C%7C-Figma?node-id=2001-183)

---
## 📋 Notes

- Long-press an alarm card to delete it
- Alarms are persisted using Hive and survive app restarts
