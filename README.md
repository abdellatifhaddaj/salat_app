name: salat_app
description: Prayer times app with GPS
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  adhan: ^2.0.0+1
  geolocator: ^10.1.0
  intl: ^0.18.1
  timezone: ^0.9.2
  flutter_local_notifications: ^17.0.0
  permission_handler: ^11.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
