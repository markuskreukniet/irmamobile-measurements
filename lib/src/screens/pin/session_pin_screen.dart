import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/data/irma_preferences.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/session_events.dart';
import 'package:irmamobile/src/screens/error/session_error_screen.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_bloc.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_event.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_state.dart';
import 'package:irmamobile/src/screens/wallet/wallet_screen.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';
import 'package:irmamobile/src/widgets/pin_common/pin_wrong_attempts.dart';
import 'package:irmamobile/src/widgets/pin_field.dart';

import '../../data/irma_preferences.dart';

class SessionPinScreen extends StatefulWidget {
  final int sessionID;
  final String title;

  const SessionPinScreen({Key key, @required this.sessionID, @required this.title}) : super(key: key);

  @override
  _SessionPinScreenState createState() => _SessionPinScreenState();
}

class _SessionPinScreenState extends State<SessionPinScreen> with WidgetsBindingObserver {
  final _repo = IrmaRepository.get();
  final _pinBloc = PinBloc();

  FocusNode _focusNode;
  StreamSubscription _pinBlocSubscription;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);

    _pinBlocSubscription = _pinBloc.state.listen((pinState) async {
      if (pinState.authenticated) {
        Navigator.of(context).pop();
        _pinBlocSubscription.cancel();
      }
      if (pinState.pinInvalid) {
        if (pinState.remainingAttempts != 0) {
          showDialog(
            context: context,
            child: PinWrongAttemptsDialog(
              attemptsRemaining: pinState.remainingAttempts,
              onClose: () {
                Navigator.of(context).pop();
                _focusNode.requestFocus();
              },
            ),
          );
        } else {
          Navigator.of(context, rootNavigator: true).popUntil(ModalRoute.withName(WalletScreen.routeName));
          _repo.lock(unblockTime: pinState.blockedUntil);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(_focusNode));
      }

      if (pinState.error != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SessionErrorScreen(
            error: pinState.error,
            onTapClose: () {
              Navigator.of(context).pop();
            },
          ),
        ));
      }
    });
  }

  @override
  void dispose() {
    _pinBlocSubscription.cancel();
    // If the user wants to close and no explicit result is available, then assume cancellation.
    if (!_pinBloc.currentState.authenticated) {
      _repo.dispatch(
        RespondPinEvent(sessionID: widget.sessionID, proceed: false),
        isBridgedEvent: true,
      );
    }
    _focusNode.dispose();
    _pinBloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    } else if (state == AppLifecycleState.resumed) {
      _pinBloc.state.first.then((pinstate) {
        if (pinstate.pinInvalid || pinstate.authenticateInProgress || pinstate.error != null) return;
        Future.delayed(const Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(_focusNode));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _pinBloc.dispatch(SessionPin(widget.sessionID, "01989")));
    return Container(height: 0);

    return WillPopScope(
      onWillPop: () async {
        // Wait on irmago response before closing, calling widget expects a result
        if (_pinBloc.currentState.authenticateInProgress) {
          return false;
        }
        return true;
      },
      child: BlocBuilder<PinBloc, PinState>(
        bloc: _pinBloc,
        builder: (context, state) {
          if (state.authenticated == true) {
            return Container();
          }

          return Scaffold(
            appBar: _buildAppBar(),
            body: SafeArea(
              minimum: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: IrmaTheme.of(context).largeSpacing,
                    ),
                    Text(
                      FlutterI18n.translate(context, "session_pin.subtitle"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: IrmaTheme.of(context).defaultSpacing,
                    ),
                    StreamBuilder(
                      stream: IrmaPreferences.get().getLongPin(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return PinField(
                          focusNode: _focusNode,
                          longPin: snapshot.hasData && snapshot.data,
                          enabled: !state.authenticateInProgress,
                          onSubmit: (pin) {
                            FocusScope.of(context).requestFocus();
                            _pinBloc.dispatch(
                              SessionPin(widget.sessionID, pin),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: IrmaTheme.of(context).defaultSpacing,
                    ),
                    Icon(
                      IrmaIcons.duration,
                      color: IrmaTheme.of(context).primaryDark,
                      size: 32,
                    ),
                    SizedBox(
                      height: IrmaTheme.of(context).defaultSpacing,
                    ),
                    Text(
                      FlutterI18n.translate(context, "session_pin.explanation"),
                      textAlign: TextAlign.center,
                    ),
                    if (state.authenticateInProgress)
                      Padding(
                          padding: EdgeInsets.all(IrmaTheme.of(context).defaultSpacing),
                          child: const CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IrmaAppBar(
      title: Text(
        widget.title,
      ),
      leadingCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
