import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({Key? key, required this.title, required this.message})
      : super(key: key);

  final String title;
  final String message;

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    return
        // UMEWidget( child:
        Scaffold(
            appBar: AppBar(
              // Here we take the value from the PlaygroundPage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            body: Center(
              child: Text(widget.message),
            )
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: const Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
            // ),
            );
  }
}
