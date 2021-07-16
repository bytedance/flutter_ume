import 'dart:core';

extension JsonMapPathWriter on Map {
  Map write(String path, dynamic value) {
    dynamic obj = this;
    dynamic root = this;
    final elements = path.split('.');
    for (final element in elements.sublist(0, elements.length - 1)) {
      if (element == r'$') continue;
      if (RegExp(r'\[[0-9]+\]').hasMatch(element)) {
        final index = int.parse(RegExp(r'\d+').stringMatch(element));
        obj = obj[index];
        continue;
      }
      if (RegExp(r'\["[0-9a-zA-Z]+"]').hasMatch(element)) {
        final key = RegExp(r'[0-9a-zA-Z]+').stringMatch(element);
        obj = obj[key];
        continue;
      }
    }
    final lastKey = elements.last;
    if (RegExp(r'\[[0-9]+\]').hasMatch(lastKey)) {
      final index = int.parse(RegExp(r'\d+').stringMatch(lastKey));
      obj[index] = value;
    } else if (RegExp(r'\["[0-9a-zA-Z]+"]').hasMatch(lastKey)) {
      final key = RegExp(r'[0-9a-zA-Z]+').stringMatch(lastKey);
      obj[key] = value;
    }

    return root;
  }
}
