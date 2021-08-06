import 'package:flutter/material.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  debugPrint('statement');
                },
                child: const Text('debugPrint')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('detail');
                },
                child: const Text('Push Detail Page')),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text('Dialog'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'))
                            ],
                          ),
                      useRootNavigator: false); // <===== It's very IMPORTANT!
                },
                child: const Text('Show Dialog')),
            TextButton(
              onPressed: () {
                Future.wait<void>(
                  List<Future<void>>.generate(
                    10,
                    (int i) => Future<void>.delayed(
                      Duration(seconds: i),
                      () => dio.get(
                        'https://api.github.com'
                        '/?_t=${DateTime.now().millisecondsSinceEpoch}&$i',
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Make multiple network requests'),
            ),
          ],
        )));
  }
}
