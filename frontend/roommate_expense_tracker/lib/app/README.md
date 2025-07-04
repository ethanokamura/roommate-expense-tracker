# App:
The main app file which includes initializing and debugging the app as well as the main app state handler.

```
lib/app/
    ├── cubit/                    # The main App cubit
    ├── view/                     # The main UI for the app features
    ├── app_bloc_observer.dart    # Observes app changes and errors
    ├── app_bootstrap.dart        # Wrapper for the app to handle debugging
    └── app.dart                  # Exports view/app.dart and bootstrap
```