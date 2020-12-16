import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/session.dart';
import 'package:irmamobile/src/models/session_events.dart';
import 'package:irmamobile/src/screens/disclosure/disclosure_screen.dart';
import 'package:irmamobile/src/screens/disclosure/issuance_screen.dart';
import 'package:irmamobile/src/screens/disclosure/session.dart';
import 'package:irmamobile/src/screens/scanner/widgets/qr_scanner.dart';
import 'package:irmamobile/src/screens/wallet/wallet_screen.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';

class ScannerScreen extends StatelessWidget {
  static const routeName = "/scanner";

  static void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onSuccess(BuildContext context, SessionPointer sessionPointer) async {
    await Future.delayed(Duration(seconds: 1));

    HapticFeedback.vibrate();
    startSessionAndNavigate(
      Navigator.of(context),
      sessionPointer,
    );
  }

  // TODO: Make this function private again and / or split it out to a utility function
  static void startSessionAndNavigate(
    NavigatorState navigator,
    SessionPointer sessionPointer, {
    bool continueOnSecondDevice = true,
    bool webview = false,
  }) {
    final event = NewSessionEvent(request: sessionPointer, continueOnSecondDevice: continueOnSecondDevice);
    final repo = IrmaRepository.get();
    repo.dispatch(event, isBridgedEvent: true);

    String screen;
    if (["disclosing", "signing", "redirect"].contains(event.request.irmaqr)) {
      screen = DisclosureScreen.routeName;
    } else if ("issuing" == event.request.irmaqr) {
      screen = IssuanceScreen.routeName;
    } else {
      // TODO show error?
      navigator.popUntil(ModalRoute.withName(WalletScreen.routeName));
      return;
    }

    repo.hasActiveSessions().then((hasActiveSessions) {
      if (hasActiveSessions) {
        // After this session finishes, we want to go back to the previous session
        if (webview) {
          // replace webview with session screen
          navigator.pushReplacementNamed(
            screen,
            arguments: SessionScreenArguments(sessionID: event.sessionID, measurementType: event.request.measurementType),
          );
        } else {
          // webview is already dismissed, just push the session screen
          navigator.pushNamed(
            screen,
            arguments: SessionScreenArguments(sessionID: event.sessionID, measurementType: event.request.measurementType),
          );
        }
      } else {
        navigator.pushNamedAndRemoveUntil(
          DisclosureScreen.routeName,
          ModalRoute.withName(WalletScreen.routeName),
          arguments: SessionScreenArguments(sessionID: event.sessionID, measurementType: event.request.measurementType),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      SessionPointer sp = new SessionPointer();

      sp.measurementType = arguments['measurementType'];
      sp.returnURL = null;

      if (arguments['measurementType'] == "disclosureMeasurement"
        || arguments['measurementType'] == "torDisclosureMeasurement") {
          sp.irmaqr = "disclosing";
          sp.u = "http://141.138.142.35:8088/irma/session/F6S2w69mpyX8ABOHbTtO";
      } else if (arguments['measurementType'] == "issuanceMeasurement"
        || arguments['measurementType'] == "torIssuanceMeasurement") {
          sp.irmaqr = "issuing";
          sp.u = "http://141.138.142.35:8088/irma/session/F6S2w69mpyX8ABOHbTtO";
      } else if (arguments['measurementType'] == "disclosureHttpsMeasurement"
        || arguments['measurementType'] == "torDisclosureHttpsMeasurement") {
          sp.irmaqr = "disclosing";
          sp.u = "https://irmamobilemeasurementtests.nl/irma/session/F6S2w69mpyX8ABOHbTtO";
      } else if (arguments['measurementType'] == "issuanceHttpsMeasurement"
        || arguments['measurementType'] == "torIssuanceHttpsMeasurement") {
          sp.irmaqr = "issuing";
          sp.u = "https://irmamobilemeasurementtests.nl/irma/session/F6S2w69mpyX8ABOHbTtO";
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _onSuccess(context, sp));
      return Container(height: 0);
    }

    return Scaffold(
      appBar: IrmaAppBar(
        title: const Text('QR code scan'),
        leadingAction: () => _onClose(context),
        leadingIcon: Icon(Icons.arrow_back, semanticLabel: FlutterI18n.translate(context, "accessibility.back")),
        actions: const [],
      ),
      body: Stack(
        children: <Widget>[
          QRScanner(
            onClose: () => _onClose(context),
            onFound: (code) => _onSuccess(context, code),
          ),
        ],
      ),
    );
  }
}
