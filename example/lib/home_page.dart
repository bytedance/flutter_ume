import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

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
                    : Icons.light_sharp))
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
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'))
                      ],
                    ),
                    // useRootNavigator: false
                  ); // <===== It's very IMPORTANT!
                },
                child: const Text('Show Dialog')),
            TextButton(
                onPressed: () {
                  Get.defaultDialog(
                      textCancel: 'Cancel', onCancel: () => Get.back());
                },
                child: const Text('GetX show dialog')),
            TextButton(
                child: const Text('Awesome_dialog show dialog'),
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO_REVERSED,
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    width: 280,
                    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                    headerAnimationLoop: false,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'INFO',
                    desc: 'Dialog description here...',
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  )..show();
                }),
          ],
        )));
  }
}
