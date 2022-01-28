import 'package:flutter/material.dart';
import 'package:flutter_ume_kit_dio/src/net/dio_manager.dart';

class SendRobotButton extends StatefulWidget {
  final String uri;
  final String requestData;
  final String responseBody;
  final String requestHeader;
  final String duration;
  final String statusCode;
  final String method;

  SendRobotButton({
    Key? key,
    required this.uri,
    required this.requestData,
    required this.responseBody,
    required this.requestHeader,
    required this.duration,
    required this.statusCode,
    required this.method,
  }) : super(key: key);

  @override
  _SendRobotButtonState createState() {
    return _SendRobotButtonState();
  }
}

class _SendRobotButtonState extends State<SendRobotButton> {
  String status = initial;

  static const initial = 'initial';
  static const sending = 'sending';
  static const success = 'success';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DioManager.instance.useBot
        ? Row(
            children: [
              _sendRobotButton(),
              SizedBox(width: 4),
              _status(),
            ],
          )
        : SizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget _sendRobotButton() {
    return TextButton(
      onPressed: send,
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
      child: const Text(
        'Send to robot',
        style: TextStyle(fontSize: 12, height: 1.2),
      ),
    );
  }

  Widget _status() {
    switch (status) {
      case sending:
        return SizedBox(width: 10, height: 10, child: CircularProgressIndicator());
      case success:
        return Text('done');
      default:
        return SizedBox(
          width: 0,
          height: 0,
        );
    }
  }

  Future<void> send() async {
    setState(() {
      status = sending;
    });

    await DioManager.instance.sendResponse(
      uri: widget.uri,
      requestData: widget.requestData,
      responseBody: widget.responseBody,
      requestHeader: widget.requestHeader,
      duration: widget.duration,
      statusCode: widget.statusCode,
      method: widget.method,
    );
    setState(() {
      status = success;
    });
  }
}
