import 'package:vm_service/vm_service.dart';
import 'package:flutter_ume/flutter_ume.dart';

class CodeDisplatService with VMServiceWrapper {
  Future<String?> getIdWithClassName(String className) async {
    String? classId = '';
    final classList = await serviceWrapper.getClassList();
    classList.classes!.forEach((c) {
      if (c.name != null && c.name!.compareTo('PageInfoHelper') == 0) {
        classId = c.id;
        return;
      }
    });
    return classId;
  }

  Future<String?> getScriptIdWithFileName(String fileName) async {
    ScriptList scriptList = await serviceWrapper.getScripts();
    String? scriptId;
    scriptList.scripts!.forEach((script) {
      if (script.uri!.contains(fileName)) {
        scriptId = script.id;
        return;
      }
    });
    return scriptId;
  }

  Future<Map<String?, String?>> getScriptIdsWithKeyword(String keyword) async {
    ScriptList scriptList = await serviceWrapper.getScripts();

    var result = <String?, String?>{};

    scriptList.scripts!.forEach((script) {
      if (script.uri!.contains(keyword)) {
        result[script.id] = script.uri;
      }
    });
    return result;
  }

  Future<String?> getSourceCodeWithScriptId(String scriptId) async {
    Obj script = await serviceWrapper.getObject(scriptId);
    if (script is Script) {
      return script.source;
    }
    return null;
  }
}
