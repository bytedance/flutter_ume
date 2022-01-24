import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final arg =
    //     (ModalRoute.of(context)!.settings.arguments as Map<String, String>?)
    //         .toString(); //?['arg'];
    final args = ModalRoute.of(context)!.settings.arguments;

    print('talisk++$args');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'Pop result from ${this.runtimeType}');
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(args.toString()), //?? 'Detail Page'),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Detail Page'),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Dialog'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                  child: const Text('Show Dialog'))
            ],
          ))),
    );
  }
}
