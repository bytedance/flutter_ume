import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        actions: [
          IconButton(
            onPressed: () => context.read<UMESwitch>().trigger(),
            icon: Icon(context.read<UMESwitch>().enable
                ? Icons.light
                : Icons.light_sharp),
          ),
        ],
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
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
            TextButton(
              child: const Text('Awesome_dialog show dialog'),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO_REVERSED,
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  width: 280,
                  buttonsBorderRadius: BorderRadius.all(
                    Radius.circular(2),
                  ),
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'INFO',
                  desc: 'Dialog description here...',
                  showCloseIcon: true,
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();
              },
            ),
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
        ),
      ),
    );
  }
}
