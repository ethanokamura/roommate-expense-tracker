import 'dart:developer';
// import 'dart:isolate';

import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'app_bloc_observer.dart';

/// Bootstrap function to initialize and run the app
///
/// [builder] is a required function that returns the root widget of the app
/// [init] is an optional function for additional initialization
Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
  FutureOr<void> Function()? init,
}) async {
  await runZonedGuarded(
    () async {
      // Enable fatal errors in debug mode
      BindingBase.debugZoneErrorsAreFatal = true;
      // Ensure Flutter bindings are initialized
      WidgetsFlutterBinding.ensureInitialized();
      try {
        // Run optional initialization
        await init?.call();
      } catch (e) {
        debugPrint('Failure to run optional initialization: $e');
      }
      // Set up global error handlers
      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        log(error.toString(), stackTrace: stackTrace);
        return true;
      };
      // // Set up error listener for the current isolate
      // Isolate.current.addErrorListener(
      //   RawReceivePort((dynamic pair) async {
      //     final errorAndStackTrace = pair as List<dynamic>;
      //     final error = errorAndStackTrace.first;
      //     final rawStackTrace = errorAndStackTrace.last;
      //     final stackTrace = rawStackTrace is StackTrace
      //         ? rawStackTrace
      //         : StackTrace.fromString(rawStackTrace.toString());
      //     log(error.toString(), stackTrace: stackTrace);
      //   }).sendPort,
      // );

      // Set up BLoC observer
      Bloc.observer = AppBlocObserver();

      // Build the app widget
      final app = await builder();
      // Set preferred device orientation to portrait
      try {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        ).then((value) => runApp(app));
      } catch (e) {
        debugPrint('Failure to Run App: $e');
      }
    },
    // Log any errors that occur during app execution
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
