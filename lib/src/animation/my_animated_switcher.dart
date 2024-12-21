import 'package:flutter/material.dart';

/// A utility class to provide customizable configurations for an AnimatedSwitcher.
///
/// This class encapsulates the duration of the animation and the transition builder.
/// Pass an instance of this class to configure an AnimatedSwitcher with custom parameters.
class AnimatedSwitcherWidget {
  /// The duration of the animation for the AnimatedSwitcher.
  /// If null, it can be handled with a default value outside this class.
  final Duration? duration;

  /// A custom transition builder for the AnimatedSwitcher.
  /// If null, a default transition builder (e.g., FadeTransition) can be provided externally.
  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  /// Constructor for the AnimatedSwitcherWidget.
  ///
  /// - [duration]: The duration of the animation.
  /// - [transitionBuilder]: The function defining the transition animation.
  AnimatedSwitcherWidget(this.duration, this.transitionBuilder);

  /// Returns the animation duration for the AnimatedSwitcher.
  ///
  /// If the [duration] is null, ensure a fallback value is provided outside this class.
  Duration? getDuration() {
    return duration;
  }

  /// Returns the transition builder for the AnimatedSwitcher.
  ///
  /// If the [transitionBuilder] is null, ensure a fallback transition is provided externally.
  Widget Function(Widget, Animation<double>)? getTransitionBuilder() {
    return transitionBuilder;
  }
}
