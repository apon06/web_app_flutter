import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:free_webview/url/app_url.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The entry point of the application.
///
/// This widget is responsible for checking the user's internet connection
/// on app startup and displaying a message if there is no internet
/// connection.
class HomePage extends StatefulWidget {
  /// Create an instance of [HomePage].
  @override
  HomePageState createState() => HomePageState();
}

/// The state of the [HomePage] widget.
class HomePageState extends State<HomePage> {
  /// The controller of the web view widget.
  late WebViewController _webViewController;

  /// The result of the user's internet connection check.
  ConnectivityResult? _connectivityResult;

  /// A boolean indicating if the user is connected to the internet.
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    // Use the Android WebView if the app is running on Android and not on
    // iOS. This is necessary because the iOS WebView does not support
    // JavaScript.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    // Check the user's internet connection and initialize the web view
    // widget.
    _initConnectivity();
  }

  /// Checks the user's internet connection and displays a message if there
  /// is no internet connection.
  Future<void> _initConnectivity() async {
    // Get the user's current connection status.
    final ConnectivityResult result =
        await Connectivity().checkConnectivity();

    // If the user is not connected to the internet, show a message.
    if (result == ConnectivityResult.none) {
      _showNoInternetSnackBar();
    }

    // Set the [_connectivityResult] to the user's connection status.
    setState(() {
      _connectivityResult = result;
    });

    // Check the user's connection status every time it changes.
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // If the user is not connected to the internet, show a message.
      if (result == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
        _showNoInternetSnackBar();
      } else {
        // If the user is connected to the internet, hide the message.
        if (!_isConnected) {
          _isConnected = true;
          _showInternetBackSnackBar();
        }
      }
    });
  }

  /// Checks the user's internet connection status.
  Future<void> _checkConnectivity() async {
    // Get the user's current connection status.
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    // If the user is not connected to the internet, hide the web view
    // widget and display a message instead.
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  /// Displays a message if the user is not connected to the internet.
  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 3000),
        content: Text('No internet connection'),
        backgroundColor: Colors.black,
      ),
    );
  }

  /// Displays a message if the user's internet connection comes back.
  void _showInternetBackSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 6500),
        content: Text('Internet connection Back'),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Restart',
          onPressed: () {
            // Restart the app by pushing the home page to the Navigator.
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If the user is not connected to the internet, display a message
    // instead of the web view widget.
    if (_connectivityResult == null ||
        _connectivityResult == ConnectivityResult.none) {
      return Scaffold(
        body: Center(
          child: Lottie.asset('assets/lottie/nointernet.json'),
        ),
      );
    } else {
      // If the user is connected to the internet, display the web view
      // widget.
      return Scaffold(
        body: SafeArea(
          child: WillPopScope(
            // Allows the user to go back in the web view widget if they
            // press the back button.
            onWillPop: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
                return false;
              } else {
                return true;
              }
            },
            child: WebView(
              // Disable zooming in the web view widget.
              zoomEnabled: false,

              // The URL of the website to display in the web view widget.
              initialUrl: appUrl,

              // Allow JavaScript execution in the web view widget.
              javascriptMode: JavascriptMode.unrestricted,

              // Initialize the web view controller.
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },

              // Handles navigation events in the web view widget.
              navigationDelegate: (NavigationRequest request) {
                // If the user tries to make a phone call or send an email,
                // launch the appropriate URL using the system's default
                // email or phone app.
                if (request.url.startsWith('tel:')) {
                  launchUrl(Uri.parse(request.url));
                  return NavigationDecision.prevent;
                }
                if (request.url.startsWith('mailto:')) {
                  launchUrl(Uri.parse(request.url));
                  return NavigationDecision.prevent;
                }

                // Allow the navigation to continue.
                return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      );
    }
  }
}

