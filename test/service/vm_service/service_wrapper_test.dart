import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/service/vm_service/service_wrapper.dart';

void main() {
  group('ServiceWrapper', () {
    test('The value of isolateId getter is not null.', () {
      final isolateId = ServiceWrapper().isolateId;
      expect(isolateId, isNotNull);
    });

    test('Getting isolateId when isolateId is not null.', () {
      final wrapper = ServiceWrapper();
      wrapper.isolateId;
      final isolateId = wrapper.isolateId;
      expect(isolateId, isNotNull);
    });

    test('The return value of getVMService() is not null.', () async {
      final vmService = await ServiceWrapper().getVMService();
      expect(vmService, isNotNull);
    });

    test('Getting getVMService() when service is not null.', () async {
      final wrapper = ServiceWrapper();
      await wrapper.getVMService();
      final vmService = await wrapper.getVMService();
      expect(vmService, isNotNull);
    });

    test('Getting vm.', () async {
      final vm = await ServiceWrapper().getVM();
      expect(vm, isNotNull);
    });

    test('Getting memory usage.', () async {
      final vm = await ServiceWrapper().getMemoryUsage();
      expect(vm, isNotNull);
    });
    test('Getting class list.', () async {
      final vm = await ServiceWrapper().getClassList();
      expect(vm, isNotNull);
    });
    test('Getting allocation profile.', () async {
      final vm = await ServiceWrapper().getAllocationProfile();
      expect(vm, isNotNull);
    });
    test('Getting isolate.', () async {
      final vm = await ServiceWrapper().getIsolate();
      expect(vm, isNotNull);
    });
    test('Getting libraries.', () async {
      final vm = await ServiceWrapper().getLibraries();
      expect(vm, isNotNull);
    });
    test('Getting Snapshot.', () async {
      final vm = await ServiceWrapper().getSnapshot();
      expect(vm, isNotNull);
    });
    test('Getting Instances.', () async {
      dynamic e;
      try {
        await ServiceWrapper().getInstances('', 0);
      } catch (exception) {
        e = exception;
      }
      expect(e, isException);
    });
    test('Getting Stack.', () async {
      final vm = await ServiceWrapper().getStack();
      expect(vm, isNotNull);
    });
    test('Getting Object.', () async {
      dynamic e;
      try {
        await ServiceWrapper().getObject('', offset: 0, count: 0);
      } catch (exception) {
        e = exception;
      }
      expect(e, isException);
    });

    test('Getting InboundReferences.', () async {
      dynamic e;
      try {
        await ServiceWrapper().getInboundReferences('');
      } catch (exception) {
        e = exception;
      }
      expect(e, isException);
    });
    test('Getting ClassHeapStats.', () async {
      final vm = await ServiceWrapper().getClassHeapStats();
      expect(vm, isNotNull);
    });
    test('Getting Scripts.', () async {
      final vm = await ServiceWrapper().getScripts();
      expect(vm, isNotNull);
    });
    test('Getting InboundReferences.', () async {
      dynamic e;
      ServiceWrapper().evaluate('', '').catchError((error) {
        e = error;
      }).whenComplete(() => expect(e, isException));
    });
  });
}
