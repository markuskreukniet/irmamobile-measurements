import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:irmamobile/src/data/irma_preferences.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/screens/error/session_error_screen.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_bloc.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_event.dart';
import 'package:irmamobile/src/screens/pin/bloc/pin_state.dart';
import 'package:irmamobile/src/screens/reset_pin/reset_pin_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/pin_common/format_blocked_for.dart';
import 'package:irmamobile/src/widgets/pin_common/pin_wrong_attempts.dart';
import 'package:irmamobile/src/widgets/pin_common/pin_wrong_blocked.dart';
import 'package:irmamobile/src/widgets/pin_field.dart';

import '../../data/irma_preferences.dart';

class PinScreen extends StatefulWidget {
  static const String routeName = '/';
  final PinEvent initialEvent;

  const PinScreen({Key key, this.initialEvent}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState(initialEvent);
}

class _PinScreenState extends State<PinScreen> with WidgetsBindingObserver {
  final _pinBloc = PinBloc();

  FocusNode _focusNode;
  StreamSubscription _pinBlocSubscription;

  _PinScreenState(PinEvent initialEvent) {
    if (initialEvent != null) {
      _pinBloc.dispatch(initialEvent);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();

    IrmaRepository.get().getBlockTime().first.then((blockedUntil) {
      if (blockedUntil != null) {
        _pinBloc.dispatch(Blocked(blockedUntil));
      }
    });

    _pinBlocSubscription = _pinBloc.state.listen((pinState) async {
      if (pinState.authenticated) {
        _pinBlocSubscription.cancel();
      } else if (pinState.pinInvalid) {
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
          showDialog(
            context: context,
            child: PinWrongBlockedDialog(blocked: pinState.blockedUntil.difference(DateTime.now()).inSeconds),
          );
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
    return BlocBuilder<PinBloc, PinState>(
      bloc: _pinBloc,
      builder: (context, state) {
        // Hide pin screen once authenticated
        if (state.authenticated == true) {
          return Container();
        }

        return Scaffold(
          backgroundColor: IrmaTheme.of(context).backgroundBlue,
          appBar: _buildAppBar(),
          body: StreamBuilder(
            stream: _pinBloc.getPinBlockedFor(),
            builder: (BuildContext context, AsyncSnapshot<Duration> blockedFor) {
              var subtitle = Text(FlutterI18n.translate(context, "pin.subtitle"));
              if (blockedFor.hasData && blockedFor.data.inSeconds > 0) {
                final blockedText = '${FlutterI18n.translate(context, "pin_common.blocked_for")}';
                final blockedForTime = formatBlockedFor(context, blockedFor.data);
                subtitle = Text('$blockedText $blockedForTime');
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: IrmaTheme.of(context).largeSpacing,
                      ),
                      SizedBox(
                        width: 76.0,
                        child: SvgPicture.asset(
                          'assets/non-free/irma_logo.svg',
                          semanticsLabel: FlutterI18n.translate(
                            context,
                            'accessibility.irma_logo',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: IrmaTheme.of(context).largeSpacing,
                      ),
                      subtitle,
                      SizedBox(
                        height: IrmaTheme.of(context).defaultSpacing,
                      ),
                      StreamBuilder(
                        stream: IrmaPreferences.get().getLongPin(),
                        builder: (BuildContext context, AsyncSnapshot<bool> longPin) => PinField(
                          focusNode: _focusNode,
                          enabled: (blockedFor.data ?? Duration.zero).inSeconds <= 0 && !state.authenticateInProgress,
                          longPin: longPin.hasData && longPin.data,
                          onSubmit: (pin) {
                            FocusScope.of(context).requestFocus();
                            _pinBloc.dispatch(
                              Unlock(pin),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: IrmaTheme.of(context).defaultSpacing,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(ResetPinScreen.routeName);
                        },
                        child: Text(
                          FlutterI18n.translate(context, "pin.button_forgot"),
                          style: IrmaTheme.of(context).hyperlinkTextStyle.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                      if (state.authenticateInProgress)
                        Padding(
                            padding: EdgeInsets.all(IrmaTheme.of(context).defaultSpacing),
                            child: const CircularProgressIndicator()),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: IrmaTheme.of(context).backgroundBlue,
      leading: Container(),
      title: Text(
        FlutterI18n.translate(context, "pin.title"),
        style: IrmaTheme.of(context).textTheme.display1,
      ),
    );
  }
}
