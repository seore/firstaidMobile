import 'package:flutter/widgets.dart';

class LocaleController extends InheritedWidget {
  final void Function(String code) setLocale;
  final Locale? currentLocale;

  const LocaleController({
    super.key,
    required this.setLocale,
    required this.currentLocale,
    required Widget child,
  }) : super(child: child);

  static LocaleController of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LocaleController>();
    assert(result != null, 'No LocaleController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LocaleController oldWidget) {
    // if locale changes we want dependents to rebuild
    return oldWidget.currentLocale != currentLocale;
  }
}
