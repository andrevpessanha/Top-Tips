import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;


class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Top Tips',
      'hello': 'Hello',
      'options': 'Options'
    },
    'es': {
      'title': 'Pistas Top',
      'hello': 'Hola',
      'options': 'Opciones'
    },
    'pt': {
      'title': 'Dicas Top',
      'hello': 'Olá',
      'options': 'Opções'
    }
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get hello {
    return _localizedValues[locale.languageCode]['hello'];
  }

  String get options {
    return _localizedValues[locale.languageCode]['options'];
  }
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}