/// An easy, imperative navigation helper for Flutter (Navigator 1.0).
///
/// Import this single library to access the entire public API:
///
/// ```dart
/// import 'package:nav/nav.dart';
/// ```
///
/// For widget-test helpers, see `package:nav/testing.dart`.
library nav;

export 'src/bottom_sheet/modal_bottom_sheet.dart' show ModalBottomSheet;
export 'src/dialog/dialog.dart' show DialogWidget;
export 'src/dialog/dialog_state.dart' show DialogState;
export 'src/enum/enum_nav_ani.dart' show NavAni, NavAniExt;
export 'src/nav_base.dart' show Nav;
export 'src/route/blink_route_builder.dart' show BlinkRouteBuilder;
export 'src/route/custom_page_route_builder.dart' show CustomPageRouteBuilder;
export 'src/route/fade_route_builder.dart' show FadeRouteBuilder;
export 'src/route/ripple_route_builder.dart' show RippleRouteBuilder;
export 'src/route/slide_route_builder.dart' show SlideRouteBuilder;
export 'src/screen/nav_screen.dart' show NavScreen;
export 'src/setting/nav_setting.dart' show NavSetting;
