import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/util/translated_text.dart';
import 'package:irmamobile/src/widgets/irma_outlined_button.dart';

class DisclosureFeedbackScreen extends StatelessWidget {
  final bool success;
  final String otherParty;
  final Function(BuildContext, [bool measurementAgain, String measurementType]) popToWallet;
  final bool measurementAgain;
  final String measurementType;

  const DisclosureFeedbackScreen({
    this.success,
    this.otherParty,
    this.popToWallet,
    this.measurementAgain,
    this.measurementType
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
      popToWallet(context, measurementAgain, measurementType));
    return Container(height: 0);
  }
}
