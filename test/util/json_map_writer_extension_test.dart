import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/util/json_map_writer_extension.dart';

void main() {
  const String testValueFlag = 'TEST_VALUE_FLAG';
  Map<String, dynamic> testMap = {
    'key0': 'value0',
    'key1': {
      'key10': 'value10',
      'key11': 'value11',
      'key12': ['value120', 'value121', 'value122']
    },
    'key2': ['value20', 'value21', 'value22', 'value23'],
    'key3': [
      {'key30': 'value30'},
      {'key31': 'value31'}
    ]
  };

  test('Write string to Map path which last component is key', () {
    testMap.write(r'$.["key3"].[1].["key31"]', testValueFlag);
    expect(testMap['key3'][1]['key31'], testValueFlag);
  });

  test('Write string to Map path which last component is number', () {
    testMap.write(r'$.["key1"].["key12"].[2]', testValueFlag);
    expect(testMap['key1']['key12'][2], testValueFlag);
  });
}
