import 'package:flutter/material.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/channel_info_model.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/channel_store.dart';
import 'package:flutter_ume_kit_channel_monitor/src/ui/template_ui.dart';
import 'package:rxdart/rxdart.dart';

class ChannelPages extends StatefulWidget {
  const ChannelPages({Key? key}) : super(key: key);

  @override
  State<ChannelPages> createState() => _ChannelPagesState();
}

class _ChannelPagesState extends State<ChannelPages> {
  int currentIndex = 0;
  String currentChannel = '';
  ChannelInfoModel? currentModel;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        buildOrderedChannels(context),
        buildSingleChannelPage(),
        buildChannelInfoPage(),
      ],
    );
  }

  ChannelInfoPage buildChannelInfoPage() {
    return ChannelInfoPage(
      channelInfoModel: currentModel,
      onBackPressed: () {
        currentIndex = 1;
        currentModel = null;
        setState(() {});
      },
    );
  }

  SingleChannelPage buildSingleChannelPage() {
    return SingleChannelPage(
      title: currentChannel,
      onBackPressed: () {
        currentIndex = 0;
        currentChannel = '';
        setState(() {});
      },
      onTap: (model) {
        currentIndex = 2;
        currentModel = model;
        setState(() {});

      },
    );
  }

  Widget buildOrderedChannels(BuildContext context) {
    return TemplatePageWidget(
      title: 'Ordered Channels',
      body: StreamBuilder<List<String>>(
          stream: channelStore.channelNamePublisher,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<String> channels = snapshot.data as List<String>;
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  return TemplateItemWidget(
                      title: channels[index],
                      onTap: () {
                        currentChannel = channels[index];
                        currentIndex = 1;
                        setState(() {});
                      });
                });
          }),
    );
  }
}

class SingleChannelPage extends StatefulWidget {
  final String title;
  final VoidCallback onBackPressed;
  final OnChannelModelSelected onTap;

  const SingleChannelPage({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SingleChannelPage> createState() => _SingleChannelPageState();
}

class _SingleChannelPageState extends State<SingleChannelPage> {
  final BehaviorSubject<List<ChannelInfoModel>> _publisher = BehaviorSubject();

  @override
  void didUpdateWidget(SingleChannelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    channelStore.getChannelByName(widget.title, _publisher.sink);
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePageWidget(
      onBackPressed: widget.onBackPressed,
      title: widget.title,
      body: StreamBuilder<List<ChannelInfoModel>>(
          stream: _publisher,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<ChannelInfoModel> channels =
                snapshot.data as List<ChannelInfoModel>;
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  return TemplateItemWidget(
                    title: channels[index].methodName,
                    onTap: () => widget.onTap(channels[index]),
                  );
                });
          }),
    );
  }
}

class ChannelInfoPage extends StatelessWidget {
  final ChannelInfoModel? channelInfoModel;
  final VoidCallback onBackPressed;
  const ChannelInfoPage(
      {Key? key, this.channelInfoModel, required this.onBackPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (channelInfoModel == null) {
      return Container();
    }
    ChannelInfoModel model = channelInfoModel!;
    bool isFlutterToNative = model.direction == TransDirection.flutterToNative;
    return TemplatePageWidget(
      title: 'Method : ${model.methodName}',
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            buildCell('Channel Name', model.channelName),
            buildCell(
                'Channel Type', '${model.type.toString().substring(12)} channel'),
            buildCell('Is System Channel', model.isSystemChannel ? 'yes' : 'no'),
            buildCell(
                'Trans Direction', model.direction.toString().substring(15)),
            buildCell('Time Cost \n(millisecond)',
                model.timestamp.millisecond.toString()),
            if (isFlutterToNative)
              buildCell('Send Data Size', model.sendDataSize.toString()),
            if (isFlutterToNative)
              ...buildDataTable('Send Data', model.sendData),
            if (!isFlutterToNative)
              buildCell('Receive Data Size', model.receiveDataSize.toString()),
            if (!isFlutterToNative)
              ...buildDataTable('Receive Data', model.receiveData),
          ],
        ),
      ),
      onBackPressed: onBackPressed,
    );
  }

  List<TableRow> buildDataTable( String title,dynamic data) {
    if (data is Map) {
      return (data.keys
          .map((keyword) => TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft, child: Text(keyword.toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data[keyword].toString()),
        ),
      ]))
          .toList())
        ..insert(0, buildCell(title, ''));
    }
    return [buildCell(title, data.toString())];
  }

  TableRow buildCell(String type, String desc) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(alignment: Alignment.centerLeft, child: Text(type)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(desc.toString()),
      ),
    ]);
  }
}

typedef OnChannelModelSelected = void Function(ChannelInfoModel model);
