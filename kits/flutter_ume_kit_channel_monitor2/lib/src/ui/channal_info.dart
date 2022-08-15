import 'package:flutter/material.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/channel_info_model.dart';

class ChannelInfoWidget extends StatefulWidget {
  final ChannelInfoModel model;
  const ChannelInfoWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ChannelInfoWidget> createState() => _ChannelInfoWidgetState();
}

class _ChannelInfoWidgetState extends State<ChannelInfoWidget>
    with AutomaticKeepAliveClientMixin {
  ChannelInfoModel get model => widget.model;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      initiallyExpanded: false,
      title: buildChannelNameTitle(context),
      subtitle: buildMethodSubTitle(),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: EdgeInsets.zero,
      tilePadding: const EdgeInsets.only(left: 12),
      children: buildDetails(),
    );
  }

  List<Widget> buildDetails() {
    final data = model.sendData ?? model.receiveData ?? {};
    return [
      if (data is Map)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.keys
              .map((e) => ListTile(
                    title: Text(
                      '$e',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text('${data[e]}'),
                  ))
              .toList(),
        ),
      SizedBox(height: 8)
    ];
  }

  Widget buildMethodSubTitle() {
    return model.methodName == 'unknown'
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Method', style: Theme.of(context).textTheme.headline6),
              Text('${model.methodName}',
                  style: Theme.of(context).textTheme.subtitle1),
              Divider(),
            ],
          );
  }

  Padding buildChannelNameTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Channel', style: Theme.of(context).textTheme.headline6),
          Text('${model.channelName}'),
          SizedBox(height: 4)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
