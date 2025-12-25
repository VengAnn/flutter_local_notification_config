# iOS Notification Sounds

Place custom notification sound files here:

## Supported Formats:

- `.wav` (recommended)
- `.aiff`
- `.caf` (Core Audio Format)

## Requirements:

- Maximum 30 seconds duration
- Sample rate: 8-48 kHz
- Bit depth: 8 or 16-bit

## Example Files:

- `notification.wav` - Default notification sound
- `alert.wav` - Alert sound
- `chime.wav` - Gentle chime
- `beep.wav` - Simple beep

## Usage in Code:

```dart
sound: 'notification.wav',  // Include file extension for iOS
```

## Adding to Xcode:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click `Runner` → "Add Files to Runner..."
3. Select sound files from this directory
4. Check "Copy items if needed"
5. Ensure "Runner" target is selected
