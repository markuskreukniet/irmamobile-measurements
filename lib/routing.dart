import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/native_events.dart';
import 'package:irmamobile/src/screens/about/about_screen.dart';
import 'package:irmamobile/src/screens/add_cards/card_store_screen.dart';
import 'package:irmamobile/src/screens/change_pin/change_pin_screen.dart';
import 'package:irmamobile/src/screens/debug/debug_screen.dart';
import 'package:irmamobile/src/screens/disclosure/disclosure_screen.dart';
import 'package:irmamobile/src/screens/disclosure/issuance_screen.dart';
import 'package:irmamobile/src/screens/disclosure/session.dart';
import 'package:irmamobile/src/screens/enrollment/email_sent_screen.dart';
import 'package:irmamobile/src/screens/enrollment/enrollment_screen.dart';
import 'package:irmamobile/src/screens/help/help_screen.dart';
import 'package:irmamobile/src/screens/history/history_screen.dart';
import 'package:irmamobile/src/screens/loading/redirect_screen.dart';
import 'package:irmamobile/src/screens/reset_pin/reset_pin_screen.dart';
import 'package:irmamobile/src/screens/scanner/scanner_screen.dart';
import 'package:irmamobile/src/screens/settings/settings_screen.dart';
import 'package:irmamobile/src/screens/wallet/wallet_screen.dart';

class Routing {
  static Map<String, WidgetBuilder> simpleRoutes = {
    RedirectScreen.routeName: (context) => RedirectScreen(),
    WalletScreen.routeName: (context) => WalletScreen(),
    EnrollmentScreen.routeName: (context) => EnrollmentScreen(),
    ScannerScreen.routeName: (context) => ScannerScreen(),
    ChangePinScreen.routeName: (context) => ChangePinScreen(),
    AboutScreen.routeName: (context) => AboutScreen(),
    SettingsScreen.routeName: (context) => SettingsScreen(),
    CardStoreScreen.routeName: (context) => CardStoreScreen(),
    HistoryScreen.routeName: (context) => HistoryScreen(),
    HelpScreen.routeName: (context) => HelpScreen(),
    ResetPinScreen.routeName: (context) => ResetPinScreen(),
    DebugScreen.routeName: (context) => DebugScreen(),
  };

  // This function returns a `WidgetBuilder` of the screen found by `routeName`
  // It returns `null` if the screen is not found
  // It throws `ValueError` is it cannot properly cast the arguments
  static WidgetBuilder _screenBuilder(String routeName, Object arguments) {
    switch (routeName) {
      case DisclosureScreen.routeName:
        return (context) => DisclosureScreen(arguments: arguments as SessionScreenArguments);
      case IssuanceScreen.routeName:
        return (context) => IssuanceScreen(arguments: arguments as SessionScreenArguments);
      case EmailSentScreen.routeName:
        return (context) => EmailSentScreen(email: arguments as String);

      default:
        return simpleRoutes[routeName];
    }
  }

  // Manually define what root routes are
  static bool _isRootRoute(RouteSettings settings) {
    return settings.name == WalletScreen.routeName || settings.name == EnrollmentScreen.routeName;
  }

  // A helper method to work around `willPopScope` limitations, see flutter/flutter#14083
  static bool _isSubnavigatorRoute(RouteSettings settings) {
    return settings.name == EnrollmentScreen.routeName || settings.name == ChangePinScreen.routeName;
  }

  static Route generateRoute(RouteSettings settings) {
    // Try to find the appropriate screen, but keep `RouteNotFoundScreen` as default
    WidgetBuilder screenBuilder = (context) => const RouteNotFoundScreen();
    try {
      screenBuilder = _screenBuilder(settings.name, settings.arguments);
    } catch (TypeError) {
      // pass
    }

    // Wrap the route in a `willPopScope` that denies Android back presses
    // if the route is an initial route
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // If the current route has a subnavigator and is on the root, defer to that component's `WillPopScope`
            if (_isSubnavigatorRoute(settings) && _isRootRoute(settings)) {
              return true;
            }

            // Otherwise if it is a root route, background the app on backpress
            if (_isRootRoute(settings)) {
              if (settings.name == WalletScreen.routeName) {
                // Check if we are in the drawn state.
                // We don't want the app to background in this case.
                // Defer to wallet_screen.dart
                return true;
              }
              IrmaRepository.get().bridgedDispatch(AndroidSendToBackgroundEvent());
              return false;
            }

            return true;
          },
          child: screenBuilder(context),
        );
      },
      settings: settings,
    );
  }
}

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      throw Exception(
        "Route not found. Invalid route or invalid arguments were specified.",
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Page not found"),
      ),
      body: const Center(
        child: Text(""),
      ),
    );
  }
}
