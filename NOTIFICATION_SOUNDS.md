# 🔊 Flutter Local Notifications - Complete Configuration Guide

## 🚀 Quick Commands

```bash
# Install dependencies and run
flutter pub get && flutter run

# Build release APK with all optimizations
flutter build apk --release

# Clean and rebuild (after config changes)
flutter clean && flutter pub get && flutter build apk --release

# Test on specific device
flutter devices
flutter run -d [device_id]
```

---

## 📱 Platform Configurations Status

### ✅ Android Setup - COMPLETE

- [x] **Permissions**: POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, VIBRATE, RECEIVE_BOOT_COMPLETED, USE_FULL_SCREEN_INTENT
- [x] **Gradle**: compileSdk 35, desugaring enabled, ProGuard configured
- [x] **Manifest**: All receivers, foreground service, action broadcast receiver
- [x] **ProGuard**: GSON rules, notification classes protected
- [x] **Resources**: Keep configuration for release builds

### ✅ iOS Setup - COMPLETE

- [x] **AppDelegate**: Plugin registrant callback for background actions
- [x] **Delegate**: UNUserNotificationCenterDelegate configured
- [x] **Imports**: flutter_local_notifications imported
- [x] **Background**: Full background notification support

### ✅ Flutter Code - COMPLETE

- [x] **Dependencies**: Latest flutter_local_notifications ^19.5.0
- [x] **Timezone**: Initialization and local timezone detection
- [x] **Permissions**: Android runtime permission handling
- [x] **Service**: Complete NotificationService implementation
- [x] **Callbacks**: Foreground and background notification handlers

---

## 🔊 Custom Notification Sounds

### Android Sound Setup

```
📁 android/app/src/main/res/raw/
├── beep.mp3          # Simple beep sound
├── alert.wav         # Alert notification
├── chime.ogg         # Gentle chime
└── notification.mp3  # Default sound
```

**Usage in Code:**

```dart
sound: RawResourceAndroidNotificationSound('beep'), // No extension
```

### iOS Sound Setup

```
📁 ios/Runner/Resources/ (via Xcode)
├── beep.wav          # iOS compatible format
├── alert.aiff        # AIFF format
├── chime.caf         # Core Audio format
└── notification.wav  # Default sound
```

**Usage in Code:**

```dart
sound: 'beep.wav', // Include extension for iOS
```

---

## 🔧 Key Configuration Details

### Android Manifest Features

```xml
<!-- Full-screen intent notifications -->
<activity android:showWhenLocked="true" android:turnScreenOn="true">

<!-- Foreground service with all types -->
<service android:foregroundServiceType="dataSync|mediaPlayback|phoneCall|location|connectedDevice|mediaProcessing|camera|microphone|health|remoteMessaging|systemExempted|shortService|specialUse"/>

<!-- Action support -->
<receiver android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver"/>
```

### iOS AppDelegate Key Features

```swift
// Background notification actions
FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
  GeneratedPluginRegistrant.register(with: registry)
}

// Notification center delegate
UNUserNotificationCenter.current().delegate = self
```

### Flutter Implementation Highlights

```dart
@pragma('vm:entry-point')  // Prevents tree-shaking
void onBackgroundNotificationTap(NotificationResponse response) {
  // Background notification handler
}

// Android 13+ permission request
await android?.requestNotificationsPermission();

// Android 14+ exact alarm permission
await android?.requestExactAlarmsPermission();
```

---

## ⚠️ Platform-Specific Limitations

### Android

- **Samsung**: Max 500 scheduled alarms
- **MIUI/Custom ROMs**: May kill background apps (user must whitelist)
- **Android 13+**: Requires runtime notification permission
- **Android 14+**: Requires exact alarm permission for scheduled notifications

### iOS

- **Pending limit**: Maximum 64 scheduled notifications
- **Sound format**: AIFF, WAV, CAF only (< 30 seconds)
- **Background**: Limited background processing time

---

## 🐛 Troubleshooting Commands

```bash
# Check Flutter environment
flutter doctor -v

# Clean everything and rebuild
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release

# Android verbose build
flutter build apk --release --verbose

# Check APK size and dependencies
flutter build apk --analyze-size
```

---

## 🎯 Testing Checklist

- [ ] Immediate notifications work
- [ ] Scheduled notifications work
- [ ] Custom sounds play correctly
- [ ] Background notification actions work
- [ ] App launches from notification tap
- [ ] Permissions requested properly
- [ ] Release build works with ProGuard
- [ ] Full-screen intent notifications work

---

**Configuration Status**: ✅ COMPLETE - All platform requirements satisfied
**Last Updated**: December 25, 2025
**Package Version**: flutter_local_notifications ^19.5.0
