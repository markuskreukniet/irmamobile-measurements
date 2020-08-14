import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:irmamobile/src/theme/theme.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: IrmaTheme.of(context).defaultSpacing,
        ),
        Center(
          child: SvgPicture.asset(
            'assets/error/no_internet.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(IrmaTheme.of(context).mediumSpacing),
            child: SingleChildScrollView(
                child: Text(
              FlutterI18n.translate(context, "error.types.no_internet"),
              style: IrmaTheme.of(context).textTheme.body1,
            )),
          ),
        ),
      ],
    );
  }
}
