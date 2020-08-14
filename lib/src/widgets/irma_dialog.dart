import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';

class IrmaDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;
  final Function() onClose;
  final String image;

  const IrmaDialog({@required this.title, @required this.content, @required this.child, this.image, this.onClose});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.symmetric(
              horizontal: IrmaTheme.of(context).mediumSpacing, vertical: IrmaTheme.of(context).defaultSpacing),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: IrmaTheme.of(context).grayscaleWhite,
              elevation: 24.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(IrmaTheme.of(context).smallSpacing),
              ),
              type: MaterialType.card,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(IrmaTheme.of(context).defaultSpacing),
                    child: ListView(
                      shrinkWrap: true,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: IrmaTheme.of(context).defaultSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  title,
                                  style: IrmaTheme.of(context).textTheme.display2,
                                ),
                                SizedBox(height: IrmaTheme.of(context).tinySpacing),
                                Text(
                                  content,
                                  style: IrmaTheme.of(context).textTheme.body1,
                                ),
                                if (image != null) ...[
                                  SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                                  Center(
                                    child: Image.asset(
                                      image,
                                      width: 240,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        child,
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      iconSize: 18.0,
                      icon: Icon(IrmaIcons.close, semanticLabel: FlutterI18n.translate(context, "accessibility.close")),
                      color: IrmaTheme.of(context).primaryBlue,
                      onPressed: onClose ?? () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
