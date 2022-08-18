import 'package:flutter/material.dart';

class TemplatePageWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBackPressed;

  const TemplatePageWidget({
    Key? key,
    required this.title,
    required this.body,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          if (onBackPressed != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBackPressed,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.navigate_before_rounded,
                  size: 42,
                ),
              ),
            ),
          Expanded(
              child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle(),
                const SizedBox(height: 20),
                buildBody(),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Expanded buildBody() {
    return Expanded(
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12)),
          child: body),
    );
  }

  Text buildTitle() {
    return Text(title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}

class TemplateItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const TemplateItemWidget({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, overflow: TextOverflow.clip)),
            const Icon(
              Icons.navigate_next_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
