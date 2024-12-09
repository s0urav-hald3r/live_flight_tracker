import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';

class OverlayLoader {
  static final OverlayLoader _instance = OverlayLoader._internal();
  factory OverlayLoader() => _instance;

  OverlayLoader._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// Show the loader without requiring a context
  static void show() {
    if (_isShowing) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Semi-transparent background
          Container(color: Colors.black.withOpacity(0.5)),
          // Circular loader in the center
          const Center(child: CupertinoActivityIndicator(color: whiteColor)),
        ],
      ),
    );

    final overlayState = NavigatorKey.navigatorKey.currentState?.overlay;
    if (overlayState != null) {
      overlayState.insert(_overlayEntry!);
      _isShowing = true;
    }
  }

  /// Hide the loader
  static void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }
}
