import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/models/session.dart';
import 'package:irmamobile/src/screens/error/session_error_screen.dart';
import 'package:irmamobile/src/screens/pin/session_pin_screen.dart';
import 'package:irmamobile/src/screens/wallet/wallet_screen.dart';
import 'package:irmamobile/src/widgets/loading_indicator.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SessionScreenArguments {
  final int sessionID;
  final String measurementType;

  SessionScreenArguments({this.sessionID, this.measurementType});
}

void toErrorScreen(BuildContext context, SessionError error, VoidCallback onTapClose) {
  // TODO implement retry button handler
  // note: this will probably also need changes in the disclosure
  //  and session screens.
  error.stack = "";
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SessionErrorScreen(
        error: error,
        onTapClose: onTapClose,
      ),
    ),
  );
}

void popToWallet(BuildContext context, [bool measurementAgain, String measurementType]) {
  Navigator.of(context).popUntil(
    ModalRoute.withName(
      WalletScreen.routeName,
    ),
  );

  measurementsFromInternalToExternalStorage();

  if (measurementAgain != null && measurementType != null) {
    if (measurementAgain && measurementType != "") {
      Navigator.pushNamed(
        context,
        "/scanner",
        arguments: {'measurementType': measurementType}
      );
    }
  }
}

Future measurementsFromInternalToExternalStorage() async {
  // read from internal
  String folderPath = "/data/user/0/foundation.privacybydesign.irmamobile.alpha/v2";
	String filePartFlutter = "/latestMeasurementsFlutter.txt";
	String filePathFlutter = folderPath + filePartFlutter;

  var fileExists = await File(filePathFlutter).exists();
  
  if (!fileExists) {
    return;
  }

  final file = File(filePathFlutter);
  String content = await file.readAsString();

  var contentLines = content.split("\n");

  for (final line in contentLines) {
    var measurementTypeAndResult = line.split(": ");
    writeMeasurement(measurementTypeAndResult);
  }
}

Future writeMeasurement(List<String> measurementTypeAndResult) async {
  String filePartExternal = await determineFilePart(measurementTypeAndResult[0]);
  String stringToWrite = "measurement: " + measurementTypeAndResult[1] + "\n";
  await writeToExternalStorage(filePartExternal, stringToWrite, true);
}

Future<String> determineFilePart(String contentLine) async {
  String filePart = "";

  switch(contentLine) {
    case "disclosureNewSession": {
      filePart = "/disclosureNewSession.txt";
    }
    break;
    case "disclosureRespondPermission": {
      filePart = "/disclosureRespondPermission.txt";
    }
    break;
    case "issuanceNewSession": {
      filePart = "/issuanceNewSession.txt";
    }
    break;
    case "issuanceRespondPermission": {
      filePart = "/issuanceRespondPermission.txt";
    }
    break;
    case "torDisclosureNewSession": {
      filePart = "/torDisclosureNewSession.txt";
    }
    break;
    case "torDisclosureRespondPermission": {
      filePart = "/torDisclosureRespondPermission.txt";
    }
    break;
    case "torIssuanceNewSession": {
      filePart = "/torIssuanceNewSession.txt";
    }
    break;
    case "torIssuanceRespondPermission": {
      filePart = "/torIssuanceRespondPermission.txt";
    }
    break;

    case "kssGetCommitments": {
      filePart = "/kssGetCommitments.txt";
    }
    break;
    case "kssGetProofPs": {
      filePart = "/kssGetProofPs.txt";
    }
    break;
    case "torKssGetCommitments": {
      filePart = "/torKssGetCommitments.txt";
    }
    break;
    case "torKssGetProofPs": {
      filePart = "/torKssGetProofPs.txt";
    }
    break;


    case "disclosureHttpsNewSession": {
      filePart = "/disclosureHttpsNewSession.txt";
    }
    break;
    case "disclosureHttpsRespondPermission": {
      filePart = "/disclosureHttpsRespondPermission.txt";
    }
    break;
    case "issuanceHttpsNewSession": {
      filePart = "/issuanceHttpsNewSession.txt";
    }
    break;
    case "issuanceHttpsRespondPermission": {
      filePart = "/issuanceHttpsRespondPermission.txt";
    }
    break;
    case "torDisclosureHttpsNewSession": {
      filePart = "/torDisclosureHttpsNewSession.txt";
    }
    break;
    case "torDisclosureHttpsRespondPermission": {
      filePart = "/torDisclosureHttpsRespondPermission.txt";
    }
    break;
    case "torIssuanceHttpsNewSession": {
      filePart = "/torIssuanceHttpsNewSession.txt";
    }
    break;
    case "torIssuanceHttpsRespondPermission": {
      filePart = "/torIssuanceHttpsRespondPermission.txt";
    }
    break;

    case "kssHttpsGetCommitments": {
      filePart = "/kssHttpsGetCommitments.txt";
    }
    break;
    case "kssHttpsGetProofPs": {
      filePart = "/kssHttpsGetProofPs.txt";
    }
    break;
    case "torKssHttpsGetCommitments": {
      filePart = "/torKssHttpsGetCommitments.txt";
    }
    break;
    case "torKssHttpsGetProofPs": {
      filePart = "/torKssHttpsGetProofPs.txt";
    }
    break;
  }

  return filePart;
}

Future writeToExternalStorage(String filePart, String result, bool append) async {
  if (await Permission.storage.request().isGranted) {
    try {
      // storage/emulated/0/Android/data/foundation.privacybydesign.irmamobile.alpha/files
      var dir = await getExternalStorageDirectory();
      final file = File(dir.path + filePart);

      if (append) {
        file.writeAsString(result, mode: FileMode.append);
      } else {
        file.writeAsString(result, mode: FileMode.write);
      }
    } catch (e) {
      print(e);
    }
  }
}

Widget buildLoadingIndicator() {
  return Column(children: [
    Center(
      child: LoadingIndicator(),
    ),
  ]);
}

void pushSessionPinScreen(BuildContext context, int sessionID, String title) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => SessionPinScreen(
      sessionID: sessionID,
      title: FlutterI18n.translate(context, title),
    ),
  ));
}
