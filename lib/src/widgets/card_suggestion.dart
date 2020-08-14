import 'package:flutter/material.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';

class CardSuggestion extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subTitle;
  final bool obtained;
  final VoidCallback onTap;

  const CardSuggestion({
    @required this.icon,
    @required this.title,
    @required this.subTitle,
    @required this.obtained,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    return Padding(
      padding: EdgeInsets.only(bottom: IrmaTheme.of(context).tinySpacing / 4),
      child: Card(
        elevation: 1.0,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: IrmaTheme.of(context).grayscale85, width: 0.2),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: IrmaTheme.of(context).smallSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: IrmaTheme.of(context).smallSpacing,
                            left: IrmaTheme.of(context).defaultSpacing,
                            bottom: IrmaTheme.of(context).smallSpacing,
                            right: IrmaTheme.of(context).smallSpacing),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 42.0,
                            minWidth: 42.0,
                            maxHeight: 42.0,
                            maxWidth: 42.0,
                          ),
                          child: obtained
                              ? Stack(
                                  children: <Widget>[
                                    Container(
                                      foregroundDecoration: BoxDecoration(
                                        color: Colors.grey,
                                        backgroundBlendMode: BlendMode.saturation,
                                      ),
                                      child: Opacity(
                                        opacity: 0.3,
                                        child: icon,
                                      ),
                                    ),
                                    Center(
                                      child: Icon(
                                        IrmaIcons.alert,
                                        color: IrmaTheme.of(context).interactionInvalid,
                                      ),
                                    ),
                                  ],
                                )
                              : icon,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 13,
                  child: Padding(
                    padding: EdgeInsets.all(IrmaTheme.of(context).smallSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: IrmaTheme.of(context).textTheme.display2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: IrmaTheme.of(context).tinySpacing),
                          child: Text(
                            subTitle,
                            style: IrmaTheme.of(context).textTheme.body1.copyWith(
                                  color: IrmaTheme.of(context).linkVisitedColor,
                                ),
                          ),
                        ),
//                        // Expiration warnings
//                        if (daysUntilExpiration <= 0)
//                          Padding(
//                            padding: EdgeInsets.only(top: IrmaTheme.of(context).tinySpacing),
//                            child: Text(
//                              "Your card has expired", // TODO add text in en/nl file and get info from scheme
//                              style: IrmaTheme.of(context).textTheme.body1.copyWith(
//                                    color: IrmaTheme.of(context).interactionInvalid,
//                                  ),
//                            ),
//                          )
//                        else if (daysUntilExpiration < 30)
//                          Padding(
//                            padding: EdgeInsets.only(top: IrmaTheme.of(context).tinySpacing),
//                            child: Text(
//                              "Expires in π days", // TODO add text in en/nl file and get info from scheme
//                              style: IrmaTheme.of(context).textTheme.body1.copyWith(
//                                    color: IrmaTheme.of(context).interactionAlert,
//                                  ),
//                            ),
//                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: IrmaTheme.of(context).smallSpacing,
                          right: IrmaTheme.of(context).defaultSpacing,
                          bottom: IrmaTheme.of(context).smallSpacing),
                      child: Icon(
                        obtained ? IrmaIcons.synchronize : IrmaIcons.add,
                        size: 20,
                        color: IrmaTheme.of(context).primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
