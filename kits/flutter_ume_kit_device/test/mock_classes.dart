import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';

class MockAndroidPlatform extends Mock implements Platform {
  @override
  bool get isAndroid => true;

  @override
  bool get isIOS => false;
}

class MockIOSPlatform extends Mock implements Platform {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => true;
}

class MockContext extends Mock implements BuildContext {}
