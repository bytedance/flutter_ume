import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_ume_kit_show_code/show_code/page_info_helper.dart';
import 'package:flutter_ume_kit_show_code/show_code/syntax_highlighter.dart';
import 'package:flutter_ume_kit_show_code/show_code/icon.dart' as icon;
import 'package:share/share.dart';

class ShowCode extends StatefulWidget
    implements Pluggable, Communicable, PluggableLifeCycle {
  String? launchKey;

  ShowCode({Key? key}) : super(key: key);

  @override
  ShowCodeState createState() => ShowCodeState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'ShowCode';

  @override
  String get displayName => 'ShowCode';

  @override
  void onTrigger() {}

  @override
  void handleParams(dynamic params) {
    if (params is Map && params.containsKey('launchKey')) {
      launchKey = params['launchKey'];
    }
  }

  @override
  void onDeactivate() {
    launchKey = null;
  }

  @override
  void onActivate() {}
}

class ShowCodeState extends State<ShowCode> with WidgetsBindingObserver {
  late PageInfoHelper pageInfoHelper;
  String? code;
  String? filePath;

  Map<String?, String>? _codeList;
  late bool showCodeList;
  late bool isSearching;
  TextEditingController? textEditingController;

  @override
  void initState() {
    pageInfoHelper = PageInfoHelper();
    if (widget.launchKey != null) {
      filePath =
          pageInfoHelper.packagePathConvertFromFilePath(widget.launchKey!);
    } else {
      filePath = pageInfoHelper
          .packagePathConvertFromFilePath(pageInfoHelper.filePath!);
    }

    pageInfoHelper.getCode(path: filePath).then((c) {
      code = c;
      setState(() {});
    });
    showCodeList = false;
    isSearching = false;
    textEditingController = TextEditingController(text: filePath);
    super.initState();
  }

  Widget _codeView() {
    String codeContent = code ?? '';
    if (_codeList != null && _codeList!.isNotEmpty && codeContent.isEmpty) {
      codeContent = '已找到匹配项，请点击菜单选择';
    }
    double _textScaleFactor = 1.0;
    final SyntaxHighlighterStyle style =
        Theme.of(context).brightness == Brightness.dark
            ? SyntaxHighlighterStyle.darkThemeStyle()
            : SyntaxHighlighterStyle.lightThemeStyle();
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText.rich(
            TextSpan(
              style: TextStyle(fontFamily: 'monospace', fontSize: 12.0)
                  .apply(fontSizeFactor: _textScaleFactor),
              children: <TextSpan>[
                DartSyntaxHighlighter(style).format(codeContent)
              ],
            ),
            style: DefaultTextStyle.of(context)
                .style
                .apply(fontSizeFactor: _textScaleFactor),
          ),
        ),
      ),
    );
  }

  Widget _infoView() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("页面代码", style: TextStyle(fontSize: 20, height: 1.5)),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "当前路径（点击以编辑，支持部分匹配）：",
                  ),
                ], style: TextStyle(height: 2)),
              ),
              Row(
                children: <Widget>[
                  if (isSearching)
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(),
                    ),
                  if (showCodeList &&
                      _codeList != null &&
                      _codeList!.isNotEmpty)
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: (String codepath) {
                        debugPrint(codepath);
                        setState(() {
                          code = _codeList![codepath];
                          filePath = codepath;
                          textEditingController!.text = filePath!;
                        });
                      },
                      itemBuilder: (BuildContext context) => _codeList!
                          .map((codepath, codeid) {
                            return MapEntry(
                              codepath,
                              PopupMenuItem<String>(
                                  value: codepath,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          codepath!,
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 14),
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  )),
                            );
                          })
                          .values
                          .toList(),
                    ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "请输入路径",
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () => textEditingController!.clear(),
                            icon: Icon(Icons.clear),
                          )),
                      controller: textEditingController,
                      style: TextStyle(color: Colors.teal, fontSize: 14),
                      maxLines: 5,
                      minLines: 1,
                      // decoration: null,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        if (value.length < 2) {
                          return;
                        }
                        setState(() {
                          isSearching = true;
                          filePath = value;
                        });
                        pageInfoHelper
                            .getCodeListByKeyword(value)
                            .then((codeList) {
                          if (codeList != null && codeList.isNotEmpty) {
                            showCodeList = true;
                            _codeList = codeList;
                          } else {
                            showCodeList = false;
                          }
                          isSearching = false;
                          code = null;
                          filePath = null;
                          setState(() {});
                          debugPrint(codeList.length.toString());
                        });
                      },
                    ),
                  ),
                ],
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _share(),
          child: Icon(Icons.share),
        ),
        body: Container(
            color: Colors.white,
            child: SafeArea(
                child: Column(
              children: <Widget>[
                _infoView(),
                Divider(),
                Expanded(
                  flex: 1,
                  child: _codeView(),
                )
              ],
            ))),
      ),
    );
  }

  Future<void> _share() async {
    if (code == null || code!.isEmpty) {
      return;
    }
    return Share.share(code!);
  }
}
