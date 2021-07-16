import 'dart:developer';
import 'dart:isolate';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart' as vm;
import 'package:vm_service/vm_service_io.dart';

class ServiceWrapper {
  vm.VmService _service;

  String _isolateId;

  String get isolateId {
    if (_isolateId != null) {
      return _isolateId;
    }
    _isolateId = Service.getIsolateID(Isolate.current);
    return _isolateId;
  }

  Future<vm.VmService> getVMService() async {
    if (_service != null) {
      return _service;
    }
    ServiceProtocolInfo info = await Service.getInfo();
    String url = info.serverUri.toString();
    Uri uri = Uri.parse(url);
    Uri socketUri = convertToWebSocketUrl(serviceProtocolUrl: uri);
    _service = await vmServiceConnectUri(socketUri.toString());
    return _service;
  }

  Future<vm.VM> getVM() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getVM();
  }

  Future<vm.MemoryUsage> getMemoryUsage() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getMemoryUsage(isolateId);
  }

  Future<vm.ClassList> getClassList() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getClassList(isolateId);
  }

  Future<vm.AllocationProfile> getAllocationProfile() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getAllocationProfile(isolateId, reset: true);
  }

  Future<vm.Isolate> getIsolate() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getIsolate(isolateId);
  }

  Future<List<vm.LibraryRef>> getLibraries() async {
    vm.Isolate isolate = await getIsolate();
    return isolate.libraries;
  }

  Future<vm.HeapSnapshotGraph> getSnapshot() async {
    vm.VmService virtualMachine = await getVMService();
    vm.Isolate isolate = await getIsolate();
    return vm.HeapSnapshotGraph.getSnapshot(virtualMachine, isolate);
  }

  Future<vm.InstanceSet> getInstances(String objectId, int limit) async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getInstances(isolateId, objectId, limit);
  }

  Future<vm.Stack> getStack() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getStack(isolateId);
  }

  Future<vm.Obj> getObject(String objectId, {int offset, int count}) async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getObject(isolateId, objectId,
        offset: offset, count: count);
  }

  Future<vm.InboundReferences> getInboundReferences(String objectId) async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getInboundReferences(isolateId, objectId, 100);
  }

  Future<List<vm.ClassHeapStats>> getClassHeapStats() async {
    vm.AllocationProfile profile = await getAllocationProfile();
    List<vm.ClassHeapStats> list = profile.members
        .where((element) =>
            element.bytesCurrent > 0 || element.instancesCurrent > 0)
        .toList();
    return list;
  }

  Future<vm.ScriptList> getScripts() async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.getScripts(isolateId);
  }

  Future<vm.Response> evaluate(String targetId, String expression) async {
    vm.VmService virtualMachine = await getVMService();
    return virtualMachine.evaluate(isolateId, targetId, expression);
  }
}
