import 'package:flutter/material.dart';

enum SortStat {
  none,
  ascending,
  descending,
}

class SpEditorWidget extends StatelessWidget {
  final Map<String, dynamic>? object;
  const SpEditorWidget({Key? key, this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return object == null
        ? const Center(
            child: Text('No data'),
          )
        : ListView.builder(
            itemCount: object!.length + 1,
            itemBuilder: (ctx, index) {
              return index == 0
                  ? const _SpEditorTitle()
                  : _SpEditorCell(
                      entire: object!.entries.elementAt(index - 1),
                      index: index - 1,
                    );
            });
  }
}

class _SpEditorTitle extends StatelessWidget {
  const _SpEditorTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        color: Colors.grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: constraints.maxWidth * 0.3,
                height: 32,
                child: const Center(
                  child: Text(
                    'key',
                    style: TextStyle(color: Colors.black87),
                  ),
                )),
            SizedBox(
                width: constraints.maxWidth * 0.7,
                height: 32,
                child: const Center(
                  child: Text(
                    'value',
                    style: TextStyle(color: Colors.black87),
                  ),
                )),
          ],
        ),
      );
    });
  }
}

class _SpEditorCell extends StatelessWidget {
  final MapEntry<String, dynamic> entire;
  final int index;
  const _SpEditorCell({Key? key, required this.entire, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        color: index % 2 == 0 ? Colors.white : Colors.white70,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entire.key),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entire.value.toString()),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SortIcon extends StatelessWidget {
  final SortStat stat;
  const SortIcon({Key? key, this.stat = SortStat.none}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 8,
              child: Transform.translate(
                offset: const Offset(0, -6),
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 24,
                  color: stat == SortStat.ascending
                      ? Colors.blueAccent
                      : Colors.black87,
                ),
              )),
          SizedBox(
              height: 8,
              child: Transform.translate(
                offset: const Offset(0, -6),
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: stat == SortStat.descending
                      ? Colors.blueAccent
                      : Colors.black87,
                ),
              )),
        ],
      ),
    );
  }
}
