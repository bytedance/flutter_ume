import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/util/json_list_writer_extension.dart';

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
  test('Write string to List path which last component is key. ', () {
    List testList = [];
    testList.add(Map.from(testMap));

    testList.write(r'$.[0].["key1"].["key10"]', testValueFlag);
    expect(testList[0]['key1']['key10'], testValueFlag);
  });

  test('Write string to List path which last component is number.', () {
    List testList = [];
    testList.add(Map.from(testMap));

    testList.write(r'$.[0].["key1"].["key12"].[2]', testValueFlag);
    expect(testList[0]['key1']['key12'][2], testValueFlag);
  });
}
