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

  VoidCallback? _onMetricsChanged;

  OverlayEntry _overlayEntry = OverlayEntry(builder: (ctx) => Container());

  @override
  void initState() {
    super.initState();
    _replaceChild();
    _injectOverlay();

    _onMetricsChanged = WidgetsBinding.instance!.window.onMetricsChanged;
    WidgetsBinding.instance!.window.onMetricsChanged = () {
      if (_onMetricsChanged != null) {
        _onMetricsChanged!();
        _replaceChild();
        setState(() {});
      }
    };
  }

  @override
  void dispose() {
    if (_onMetricsChanged != null) {
      WidgetsBinding.instance!.window.onMetricsChanged = _onMetricsChanged;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(UMEWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.enable
        ? PluggableMessageService().resetListener()
        : PluggableMessageService().clearListener();
    if (widget.enable != oldWidget.enable && widget.enable) {
      _injectOverlay();
    }
    if (widget.child != oldWidget.child) {
      _replaceChild();
    }
    if (!widget.enable) {
      _removeOverlay();
    }
  }

  void _replaceChild() {
    final nestedWidgets =
        PluginManager.instance.pluginsMap.values.where((value) {
      return value != null && value is PluggableWithNestedWidget;
    }).toList();
    Widget layoutChild = _buildLayout(
        widget.child, widget.supportedLocales, widget.localizationsDelegates);
    for (var item in nestedWidgets) {
      if (item!.name != PluginManager.instance.activatedPluggableName) {
        continue;
      }
      if (item is PluggableWithNestedWidget) {
        layoutChild = item.buildNestedWidget(layoutChild);
        break;
      }
    }
    _child =
        Directionality(textDirection: TextDirection.ltr, child: layoutChild);
  }

  Stack _buildLayout(Widget child, Iterable<Locale>? supportedLocales,
      Iterable<LocalizationsDelegate> delegates) {
    return Stack(
      children: <Widget>[
        RepaintBoundary(child: child, key: rootKey),
        MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
          child: Localizations(
            locale: supportedLocales?.first ?? Locale('en', 'US'),
            delegates: delegates.toList(),
            child: ScaffoldMessenger(child: Overlay(key: overlayKey)),
          ),
        ),
      ],
    );
  }

  void _removeOverlay() => _overlayEntry.remove();

  void _injectOverlay() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.enable) {
        _overlayEntry = OverlayEntry(
            builder: (_) => Material(
                type: MaterialType.transparency,
                child: _ContentPage(
                  refreshChildLayout: () {
                    _replaceChild();
                    setState(() {});
                  },
                )));
        overlayKey.currentState?.insert(_overlayEntry);
      }
    });
  }

  @override
  Widget build(BuildContext context) => _child;
}

class _ContentPage extends StatefulWidget {
  _ContentPage({Key? key, this.refreshChildLayout}) : super(key: key);

  final VoidCallback? refreshChildLayout;

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
      PluginManager.instance.deactivatePluggable(_currentSelected!);
      if (widget.refreshChildLayout != null) {
        widget.refreshChildLayout!();
      }
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
      final x = double.parse(value.split(',').first);
      final y = double.parse(value.split(',').last);
      if (MediaQuery.of(context).size.height - dotSize.height < y ||
          MediaQuery.of(context).size.width - dotSize.width < x) {
        return;
      }
      _dx = x;
      _dy = y;
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
      if (_currentSelected != null) {
        PluginManager.instance.activatePluggable(_currentSelected!);
      }
      _handleAction(_context, pluginData!);
      if (widget.refreshChildLayout != null) {
        widget.refreshChildLayout!();
      }
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
            child: Tooltip(
              message: 'Open ume panel',
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
                            pluginDatas: PluginManager
                                .instance.pluginsMap.values
                                .toList(),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
