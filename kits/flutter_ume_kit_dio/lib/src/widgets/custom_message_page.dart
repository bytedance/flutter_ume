import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume_kit_dio/src/net/dio_manager.dart';

class CustomMessagePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'input',
            ),
            controller: _controller,
            minLines: 3,
            maxLines: 100,
          ),
        ),
        SizedBox(height: 12),
        TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                DioManager.instance.sendCustomText(_controller.text);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999999),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              primary: Colors.white,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Container(
              width: 100,
              height: 32,
              alignment: Alignment.center,
              child: Text('Send'),
            ))
      ],
    );
  }
}
