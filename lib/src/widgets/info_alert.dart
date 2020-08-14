import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:irmamobile/src/theme/theme.dart';

class InfoAlert extends StatelessWidget {
  final String title;
  final String body;
  final List<Widget> widgets;

  const InfoAlert({Key key, @required this.title, @required this.body, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxWidgets = <Widget>[
      Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
      SizedBox(
        height: IrmaTheme.of(context).defaultSpacing,
      ),
      Center(
        child: Text(
          body,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: IrmaTheme.of(context).grayscale40,
              ),
        ),
      ),
    ];
    if (widgets != null) boxWidgets.addAll(widgets);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: IrmaTheme.of(context).notificationInfoBg,
        border: Border.all(color: const Color(0xffbbbbbb)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              'assets/generic/info.svg',
              width: 24,
            ),
            SizedBox(
              width: IrmaTheme.of(context).smallSpacing,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: boxWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
