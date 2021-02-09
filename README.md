# irmamobile-measurements

The purpose of this project is to perform measurements of the study 'IRMA and Network Anonymity with Tor' by Markus Kreukniet. This project is a modified version of the project ['irmamobile'](https://github.com/privacybydesign/irmamobile) commit 813d3b53b5ff409449488ac74f7e22e27d8e8ef5, which was committed on 10 June 2020. This project (irmamobile-measurements) requires the project ['irmago-measurements.'](https://github.com/markuskreukniet/irmago-measurements) The setup of the irmamobile-measurements project should be the same as the setup of irmamobile.

This README might not be complete.

## Additional Setup

Here is the additional setup that we should perform after the irmamobile project's setup.

First, git clone the project ['irmago-measurements.'](https://github.com/markuskreukniet/irmago-measurements)

In the file `/go.mod` of this project (irmamobile-measurements), change the part after `=>` of line 27 to the place where the cloned project 'irmago-measurements' is. An example of line 27: `replace github.com/markuskreukniet/irmago-measurements => /home/user/go/src/github.com/markuskreukniet/irmago-measurements`

The file `/lib/src/screens/scanner/scanner_screen.dart` has a few static URLs, which we should change to the URLs of an active and configured IRMA server. An example of such an unchanged URL is: `"http://141.138.142.35:8088/irma/session/F6S2w69mpyX8ABOHbTtO"`.

When we start the app for the first time, we should choose 01989 as the PIN code, and we can skip the extra security by registering with an email address. When the main screen is visible, we can tap on the _WFTest_ button and then allow external storage permission. This button's function is to write a test file to external storage.

When we have started the app, entered the PIN code 01989, and started a batch of measurements, we experienced around four minutes later that the app wants us to enter the PIN code again. The app enters the PIN code 01989 automatically. However, the measurements are still interrupted. By tapping on the same measurement button, the measurements will continue.

In the ['irmago-measurements'](https://github.com/markuskreukniet/irmago-measurements) project is the configuration of sending emails. The IRMA mobile app can send email after it performed 25 measurements. The README of irmago-measurements explains where we can change the email sending configuration.

## The Main Screen (Wallet Screen) of the App

The app's main screen has in the bottom a grey colored part with 11 buttons. Each of these buttons has an abbreviation above it. The functions of these buttons in combination with their abbreviations are:

* __DEF__. We scan a single QR code to perform a single IRMA session with this button. This button works almost like the __default__ 'Scan QR' button from the app's unmodified version.
* __WFTest__. __Write__ a __test__ __file__ to external storage. Useful to give external storage permission and see if writing to external storage works. After we gave permission, the app writes the file to `Android/data/foundation.privacybydesign.irmamobile.alpha/files/test.txt`.
* __Help__. The button that makes the app open the __help__ screen.
* __DSM__. The app performs a batch of 25 __disclosure session measurements__.
* __ISM__. The app performs a batch of 25 __issuance session measurements__.
* __TDSM__. The app performs a batch of 25 __disclosure session measurements__ when the app routes its network traffic over the __Tor__ network.
* __TISM__. The app performs a batch of 25 __issuance session measurements__ when the app routes its network traffic over the __Tor__ network.
* __DSSM__. The app performs a batch of 25 __disclosure session HTTPS measurements__ over __HTTPS__.
* __ISSM__. The app performs a batch of 25 __issuance session HTTPS measurements__ over __HTTPS__.
* __TDSSM__. The app performs a batch of 25 __disclosure session measurements__ over __HTTPS__ when it routes its network traffic over the __Tor__ network.
* __TISSM__. The app performs a batch of 25 __issuance session measurements__ over __HTTPS__ when it routes its network traffic over the __Tor__ network.

## APK

The study built this project successfully, and a result of this build is the APK (Android application package) file `/apk/app-alpha-debug.apk`. We can use this APK to install the Android application that the study did use to perform measurements.

## Results of the Study

The study performed measurements, and the results of these measurements are in the directory `/measurement_results`. All these measurements are saved in microseconds and are in .txt files by which each line is a measurement. The `/measurement_results` directory has two subdirectories, HTTP and HTTPS.  The HTTP directory contains only HTTP IRMA session measurements, and the HTTPS directory contains only IRMA session measurements. The HTTP and HTTPS directory contains two subdirectories, KSS and no KSS. The KSS directory contains keyshare message measurements, and the no KSS directory does not have keyshare message measurements.

The subdirectories of the KSS and no KSS are directories that represent the only active network connection the phone had while performing the measurements and the attribute set used in the IRMA sessions. The naming of such a directory is first the network connection followed by a _ and then the attribute set. The files in the subfolder also have naming convention:

* When such a file starts with 'tor,' it means that the app's network traffic was routed over the Tor network while the measurements happened.
* When the file name contains 'disclosure,' the measured network messages were part of a disclosure session. When the file name contains 'issuance,' the measured network messages were part of an issuance session. Disclosure and issuance can occur with or without a capital letter.
* When the file name contains 'Https,' the measured network messages were part of an HTTPS session. If the file name does not contain 'Https,' the measured network messages were part of an HTTP session.
* If the file name contains 'NewSession,' the measured network messages were the 'new session' message. If the file name contains 'RespondPermission,' the measured network messages were the 'respond permission' message. If the file name contains 'GetCommitments,' the measured network messages were the 'get commitments' message. If the file name contains 'GetProofPs,' the measured network messages were the 'get proof ps' message.

## Good to Know

The latest version of Flutter may not work with this project. The study could build this project successfully with 'Flutter 1.17.4' and then use the app as expected.

The 'Screen timeout' of the phone might interrupt a batch of measurements. Therefore, it can be a good idea to set the 'Screen timeout' to a value such as 30 minutes.

Measurement results do get saved in app-specific storage and external storage. When we performed the measurements, the app saved the measurement results in the directory `Android/data/foundation.privacybydesign.irmamobile.alpha/files`.

By tapping some buttons on the IRMA mobile app's main screen, the app tries to perform 25 measurements and then send the measurement results to the email irmamobilemeasurementtests@gmail.com. We can change this email by modifying the [irmago-measurements](https://github.com/markuskreukniet/irmago-measurements) project, which the README of that project explains. As already mentioned, the app saves measurement results also in external storage. However, we recommend mailing the results since some measurements do not get saved in external storage in rare cases. We think that the reason for this external storage problem is that Android can block the writing of a file in external storage.

When the IRMA mobile app tries to perform 25 measurements, and these measurements get interrupted, we can continue the measurements, even if the app restarted. However, before continuing the measurements, restarting of the IRMA server and requestor might be needed.

Between the measurements, the app sleeps so that the requestor can start a new session with the IRMA server, which can result in that the app shows a black screen of around 13 seconds. Also, when performing measurements over the Tor network, the restarting of the Tor network can take some time (probably around 10 seconds or longer). Sometimes the time between measurements can be longer than 45 seconds.

Some of the measurements that we performed for the study did measure keyshare sessions but the keyshare messages did not get saved. These mesagges did not get saved since the app did not have the modifications to save these measurements yet.

The ['Getting started' of the 'IRMA docs'](https://irma.app/docs/getting-started/) contains information about how to start an IRMA server and an IRMA session. The docs also has information about how to start HTTPS IRMA sessions.

The study used a script like this one on ubuntu server to automatically restart the same irma session. ----- .sh file?
```
#!/bin/bash

while :
do
./irma session --server http://localhost:8088 --disclose pbdf.pbdf.irmatube.type
done
```

For convience, all the files in `/measurement_results` have 25 measurements. Originally, some of these files had more or less than 25 measurements, which is possible by performing mutiple times the same measurement batch after each other or interupting a measurements batch, and than getting the files from external storage. Or code change 25. Same as used in study kan dus ook 5 measurements zijn zoals in aantal mails
