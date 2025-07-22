# Frontend Architecture

This document will cover the basics of our Flutter Architecture as well as describe the various modules and subdirectories within the Flutter project.

---

## General Idea

The Flutter project is broken down into two main sections:

1. `lib` - The main client-facing app directory.
    1. This is where the main UI / UX is implemented
2. `packages` - Our custom Flutter packages 
    1. This includes API interactions, core dart packages, reusable UI components, and custom datatypes.

Within both these directories, there are a wide range of sub-directories to help with project organization, clean architecture and separation of concerns.

---

## Lib

The main `lib` directory contains the main pages and Flutter components for the application.

The main structure for the `lib` directory is as follows:

```jsx
lib/
├── app/
├── config/
├── features/
├── theme/
└── main.dart
```

The `app` directory holds the logic for the app components highest in the widget tree. This includes authentication wrappers, app listeners, state handlers, and the app bootstrap (to safely initialize and run the app).

The `config` directory handles dependency injection using `GetIt`. This allows a single instance of each dependency to be used throughout the app.

The `features` directory is where the main client-facing features are held. This subsection of `lib` is where the app’s pages, views, and general UI is displayed. It implements the UI/UX logic for the features we have defined within our app.

To help maintain state throughout the app, we have implemented `cubits`, a subsection of the `bloc` architecture. Unlike other state management systems such as `riverpod` or `provider` , cubits allow a lightweight, fully customizable alternative.

`cubits` are found throughout the entire `lib` directory and are our main source of contact to our `packages` that handle API logic.

The `theme` directory is a simple `ThemeCubit` that allows us to maintain the state of the theme preferences of the current user. Though CorkVision only has a light theme at this point in time (April 2025), the theme logic allows for easy implementation of multiple themes.

Finally the `main.dart` file ties all of this logic together being the main file of the application. It is from here that the application is run and the app is able to function.

---

## Packages

The `packages` directory is not as straight forward as the `lib` directory upon first glance, however the architecture of the `packages` has been carefully and purposely crafted.

This is the main point of contact for interaction with external libraries and packages imported into the project. This is also where we handle all of the logic working with data from our API’s and databases. The purpose of `packages` directory is to modularize all of our apps logic in lightweight packages. This allows us to the flexibility to use the packages we need, while making it easy to add, remove, or delete external integrations. With the packages directory, we just need to change the referenced API’s or databases in one, organized directory. 

This allows the “frontend” or `lib` directory to be fully removed from interaction with the `packages`. If at any point we were to change databases, update API calls, or add / remove external packages or libraries, we would only need to do so within `packages`. The goal is to completely separate the logic between `lib` and `packages` and have the `cubits` as our main point of contact between the two.

You can think of `cubits` not only as a state management tool, but also a middle man for our app’s frontend and backend systems.

The general structure of the `packages` directory is as follows:

```jsx
packages/
├── api_client/
├── app_core/
├── app_ui/
└── <module>_repository/
```

Each `package` inside our `packages` directory has its own separate logic. 

`api_client` handles our main imports and exports of external libraries as well as custom generic API methods and implementations. Here, we can create custom methods to help us access our database or simplify API calls. This directory is where the `CacheManager` system is held. The cache manager handles local caching using the `Isar` library (using the devices native local storage). We also want to export our external libraries to allow full access of API related packages throughout our entire app.

When importing any api package in our app inside our app, it is as simple as importing the `api_client` at the top of the page.

```dart
import "package:api_client/api_client.dart";
```

The package is defined and implemented within the `api_client` directory and is imported (to be used across the app) within our `pubspec.yaml` files.

`app_core` is fairly similar to `api_client`, but instead focuses on handling the main building blocks of the app. This includes exporting essential packages to maintain the integrity of our flutter application. Along with exporting these packages, the app core implements basic extensions for the core app functions. For example, it is here that we can add extensions onto things like Flutter’s `BuildContext` class.

Our final core package is `app_ui`. Of the three main packages, this one is the most self explanatory. 

The `app_ui` contains all reusable widgets and constant that do not need direct interaction with data. The goal of the widgets inside the `app_ui` is to act as template widgets for the main features inside of `lib` .

The `app_ui` also defines app constants, such as colors, text constants, and theme data. 

## Repositories

The `<module>_repository` packages are subdirectories to handle all interaction with data for a specific `<module>`. This will contain the main logic between our client-side app and our backend — including localized caching.

The repositories also define failures for the module and custom dart types or `classes`. This is extremely important for safely performing operations with verbose logging as well as writing type-safe code using our defined objects.
