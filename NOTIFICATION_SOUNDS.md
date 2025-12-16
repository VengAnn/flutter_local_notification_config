# 🔊 Custom Notification Sounds Guide

This project now supports **10 different custom notification sounds** from the assets folder!

## 🎵 Available Sounds

All sounds are stored in `assets/sounds/` and automatically work on both Android and iOS:

| Sound            | Emoji | Use Case                      |
| ---------------- | ----- | ----------------------------- |
| **beep**         | 🔔    | Default simple notification   |
| **alarm**        | 🚨    | Urgent alerts                 |
| **bell**         | 🔔    | Classic bell sound            |
| **chime**        | ✨    | Musical notification          |
| **ding**         | 📍    | Single tone alert             |
| **alert**        | ⚠️    | High priority alerts          |
| **notification** | 💬    | Gentle notification           |
| **pop**          | 💥    | Quick notification            |
| **ping**         | 🌐    | Network/message notifications |
| **whistle**      | 🎵    | Pleasant notification         |

## 📁 File Structure

```
assets/
└── sounds/
    ├── beep.wav
    ├── alarm.wav
    ├── bell.wav
    ├── chime.wav
    ├── ding.wav
    ├── alert.wav
    ├── notification.wav
    ├── pop.wav
    ├── ping.wav
    └── whistle.wav
```

## ✅ Setup (Already Configured)

The following are already set up in this project:

1. ✅ `assets/sounds/` directory created with all 10 sound files
2. ✅ `pubspec.yaml` configured to include `assets/sounds/`
3. ✅ `notification_service.dart` updated to use asset sounds
4. ✅ `main.dart` updated with UI buttons for all sounds

## 🎯 Usage Examples

### Basic Usage (Default Beep Sound)

```dart
NotificationService.instance.showNotification(
  id: 1,
  title: 'Hello!',
  body: 'Uses default beep sound',
);
```

### Using Different Sounds

```dart
// Alarm sound
NotificationService.instance.showNotification(
  id: 1,
  title: 'Urgent!',
  body: 'This uses the alarm sound',
  soundName: 'alarm',
);

// Bell sound
NotificationService.instance.showNotification(
  id: 2,
  title: 'Reminder',
  body: 'This uses the bell sound',
  soundName: 'bell',
);

// Chime sound
NotificationService.instance.showNotification(
  id: 3,
  title: 'Update',
  body: 'This uses the chime sound',
  soundName: 'chime',
);
```

### Scheduled Notifications with Custom Sounds

```dart
// Schedule with alarm sound
NotificationService.instance.scheduleOnce(
  id: 10,
  title: 'Appointment',
  body: 'Your appointment in 5 minutes',
  dateTime: DateTime.now().add(Duration(minutes: 5)),
  soundName: 'alert',
);

// Daily reminder with bell sound
NotificationService.instance.scheduleDaily(
  id: 20,
  title: 'Good Morning',
  body: 'Start your day',
  hour: 8,
  minute: 0,
  soundName: 'bell',
);

// Weekly meeting with alert sound
NotificationService.instance.scheduleWeekly(
  id: 30,
  title: 'Meeting Time',
  body: 'Your weekly meeting',
  weekdays: [1, 3, 5],
  hour: 10,
  minute: 0,
  soundName: 'alert',
);
```

## 🎚️ How to Add Your Own Custom Sounds

### Step 1: Prepare Audio File

- Format: `.wav` (recommended), `.mp3`, `.m4a`, or `.aiff`
- Duration: 0.5 - 3 seconds (ideal)
- Sample rate: 44100 Hz minimum

### Step 2: Add to Assets

```bash
# Copy your custom sound to the sounds folder
cp /path/to/your/sound.wav assets/sounds/my_custom_sound.wav
```

### Step 3: Use in Code

```dart
NotificationService.instance.showNotification(
  id: 1,
  title: 'Title',
  body: 'Body',
  soundName: 'my_custom_sound', // No .wav extension!
);
```

### Step 4: Update pubspec.yaml (if needed)

The `pubspec.yaml` already includes the entire `assets/sounds/` directory:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/sounds/
```

## 🛠️ Creating Custom Sounds Programmatically

### Using FFmpeg (Command Line)

```bash
# Simple beep
ffmpeg -f lavfi -i "sine=frequency=1000:duration=0.5" my_beep.wav

# Complex tone
ffmpeg -f lavfi -i "sine=frequency=1000:duration=0.2, sine=frequency=500:duration=0.2" my_tone.wav

# Trim existing audio
ffmpeg -i original.mp3 -t 2 -q:a 9 my_sound.wav
```

### Using Python

```python
import wave
import math

def create_sound(filename, frequency=800, duration=0.5):
    sample_rate = 44100
    num_samples = int(sample_rate * duration)
    frames = []

    for i in range(num_samples):
        sample = math.sin(2 * math.pi * frequency * i / sample_rate)
        sample = int(sample * 32767 * 0.8)
        frames.append((sample & 0xff).to_bytes(1, 'little'))
        frames.append(((sample >> 8) & 0xff).to_bytes(1, 'little'))

    with wave.open(filename, 'wb') as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(sample_rate)
        f.writeframes(b''.join(frames))

# Create a 1000Hz beep for 0.5 seconds
create_sound('assets/sounds/my_beep.wav', frequency=1000, duration=0.5)
```

## ⚙️ Sound Configuration Details

### Android

- Uses `UriAndroidNotificationSound` with asset URI
- Path: `asset://assets/sounds/soundname.wav`
- Supported formats: WAV, MP3, OGG

### iOS

- Uses sound filename from assets
- Path: `assets/sounds/soundname.wav`
- Supported formats: WAV, M4A, AIFF

### Vibration

Default vibration pattern is configured:

- 0ms delay → 250ms vibrate → 250ms pause → 250ms vibrate

To customize vibration, edit `notification_service.dart`:

```dart
vibrationPattern: const [0, 250, 250, 250],
```

## 🔍 Testing

1. **Hot Reload**:

   ```bash
   flutter pub get
   flutter run
   ```

2. **Test Each Sound**:

   - Use the app's UI buttons to test each sound
   - Check console logs for confirmations

3. **Testing Scheduled Notifications**:
   - Put app in background
   - Wait for notification to appear
   - Sound should play

## ⚠️ Troubleshooting

### Sound Not Playing

**Android:**

- Check device volume isn't muted
- Verify file exists in `assets/sounds/`
- Check file format (.wav recommended)
- Run: `flutter clean && flutter pub get && flutter run`

**iOS:**

- Verify sound file is in `assets/sounds/`
- Check device mute switch (physical switch on left side)
- Try different sound format (.m4a or .aiff)

### File Not Found Error

- Verify filename spelling (case-sensitive!)
- Don't include `.wav` extension in `soundName` parameter
- Rebuild app: `flutter clean && flutter pub get`

### Old Sound Still Playing

- Clear app cache
- Rebuild and reinstall: `flutter run --release`

## 📊 Sound File Sizes

Typical file sizes for 0.5 second sounds:

- WAV (Mono): ~45 KB
- WAV (Stereo): ~90 KB
- MP3: ~5-10 KB
- M4A: ~3-5 KB

## 🎵 Sound Design Tips

- **Keep it short**: 0.5 - 1.5 seconds is ideal
- **Use mono**: Reduces file size
- **Avoid clipping**: Keep amplitude reasonable (80% max)
- **Multiple alerts**: Use different frequencies for distinction
- **Professional sounds**: Use royalty-free sites if needed

## 🔗 Resources

- [FFmpeg Documentation](https://ffmpeg.org/)
- [Freesound.org](https://freesound.org/) - Free sound effects
- [Zapsplat](https://www.zapsplat.com/) - Free sound effects
- [Notification Sound Generator](https://onlinetonegenerator.com/)

## 📝 Notes

- Sound parameter is optional (defaults to 'beep')
- Each method supports custom sounds: `showNotification()`, `scheduleOnce()`, `scheduleDaily()`, `scheduleWeekly()`
- Sounds must be in `assets/sounds/` directory
- Both Android and iOS use the same sound files

---

**Ready to customize your notifications with custom sounds!** 🎵✨
