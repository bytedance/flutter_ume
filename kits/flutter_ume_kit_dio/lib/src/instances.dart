///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 2:54 PM
///
import 'containers/http_container.dart';

/// The inner singleton instance to keep containers.
///
/// Currently we only have a http container here.
class InspectorInstance {
  const InspectorInstance._();

  static final HttpContainer httpContainer = HttpContainer();
}
