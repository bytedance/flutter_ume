import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

final GlobalKey rootKey = GlobalKey();

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'ume_navigator');

final EventBus umeEventBus = EventBus();
