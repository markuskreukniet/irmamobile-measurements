#!/usr/bin/env bash

gomobile bind -target android -o android/irmagobridge/irmagobridge.aar github.com/markuskreukniet/irmamobile-measurements/irmagobridge
gomobile bind -target ios -o ios/Runner/Irmagobridge.framework github.com/markuskreukniet/irmamobile-measurements/irmagobridge
