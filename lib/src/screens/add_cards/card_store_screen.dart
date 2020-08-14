import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/util/language.dart';
import 'package:irmamobile/src/widgets/card_suggestion.dart';
import 'package:irmamobile/src/widgets/card_suggestion_group.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';

import 'card_info_screen.dart';

class CardStoreScreen extends StatelessWidget {
  static const String routeName = '/store';

  Future<void> _onStartIssuance(BuildContext context, CredentialType credentialType) async {
    final url = getTranslation(context, credentialType.issueUrl);
    IrmaRepository.get().openURL(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IrmaAppBar(
        title: Text(
          FlutterI18n.translate(context, 'card_store.app_bar'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: IrmaTheme.of(context).tinySpacing * 5,
                left: IrmaTheme.of(context).defaultSpacing,
                bottom: IrmaTheme.of(context).defaultSpacing),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                FlutterI18n.translate(context, 'card_store.choose'),
                style: IrmaTheme.of(context).textTheme.body1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: IrmaTheme.of(context).smallSpacing,
                right: IrmaTheme.of(context).smallSpacing,
              ),
              child: StreamBuilder<IrmaConfiguration>(
                  stream: IrmaRepository.get().getIrmaConfiguration(),
                  builder: (context, AsyncSnapshot<IrmaConfiguration> snapshot) {
                    if (snapshot.hasData) {
                      final irmaConfiguration = snapshot.data;
                      final credentialTypes = irmaConfiguration.credentialTypes.values.where(
                        (ct) => ct.isInCredentialStore,
                      );

                      final credentialTypesByCategory = groupBy<CredentialType, String>(
                          credentialTypes, (ct) => getTranslation(context, ct.category));
                      final categories = credentialTypesByCategory.keys.toList();

                      return ListView.builder(
                          itemCount: credentialTypesByCategory.length,
                          itemBuilder: (context, categoryIndex) {
                            final String category = categories[categoryIndex];
                            return CardSuggestionGroup(
                                title: category,
                                credentials: credentialTypesByCategory[category].map((credentialType) {
                                  VoidCallback navigationCallBack;
                                  navigationCallBack = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfoScreen(
                                          irmaConfiguration: irmaConfiguration,
                                          credentialType: credentialType,
                                          onStartIssuance: () => _onStartIssuance(context, credentialType),
                                        ),
                                      ),
                                    );
                                  };

                                  final File logoFile = File(credentialType.logoPath(irmaConfiguration.path));
                                  return CardSuggestion(
                                    icon: logoFile.existsSync()
                                        ? Image.file(logoFile)
                                        : Image.asset("assets/non-free/irmalogo.png"),
                                    title: getTranslation(context, credentialType.name),
                                    subTitle: getTranslation(
                                        context, irmaConfiguration.issuers[credentialType.fullIssuerId].name),
                                    obtained: false,
                                    onTap: navigationCallBack,
                                  );
                                }).toList());
                          });
                    } else {
                      return Center(
                        child: Text(
                          FlutterI18n.translate(context, 'ui.loading'),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _search(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(IrmaTheme.of(context).spacing),
  //     child: Theme(
  //       // Theme data to control the color of the icons in the search bar when the search bar is active
  //       data: Theme.of(context).copyWith(
  //         primaryColor: IrmaTheme.of(context).grayscale40,
  //       ),
  //       child: TextField(
  //         //onChanged: ,
  //         decoration: InputDecoration(
  //             fillColor: IrmaTheme.of(context).grayscale90,
  //             filled: true,
  //             prefixIcon: Icon(IrmaIcons.search),
  //             suffixIcon: IconButton(
  //                 icon: Icon(Icons.cancel),
  //                 onPressed: () {
  //                   debugPrint('remove search term');
  //                 }),
  //             hintText: FlutterI18n.translate(context, 'card_store.search'),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               borderSide: BorderSide.none,
  //             ),
  //             contentPadding: EdgeInsets.zero),
  //       ),
  //     ),
  //   );
  // }
}
