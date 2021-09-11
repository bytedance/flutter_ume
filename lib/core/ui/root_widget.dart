import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    hide FlutterLogo, FlutterLogoDecoration, FlutterLogoStyle;
import 'package:flutter_ume/core/pluggable_message_service.dart';
import 'package:flutter_ume/core/ui/panel_action_define.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/red_dot.dart';
import 'package:flutter_ume/core/store_manager.dart';
import 'package:flutter_ume/core/ui/toolbar_widget.dart';
import 'package:flutter_ume/core/pluggable.dart';
import 'package:flutter_ume/util/constants.dart';
import './menu_page.dart';
import 'package:flutter_ume/util/flutter_logo.dart';
import 'global.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const defaultLocalizationsDelegates = const [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  DefaultCupertinoLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

/// Wrap your App widget. If [enable] is false, the function will return [child].
@Deprecated(
  'injectUMEWidget has been deprecated since 0.3.0. '
  'Use UMEWidget instead.',
)
Widget injectUMEWidget({
  required Widget child,
  required bool enable,
  Iterable<Locale>? supportedLocales,
  Iterable<LocalizationsDelegate> localizationsDelegates =
      defaultLocalizationsDelegates,
}) {
  enable
      ? PluggableMessageService().resetListener()
      : PluggableMessageService().clearListener();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    if (enable) {
      final overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return const _FloatingWidget();
      });
      overlayKey.currentState?.insert(overlayEntry);
    }
  });
  if (!enable) return child;
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Stack(
      children: <Widget>[
        RepaintBoundary(child: child, key: rootKey),
        MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
          child: Localizations(
            locale: supportedLocales?.first ?? Locale('en', 'US'),
            delegates: localizationsDelegates.toList(),
            child: ScaffoldMessenger(child: Overlay(key: overlayKey)),
          ),
        )
      ],
    ),
  );
}

class UMEWidget extends StatefulWidget {
  const UMEWidget({
    Key? key,
    required this.child,
    this.enable = true,
    this.supportedLocales,
    this.localizationsDelegates = defaultLocalizationsDelegates,
  }) : super(key: key);

  final Widget child;
  final bool enable;
  final Iterable<Locale>? supportedLocales;
  final Iterable<LocalizationsDelegate> localizationsDelegates;

  @override
  _UMEWidgetState createState() => _UMEWidgetState();
}

class _UMEWidgetState extends State<UMEWidget> {
  late Widget _child;

  @override
  void initState() {
    super.initState();
    _replaceChild();
    _injectOverlay();
  }

  @override
  void didUpdateWidget(UMEWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable || widget.child != oldWidget.child) {
      _replaceChild();
    }
  }

  void _replaceChild() {
    _child = RepaintBoundary(key: rootKey, child: widget.child);
  }

  void _injectOverlay() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.enable) {
        final overlayEntry = OverlayEntry(
          builder: (_) => const _FloatingWidget(),
        );
        overlayKey.currentState?.insert(overlayEntry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) {
      return _child;
    }
    return Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        _child,
        MediaQuery(
          data: MediaQueryData.fromWindow(ui.window),
          child: Localizations(
            locale: widget.supportedLocales?.first ?? Locale('en', 'US'),
            delegates: widget.localizationsDelegates.toList(),
            child: ScaffoldMessenger(child: Overlay(key: overlayKey)),
          ),
        )
      ],
    );
  }
}

class _FloatingWidget extends StatelessWidget {
  const _FloatingWidget({
    Key? key,
    this.supportedLocales,
    this.localizationsDelegates,
  }) : super(key: key);

  final Iterable<Locale>? supportedLocales;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  @override
  Widget build(BuildContext context) {
    return Material(type: MaterialType.transparency, child: _ContentPage());
  }
}

class _ContentPage extends StatefulWidget {
  _ContentPage({
    Key? key,
  }) : super(key: key);

  @override
  __ContentPageState createState() => __ContentPageState();
}

class __ContentPageState extends State<_ContentPage> {
  PluginStoreManager _storeManager = PluginStoreManager();
  Size _windowSize = windowSize;
  double _dx = 0;
  double _dy = 0;
  bool _showedMenu = false;
  Pluggable? _currentSelected;
  Widget _empty = Container();
  Widget? _currentWidget;
  Widget? _menuPage;
  BuildContext? _context;

  bool _minimalContent = true;
  Widget? _toolbarWidget;

  void dragEvent(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - dotSize.width / 2;
    _dy = details.globalPosition.dy - dotSize.height / 2;
    setState(() {});
  }

  void dragEnd(DragEndDetails details) {
    if (_dx + dotSize.width / 2 < _windowSize.width / 2) {
      _dx = margin;
    } else {
      _dx = _windowSize.width - dotSize.width - margin;
    }
    if (_dy + dotSize.height > _windowSize.height) {
      _dy = _windowSize.height - dotSize.height - margin;
    } else if (_dy < 0) {
      _dy = margin;
    }

    _storeManager.storeFloatingDotPos(_dx, _dy);

    setState(() {});
  }

  void onTap() {
    if (_currentSelected != null) {
      _currentSelected = null;
      _currentWidget = _empty;
      if (_minimalContent) {
        _currentWidget = _toolbarWidget;
        _showedMenu = true;
      }
      setState(() {});
      return;
    }
    _showedMenu = !_showedMenu;
    _updatePanelWidget();
  }

  void _updatePanelWidget() {
    setState(() {
      _currentWidget =
          _showedMenu ? (_minimalContent ? _toolbarWidget : _menuPage) : _empty;
    });
  }

  void _handleAction(BuildContext? context, Pluggable data) {
    _currentWidget = data.buildWidget(context);
    setState(() {
      _showedMenu = false;
    });
  }

  Widget _logoWidget() {
    if (_currentSelected != null) {
      return Container(
          child: Image(image: _currentSelected!.iconImageProvider),
          height: 30,
          width: 30);
    }
    return FlutterLogo(size: 40, colors: _showedMenu ? Colors.red : null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _storeManager.fetchFloatingDotPos().then((value) {
      if (value == null || value.split(',').length != 2) {
        return;
      }
      _dx = double.parse(value.split(',').first);
      _dy = double.parse(value.split(',').last);
      setState(() {});
    });
    _storeManager.fetchMinimalToolbarSwitch().then((value) {
      setState(() {
        _minimalContent = value ?? true;
      });
    });
    _dx = _windowSize.width - dotSize.width - margin * 4;
    _dy = _windowSize.height - dotSize.height - bottomDistance;
    MenuAction itemTapAction = (pluginData) {
      _currentSelected = pluginData;
      _handleAction(_context, pluginData!);
      if (pluginData.onTrigger != null) {
        pluginData.onTrigger();
      }
    };
    _menuPage = MenuPage(
      action: itemTapAction,
      minimalAction: () {
        _minimalContent = true;
        _updatePanelWidget();
        PluginStoreManager().storeMinimalToolbarSwitch(true);
      },
      closeAction: () {
        _showedMenu = false;
        _updatePanelWidget();
      },
    );
    _toolbarWidget = ToolBarWidget(
      action: itemTapAction,
      maximalAction: () {
        _minimalContent = false;
        _updatePanelWidget();
        PluginStoreManager().storeMinimalToolbarSwitch(false);
      },
      closeAction: () {
        _showedMenu = false;
        _updatePanelWidget();
      },
    );
    _currentWidget = _empty;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // ugly code .. because in release mode, WidgetsBinding.instance.window.physicalSize's value is zero...What the Fuck!!!
    if (_windowSize.isEmpty) {
      _dx = MediaQuery.of(context).size.width - dotSize.width - margin * 4;
      _dy =
          MediaQuery.of(context).size.height - dotSize.height - bottomDistance;
      _windowSize = MediaQuery.of(context).size;
    }
    return Container(
      width: _windowSize.width,
      height: _windowSize.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _currentWidget!,
          Positioned(
            left: _dx,
            top: _dy,
            child: GestureDetector(
              onTap: onTap,
              onVerticalDragEnd: dragEnd,
              onHorizontalDragEnd: dragEnd,
              onHorizontalDragUpdate: dragEvent,
              onVerticalDragUpdate: dragEvent,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0)
                    ]),
                width: dotSize.width,
                height: dotSize.height,
                child: Stack(
                  children: [
                    Center(
                      child: _logoWidget(),
                    ),
                    Positioned(
                        right: 6,
                        top: 8,
                        child: RedDot(
                          pluginDatas:
                              PluginManager.instance.pluginsMap.values.toList(),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
