import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/screens/help/widgets/illustrator.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/util/collapsible_helper.dart';
import 'package:irmamobile/src/widgets/collapsible.dart';

class DemoItems extends StatefulWidget {
  const DemoItems({this.credentialType, this.parentKey, this.parentScrollController});

  final CredentialType credentialType;
  final GlobalKey parentKey;
  final ScrollController parentScrollController;

  @override
  _DemoItemsState createState() => _DemoItemsState();
}

class _DemoItemsState extends State<DemoItems> with TickerProviderStateMixin {
  final List<GlobalKey> _collapsableKeys = List<GlobalKey>.generate(4, (int index) => GlobalKey());

  // Content for question 1
  @override
  Widget build(BuildContext context) {
    final List<Widget> _demoPagesQuestion1 = <Widget>[
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q1_step_1.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q1_step_2.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q1_step_3.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q1_step_4.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
    ];

    final List<String> _demoTextsQuestion1 = [
      FlutterI18n.translate(context, 'manual.answer_1.step_1'),
      FlutterI18n.translate(context, 'manual.answer_1.step_2'),
      FlutterI18n.translate(context, 'manual.answer_1.step_3'),
      FlutterI18n.translate(context, 'manual.answer_1.step_4'),
    ];

    // Content for question 2
    final List<Widget> _demoPagesQuestion2 = <Widget>[
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q2_step_1.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q2_step_2.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q2_step_3.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q2_step_4.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
      Container(
        child: Center(
          child: SizedBox(
              child: SvgPicture.asset(
            'assets/help/q2_step_5.svg',
            excludeFromSemantics: true,
          )),
        ),
      ),
    ];

    final List<String> _demoTextsQuestion2 = [
      FlutterI18n.translate(context, 'manual.answer_2.step_1'),
      FlutterI18n.translate(context, 'manual.answer_2.step_2'),
      FlutterI18n.translate(context, 'manual.answer_2.step_3'),
      FlutterI18n.translate(context, 'manual.answer_2.step_4'),
      FlutterI18n.translate(context, 'manual.answer_2.step_5'),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          button: true,
          child: Collapsible(
              header: FlutterI18n.translate(context, 'manual.question_1'),
              onExpansionChanged: (v) =>
                  {if (v) jumpToCollapsable(widget.parentScrollController, widget.parentKey, _collapsableKeys[0])},
              content: Column(
                children: <Widget>[
                  SizedBox(
                    height: IrmaTheme.of(context).smallSpacing,
                  ),
                  Illustrator(
                    imageSet: _demoPagesQuestion1,
                    textSet: _demoTextsQuestion1,
                    width: 280.0,
                    height: 220.0,
                  ),
                ],
              ),
              key: _collapsableKeys[0]),
        ),
        Semantics(
          button: true,
          child: Collapsible(
              header: FlutterI18n.translate(context, 'manual.question_2'),
              onExpansionChanged: (v) =>
                  {if (v) jumpToCollapsable(widget.parentScrollController, widget.parentKey, _collapsableKeys[1])},
              content: Column(
                children: <Widget>[
                  SizedBox(
                    height: IrmaTheme.of(context).smallSpacing,
                  ),
                  Illustrator(
                    imageSet: _demoPagesQuestion2,
                    textSet: _demoTextsQuestion2,
                    width: 280.0,
                    height: 220.0,
                  ),
                ],
              ),
              key: _collapsableKeys[1]),
        ),
      ],
    );
  }
}
