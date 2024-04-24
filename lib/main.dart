import 'package:flutter/material.dart';
import 'pages/home_page.dart';

/// The entry point of the application.
///
/// This widget is the root of the application and is responsible for
/// displaying the [HomePage].
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// This widget wraps the [HomePage] in a [MaterialApp] widget which provides
/// Material Design theming, routing and other useful features.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  ///
  /// The [key] is optional and is used to give this widget a unique key.
  const MyApp({super.key});

  /// Builds the widget hierarchy for this widget.
  ///
  /// This method is called whenever the widget needs to be built. It is
  /// typically called once when the widget is first created, and may be
  /// called many times if the widget is rebuilt.
  ///
  /// The [context] argument is used to build the widget. The [context] is
  /// guaranteed to be non-null and is the same context that was passed to
  /// [build].
  ///
  /// See also:
  ///
  /// * [StatefulWidget.build], which is the equivalent method for
  ///   [StatefulWidget]s.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// The title of the application.
      ///
      /// This string is used to set the title of the application.
      title: 'Website To App',

      /// Whether to show a debug banner and debug overlay.
      ///
      /// This flag is used to toggle the display of the debug banner and debug
      /// overlay. When the flag is set to true, both the banner and the overlay
      /// are shown. When the flag is set to false, neither the banner nor the
      /// overlay are shown.
      ///
      /// The default value is false.
      debugShowCheckedModeBanner: false,

      /// The theme for descendant widgets.
      ///
      /// The [MaterialApp] widget's theme is used to configure the color scheme
      /// of the application. The theme describes the colors, typography, and
      /// layout for the entire application.
      ///
      /// The default value is [ThemeData.light].
      theme: ThemeData(useMaterial3: true),

      /// The widget that is below the [Navigator] in the widget tree.
      ///
      /// The home widget is below the [Navigator] in the widget tree, below the
      /// [MaterialApp] widget. It is the initial screen shown when the app is
      /// run.
      ///
      /// The [home] property is optional and is only necessary if the app has
      /// a single screen. If the app has multiple screens, the [home] property
      /// should not be specified, and instead, the [routes] table should be
      /// used to define the app's routes.
      ///
      /// The [home] widget is typically a [Scaffold] widget.
      ///
      /// The [home] property can also be set to [null], in which case the app
      /// will not start with a screen.
      home: HomePage(),
    );
  }
}


