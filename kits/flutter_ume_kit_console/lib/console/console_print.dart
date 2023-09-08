import 'console_manager.dart';

/// Print the message to the console.
void consolePrint(String message) {
  ConsoleManager.streamController!.add(message);
}
