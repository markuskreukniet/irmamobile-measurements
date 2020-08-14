import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/models/translated_value.dart';

abstract class AttributeValue {
  String get raw;

  factory AttributeValue.fromRaw(AttributeType attributeType, TranslatedValue rawAttribute) {
    // In IrmaGo attribute values are set to null when an optional attribute is empty.
    if (rawAttribute == null) {
      return NullValue();
    }

    switch (attributeType.displayHint) {
      case "portraitPhoto":
        try {
          return PhotoValue.fromRaw(rawAttribute);
        } catch (_) {}
        // When rendering of the photo fails, fall back to NullValue.
        return NullValue();
      default:
        return TextValue.fromRaw(rawAttribute);
    }
  }
}

// Used in optional attributes when value is null
class NullValue implements AttributeValue {
  @override
  String get raw => null;
}

class TextValue implements AttributeValue {
  final TranslatedValue translated;
  @override
  final String raw;

  TextValue({this.translated, this.raw});

  // A raw TextValue is received as TranslatedValue.
  factory TextValue.fromRaw(rawAttribute) {
    final translatedValue = TranslatedValue.fromJson(rawAttribute as Map<String, dynamic>);
    return TextValue(
      translated: translatedValue,
      raw: translatedValue[""],
    );
  }
}

class PhotoValue implements AttributeValue {
  final Image image;
  @override
  final String raw;

  PhotoValue({this.image, this.raw});

  // A raw PhotoValue is received in a TextValue's raw block.
  // Is a bit hacky now, should be converted when irmago has knowledge of types
  factory PhotoValue.fromRaw(rawAttribute) {
    final textValue = TextValue.fromRaw(rawAttribute);
    return PhotoValue(
      image: Image.memory(
        const Base64Decoder().convert(textValue.raw),
      ),
      raw: textValue.raw,
    );
  }
}
