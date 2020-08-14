import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:irmamobile/src/data/irma_bridge.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/authentication_events.dart';
import 'package:irmamobile/src/models/change_pin_events.dart';
import 'package:irmamobile/src/models/client_preferences.dart';
import 'package:irmamobile/src/models/credential_events.dart';
import 'package:irmamobile/src/models/enrollment_events.dart';
import 'package:irmamobile/src/models/event.dart';
import 'package:irmamobile/src/models/handle_url_event.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/models/log_entry.dart';
import 'package:irmamobile/src/models/session_events.dart';

typedef EventUnmarshaller = Event Function(Map<String, dynamic>);

class IrmaClientBridge extends IrmaBridge {
  MethodChannel _methodChannel;

  final Map<Type, EventUnmarshaller> _eventUnmarshallers = {
    IrmaConfigurationEvent: (j) => IrmaConfigurationEvent.fromJson(j),
    CredentialsEvent: (j) => CredentialsEvent.fromJson(j),
    EnrollmentStatusEvent: (j) => EnrollmentStatusEvent.fromJson(j),
    LogsEvent: (j) => LogsEvent.fromJson(j),

    HandleURLEvent: (j) => HandleURLEvent.fromJson(j),

    EnrollmentSuccessEvent: (j) => EnrollmentSuccessEvent.fromJson(j),
    EnrollmentFailureEvent: (j) => EnrollmentFailureEvent.fromJson(j),

    AuthenticationSuccessEvent: (j) => AuthenticationSuccessEvent.fromJson(j),
    AuthenticationFailedEvent: (j) => AuthenticationFailedEvent.fromJson(j),
    AuthenticationErrorEvent: (j) => AuthenticationErrorEvent.fromJson(j),

    ChangePinSuccessEvent: (j) => ChangePinSuccessEvent.fromJson(j),
    ChangePinFailedEvent: (j) => ChangePinFailedEvent.fromJson(j),
    ChangePinErrorEvent: (j) => ChangePinErrorEvent.fromJson(j),

    ClientPreferencesEvent: (j) => ClientPreferencesEvent.fromJson(j),

    StatusUpdateSessionEvent: (j) => StatusUpdateSessionEvent.fromJson(j),
    RequestVerificationPermissionSessionEvent: (j) => RequestVerificationPermissionSessionEvent.fromJson(j),
    RequestIssuancePermissionSessionEvent: (j) => RequestIssuancePermissionSessionEvent.fromJson(j),
    RequestPinSessionEvent: (j) => RequestPinSessionEvent.fromJson(j),
    SuccessSessionEvent: (j) => SuccessSessionEvent.fromJson(j),
    CanceledSessionEvent: (j) => CanceledSessionEvent.fromJson(j),
    KeyshareBlockedSessionEvent: (j) => KeyshareBlockedSessionEvent.fromJson(j),
    ClientReturnURLSetSessionEvent: (j) => ClientReturnURLSetSessionEvent.fromJson(j),
    FailureSessionEvent: (j) => FailureSessionEvent.fromJson(j),

    // FooBar: (j) => FooBar.fromJson(j),
  };

  final Map<String, EventUnmarshaller> _eventUnmarshallerLookup = {};

  IrmaClientBridge() {
    // Create a lookup of unmarshallers
    _eventUnmarshallerLookup.addAll(
        _eventUnmarshallers.map((Type t, EventUnmarshaller u) => MapEntry<String, EventUnmarshaller>(t.toString(), u)));

    // Start listening to method calls from the native side and
    _methodChannel = const MethodChannel('irma.app/irma_mobile_bridge');
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    final success = Future<dynamic>.value(null);

    try {
      final data = jsonDecode(call.arguments as String) as Map<String, dynamic>;
      final EventUnmarshaller unmarshaller = _eventUnmarshallerLookup[call.method];

      if (unmarshaller == null) {
        debugPrint("Unrecognized bridge event received: ${call.method} with payload ${call.arguments}");
        return success;
      }

      debugPrint("Received bridge event: ${call.method} with payload ${call.arguments}");

      final Event event = unmarshaller(data);
      IrmaRepository.get().dispatch(event);
    } catch (e, stacktrace) {
      debugPrint("Error receiving or parsing method call from native: ${e.toString()}");
      debugPrint(stacktrace.toString());
    }

    return success;
  }

  @override
  void dispatch(Event event) {
    final encodedEvent = jsonEncode(event);
    debugPrint("Sending ${event.runtimeType.toString()} to bridge: $encodedEvent");

    _methodChannel.invokeMethod(event.runtimeType.toString(), encodedEvent);
  }
}
