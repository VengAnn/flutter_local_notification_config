# 📱 Flutter Local Notifications Configuration

Complete setup for `flutter_local_notifications` package with all necessary Android and iOS configurations.

## 🚀 Quick Commands

```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release

# Clean and rebuild
flutter clean && flutter pub get && flutter build apk --release
```

## 📦 Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_local_notifications: ^19.5.0 # Latest version
  permission_handler: ^12.0.1 # Android permissions
  timezone: ^0.10.1 # Required for scheduled notifications
  flutter_timezone: ^5.0.1 # Timezone detection
```

---

## 🤖 Android Configuration

### 1. Gradle Setup (`android/app/build.gradle.kts`)

```kotlin
android {
    compileSdk = 35  // ⚠️ REQUIRED minimum for flutter_local_notifications

    compileOptions {
        isCoreLibraryDesugaringEnabled = true  // ⚠️ REQUIRED for scheduled notifications
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles("proguard-rules.pro")  // ProGuard configuration
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")  // ⚠️ REQUIRED
}
```

### 2. AndroidManifest.xml Setup

```xml
<!-- PERMISSIONS -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>

<application>
    <!-- Main Activity - Full-screen intent support -->
    <activity
        android:name=".MainActivity"
        android:showWhenLocked="true"
        android:turnScreenOn="true">
    </activity>

    <!-- SCHEDULED NOTIFICATIONS -->
    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>

    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
            <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
        </intent-filter>
    </receiver>

    <!-- NOTIFICATION ACTIONS -->
    <receiver android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver"/>

    <!-- FOREGROUND SERVICE -->
    <service
        android:name="com.dexterous.flutterlocalnotifications.ForegroundService"
        android:exported="false"
        android:stopWithTask="false"
        android:foregroundServiceType="dataSync|mediaPlayback|phoneCall|location|connectedDevice|mediaProcessing|camera|microphone|health|remoteMessaging|systemExempted|shortService|specialUse"/>
</application>
```

### 3. ProGuard Rules (`android/app/proguard-rules.pro`)

```proguard
# Flutter Local Notifications ProGuard Rules
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# GSON Rules (required)
-keep class com.google.gson.stream.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
```

### 4. Resource Keeping (`android/app/src/main/res/raw/keep.xml`)

```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@drawable/*,@mipmap/*,@raw/*" />
```

---

## 🍎 iOS Configuration

### 1. AppDelegate.swift Setup

```swift
import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ⚠️ REQUIRED for background notification actions
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // ⚠️ REQUIRED for iOS 10+ notification handling
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 2. Info.plist Setup (if needed)

```xml
<!-- Add to ios/Runner/Info.plist if using custom sounds -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

## 🎯 Flutter/Dart Implementation

### Basic Setup in main.dart

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize notifications
  await initNotifications();

  runApp(MyApp());
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onNotificationTap,
    onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
  );
}

void onNotificationTap(NotificationResponse response) {
  print('Notification tapped: ${response.payload}');
}

@pragma('vm:entry-point')
void onBackgroundNotificationTap(NotificationResponse response) {
  print('Background notification tapped: ${response.payload}');
}
```

---

## 🔧 Build Commands by Configuration

### Debug Build

```bash
flutter run
```

### Release Build (Android)

```bash
# Standard release
flutter build apk --release

# Split APK by architecture (smaller files)
flutter build apk --release --split-per-abi

# Bundle for Play Store
flutter build appbundle --release
```

### Release Build (iOS)

```bash
flutter build ios --release
```

### Clean Build (when configuration changes)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## ⚠️ Important Notes

### Android 13+ Permission Handling

```dart
// Request notification permission on Android 13+
final android = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
await android?.requestNotificationsPermission();
```

### Exact Alarm Permission (Android 14+)

```dart
// Request exact alarm permission for scheduled notifications
final android = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
await android?.requestExactAlarmsPermission();
```

### Scheduled Notification Limitations

- **Samsung devices**: Maximum 500 scheduled alarms
- **MIUI/Custom ROMs**: May kill background apps - users need to whitelist
- **iOS**: Maximum 64 pending notifications

---

## 🐛 Troubleshooting

### Release Build Issues

1. **ProGuard**: Ensure `proguard-rules.pro` is properly configured
2. **Resources**: Check `keep.xml` includes all notification resources
3. **Permissions**: Verify all permissions in AndroidManifest.xml

### Notification Not Showing

1. **Android**: Check notification permission granted
2. **iOS**: Check notification permission in Settings
3. **Channel**: Ensure notification channel is created first

### Scheduled Notifications Not Working

1. **Android**: Check exact alarm permission granted
2. **Battery Optimization**: Disable for your app
3. **Custom ROMs**: Whitelist app in autostart/background restrictions

---

## 📚 Useful Commands Reference

```bash
# Check Flutter doctor
flutter doctor

# List all devices
flutter devices

# Install on specific device
flutter install -d <device_id>

# Build with verbose output
flutter build apk --release --verbose

# Check APK size
flutter build apk --analyze-size

# Profile build performance
flutter build apk --release --profile
```

## 🎨 Notification Icons

Place notification icons in:

- `android/app/src/main/res/drawable/notification_icon.png`
- Use white icons with transparent background
- Multiple sizes: 24dp, 36dp, 48dp, 72dp

Create with Android Studio's Image Asset Studio for best results.

---

_Last updated: December 25, 2025_
_flutter_local_notifications version: 19.5.0_
