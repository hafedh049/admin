import 'package:dabka/translations/ar.dart';
import 'package:dabka/translations/en.dart';
import 'package:dabka/translations/fr.dart';
import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en_US': en,
        'ar_AR': ar,
        'fr_FR': fr,
      };
}
