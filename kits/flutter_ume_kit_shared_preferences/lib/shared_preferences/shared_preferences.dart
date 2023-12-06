import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume/util/floating_widget.dart';
import 'package:flutter_ume_kit_shared_preferences/shared_preferences/sp_editor_widget.dart';
import 'package:tuple/tuple.dart';
import "icon.dart" as icon;
import 'package:shared_preferences/shared_preferences.dart' as sp;

class SharedPreferences extends StatefulWidget implements Pluggable {
  const SharedPreferences({Key? key}) : super(key: key);

  @override
  State<SharedPreferences> createState() => _SharedPreferencesState();

  @override
  Widget buildWidget(BuildContext? context) => const SharedPreferences();

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'SharedPreferences';

  @override
  String get displayName => 'SharedPreferences';

  @override
  void onTrigger() {}
}

extension _SharedPreferencesExtension on sp.SharedPreferences {
  Map<String, Object> get allMap {
    final keys = getKeys();
    final result = <String, Object>{};
    for (final key in keys) {
      dynamic value = get(key);
      result[key] = value;
    }
    return result;
  }
}

var _allmap = <String, Object>{};

class _SharedPreferencesState extends State<SharedPreferences>
    with TickerProviderStateMixin {
  static int no = 0;
  Timer? _timer;
  static bool _realtime = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();
    _updateSP();
    _setupTimer();
    _updateAnimation();
  }

  void _setupTimer() {
    if (_realtime) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await _updateSP();
      });
    } else {
      _timer?.cancel();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateSP() async {
    final instance = await sp.SharedPreferences.getInstance();
    await instance.setInt(no.toString(), no);
    no++;
    setState(() {
      _allmap = instance.allMap;
    });
  }

  void _updateAnimation() async {
    if (_realtime) {
      _controller.repeat();
    } else {
      _controller.reset();
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      toolbarActions: [
        Tuple3(
            _realtime ? 'Updating' : "Paused",
            RotationTransition(
              turns: _animation,
              child: Icon(
                _realtime ? Icons.refresh : Icons.pause,
                size: 20,
              ),
            ), () {
          _realtime = !_realtime;
          _setupTimer();
          _updateAnimation();
        })
      ],
      contentWidget: Container(
        child: SpEditorWidget(
          object: _allmap,
        ),
      ),
      minimalHeight: 300,
    );
  }
}
