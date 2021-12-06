import 'dart:async';

import 'package:flutter/material.dart';

class InfoContainer extends StatefulWidget {
  const InfoContainer(
      {Key? key, required this.imageUrls, required this.backgroundColor})
      : super(key: key);

  final List<String> imageUrls;
  final Color backgroundColor;

  @override
  _InfoContainerState createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  late Timer _timer;
  int _uiKitsImageIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(milliseconds: 4000), (value) {
        _updateImage();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _updateImage() {
    _uiKitsImageIndex = (_uiKitsImageIndex + 1) % widget.imageUrls.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: widget.backgroundColor,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 60, left: 20, right: 20),
        child: Row(
          children: [
            // Image.network(src)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 2000),
              transitionBuilder: (child, animation) {
                return FadeTransition(child: child, opacity: animation);
              },
              child: Image.asset(widget.imageUrls[_uiKitsImageIndex],
                  key: ValueKey<int>(_uiKitsImageIndex)),
            ),
          ],
        ),
      ),
    );
  }
}
