import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ume_kit_show_code/show_code/code_display_service.dart';
import 'package:flutter_ume/flutter_ume.dart';

class PageInfoHelper {
  PageInfoHelper() {
    _selectionInit();
  }

  final InspectorSelection selection =
      WidgetInspectorService.instance.selection;

  RenderObject? get renderObject => selection.current;

  Element? get element => selection.currentElement;

  String? get filePath => _jsonInfo!['creationLocation']['file'];

  String packagePathConvertFromFilePath(String filePath) {
    final parts = filePath.split(r'/lib/');
    final fileForwardPart = parts.sublist(1).join('/lib/');
    final packageName = parts.first.split('/').last;
    final keyword = "package:$packageName/$fileForwardPart";
    CodeDisplayService().getScriptIdsWithKeyword(keyword);
    debugPrint(keyword);
    return keyword;
  }

  int? get line => _jsonInfo!['creationLocation']['line'];

  dynamic _ignorePointer;

  String get message {
    return '''${element!.toStringShort()}\nsize: ${renderObject!.paintBounds.size}\nfilePath: $filePath\nline: $line''';
  }

  Map? get _jsonInfo {
    if (renderObject == null) return null;
    final widgetId = WidgetInspectorService.instance
        // ignore: invalid_use_of_protected_member
        .toId(renderObject!.toDiagnosticsNode(), '');
    if (widgetId == null) return null;

    String infoStr =
        WidgetInspectorService.instance.getSelectedSummaryWidget(widgetId, '');
    return json.decode(infoStr);
  }

  double _area(RenderObject object) {
    final Size size = object.paintBounds.size;
    return size == null ? double.maxFinite : size.width * size.height;
  }

  // Init selection of current page
  void _selectionInit() {
    _ignorePointer = rootKey.currentContext!.findRenderObject();
    final RenderObject userRender = _ignorePointer.child;
    List<RenderObject> objectList = [];

    void findAllRenderObject(RenderObject object) {
      final List<DiagnosticsNode> children = object.debugDescribeChildren();
      for (int i = 0; i < children.length; i++) {
        DiagnosticsNode c = children[i];
        if (c.style == DiagnosticsTreeStyle.offstage || c.value is! RenderBox)
          continue;
        RenderObject child = c.value as RenderObject;
        objectList.add(child);
        findAllRenderObject(child);
      }
    }

    findAllRenderObject(userRender);
    objectList
        .sort((RenderObject a, RenderObject b) => _area(a).compareTo(_area(b)));
    Set<RenderObject> objectSet = Set<RenderObject>();
    objectSet.addAll(objectList);
    objectList = objectSet.toList();
    selection.candidates = objectList;
  }

  Future<String?> getCode() async {
    CodeDisplayService codeDisplayService = CodeDisplayService();
    String targetFileName = filePath!.split('/').last;
    String? scriptId =
        await codeDisplayService.getScriptIdWithFileName(targetFileName);
    if (scriptId == null) return null;
    String? sourceCode =
        await codeDisplayService.getSourceCodeWithScriptId(scriptId);
    return sourceCode;
  }

  Future<String?> getCodeByFileName(String fileName) async {
    CodeDisplayService codeDisplayService = CodeDisplayService();
    String? sourceCode;
    String? scriptId =
        await codeDisplayService.getScriptIdWithFileName(fileName);
    if (scriptId != null) {
      sourceCode = await codeDisplayService.getSourceCodeWithScriptId(scriptId);
    }
    return sourceCode;
  }

  Future<Map<String?, String>> getCodeListByKeyword(String keyword) async {
    CodeDisplayService codeDisplayService = CodeDisplayService();
    Map<String?, String> result = <String?, String>{};
    final scriptIds = await codeDisplayService.getScriptIdsWithKeyword(keyword);
    if (scriptIds.isNotEmpty) {
      for (final entry in scriptIds.entries) {
        final code =
            await codeDisplayService.getSourceCodeWithScriptId(entry.key!);
        if (code != null && code.isNotEmpty) {
          result[entry.value] = code;
        }
      }
    }
    return result;
  }
}
