import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class TextCardContainer extends StatelessWidget {
  const TextCardContainer(
      {Key? key,
      required this.backgroundColor,
      required this.title,
      required this.subtitle,
      required this.details})
      : super(key: key);
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final List<Tuple3<IconData, String, String>> details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 60, left: 20, right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: details
                .map((e) => Container(
                        child: Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(e.item1, size: 22),
                          Text(
                            e.item2,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 22),
                          ),
                          Text(e.item3,
                              maxLines: 3,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Color(0xFF101010), fontSize: 16)),
                        ],
                      ),
                    )))
                .toList()),
      ),
    );
  }
}
